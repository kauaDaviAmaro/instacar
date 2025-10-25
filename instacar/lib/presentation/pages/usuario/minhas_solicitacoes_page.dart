import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:instacar/core/services/solicitacao_service.dart';
import 'package:instacar/core/services/user_service.dart';
import 'package:instacar/presentation/widgets/BottomNavigationBar.dart';

class MinhasSolicitacoesPage extends StatefulWidget {
  const MinhasSolicitacoesPage({super.key});

  @override
  State<MinhasSolicitacoesPage> createState() => _MinhasSolicitacoesPageState();
}

class _MinhasSolicitacoesPageState extends State<MinhasSolicitacoesPage> {
  List<Map<String, dynamic>> solicitacoes = [];
  bool isLoading = true;
  String? currentUserId;

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
      final solicitacoesData = await SolicitacaoService.getMinhasSolicitacoes();
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
              message: 'Erro ao carregar suas solicitações: ${e.toString().replaceFirst('Exception: ', '')}',
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    }
  }

  Future<void> _cancelarSolicitacao(String solicitacaoId) async {
    try {
      await SolicitacaoService.cancelarSolicitacao(solicitacaoId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Solicitação Cancelada',
              message: 'Sua solicitação foi cancelada com sucesso.',
              contentType: ContentType.warning,
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
              title: 'Erro ao Cancelar',
              message: 'Erro ao cancelar solicitação: ${e.toString().replaceFirst('Exception: ', '')}',
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    }
  }

  Widget _buildSolicitacaoCard(Map<String, dynamic> solicitacao) {
    final carona = solicitacao['carona'] as Map<String, dynamic>;
    final motorista = carona['motorista'] as Map<String, dynamic>;
    
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    switch (solicitacao['status']) {
      case 'pendente':
        statusColor = const Color(0xFFF6AD55);
        statusText = 'Pendente';
        statusIcon = Icons.hourglass_empty;
        break;
      case 'aceita':
        statusColor = const Color(0xFF48BB78);
        statusText = 'Aceita';
        statusIcon = Icons.check_circle;
        break;
      case 'rejeitada':
        statusColor = const Color(0xFFE53E3E);
        statusText = 'Rejeitada';
        statusIcon = Icons.cancel;
        break;
      case 'cancelada':
        statusColor = const Color(0xFF718096);
        statusText = 'Cancelada';
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = const Color(0xFF4A5568);
        statusText = 'Desconhecido';
        statusIcon = Icons.help_outline;
    }
    
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
            // Header com status e data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        statusText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(solicitacao['dataSolicitacao']),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Informações do motorista
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF3182CE),
                  child: Text(
                    (motorista['name'] ?? 'M')[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        motorista['name'] ?? 'Motorista',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        'Motorista',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
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
            
            // Mensagem enviada
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
                      'Sua mensagem:',
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
            
            // Botão de cancelar (apenas se pendente)
            if (solicitacao['status'] == 'pendente') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showCancelDialog(solicitacao['id']),
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('Cancelar Solicitação'),
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
            ],
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(String solicitacaoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Solicitação'),
        content: const Text('Tem certeza que deseja cancelar esta solicitação de carona?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cancelarSolicitacao(solicitacaoId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
            ),
            child: const Text('Sim, Cancelar'),
          ),
        ],
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas Solicitações',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF3182CE),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadSolicitacoes,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Atualizar',
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 3),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3182CE)),
              ),
            )
          : solicitacoes.isEmpty
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
                        'Suas solicitações de carona aparecerão aqui',
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
                    itemCount: solicitacoes.length,
                    itemBuilder: (context, index) {
                      return _buildSolicitacaoCard(solicitacoes[index]);
                    },
                  ),
                ),
    );
  }
}
