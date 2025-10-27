import 'package:flutter/material.dart';
import 'package:instacar/core/services/solicitacao_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class RequestRideDialog extends StatefulWidget {
  final String rideId;
  final String motoristaId;
  final String motoristaName;

  const RequestRideDialog({
    super.key,
    required this.rideId,
    required this.motoristaId,
    required this.motoristaName,
  });

  @override
  State<RequestRideDialog> createState() => _RequestRideDialogState();
}

class _RequestRideDialogState extends State<RequestRideDialog> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messageController.text = 'Olá ${widget.motoristaName}! Posso pegar uma carona?';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _requestRide() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await SolicitacaoService.solicitarCarona(
        caronaId: widget.rideId,
        mensagem: _messageController.text.trim().isEmpty 
            ? null 
            : _messageController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Solicitação Enviada!',
              message: 'Sua solicitação foi enviada para ${widget.motoristaName}. Aguarde a resposta.',
              contentType: ContentType.success,
            ),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Erro ao Enviar',
              message: e.toString().replaceFirst('Exception: ', ''),
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.directions_car,
            color: Color(0xFF3182CE),
            size: 28,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Solicitar Carona',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Color(0xFF3182CE),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Motorista: ${widget.motoristaName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Envie uma mensagem para o motorista:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Digite sua mensagem...',
              hintStyle: const TextStyle(color: Color(0xFFA0AEC0)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF3182CE), width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            maxLines: 3,
            maxLength: 200,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dica: Seja educado e informe seu ponto de encontro se necessário.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: Color(0xFF718096),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _requestRide,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF48BB78),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Enviar Solicitação',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
