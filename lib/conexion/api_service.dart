import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/citas'; 

  // Método para agendar una cita (POST /agendar)
  Future<Map<String, dynamic>> agendarCita(Map<String, dynamic> citaData) async {
    final url = Uri.parse('$baseUrl/agendar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(citaData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al agendar cita: ${response.body}');
    }
  }

  // Método para obtener horarios disponibles (GET /disponibilidad/{fecha})
  Future<List<dynamic>> obtenerDisponibilidad(String fecha) async {
    final url = Uri.parse('$baseUrl/disponibilidad/$fecha');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener disponibilidad: ${response.body}');
    }
  }

  // Método para obtener cita por ID (GET /citas/{id_cita})
  Future<Map<String, dynamic>> obtenerCitaPorId(String idCita) async {
    final url = Uri.parse('$baseUrl/citas/$idCita');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener cita: ${response.body}');
    }
  }

  // Método para obtener citas por contacto (GET /citas/contacto/{correo})
  Future<List<dynamic>> obtenerCitasPorContacto(String correo, String fechaInicio) async {
    final url = Uri.parse('$baseUrl/citas/contacto/$correo?fecha_inicio=$fechaInicio');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener citas por contacto: ${response.body}');
    }
  }
}
