import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:instacar/presentation/widgets/navbar.dart';
import 'chat_page.dart';
import 'package:instacar/presentation/widgets/BottomNavigationBar.dart';
import 'package:instacar/core/services/chat_service.dart';
import 'package:instacar/core/services/user_service.dart';

class ChatListPage extends StatefulWidget {
  final String userId;

  const ChatListPage({super.key, required this.userId});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, dynamic>> chats = [];
  int currentIndex = 4;
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  void loadChats() async {
    try {
      print('Loading chats for userId: ${widget.userId}');
      setState(() {
        isLoading = true;
      });
      
      final conversations = await ChatService.getUserConversations();
      print('Found ${conversations.length} conversations');
      final List<Map<String, dynamic>> chatList = [];
      
      for (var conversation in conversations) {
        print('Processing conversation: ${conversation['id']}');
        // Get the other user's ID
        final otherUserId = conversation['user1Id'] == widget.userId 
            ? conversation['user2Id'] 
            : conversation['user1Id'];
        
        print('Other user ID: $otherUserId');
        
        // Get user details
        try {
          final userDetails = await UserService.getUserById(otherUserId);
          print('User details: ${userDetails['name']}');
          final lastMessage = conversation['Messages']?.isNotEmpty == true 
              ? conversation['Messages'][0] 
              : null;
          
          chatList.add({
            "userId": otherUserId.toString(),
            "name": userDetails['name'] ?? 'Usuário',
            "LastMessage": lastMessage?['message'] ?? 'Nenhuma mensagem',
            "lastMessageTime": lastMessage != null 
                ? _formatTime(DateTime.parse(lastMessage['createdAt']))
                : '',
            "initials": _getInitials(userDetails['name'] ?? 'U'),
            "conversationId": conversation['id'].toString(),
          });
          print('Added chat: ${userDetails['name']}');
        } catch (e) {
          print('Error loading user details for $otherUserId: $e');
        }
      }
      
      print('Final chat list length: ${chatList.length}');
      setState(() {
        chats = chatList;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading chats: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}';
    } else {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Normalize search query
    final normalizedQuery = removeDiacritics(searchQuery).toLowerCase();

    // Filter chats based on normalized search query
    final filteredChats =
        chats.where((chat) {
          final normalizedName = removeDiacritics(chat["name"]).toLowerCase();
          return normalizedName.contains(normalizedQuery);
        }).toList();

    return Scaffold(
      body: Column(
        children: [
          TopNavbar(
            // title: "Chats",
            onSearchChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            showFilter: false,
          ),
          Expanded(
            // Wrap ListView in Expanded to avoid overflow
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredChats.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF3182CE).withOpacity(0.1),
                                      const Color(0xFF2B6CB0).withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  size: 64,
                                  color: Color(0xFF3182CE),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Nenhum chat encontrado',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                searchQuery.isNotEmpty 
                                  ? 'Nenhum chat corresponde à sua busca'
                                  : 'Seus chats aparecerão aqui quando você começar a conversar',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF4A5568),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (searchQuery.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: const Text(
                                    'Tente usar termos diferentes na busca',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4A5568),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {
                          final chat = filteredChats[index];
                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 300 + (index * 100)),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.grey[50]!,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          receiveName: chat["name"],
                                          userId: widget.userId,
                                          receiverId: chat["userId"],
                                          conversationId: chat["conversationId"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        // Avatar
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                const Color(0xFF3182CE),
                                                const Color(0xFF2B6CB0),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(28),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF3182CE).withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              chat["initials"],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        
                                        const SizedBox(width: 16),
                                        
                                        // Chat info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      chat["name"],
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xFF2D3748),
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFE2E8F0),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      chat["lastMessageTime"],
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color(0xFF4A5568),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              
                                              const SizedBox(height: 8),
                                              
                                              Text(
                                                chat["LastMessage"],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF4A5568),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        
                                        const SizedBox(width: 12),
                                        
                                        // Arrow icon
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF7FAFC),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: Color(0xFF4A5568),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: currentIndex),
    );
  }
}
