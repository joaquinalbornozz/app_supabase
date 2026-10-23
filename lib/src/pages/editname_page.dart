import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final TextEditingController nombreController = TextEditingController(
    text: '',
  );
  bool _initialized = false;
  dynamic _id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      nombreController.text = arguments['nombre'] as String;
      _id = arguments['id'];
      _initialized = true;
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supabase = SupabaseService.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF059669),
        foregroundColor: Colors.white,
        title: const Text('Editar Nombre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                hintText: 'Ingrese Modificación',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (nombreController.text.trim().isEmpty) return;
                await supabase.updatePersona(_id, nombreController.text.trim());
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
