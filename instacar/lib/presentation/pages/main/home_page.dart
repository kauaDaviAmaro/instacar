import 'package:flutter/material.dart';
import 'package:instacar/presentation/widgets/BottomNavigationBar.dart';
import 'package:instacar/presentation/widgets/RideListWidget.dart';
import 'package:instacar/presentation/widgets/navbar.dart';
import 'package:instacar/presentation/widgets/floating_map_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  String searchQuery = '';
  
  // Filter state
  String? selectedVehicleType;
  String? selectedGender;
  int? selectedSpots;
  String? selectedSortOrder;
  int? minAge;
  int? maxAge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              TopNavbar(
                // title: "texto",
                onSearchChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                onFilterApplied: (filters) {
                  updateFilters(
                    vehicleType: filters['vehicleType'],
                    gender: filters['gender'],
                    spots: filters['spots'],
                    sortOrder: filters['sortOrder'],
                    minAge: filters['minAge'],
                    maxAge: filters['maxAge'],
                  );
                },
                showRequestsButton: true, // Adicionar botão na página Home também
              ),
              Expanded(
                child: RideListWidget(
                  searchQuery: searchQuery,
                  vehicleType: selectedVehicleType,
                  gender: selectedGender,
                  spots: selectedSpots,
                  sortOrder: selectedSortOrder,
                  minAge: minAge,
                  maxAge: maxAge,
                ),
              ),
            ],
          ),
          const FloatingMapButton(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: currentIndex),
      
    );
  }

  // Method to update filter criteria
  void updateFilters({
    String? vehicleType,
    String? gender,
    int? spots,
    String? sortOrder,
    int? minAge,
    int? maxAge,
  }) {
    setState(() {
      selectedVehicleType = vehicleType;
      selectedGender = gender;
      selectedSpots = spots;
      selectedSortOrder = sortOrder;
      this.minAge = minAge;
      this.maxAge = maxAge;
    });
  }
}
