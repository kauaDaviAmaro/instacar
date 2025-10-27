import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  final String? selectedPlan;
  
  const RegisterPage({super.key, this.selectedPlan});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  String? _selectedGender;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  String? _nameErrorText;
  String? _emailErrorText;
  String? _birthDateErrorText;
  String? _phoneErrorText;
  String? _cepErrorText;
  String? _numberErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;
  String? _genderErrorText;

  bool _isEmailValid(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _isNameValid(String name) {
    return name.trim().length >= 2;
  }

  bool _isPhoneValid(String phone) {
    return phone.replaceAll(RegExp(r'[^\d]'), '').length == 11;
  }

  bool _isCepValid(String cep) {
    return cep.replaceAll(RegExp(r'[^\d]'), '').length == 8;
  }

  Future<void> registerUser() async {
    setState(() {
      _isLoading = true;
      _nameErrorText = null;
      _emailErrorText = null;
      _birthDateErrorText = null;
      _phoneErrorText = null;
      _cepErrorText = null;
      _numberErrorText = null;
      _passwordErrorText = null;
      _confirmPasswordErrorText = null;
      _genderErrorText = null;
    });

    // Validações
    if (!_isNameValid(nameController.text)) {
      setState(() {
        _isLoading = false;
        _nameErrorText = "Nome deve ter pelo menos 2 caracteres";
      });
      return;
    }

    if (!_isEmailValid(emailController.text)) {
      setState(() {
        _isLoading = false;
        _emailErrorText = "E-mail inválido";
      });
      return;
    }

    if (birthDateController.text.isEmpty) {
      setState(() {
        _isLoading = false;
        _birthDateErrorText = "Data de nascimento obrigatória";
      });
      return;
    }

    if (_selectedGender == null) {
      setState(() {
        _isLoading = false;
        _genderErrorText = "Gênero obrigatório";
      });
      return;
    }

    if (!_isPhoneValid(phoneController.text)) {
      setState(() {
        _isLoading = false;
        _phoneErrorText = "Telefone inválido";
      });
      return;
    }

    if (!_isCepValid(cepController.text)) {
      setState(() {
        _isLoading = false;
        _cepErrorText = "CEP inválido";
      });
      return;
    }

    if (numberController.text.isEmpty) {
      setState(() {
        _isLoading = false;
        _numberErrorText = "Número obrigatório";
      });
      return;
    }

    if (!_isPasswordValid(passwordController.text)) {
      setState(() {
        _isLoading = false;
        _passwordErrorText = "Senha deve ter pelo menos 6 caracteres";
      });
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _isLoading = false;
        _confirmPasswordErrorText = "As senhas não coincidem";
      });
      return;
    }

    final url = Uri.parse('http://localhost:3000/api/users/register');

    final body = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'birthDate': birthDateController.text.trim(),
      'phone': phoneController.text.trim(),
      'cep': cepController.text.trim(),
      'number': numberController.text.trim(),
      'gender': _selectedGender,
      'password': passwordController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        // Cadastro bem-sucedido
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Falha no cadastro'),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Tenta voltar no histórico, se não conseguir vai para pricing
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/pricing');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/instacar.png', height: 110),
              SizedBox(height: 16),
              Text(
                "Criar Conta",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              
              // Exibir plano selecionado
              if (widget.selectedPlan != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: widget.selectedPlan == 'premium' 
                        ? Color(0xFF4A90E2).withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.selectedPlan == 'premium' 
                          ? Color(0xFF4A90E2)
                          : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: widget.selectedPlan == 'premium' 
                            ? Color(0xFF4A90E2)
                            : Colors.grey,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Plano ${widget.selectedPlan == 'premium' ? 'Premium' : 'Básico'} selecionado',
                        style: TextStyle(
                          color: widget.selectedPlan == 'premium' 
                              ? Color(0xFF4A90E2)
                              : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 32),
              
              // Nome
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nome Completo",
                  errorText: _nameErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: _emailErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),

              // Data de Nascimento
              TextField(
                controller: birthDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Data de Nascimento",
                  errorText: _birthDateErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
                    setState(() {
                      _birthDateErrorText = null;
                    });
                  }
                                },
              ),
              SizedBox(height: 12),

              // Gênero
              DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: InputDecoration(
                  labelText: "Gênero",
                  errorText: _genderErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: "Masculino", child: Text("Masculino")),
                  DropdownMenuItem(value: "Feminino", child: Text("Feminino")),
                  DropdownMenuItem(value: "Outro", child: Text("Outro")),
                  DropdownMenuItem(value: "Prefiro não informar", child: Text("Prefiro não informar")),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                    _genderErrorText = null;
                  });
                },
              ),
              SizedBox(height: 12),

              // Telefone
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Celular",
                  errorText: _phoneErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [MaskedInputFormatter('## #####-####')],
              ),
              SizedBox(height: 12),

              // CEP e Número em linha
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: cepController,
                      decoration: InputDecoration(
                        labelText: "CEP",
                        errorText: _cepErrorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [MaskedInputFormatter('#####-###')],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: numberController,
                      decoration: InputDecoration(
                        labelText: "Número",
                        errorText: _numberErrorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Senha
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Senha",
                  errorText: _passwordErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
              ),
              SizedBox(height: 12),

              // Confirmar Senha
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirmar Senha",
                  errorText: _confirmPasswordErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
              ),

              SizedBox(height: 24),
              
              // Botão de Cadastro
              ElevatedButton(
                onPressed: _isLoading ? null : registerUser,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Criar Conta", style: TextStyle(color: Colors.white)),
              ),
              
              SizedBox(height: 16),
              
              // Link para Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Já tem uma conta?"),
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: Text("Fazer Login", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}