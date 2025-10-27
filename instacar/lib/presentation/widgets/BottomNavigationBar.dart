import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instacar/presentation/widgets/create_ride_page.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  static const List<TabItem> items = [
    TabItem(icon: Icons.home, title: 'Home'),
    TabItem(icon: Icons.favorite_border, title: 'Favoritos'),
    TabItem(icon: Icons.car_crash_outlined, title: 'Caronas'),
    TabItem(icon: Icons.account_box, title: 'Perfil'),
  ];

  void onItemSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/favorites');
        break;
      case 2:
        GoRouter.of(context).go('/caronas');
        break;
      case 3:
        GoRouter.of(context).go('/profile');
        break;
    }
  }

  void _showCreateRideDialog(BuildContext context) async {
    final result = await showBarModalBottomSheet(
      context: context,
      builder: (context) => CreateRidePage(),
    );
    // Se a carona foi criada com sucesso, pode recarregar dados se necessário
    if (result == true) {
      // Aqui você pode adicionar lógica para recarregar dados se necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Botão Home
              _buildNavItem(
                context,
                icon: Icons.home,
                label: 'Home',
                index: 0,
                isSelected: selectedIndex == 0,
              ),
              // Botão Favoritos
              _buildNavItem(
                context,
                icon: Icons.favorite_border,
                label: 'Favoritos',
                index: 1,
                isSelected: selectedIndex == 1,
              ),
              // Botão Central de Adicionar Corrida
              _buildCenterButton(context),
              // Botão Caronas
              _buildNavItem(
                context,
                icon: Icons.car_crash_outlined,
                label: 'Caronas',
                index: 2,
                isSelected: selectedIndex == 2,
              ),
              // Botão Perfil
              _buildNavItem(
                context,
                icon: Icons.account_box,
                label: 'Perfil',
                index: 3,
                isSelected: selectedIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onItemSelected(context, index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color.fromARGB(255, 230, 230, 230),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color.fromARGB(255, 230, 230, 230),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCreateRideDialog(context),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.blue,
          size: 30,
        ),
      ),
    );
  }
}
