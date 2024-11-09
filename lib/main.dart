import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vetucaldas/formularios/pagina_formulario.dart';
import 'package:vetucaldas/Calendario/pagina_calendario.dart'; // Importa la pantalla de calendario

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Material App',
        initialRoute: '/', // Se establece la ruta principal como "/"
        routes: {
          '/': (context) => const HomeScreen(), // La ruta principal es HomeScreen
          PaginaFormulario.routename: (context) => const PaginaFormulario(),
          PaginaCalendario.routename: (context) => const PaginaCalendario(), // Ruta para la pantalla de calendario
        },
      );
    });
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Para manejar la selección del BottomNavigationBar

  // Lista de pantallas para las pestañas
  final List<Widget> _screens = const [
    PaginaFormulario(),
    PaginaCalendario(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Muestra la pantalla correspondiente según el índice seleccionado
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
