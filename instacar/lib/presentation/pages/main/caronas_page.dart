import 'package:flutter/material.dart';
import 'package:instacar/presentation/pages/main/edit_ride_page.dart';

import 'package:instacar/presentation/widgets/BottomNavigationBar.dart';
import 'package:instacar/presentation/widgets/navbar.dart';
import 'package:instacar/presentation/widgets/ride_feedback_dialog.dart';
import 'package:instacar/presentation/widgets/floating_map_button.dart';
import 'package:instacar/presentation/pages/chat/chat_page.dart';
import 'package:instacar/core/services/user_service.dart';
import 'package:instacar/core/services/solicitacao_service.dart';

class CaronasPage extends StatefulWidget {
  const CaronasPage({super.key});

  @override
  State<CaronasPage> createState() => _CaronasPageState();
}

class _CaronasPageState extends State<CaronasPage> {
  int currentIndex = 2;
  String searchQuery = '';
  List<dynamic> caronas = [];
  bool isLoading = true;
  String? currentUserId;

  Color _statusColor(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'aceita':
        return const Color(0xFF48BB78);
      case 'rejeitada':
        return const Color(0xFFE53E3E);
      case 'cancelada':
        return const Color(0xFF718096);
      case 'pendente':
        return const Color(0xFFF6AD55);
      default:
        return const Color(0xFF4A5568);
    }
  }

  String _statusLabel(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'aceita':
        return 'Aceita';
      case 'rejeitada':
        return 'Rejeitada';
      case 'cancelada':
        return 'Cancelada';
      case 'pendente':
        return 'Pendente';
      default:
        return 'Desconhecido';
    }
  }

  Color _roleColor(String? papel) {
    if ((papel ?? '').toLowerCase() == 'motorista') return const Color(0xFF3182CE);
    return const Color(0xFF805AD5);
  }

  String _formatDateTimePretty(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      final dt = DateTime.parse(date);
      final dd = dt.day.toString().padLeft(2, '0');
      final mm = dt.month.toString().padLeft(2, '0');
      final yyyy = dt.year.toString();
      final hh = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '$dd/$mm/$yyyy às $hh:$min';
    } catch (_) {
      return date;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    fetchCaronas();
  }

  Future<void> _loadCurrentUser() async {
    final userId = await UserService.getCurrentUserId();
    setState(() {
      currentUserId = userId;
    });
  }

  Future<void> fetchCaronas() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Caronas derivadas de solicitações enviadas (como passageiro)
      final minhasSolicitacoes = await SolicitacaoService.getMinhasSolicitacoes();

      // Caronas derivadas de solicitações recebidas (como motorista)
      final solicitacoesRecebidas = await SolicitacaoService.getSolicitacoesRecebidas();

      // Constrói uma lista de histórico (cada solicitação é um item)
      List<Map<String, dynamic>> historico = [];

      for (final s in minhasSolicitacoes) {
        final carona = s['carona'] as Map<String, dynamic>?;
        if (carona == null) continue;
        final motorista = (carona['motorista'] as Map<String, dynamic>?) ?? {};
        historico.add({
          'solicitacaoId': s['id']?.toString(),
          'from': carona['origem'] ?? '',
          'to': carona['destino'] ?? '',
          'date': s['dataSolicitacao'] ?? carona['dataHora'] ?? '',
          'papel': 'passageiro',
          'statusSolicitacao': s['status'],
          'counterpartyName': motorista['name'] ?? motorista['nome'] ?? 'Motorista',
          'counterpartyId': motorista['id']?.toString() ?? motorista['userId']?.toString() ?? '',
        });
      }

      for (final s in solicitacoesRecebidas) {
        final carona = s['carona'] as Map<String, dynamic>?;
        if (carona == null) continue;
        final passageiro = (s['passageiro'] as Map<String, dynamic>?) ?? {};
        final motorista = (carona['motorista'] as Map<String, dynamic>?) ?? {};
        historico.add({
          'solicitacaoId': s['id']?.toString(),
          'from': carona['origem'] ?? '',
          'to': carona['destino'] ?? '',
          'date': s['dataSolicitacao'] ?? carona['dataHora'] ?? '',
          'papel': 'motorista',
          'statusSolicitacao': s['status'],
          'counterpartyName': passageiro['name'] ?? passageiro['nome'] ?? 'Passageiro',
          'counterpartyId': passageiro['id']?.toString() ?? passageiro['userId']?.toString() ?? '',
          'driverName': motorista['name'] ?? motorista['nome'] ?? 'Motorista',
        });
      }

      // Ordena por data (mais recente primeiro)
      int parseDateSafe(a) {
        try {
          return DateTime.parse(a?.toString() ?? '').millisecondsSinceEpoch;
        } catch (_) {
          return 0;
        }
      }

      historico.sort((a, b) => parseDateSafe(b['date']).compareTo(parseDateSafe(a['date'])));

      setState(() {
        caronas = historico;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar caronas de solicitações: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showFeedbackDialog(Map<String, dynamic> carona) {
    showDialog(
      context: context,
      builder: (context) => RideFeedbackDialog(
        rideId: carona['solicitacaoId'] ?? '',
        counterpartyName: carona['counterpartyName'] ?? '',
        counterpartyId: carona['counterpartyId'] ?? '',
        from: carona['from'] ?? '',
        to: carona['to'] ?? '',
      ),
    ).then((result) {
      if (result == true) {
        // Feedback enviado com sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avaliação enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredCaronas =
        caronas.where((carona) {
          return carona["from"].toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              carona["to"].toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              TopNavbar(
                onSearchChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                showRequestsButton: true,
              ),
          Expanded(
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : (filteredCaronas.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Sem histórico ainda',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Suas solicitações aparecerão aqui',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredCaronas.length,
                            itemBuilder: (context, index) {
                              final carona = filteredCaronas[index];
                              final status = carona['statusSolicitacao'];
                              final papel = carona['papel'];
                              final statusColor = _statusColor(status);
                              final roleColor = _roleColor(papel);
                              final datePretty = _formatDateTimePretty(carona['date']?.toString());

                              String initialsFromName(String? name) {
                                final n = (name ?? '').trim();
                                if (n.isEmpty) return '?';
                                final parts = n.split(' ');
                                final first = parts.first.isNotEmpty ? parts.first[0] : '';
                                final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
                                return (first + last).toUpperCase();
                              }

                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Header: chips e data
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: statusColor.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  _statusLabel(status) == 'Aceita' ? Icons.check_circle :
                                                  (_statusLabel(status) == 'Pendente' ? Icons.hourglass_empty :
                                                  (_statusLabel(status) == 'Rejeitada' ? Icons.cancel : Icons.help_outline)),
                                                  size: 16,
                                                  color: statusColor,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  _statusLabel(status),
                                                  style: TextStyle(
                                                    color: statusColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: roleColor.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              (papel ?? '-').toString().toUpperCase(),
                                              style: TextStyle(
                                                color: roleColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              const Icon(Icons.event, size: 16, color: Color(0xFF4A5568)),
                                              const SizedBox(width: 6),
                                              Text(
                                                datePretty,
                                                style: const TextStyle(
                                                  color: Color(0xFF4A5568),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      // Rota
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: const [
                                              Icon(Icons.radio_button_checked, color: Color(0xFF48BB78), size: 16),
                                              SizedBox(height: 6),
                                              SizedBox(
                                                height: 18,
                                                child: VerticalDivider(
                                                  color: Color(0xFFE2E8F0),
                                                  thickness: 2,
                                                  width: 2,
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Icon(Icons.location_on, color: Color(0xFFE53E3E), size: 16),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  carona["from"] ?? '-',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF2D3748),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  carona["to"] ?? '-',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF2D3748),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      // Contra-parte + ações
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: const Color(0xFF3182CE),
                                            child: Text(
                                              initialsFromName(carona['counterpartyName']),
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Com',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF718096),
                                                  ),
                                                ),
                                                Text(
                                                  carona['counterpartyName'] ?? '-',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: 'Conversar',
                                            icon: const Icon(Icons.chat_bubble_outline),
                                            onPressed: currentUserId != null ? () {
                                              final receiverId = carona['counterpartyId']?.toString() ?? '';
                                              final receiveName = carona['counterpartyName'] ?? 'Usuário';
                                              if (receiverId.isEmpty) return;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ChatPage(
                                                    receiveName: receiveName,
                                                    userId: currentUserId!,
                                                    receiverId: receiverId,
                                                  ),
                                                ),
                                              );
                                            } : null,
                                          ),
                                          // Botão de avaliação para caronas aceitas
                                          if (carona['statusSolicitacao']?.toString().toLowerCase() == 'aceita') ...[
                                            IconButton(
                                              tooltip: 'Avaliar carona',
                                              icon: const Icon(Icons.star_outline),
                                              onPressed: () => _showFeedbackDialog(carona),
                                            ),
                                          ],
                                          if ((carona['papel']?.toString().toLowerCase() ?? '') == 'motorista')
                                            IconButton(
                                              tooltip: 'Editar carona',
                                              icon: const Icon(Icons.edit_outlined),
                                              onPressed: () async {
                                                final updated = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) => EditCaronaPage(carona: carona),
                                                  ),
                                                );
                                                if (updated == true) {
                                                  fetchCaronas();
                                                }
                                              },
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
          ),
            ],
          ),
          const FloatingMapButton(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: currentIndex),
    );
  }
}
