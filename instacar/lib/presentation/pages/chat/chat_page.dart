import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:instacar/core/services/chat_service.dart';
import 'package:instacar/core/services/map_service.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String receiveName;
  final String receiverId;
  final String? conversationId;

  const ChatPage({
    super.key,
    required this.userId,
    required this.receiveName,
    required this.receiverId,
    this.conversationId,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  List<Message> messages = [];
  final ScrollController _scrollController = ScrollController();
  IO.Socket? socket;
  String? conversationId;
  bool isLoading = true;
  bool isSendingMessage = false;
  String? errorMessage;
  int _mapViewCounter = 0;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recarregar mensagens quando o chat for reaberto
    if (conversationId != null && messages.isEmpty) {
      _loadMessages();
    }
  }

  void _initializeChat() async {
    try {
      setState(() {
        errorMessage = null;
      });

      // Get or create conversation
      if (widget.conversationId != null) {
        conversationId = widget.conversationId;
      } else {
        final conversation = await ChatService.getOrCreateConversation(widget.receiverId);
        conversationId = conversation['id'].toString();
      }

      // Load existing messages
      await _loadMessages();

      // Initialize socket connection
      _initializeSocket();

      setState(() {
        isLoading = false;
      });

      // Ensure we scroll to bottom after initial load
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      print('Error initializing chat: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Erro ao inicializar o chat: ${e.toString()}';
      });
    }
  }

  void _initializeSocket() async {
    // Use same base from AuthService
    final baseUrl = 'http://localhost:3000';
    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'query': {'userId': widget.userId}
    });

    socket!.on('connect', (_) {
      print('Connected to server');
    });

    socket!.on('receiveMessage', (data) {
      if (!mounted) return;
      setState(() {
        messages.add(Message(
          senderId: data['senderId']?.toString() ?? '',
          receiverId: data['receiverId']?.toString() ?? '',
          message: data['message']?.toString() ?? '',
          timestamp: DateTime.tryParse(data['createdAt']?.toString() ?? '') ?? DateTime.now(),
          isMe: data['senderId']?.toString() == widget.userId,
        ));
      });
      _scrollToBottom();
    });

    socket!.on('messageSent', (data) {
      if (!mounted) return;
      // Confirmação de que a mensagem foi enviada
      _scrollToBottom();
    });

    socket!.on('messageError', (data) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Erro ao enviar mensagem: ${data['error']}';
      });
    });

    socket!.on('disconnect', (_) {
      print('Disconnected from server');
    });
  }

  Future<void> _sendCurrentLocation() async {
    if (isSendingMessage) return;
    try {
      setState(() {
        isSendingMessage = true;
        errorMessage = null;
      });

      final loc = await MapService.getCurrentLocation();
      if (loc == null) {
        setState(() {
          errorMessage = 'Não foi possível obter sua localização';
        });
        return;
      }

      final lat = loc['lat'];
      final lng = loc['lng'];
      final geoText = 'geo:$lat,$lng';

      socket?.emit('sendMessage', {
        'senderId': widget.userId,
        'receiverId': widget.receiverId,
        'message': geoText,
      });

      setState(() {
        messages.add(
          Message(
            senderId: widget.userId,
            receiverId: widget.receiverId,
            message: geoText,
            timestamp: DateTime.now(),
            isMe: true,
          ),
        );
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao enviar localização: ${e.toString()}';
      });
    } finally {
      setState(() {
        isSendingMessage = false;
      });
    }
  }

  bool _isGeoMessage(String text) {
    return text.startsWith('geo:') && text.contains(',');
  }

  List<double>? _parseGeo(String text) {
    try {
      final coords = text.substring(4).split(',');
      if (coords.length != 2) return null;
      final lat = double.parse(coords[0]);
      final lng = double.parse(coords[1]);
      return [lat, lng];
    } catch (_) {
      return null;
    }
  }

  Widget _buildGeoBubble(String text, {required bool isMe}) {
    final coords = _parseGeo(text);
    if (coords == null) {
      return Text(text, style: const TextStyle(fontSize: 16));
    }

    final lat = coords[0];
    final lng = coords[1];

    if (!kIsWeb) {
      final url = 'https://www.google.com/maps?q=$lat,$lng';
      return InkWell(
        onTap: () {},
        child: Text(url, style: const TextStyle(decoration: TextDecoration.underline)),
      );
    }

    final viewType = 'geo-map-${_mapViewCounter++}-${DateTime.now().millisecondsSinceEpoch}';

    final iframe = html.IFrameElement()
      ..src = 'embed_map.html?lat=$lat&lng=$lng'
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '180px';

    // Register the view factory once per unique viewType
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      return iframe;
    });

    return SizedBox(
      width: 260,
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: HtmlElementView(viewType: viewType),
      ),
    );
  }

  Future<void> _loadMessages() async {
    if (conversationId != null) {
      try {
        final messagesData = await ChatService.getConversationMessages(conversationId!);
        setState(() {
          messages = messagesData.map((msg) {
            final senderId = msg['senderId'].toString();
            final isMe = (msg['isMe'] == true) || (senderId == widget.userId);
            return Message(
              senderId: senderId,
              receiverId: widget.receiverId,
              message: msg['message'].toString(),
              timestamp: DateTime.tryParse(msg['createdAt']?.toString() ?? '') ?? DateTime.now(),
              isMe: isMe,
            );
          }).toList();
        });
        
        // Scroll to bottom after loading messages
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      } catch (e) {
        print('Error loading messages: $e');
        setState(() {
          errorMessage = 'Erro ao carregar mensagens: ${e.toString()}';
        });
      }
    }
  }

  void sendMessage() async {
    if (messageController.text.trim().isNotEmpty && !isSendingMessage) {
      String message = messageController.text.trim();

      setState(() {
        isSendingMessage = true;
        errorMessage = null;
      });

      try {
        // Send message via socket (real-time) - this also saves to database
        socket?.emit('sendMessage', {
          'senderId': widget.userId,
          'receiverId': widget.receiverId,
          'message': message,
        });

        // Add message to UI immediately (optimistic update)
        setState(() {
          messages.add(
            Message(
              senderId: widget.userId,
              receiverId: widget.receiverId,
              message: message,
              timestamp: DateTime.now(),
              isMe: true,
            ),
          );
        });
        _scrollToBottom();

        // Note: Message is already saved to database via socket handler on server
        // No need to call ChatService.sendMessage() to avoid duplication
      } catch (e) {
        print('Error sending message: $e');
        setState(() {
          errorMessage = 'Erro ao enviar mensagem: ${e.toString()}';
        });
      } finally {
        setState(() {
          isSendingMessage = false;
        });
      }

      messageController.clear();
    }
  }

  @override
  void dispose() {
    socket?.disconnect();
    _scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  // Método para recarregar mensagens
  Future<void> refreshMessages() async {
    if (conversationId != null) {
      await _loadMessages();
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    // Delay to wait for new items to render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Conversa com ${widget.receiveName}",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: refreshMessages,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.red[700]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _initializeChat();
                        },
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final senderId = msg.senderId.trim();
                          final currentUserId = widget.userId.trim();
                          final isMe = msg.isMe ?? (senderId == currentUserId);
                          
                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue[100] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _isGeoMessage(msg.message)
                                      ? _buildGeoBubble(msg.message, isMe: isMe)
                                      : Text(
                                          msg.message,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTime(msg.timestamp),
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.red[50],
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red[700], fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  maxLines: null,
                                  enabled: !isSendingMessage,
                                  decoration: InputDecoration(
                                    hintText: isSendingMessage ? "Enviando..." : "Digite sua mensagem...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                ),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                tooltip: 'Enviar minha localização',
                                icon: const Icon(Icons.my_location),
                                color: Colors.blueGrey,
                                onPressed: isSendingMessage ? null : _sendCurrentLocation,
                              ),
                              IconButton(
                                icon: isSendingMessage
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.send),
                                color: Colors.blue,
                                onPressed: isSendingMessage ? null : sendMessage,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool? isMe;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isMe,
  });
}
