import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService instance = SupabaseService._init();
  final supabase = Supabase.instance.client;

  SupabaseService._init();

  /// Consulta todos los registros de la tabla 'persona' ordenados por id.
  Future<List<Map<String, dynamic>>> getPersona() async {
    final List<dynamic> response = await supabase
        .from('persona')
        .select('id, nombre')
        .order('id', ascending: true);

    return response
        .map((fila) => {'id': fila['id'], 'nombre': fila['nombre'] ?? ''})
        .toList();
  }

  /// Inserta un nuevo registro en la tabla 'persona'.
  Future<void> addPersona(String nombre) async {
    await supabase.from('persona').insert({'nombre': nombre});
  }

  /// Actualiza el campo 'nombre' de un registro existente según su 'id'.
  Future<void> updatePersona(dynamic id, String newNombre) async {
    await supabase.from('persona').update({'nombre': newNombre}).eq('id', id);
  }

  /// Elimina un registro de la tabla 'persona' según su 'id'.
  Future<void> borrarPersona(dynamic id) async {
    await supabase.from('persona').delete().eq('id', id);
  }
}
