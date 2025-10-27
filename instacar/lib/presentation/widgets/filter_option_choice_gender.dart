import 'package:flutter/material.dart';


class ChoiceChipWidget extends StatefulWidget {
  final Function(String?)? onSelectionChanged;
  
  const ChoiceChipWidget({super.key, this.onSelectionChanged});

  @override
  _ChoiceChipWidgetState createState() => _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<ChoiceChipWidget> {
  // Use a set to keep track of selected indices
  final Set<int> _selectedIndices = {};

  final List<String> _options = [
    'Masculino',
    'Feminino',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 15.0,
      children: List<Widget>.generate(
        _options.length,
        (int index) {
          return ChoiceChip(
            label: Text(_options[index]),
            selected: _selectedIndices.contains(index),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedIndices.add(index);
                } else {
                  _selectedIndices.remove(index);
                }
                // Notify parent of selection change
                if (_selectedIndices.isNotEmpty) {
                  widget.onSelectionChanged?.call(_options[_selectedIndices.first]);
                } else {
                  widget.onSelectionChanged?.call(null);
                }
              });
            },
            iconTheme: const IconThemeData(
              color: Colors.black,
              size: 20.0,
            ),
            selectedColor: Color.fromRGBO(100, 141, 219, 1),
            backgroundColor: Colors.grey[300],
            disabledColor: Colors.grey,
            labelStyle: TextStyle(
              color: _selectedIndices.contains(index)
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(color: Colors.transparent)),
          );
        },
      ).toList(),
    );
  }
}
