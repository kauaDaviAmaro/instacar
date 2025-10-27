import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl =
      'http://10.0.2.2:3000/api'; // ajuste conforme o ambiente

  static Future<String?> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final token = json['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      return token;
    } else {
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  final telefoneMask = MaskedInputFormatter('(##) #####-####');
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.grey),
  );

  bool _mostrarSenha = false;
  bool _mostrarConfirmaSenha = false;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final token = await AuthService.getToken();
    print('Token: $token'); // Debugging line to check token
    if (token == null) return;

    final response = await http.get(
      Uri.parse('http://localhost:3000/api/users/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['user'];

      setState(() {
        _nomeController.text = user['name'] ?? '';
        _emailController.text = user['email'] ?? '';
        _telefoneController.text = user['phone'] ?? '';
        if (user['birthDate'] != null) {
          final parsed = DateTime.parse(user['birthDate']);
          _dataNascimentoController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(parsed);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar dados do usuário')),
      );
    }
  }

  Future<void> _editarInformacoes() async {
    final token = await AuthService.getToken();
    if (token == null) return;

    final dataNascimento = _dataNascimentoController.text;
    DateTime? parsedDataNascimento;

    try {
      parsedDataNascimento = DateFormat(
        'dd/MM/yyyy',
      ).parseStrict(dataNascimento);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data de nascimento inválida')),
      );
      return;
    }

    final response = await http.put(
      Uri.parse('http://localhost:3000/api/users/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': _nomeController.text,
        'email': _emailController.text,
        'birthDate': parsedDataNascimento.toIso8601String(),
        'phone': _telefoneController.text,
        if (_senhaController.text.isNotEmpty) 'password': _senhaController.text,
      }),
    );


    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informações atualizadas com sucesso!')),
      );
      Future.delayed(const Duration(seconds: 1), () {
        GoRouter.of(context).go('/profile');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar informações')),
      );
    }
  }

  void _toggleMostrarSenha() {
    setState(() {
      _mostrarSenha = !_mostrarSenha;
    });
  }

  void _toggleMostrarConfirmaSenha() {
    setState(() {
      _mostrarConfirmaSenha = !_mostrarConfirmaSenha;
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _dataNascimentoController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).push('/profile'),
        ),
        title: const Text(
          'Perfil do Usuário',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Edite suas informações de usuário:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome completo',
                hintText: 'Insira seu nome',
                border: border,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Insira seu email',
                border: border,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dataNascimentoController,
              readOnly: true,
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dataNascimentoController.text = DateFormat(
                      'dd/MM/yyyy',
                    ).format(pickedDate);
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Data de nascimento',
                hintText: 'DD/MM/AAAA',
                suffixIcon: const Icon(Icons.calendar_today),
                border: border,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [telefoneMask],
              decoration: InputDecoration(
                labelText: 'Número de celular',
                hintText: '(DDD) xxxxx-xxxx',
                border: border,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaController,
              obscureText: !_mostrarSenha,
              decoration: InputDecoration(
                labelText: 'Senha',
                hintText: 'Insira sua nova senha',
                suffixIcon: IconButton(
                  icon: Icon(
                    _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _toggleMostrarSenha,
                ),
                border: border,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmaSenhaController,
              obscureText: !_mostrarConfirmaSenha,
              decoration: InputDecoration(
                labelText: 'Confirmar senha',
                hintText: 'Confirme sua senha',
                suffixIcon: IconButton(
                  icon: Icon(
                    _mostrarConfirmaSenha
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: _toggleMostrarConfirmaSenha,
                ),
                border: border,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _editarInformacoes,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFFD0DBFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Editar informações',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
