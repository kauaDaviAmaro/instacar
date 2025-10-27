import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:instacar/core/services/solicitacao_service.dart';
import 'package:instacar/core/services/user_service.dart';
import 'package:instacar/presentation/widgets/BottomNavigationBar.dart';
import 'package:instacar/presentation/widgets/navbar.dart';

class SolicitacoesPage extends StatefulWidget {
  const SolicitacoesPage({super.key});

  @override
  State<SolicitacoesPage> createState() => _SolicitacoesPageState();
}

class _SolicitacoesPageState extends State<SolicitacoesPage> {
  List<Map<String, dynamic>> solicitacoes = [];
  bool isLoading = true;
  String? currentUserId;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadSolicitacoes();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final userId = await UserService.getCurrentUserId();
      setState(() {
        currentUserId = userId;
      });
    } catch (e) {
      print('Erro ao obter ID do usuário: $e');
    }
  }

  Future<void> _loadSolicitacoes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final solicitacoesData = await SolicitacaoService.getSolicitacoesRecebidas();
      setState(() {
        solicitacoes = solicitacoesData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Erro ao Carregar',
              message: 'Erro ao carregar solicitações: ${e.toString().replaceFirst('Exception: ', '')}',
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    }
  }

  Future<void> _responderSolicitacao(String solicitacaoId, String status) async {
    try {
      await SolicitacaoService.responderSolicitacao(
        solicitacaoId: solicitacaoId,
        status: status,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: status == 'aceita' ? 'Solicitação Aceita!' : 'Solicitação Rejeitada',
              message: status == 'aceita' 
                  ? 'A solicitação foi aceita com sucesso.'
                  : 'A solicitação foi rejeitada.',
              contentType: status == 'aceita' ? ContentType.success : ContentType.warning,
            ),
          ),
        );
      }

      // Recarregar a lista de solicitações
      _loadSolicitacoes();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Erro ao Responder',
              message: 'Erro ao responder solicitação: ${e.toString().replaceFirst('Exception: ', '')}',
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    }
  }

  Widget _buildSolicitacaoCard(Map<String, dynamic> solicitacao) {
    final passageiro = solicitacao['passageiro'] as Map<String, dynamic>;
    final carona = solicitacao['carona'] as Map<String, dynamic>;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com nome do passageiro e data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    passageiro['name'] ?? 'Passageiro',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3182CE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _formatDate(solicitacao['dataSolicitacao']),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Informações da carona
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF48BB78), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          carona['origem'] ?? 'Origem não informada',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFE53E3E), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          carona['destino'] ?? 'Destino não informado',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Color(0xFF4A5568), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        _formatDateTime(carona['dataHora']),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Mensagem do passageiro
            if (solicitacao['mensagem'] != null && solicitacao['mensagem'].toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mensagem do passageiro:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      solicitacao['mensagem'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _responderSolicitacao(solicitacao['id'], 'rejeitada'),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Rejeitar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53E3E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _responderSolicitacao(solicitacao['id'], 'aceita'),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Aceitar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF48BB78),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Data não informada';
    
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'Data inválida';
    }
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return 'Data não informada';
    
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Data inválida';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar solicitações baseado na busca
    final filteredSolicitacoes = solicitacoes.where((solicitacao) {
      if (searchQuery.isEmpty) return true;
      
      final carona = solicitacao['carona'] as Map<String, dynamic>?;
      if (carona == null) return false;
      
      final origem = (carona['origem'] ?? '').toLowerCase();
      final destino = (carona['destino'] ?? '').toLowerCase();
      final passageiro = solicitacao['passageiro'] as Map<String, dynamic>?;
      final nomePassageiro = (passageiro?['name'] ?? passageiro?['nome'] ?? '').toLowerCase();
      
      final query = searchQuery.toLowerCase();
      return origem.contains(query) || 
             destino.contains(query) || 
             nomePassageiro.contains(query);
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          TopNavbar(
            onSearchChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            showRequestsButton: false, // Não mostrar botão de solicitações na própria página de solicitações
            showFilter: false, // Não mostrar filtro nesta página
          ),
          Expanded(
            child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3182CE)),
              ),
            )
          : filteredSolicitacoes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma solicitação encontrada',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'As solicitações de carona aparecerão aqui',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadSolicitacoes,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Atualizar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3182CE),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSolicitacoes,
                  color: const Color(0xFF3182CE),
                  child: ListView.builder(
                    itemCount: filteredSolicitacoes.length,
                    itemBuilder: (context, index) {
                      return _buildSolicitacaoCard(filteredSolicitacoes[index]);
                    },
                  ),
                ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 3),
    );
  }
}
