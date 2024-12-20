import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetucaldas/conexion/citas_service.dart';

class PaginaCalendario extends StatefulWidget {
  static const String routename = 'calendario';

  const PaginaCalendario({super.key});

  @override
  _PaginaCalendarioState createState() => _PaginaCalendarioState();
}

class _PaginaCalendarioState extends State<PaginaCalendario> {
  final CitasService _citasService = CitasService();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _correoUsuario;
  Map<DateTime, List<String>> _citas = {};

  @override
  void initState() {
    super.initState();
    _loadCorreoUsuario();
  }

  Future<void> _loadCorreoUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final correo = prefs.getString('correo_dueño');
    _correoUsuario = correo; // Cargar el correo almacenado
  }

  Future<void> _fetchCitas() async {
    print('');
    try {
      final citasList = await _citasService.obtenerCitasCorreo(_correoUsuario!, _selectedDay!); //citas traidas del backend por correo y fecha
      setState(() {
        _citas = {}; // Reinicia el mapa antes de llenarlo

        for (var cita in citasList) {
          final fechaHora = DateTime.parse(cita['fecha_hora']);
          final descripcion =
              'Estado: ${cita['estado']} - Paciente: ${cita['nombre_mascota']} - Hora cita: ${fechaHora.hour.toString().padLeft(2, '0')}:${fechaHora.minute.toString().padLeft(2, '0')}';

          final dateKey =
              DateTime(fechaHora.year, fechaHora.month, fechaHora.day);
          if (_citas.containsKey(dateKey)) {
            _citas[dateKey]!.add(descripcion);
          } else {
            _citas[dateKey] = [descripcion];
          }
        }
      });
    } catch (e) {
      // Maneja el error mostrando un mensaje en la interfaz
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener citas: $e')),
      );
    }
  }

  List<String> _getCitasForSelectedDay(DateTime? selectedDay) {//obtiene la cita por el dia seleccionado y se agrega para mostrar
    if (selectedDay == null) return [];
    DateTime normalizedDate =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    return _citas[normalizedDate] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    List<String> citasDelDia = _getCitasForSelectedDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Citas'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          SizedBox.expand(
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
          // Contenido principal
          Column(
            children: [
              // Container para la tabla de calendario
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.blueAccent, width: 1),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _fetchCitas();
                  },
                  calendarFormat: CalendarFormat.month,
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
              const Divider(color: Colors.grey),

              // Mostrar cuadro de citas
              Expanded(
                child: citasDelDia.isNotEmpty
                    ? ListView.builder(
                        itemCount: citasDelDia.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                  color: Colors.blueAccent, width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.event, color: Colors.blue),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    citasDelDia[index],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No hay citas programadas para este día',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
