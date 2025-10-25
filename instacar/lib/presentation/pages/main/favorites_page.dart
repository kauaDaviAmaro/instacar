import 'package:flutter/material.dart';
import 'package:instacar/core/services/FavoritesService.dart';
import 'package:instacar/presentation/widgets/RideListWidget.dart';
import 'package:instacar/presentation/widgets/navbar.dart';
import 'package:instacar/presentation/widgets/BottomNavigationBar.dart';
import 'package:instacar/presentation/widgets/floating_map_button.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({
    super.key,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String searchQuery = '';
  List<String> favoriteRideIds = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final ids = await FavoritesService.getFavorites();
    setState(() {
      favoriteRideIds = ids;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              TopNavbar(
                // title: "Favoritos",
                onSearchChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                showRequestsButton: true, // Adicionar botão na página Favoritos também
              ),
              Expanded(
                child: RideListWidget(
                  searchQuery: searchQuery,
                  favoriteRideIds: favoriteRideIds,
                ),
              ),
            ],
          ),
          const FloatingMapButton(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 1),
    );
  }
}
