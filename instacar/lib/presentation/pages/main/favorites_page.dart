import 'package:flutter/material.dart';
import 'package:instacar/core/services/FavoritesService.dart';
import 'package:instacar/presentation/widgets/RideListWidget.dart';
import 'package:instacar/presentation/widgets/navbar.dart';
import 'package:instacar/presentation/widgets/BottomNavigationBar.dart';

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
      body: Column(
        children: [
          TopNavbar(
            // title: "Favoritos",
            onSearchChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          Expanded(
            child: RideListWidget(
              searchQuery: searchQuery,
              favoriteRideIds: favoriteRideIds,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 1),
    );
  }
}
