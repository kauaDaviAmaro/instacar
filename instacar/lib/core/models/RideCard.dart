import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:instacar/core/services/FavoritesService.dart';
import 'package:instacar/core/services/user_service.dart';
import 'package:instacar/presentation/pages/chat/chat_page.dart';
import 'package:instacar/presentation/pages/main/ride_details_page.dart';
 

class RideCard extends StatefulWidget {
  final String id;
  final String name;
  final String genderAge;
  final String date;
  final String from;
  final String to;
  final String type;
  final String model;
  final String color;
  final String plate;
  final int totalSpots;
  final int takenSpots;
  final String observation;
  final String motoristaId;

  const RideCard({
    super.key,
    required this.id,
    required this.name,
    required this.genderAge,
    required this.date,
    required this.from,
    required this.to,
    required this.type,
    required this.model,
    required this.color,
    required this.plate,
    required this.totalSpots,
    required this.takenSpots,
    required this.observation,
    required this.motoristaId,
  });

  @override
  State<RideCard> createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  bool isExpanded = false;
  bool isFavorite = false;
  String? currentUserId;
  

  @override
  void initState() {
    super.initState();
    checkFavorite();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      print('Tentando obter ID do usuário atual...');
      final userId = await UserService.getCurrentUserId();
      print('ID do usuário obtido: $userId');
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

  Future<void> checkFavorite() async {
    final fav = await FavoritesService.isFavorite(widget.id);
    setState(() {
      isFavorite = fav;
    });
  }

  void toggleFavorite() async {
    if (isFavorite) {
      await FavoritesService.removeFavorite(widget.id);
    } else {
      await FavoritesService.addFavorite(widget.id);
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

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF4A5568)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4A5568),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            // Navegar para a página de detalhes da carona
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RideDetailsPage(rideId: widget.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Name + Age + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.genderAge,
                        style: const TextStyle(
                          color: Color(0xFF4A5568),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3182CE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.date,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Locations
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFF48BB78),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53E3E),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFF7FAFC),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF48BB78),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.from,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFF7FAFC),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFFE53E3E),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.to,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: const Color(0xFF4A5568),
                        ),
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                // Expandable content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Vehicle details
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Detalhes do Veículo",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailItem("Tipo", widget.type, Icons.directions_car),
                                ),
                                Expanded(
                                  child: _buildDetailItem("Modelo", widget.model, Icons.car_rental),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailItem("Cor", widget.color, Icons.palette),
                                ),
                                Expanded(
                                  child: _buildDetailItem("Placa", widget.plate, Icons.confirmation_number),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Observation
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Observação",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.observation,
                              style: const TextStyle(
                                color: Color(0xFF4A5568),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Action buttons and spots info
                      Row(
                        children: [
                          // Spots info
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3182CE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Vagas ${widget.takenSpots}/${widget.totalSpots}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Removed request ride button from card to avoid overflow
                          // Favorite button
                          Container(
                            decoration: BoxDecoration(
                              color: isFavorite ? const Color(0xFFE53E3E) : const Color(0xFFF7FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isFavorite ? const Color(0xFFE53E3E) : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: toggleFavorite,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? Colors.white : const Color(0xFFE53E3E),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isFavorite ? "Favorito" : "Favoritar",
                                        style: TextStyle(
                                          color: isFavorite ? Colors.white : const Color(0xFFE53E3E),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Chat button
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF3182CE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  print('Botão de chat clicado');
                                  print('currentUserId: $currentUserId');
                                  print('motoristaId: ${widget.motoristaId}');
                                  
                                  if (currentUserId != null && currentUserId!.isNotEmpty) {
                                    try {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            receiveName: widget.name,
                                            userId: currentUserId!,
                                            receiverId: widget.motoristaId,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      print('Erro ao navegar para o chat: $e');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Erro ao abrir chat: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } else {
                                    print('Usuário não autenticado ou ID vazio');
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
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        "Chat",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  crossFadeState:
                      isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
