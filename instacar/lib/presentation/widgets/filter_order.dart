import 'package:flutter/material.dart';

class ChoiceChipFilterOrder extends StatefulWidget {
  final Function(String?)? onSelectionChanged;
  
  const ChoiceChipFilterOrder({super.key, this.onSelectionChanged});

  @override
  _ChoiceChipWidgetState createState() => _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<ChoiceChipFilterOrder> {
  // Variável para armazenar o índice da opção selecionada
  int? _selectedIndex;

  final List<String> _optionsFilter = [
    'Mais recentes',
    'Mais antigos'
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 15.0,
      children: List<Widget>.generate(
        _optionsFilter.length,
        (int index) {
          return ChoiceChip(
            label: Text(_optionsFilter[index]),
            selected: _selectedIndex == index,
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedIndex = index; // Define o índice selecionado
                  widget.onSelectionChanged?.call(_optionsFilter[index]);
                } else {
                  _selectedIndex = null; // Desmarcar a seleção
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
              color: _selectedIndex == index
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: const BorderSide(color: Colors.transparent),
            ),
          );
        },
      ).toList(),
    );
  }
}

