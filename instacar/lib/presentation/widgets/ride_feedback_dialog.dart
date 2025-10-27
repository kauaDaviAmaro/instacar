import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:instacar/core/services/user_service.dart';

class RideFeedbackDialog extends StatefulWidget {
  final String rideId;
  final String counterpartyName;
  final String counterpartyId;
  final String from;
  final String to;

  const RideFeedbackDialog({
    super.key,
    required this.rideId,
    required this.counterpartyName,
    required this.counterpartyId,
    required this.from,
    required this.to,
  });

  @override
  State<RideFeedbackDialog> createState() => _RideFeedbackDialogState();
}

class _RideFeedbackDialogState extends State<RideFeedbackDialog> {
  int _rating = 5;
  int _seatCount = 1;
  final TextEditingController _observationsController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_observationsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, adicione suas observações'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Obter o ID do usuário atual
      final userId = await UserService.getCurrentUserId();
      if (userId == null || userId.isEmpty) {
        throw Exception('Usuário não autenticado');
      }

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/feedback'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'rideId': widget.rideId,
          'userId': userId,
          'counterpartyId': widget.counterpartyId,
          'counterpartyName': widget.counterpartyName,
          'rating': _rating,
          'seatCount': _seatCount,
          'comment': _observationsController.text.trim(),
          'from': widget.from,
          'to': widget.to,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avaliação enviada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Erro ao enviar avaliação');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar avaliação: $e'),
            backgroundColor: Colors.red,
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              'Espero que tenha apreciado sua carona!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            
            // Descrição
            Text(
              'Por favor, preenchimento obrigatório, faça uma avaliação do serviço prestado para compreender sua experiência e ajudar a melhorar a experiência dos demais:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Avaliação com estrelas
            const Text(
              'Avalie a sua carona*:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Número de vagas
            const Text(
              'Número de vagas no carro *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                // Botão menos
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3182CE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _seatCount > 1 ? () {
                      setState(() {
                        _seatCount--;
                      });
                    } : null,
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Campo de número
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Center(
                    child: Text(
                      _seatCount.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Botão mais
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3182CE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _seatCount < 10 ? () {
                      setState(() {
                        _seatCount++;
                      });
                    } : null,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Observações
            const Text(
              'Observações*:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _observationsController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Adicione suas observações sobre sua carona, conte-nos o máximo possível:',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão Confirm
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3182CE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                    : const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
