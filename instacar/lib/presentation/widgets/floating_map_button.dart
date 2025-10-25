import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FloatingMapButton extends StatelessWidget {
  const FloatingMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 100, // Posicionado acima da bottom navigation bar
      child:       FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).push('/map');
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.map,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
