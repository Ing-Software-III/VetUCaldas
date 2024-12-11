import 'dart:convert';
import 'package:http/http.dart' as http;

class CitasService {
  static const String _baseUrl = 'https://vetucaldas-backend.onrender.com/citas';

  Future<Map<String, dynamic>> agendarCita(Map<String, dynamic> cita) async {
    final url = Uri.parse('$_baseUrl/agendar');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cita),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body); // Respuesta del servidor
      } else {
        throw Exception('Error al agendar la cita: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<dynamic>> obtenerDisponibilidad(String fecha) async {
    final url = Uri.parse('$_baseUrl/disponibilidad/$fecha');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Lista de horarios disponibles
      } else {
        throw Exception('Error al obtener disponibilidad: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<dynamic>> obtenerCitasCorreo(String correo, DateTime fecha) async {
    final url = Uri.parse('$_baseUrl/citas/contacto/$correo?fecha_inicio=${fecha.toIso8601String().split('T').first}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Lista de horarios disponibles
      } else {
        throw Exception('Error al obtener disponibilidad: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  

  // Otros métodos como obtener citas por ID, por contacto, etc.
}
