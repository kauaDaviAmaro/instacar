import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

  @override
  _SetPassword createState() => _SetPassword();
}

class _SetPassword extends State<SetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isSuccess = false;

  String email = '';
  String code = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      email = extra['email'] ?? '';
      code = extra['code'] ?? '';
    }
  }

  Future<void> _validatePassword() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Preencha todos os campos.');
      return;
    }

    if (password.length < 6) {
      _showSnackBar('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('As senhas não coincidem.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
          'newPassword': password,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSuccess = true;
        });
        await Future.delayed(Duration(seconds: 2));
        GoRouter.of(context).push('/login');
      } else {
        _showSnackBar('Erro: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Erro ao conectar com o servidor.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Insira uma nova senha",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Crie uma nova senha diferente das anteriores.",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirmar senha",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed:
                          () => setState(
                            () =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                          ),
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _validatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              "Atualizar senha",
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ),
              ],
            ),
          ),

          // Se o estado de sucesso for verdadeiro, mostrar a animação do Lottie
          if (_isSuccess)
            Positioned.fill(
              child: Container(
                color: Colors.white, // Para escurecer o fundo
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/lottie/success.json',
                        width: 150,
                        repeat: false,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Senha alterada com sucesso!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 400),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
