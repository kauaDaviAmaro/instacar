import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:instacar/core/models/RideModel.dart';
import 'package:instacar/core/services/ride_service.dart';
import 'package:instacar/core/services/FavoritesService.dart';
import 'package:instacar/core/services/user_service.dart';
import 'package:instacar/presentation/pages/chat/chat_page.dart';
import 'package:instacar/core/services/solicitacao_service.dart';
import 'package:instacar/presentation/widgets/request_ride_dialog.dart';

class RideDetailsPage extends StatefulWidget {
  final String rideId;

  const RideDetailsPage({
    super.key,
    required this.rideId,
  });

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  late Future<RideModel> _futureRide;
  bool isFavorite = false;
  String? currentUserId;
  String? solicitacaoStatus;
  bool isLoadingSolicitacao = false;

  @override
  void initState() {
    super.initState();
    _futureRide = RideService().fetchRideById(widget.rideId);
    _loadCurrentUser();
    _checkFavorite();
    _checkSolicitacaoStatus();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final userId = await UserService.getCurrentUserId();
      setState(() {
        currentUserId = userId;
      });
    } catch (e) {
      print('Erro ao obter ID do usuário: $e');
      setState(() {
        currentUserId = null;
      });
    }
  }

  Future<void> _checkSolicitacaoStatus() async {
    try {
      final status = await SolicitacaoService.getStatusSolicitacao(widget.rideId);
      setState(() {
        solicitacaoStatus = status;
      });
    } catch (e) {
      print('Erro ao verificar status da solicitação: $e');
    }
  }

  void _showRequestRideDialog(RideModel ride) {
    if (currentUserId == null || currentUserId!.isEmpty) return;
    if (currentUserId == ride.motoristaId) return;

    showDialog(
      context: context,
      builder: (context) => RequestRideDialog(
        rideId: widget.rideId,
        motoristaId: ride.motoristaId,
        motoristaName: ride.name,
      ),
    ).then((result) {
      if (result == true) {
        _checkSolicitacaoStatus();
      }
    });
  }

  Future<void> _checkFavorite() async {
    final fav = await FavoritesService.isFavorite(widget.rideId);
    setState(() {
      isFavorite = fav;
    });
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      await FavoritesService.removeFavorite(widget.rideId);
    } else {
      await FavoritesService.addFavorite(widget.rideId);
    }
    setState(() {
      isFavorite = !isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: isFavorite ? 'Carona Favoritada!' : 'Favorito Removido',
          message: isFavorite
              ? 'Você marcou a carona como favorita.'
              : 'Você removeu a carona dos favoritos.',
          contentType:
              isFavorite ? ContentType.success : ContentType.warning,
        ),
      ),
    );
  }

  void _openChat() async {
    if (currentUserId != null && currentUserId!.isNotEmpty) {
      try {
        // Buscar os dados da carona para obter o nome do motorista
        final ride = await _futureRide;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiveName: ride.name,
              userId: currentUserId!,
              receiverId: ride.motoristaId,
            ),
          ),
        );
      } catch (e) {
        print('Erro ao abrir chat: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir chat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: Usuário não autenticado. Faça login novamente.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              // Pode adicionar navegação para tela de login aqui
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Detalhes da Carona",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<RideModel>(
              future: _futureRide,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Erro ao carregar detalhes da carona',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _futureRide = RideService().fetchRideById(widget.rideId);
                            });
                          },
                          child: const Text('Tentar Novamente'),
                        ),
                      ],
                    ),
                  );
                }

                final ride = snapshot.data!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card principal com informações básicas
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nome e idade
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ride.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ride.genderAge,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ride.date,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              // Rota
                              _buildRouteSection(ride.from, ride.to),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Card com detalhes do veículo
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Detalhes do Veículo',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildDetailRow('Tipo', ride.type),
                              _buildDetailRow('Modelo', ride.model),
                              _buildDetailRow('Cor', ride.color),
                              _buildDetailRow('Placa', ride.plate),
                              const SizedBox(height: 16),
                              _buildDetailRow('Vagas Disponíveis', '${ride.takenSpots}/${ride.totalSpots}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Card com observações
                      if (ride.observation.isNotEmpty)
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Observações',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Text(
                                    ride.observation,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      // Botões de ação
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _toggleFavorite,
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.pink : null,
                              ),
                              label: Text(isFavorite ? 'Favoritado' : 'Favoritar'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: isFavorite ? Colors.pink[50] : null,
                                foregroundColor: isFavorite ? Colors.pink : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _openChat,
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: const Text('Chat'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: Colors.blue[50],
                                foregroundColor: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Botão Pedir Carona (full width)
                      if (currentUserId != null &&
                          currentUserId!.isNotEmpty &&
                          currentUserId != ride.motoristaId)
                        SizedBox(
                          width: double.infinity,
                          child: _buildRequestRideButton(ride),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestRideButton(RideModel ride) {
    Color buttonColor;
    String buttonText;
    IconData buttonIcon;
    VoidCallback? onPressed;

    switch (solicitacaoStatus) {
      case 'pendente':
        buttonColor = const Color(0xFFF6AD55);
        buttonText = 'Solicitação Enviada';
        buttonIcon = Icons.hourglass_empty;
        onPressed = null;
        break;
      case 'aceita':
        buttonColor = const Color(0xFF48BB78);
        buttonText = 'Aceita';
        buttonIcon = Icons.check_circle;
        onPressed = null;
        break;
      case 'rejeitada':
        buttonColor = const Color(0xFFE53E3E);
        buttonText = 'Rejeitada';
        buttonIcon = Icons.cancel;
        onPressed = () => _showRequestRideDialog(ride);
        break;
      case 'cancelada':
        buttonColor = const Color(0xFF718096);
        buttonText = 'Cancelada';
        buttonIcon = Icons.cancel_outlined;
        onPressed = () => _showRequestRideDialog(ride);
        break;
      default:
        buttonColor = const Color(0xFF48BB78);
        buttonText = 'Pedir Carona';
        buttonIcon = Icons.directions_car;
        onPressed = () => _showRequestRideDialog(ride);
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(buttonIcon, color: Colors.white, size: 24),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        minimumSize: const Size.fromHeight(60),
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildRouteSection(String from, String to) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Icon(Icons.circle, size: 12, color: Colors.green),
                Container(
                  height: 40,
                  width: 2,
                  color: Colors.grey,
                ),
                const Icon(Icons.square, size: 12, color: Colors.red),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      from,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      to,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
