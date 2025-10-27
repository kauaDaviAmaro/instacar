import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CodePage extends StatefulWidget {
  const CodePage({super.key});

  @override
  _CodePage createState() => _CodePage();
}

class _CodePage extends State<CodePage> {
  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;
  String email = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final extra = GoRouterState.of(context).extra;
    if (extra is String) {
      email = extra;
    }
  }

  Future<void> _validateCode(String email) async {
    final code = _pinController.text.trim();

    if (code.isEmpty || code.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('O código deve conter 5 dígitos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        GoRouter.of(
          context,
        ).push('/set', extra: {'email': email, 'code': code});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código inválido ou expirado.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao conectar com o servidor.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Verifique seu email",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Entre com os 5 dígitos que enviamos para $email",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 30),
            Center(
              child: Pinput(
                length: 5,
                controller: _pinController,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _validateCode(email),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                ),
                child:
                    _isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          "Atualizar senha",
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: TextButton(
                onPressed: () {
                  // Aqui você pode reutilizar a lógica da tela de "forgot-password"
                  // ou fazer uma requisição para reenviar o código
                },
                child: Text(
                  "Não recebeu o email ainda? Reenviar email",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
