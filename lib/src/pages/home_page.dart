import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final supabase = SupabaseService.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF059669),
        foregroundColor: Colors.white,
        title: const Text('Personas — Supabase + Flutter'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        initialData: const [],
        future: supabase.getPersona(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Error al conectar con Supabase:\n${snapshot.error}\n\nVerifica tu URL, Anon Key y que la tabla "persona" exista.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final personas = snapshot.data ?? [];
          if (personas.isEmpty) {
            return const Center(
              child: Text(
                'No hay personas registradas en la tabla.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: personas.length,
            itemBuilder: (context, index) {
              final persona = personas[index];
              final id = persona['id'];
              final nombre = persona['nombre'] as String;

              return Dismissible(
                key: Key(id.toString()),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  final bool? result = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('¿Está seguro de eliminar a $nombre?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Sí, estoy seguro'),
                          ),
                        ],
                      );
                    },
                  );
                  return result ?? false;
                },
                onDismissed: (direction) async {
                  await supabase.borrarPersona(id);
                  personas.removeAt(index);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    child: Text(
                      nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                    ),
                  ),
                  title: Text(nombre),
                  subtitle: Text('ID: $id'),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      '/edit',
                      arguments: {'id': id, 'nombre': nombre},
                    );
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF059669),
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
