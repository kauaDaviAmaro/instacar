import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:instacar/core/services/auth_service.dart';

// Formatter para placa brasileira (ABC-1234 ou ABC1D23)
class LicensePlateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.toUpperCase();
    
    if (text.length <= 3) {
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } else if (text.length == 4 && !text.contains('-')) {
      return TextEditingValue(
        text: '${text.substring(0, 3)}-${text.substring(3)}',
        selection: TextSelection.collapsed(offset: 5),
      );
    } else if (text.length > 8) {
      return oldValue;
    }
    
    return newValue;
  }
}

class EditCaronaPage extends StatefulWidget {
  final Map<String, dynamic> carona;

  const EditCaronaPage({super.key, required this.carona});

  @override
  State<EditCaronaPage> createState() => _EditCaronaPageState();
}

class _EditCaronaPageState extends State<EditCaronaPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _departureController;
  late TextEditingController _destinationController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleColorController;
  late TextEditingController _licensePlateController;
  late TextEditingController _notesController;
  late TextEditingController _priceController;
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _seatCount = 2;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _departureController = TextEditingController(text: widget.carona["origem"] ?? widget.carona["from"] ?? "");
    _destinationController = TextEditingController(text: widget.carona["destino"] ?? widget.carona["to"] ?? "");
    _vehicleModelController = TextEditingController(text: widget.carona["modeloVeiculo"] ?? "");
    _vehicleColorController = TextEditingController(text: widget.carona["corVeiculo"] ?? "");
    _licensePlateController = TextEditingController(text: widget.carona["placa"] ?? "");
    _notesController = TextEditingController(text: widget.carona["observacao"] ?? "");
    _priceController = TextEditingController(text: widget.carona["preco"]?.toString() ?? "");
    
    _seatCount = widget.carona["vagas"] ?? widget.carona["seats"] ?? 2;
    
    // Parse data e hora se existirem
    if (widget.carona["dataHora"] != null) {
      try {
        final dateTime = DateTime.parse(widget.carona["dataHora"]);
        _selectedDate = dateTime;
        _selectedTime = TimeOfDay.fromDateTime(dateTime);
      } catch (e) {
        print('Erro ao parsear dataHora: $e');
      }
    } else if (widget.carona["date"] != null) {
      try {
        // A API retorna data formatada como "DD/MM/YYYY HH:MM"
        final dateString = widget.carona["date"];
        print('Data recebida: $dateString');
        
        // Tenta parsear formato brasileiro DD/MM/YYYY HH:MM
        final parts = dateString.split(' ');
        if (parts.length >= 2) {
          final datePart = parts[0]; // DD/MM/YYYY
          final timePart = parts[1]; // HH:MM
          
          final dateComponents = datePart.split('/');
          if (dateComponents.length == 3) {
            final day = int.parse(dateComponents[0]);
            final month = int.parse(dateComponents[1]);
            final year = int.parse(dateComponents[2]);
            
            final timeComponents = timePart.split(':');
            if (timeComponents.length >= 2) {
              final hour = int.parse(timeComponents[0]);
              final minute = int.parse(timeComponents[1]);
              
              _selectedDate = DateTime(year, month, day);
              _selectedTime = TimeOfDay(hour: hour, minute: minute);
              
              print('Data parseada: $_selectedDate, Hora: $_selectedTime');
            }
          }
        }
      } catch (e) {
        print('Erro ao parsear data formatada: $e');
        // Fallback: tenta parsear como ISO string
        try {
          final dateTime = DateTime.parse(widget.carona["date"]);
          _selectedDate = dateTime;
          _selectedTime = TimeOfDay.fromDateTime(dateTime);
        } catch (e2) {
          print('Erro no fallback: $e2');
        }
      }
    }
  }

  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    _vehicleModelController.dispose();
    _vehicleColorController.dispose();
    _licensePlateController.dispose();
    _notesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 8, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _updateCarona() async {
    // Validar campos obrigatórios
    if (!_formKey.currentState!.validate()) {
      setState(() {}); // Força rebuild para mostrar validações visuais
      return;
    }

    // Validar seletores de data e hora
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione a data da carona'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {}); // Força rebuild para mostrar validação visual
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione a hora da carona'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {}); // Força rebuild para mostrar validação visual
      return;
    }

    // Validar número de vagas
    if (_seatCount < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione pelo menos 2 vagas'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {}); // Força rebuild para mostrar validação visual
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você precisa estar logado para editar uma carona'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

    final body = {
        'origem': _departureController.text,
        'destino': _destinationController.text,
        'dataHora': dateTime.toIso8601String(),
        'vagas': _seatCount,
        'observacao': _notesController.text,
        'preco': _priceController.text.isNotEmpty ? double.parse(_priceController.text) : null,
        'origem_lat': widget.carona["origem_lat"] ?? 0.0,
        'origem_lon': widget.carona["origem_lon"] ?? 0.0,
        // Dados de veículo para atualizar o perfil do usuário
        'vehicleData': {
          'tipoVeiculo': 'Carro', // TODO: Adicionar seletor de tipo
          'modeloVeiculo': _vehicleModelController.text,
          'corVeiculo': _vehicleColorController.text,
          'placa': _licensePlateController.text,
        }
      };

      final response = await http.put(
        Uri.parse('http://localhost:3000/api/caronas/${widget.carona["id"]}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Carona atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Retorna true para indicar sucesso
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Erro ao atualizar carona'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro de rede: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Carona'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edite os dados da sua carona. Se atente às informações obrigatórias.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Endereço de saída
              const Text(
                'Endereço de Saída *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _departureController,
                decoration: const InputDecoration(
                  hintText: 'Adicione endereço',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço de saída';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Endereço de chegada
              const Text(
                'Endereço de Final *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  hintText: 'Adicione endereço',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço de destino';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Data da carona
              const Text(
                'Data da carona *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedDate == null ? Colors.red : Colors.grey,
                      width: _selectedDate == null ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today, 
                        color: _selectedDate == null ? Colors.red : Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                            : 'Selecione a data *',
                        style: TextStyle(
                          color: _selectedDate != null ? Colors.black : Colors.red[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_selectedDate == null)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Por favor, selecione a data da carona',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              // Hora da carona
              const Text(
                'Hora da carona *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectTime,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedTime == null ? Colors.red : Colors.grey,
                      width: _selectedTime == null ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time, 
                        color: _selectedTime == null ? Colors.red : Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedTime != null
                            ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                            : 'Selecione a hora *',
                        style: TextStyle(
                          color: _selectedTime != null ? Colors.black : Colors.red[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_selectedTime == null)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Por favor, selecione a hora da carona',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              // Preço da carona
              const Text(
                'Preço por passageiro (R\$)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: const InputDecoration(
                  hintText: 'Ex: 15.50',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Modelo de veículo
              const Text(
                'Modelo do veículo *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _vehicleModelController,
                decoration: const InputDecoration(
                  hintText: 'Adicione modelo do veículo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o modelo do veículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Cor do Veículo
              const Text(
                'Cor do veículo *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _vehicleColorController,
                decoration: const InputDecoration(
                  hintText: 'Adicione a cor do veículo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a cor do veículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Placa do Veículo
              const Text(
                'Placa do veículo *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _licensePlateController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                  LicensePlateFormatter(),
                ],
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'ABC-1234',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a placa do veículo';
                  }
                  if (value.length < 7) {
                    return 'Placa deve estar no formato ABC-1234';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contador de vagas
              const Text(
                'Número de vagas no carro *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _seatCount < 2 ? Colors.red : Colors.blue,
                    width: _seatCount < 2 ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
            children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      color: _seatCount <= 2 ? Colors.grey : Colors.blue,
                      onPressed: _seatCount <= 2 ? null : () {
                        setState(() {
                          if (_seatCount > 2) _seatCount--;
                        });
                      },
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '$_seatCount',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          _seatCount++;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (_seatCount < 2)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Mínimo de 2 vagas necessárias',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              // Observações
              const Text(
                'Observações',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Adicione suas observações',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button (Salvar)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateCarona,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Salvar Alterações'),
                ),
              ),
              const SizedBox(height: 16),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
