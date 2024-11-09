import 'package:flutter/material.dart';

class PaginaCalendario extends StatelessWidget {
  static const String routename = 'calendario'; // Opcional si usas rutas

  const PaginaCalendario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          'Aquí se mostrará el calendario',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}