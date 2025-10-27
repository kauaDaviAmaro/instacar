import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  int selectedStars = 4;
  bool isLoading = false;

  Future<void> submitFeedback() async {
    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/feedback'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'email': emailController.text,
        'rating': selectedStars,
        'comment': commentController.text,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Obrigado pelo seu feedback!')),
      );
      GoRouter.of(context).pop();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao enviar feedback')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Add blue background color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Make back arrow white for better contrast
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: const Text('Fale Conosco'),
        centerTitle: true,
        foregroundColor: Colors.white, // Make title text white
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Deixe sua opinião, sugestão ou elogio:',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Nome'),
            const SizedBox(height: 4),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                hintText: 'Digite seu nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Email'),
            const SizedBox(height: 4),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                hintText: 'Digite seu email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            const Text(
              'Como você avalia sua experiência?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < selectedStars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => setState(() => selectedStars = index + 1),
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                    'Fale mais sobre sua experiência ou o que podemos melhorar.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('ENVIAR'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
