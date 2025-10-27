import 'package:flutter/material.dart';

class TopChatButton extends StatelessWidget {
  final VoidCallback onTap;

  const TopChatButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8), // espaço interno
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.blue.shade800,
          borderRadius: BorderRadius.circular(12) // azul mais escuro
        ),
        child: Icon(
          Icons.chat,
          size: 30, // aumenta o tamanho do ícone
          color: Colors.white,
        ),
      ),
    );
  }
}
