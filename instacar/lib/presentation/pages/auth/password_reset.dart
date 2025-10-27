import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  _PasswordReset createState() => _PasswordReset();
}

class _PasswordReset extends State<PasswordReset> {
  final TextEditingController _pinController = TextEditingController();

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
              "Redefinir senha",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Clique em confirmar para definir uma nova senha",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push('/set');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Confirmar", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}