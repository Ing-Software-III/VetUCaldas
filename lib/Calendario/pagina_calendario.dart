import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PaginaCalendario extends StatefulWidget {
  static const String routename = 'calendario';

  const PaginaCalendario({super.key});

  @override
  _PaginaCalendarioState createState() => _PaginaCalendarioState();
}

class _PaginaCalendarioState extends State<PaginaCalendario> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Ejemplo de citas programadas
  final Map<DateTime, List<String>> _citas = {
    DateTime(2024, 11, 14): ['Consulta general - 10:00 AM', 'Vacunación - 2:00 PM'],
    DateTime(2024, 11, 15): ['Chequeo dental - 11:00 AM'],
    DateTime(2024, 11, 16): ['Cirugía menor - 1:00 PM'],
  };

  List<String> _getCitasForSelectedDay(DateTime? selectedDay) {
    if (selectedDay == null) return [];
    DateTime normalizedDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
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
              'assets/images/logo.png', // Cambia esta ruta según la ubicación de tu imagen
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
                  },
                  calendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
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
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8), // Fondo con transparencia
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
                            child: Row(
                              children: [
                                const Icon(Icons.event, color: Colors.blue),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    citasDelDia[index],
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
