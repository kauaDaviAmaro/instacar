import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  static const List<TabItem> items = [
    TabItem(icon: Icons.home, title: 'Home'),
    TabItem(icon: Icons.favorite_border, title: 'Favoritos'),
    TabItem(icon: Icons.car_crash_outlined, title: 'Caronas'),
    TabItem(icon: Icons.notifications, title: 'Solicitações'),
    TabItem(icon: Icons.history, title: 'Histórico'),
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
        GoRouter.of(context).go('/solicitacoes');
        break;
      case 4:
        GoRouter.of(context).go('/historico');
        break;
      case 5:
        GoRouter.of(context).go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomBarDefault(
      items: items,
      backgroundColor: Colors.blue,
      color: const Color.fromARGB(255, 230, 230, 230),
      colorSelected: Colors.white,
      indexSelected: selectedIndex,
      onTap: (index) => onItemSelected(context, index),
      // chipStyle: const ChipStyle(convexBridge: true),
      // itemStyle: ItemStyle.circle,
      animated: true,
    );
  }
}
