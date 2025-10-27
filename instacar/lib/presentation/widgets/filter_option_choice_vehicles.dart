import 'package:flutter/material.dart';

enum Vehicles {
  Carro,
  Moto,
}

class SingleSegmentedButton extends StatefulWidget {
  const SingleSegmentedButton({super.key});

  @override
  State<SingleSegmentedButton> createState() => _SingleSegmentedButtonState();
}

class _SingleSegmentedButtonState extends State<SingleSegmentedButton> {
  Vehicles VehiclesView = Vehicles.Carro;
 
  @override
  Widget build(BuildContext context) {
    return 
      SegmentedButton<Vehicles>(
        segments: const <ButtonSegment<Vehicles>>[
          ButtonSegment<Vehicles>(value: Vehicles.Carro, label: Text('Carro')),
          ButtonSegment<Vehicles>(value: Vehicles.Moto, label: Text('Moto')),
        ],
        selected: <Vehicles>{VehiclesView},
        onSelectionChanged: (Set<Vehicles> newSelection) {
          setState(() {
            VehiclesView = newSelection.first;
        });
      },
    );
  }
}
