import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instacar/core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _emailErrorText;
  String? _passwordErrorText;

  bool _isEmailValid(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password != "";
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _emailErrorText = null;
      _passwordErrorText = null;
    });

    final email = _emailController.text;
    final senha = _passwordController.text;

    if (!_isEmailValid(email)) {
      setState(() {
        _isLoading = false;
        _emailErrorText = "E-mail inválido";
      });
      return;
    }

    if (!_isPasswordValid(senha)) {
      setState(() {
        _isLoading = false;
        _passwordErrorText = "Senha incorreta";
      });
      return;
    }

    final token = await AuthService.login(email, senha);

    setState(() {
      _isLoading = false;
    });

    if (token != null) {
      GoRouter.of(context).go('/home');
    } else {
      setState(() {
        _emailErrorText = "E-mail ou senha incorretos";
        _passwordErrorText = "E-mail ou senha incorretos";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/instacar.png', height: 110),
            SizedBox(height: 16),
            SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                errorText:
                    _emailErrorText, // Exibe mensagem de erro do e-mail aqui
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Senha",
                errorText:
                    _passwordErrorText, // Exibe mensagem de erro da senha aqui
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

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  GoRouter.of(context).push('/forgot');
                },
                child: Text(
                  "Esqueci minha senha",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
              child:
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Entrar", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Não tem uma conta?"),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).go('/pricing');
                  },
                  child: Text("Criar", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
