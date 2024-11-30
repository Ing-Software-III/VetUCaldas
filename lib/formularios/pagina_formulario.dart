import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetucaldas/custom/form_builder.dart';
import 'package:vetucaldas/conexion/citas_service.dart';

class PaginaFormulario extends StatefulWidget {
  static const String routename = 'formulario';

  const PaginaFormulario({super.key});

  @override
  State<PaginaFormulario> createState() => _PaginaFormularioState();
}

class _PaginaFormularioState extends State<PaginaFormulario> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  List<String> opciones = []; // Changed to List<String> for type safety
  String? selectedTime;
  DateTime? selectedDate;

  Future<void> _obtenerOpcionesDropdown() async {
    if (selectedDate != null) {
      String fechaFormateada = selectedDate!.toIso8601String().split('T')[0];
      try {
        final List<dynamic> fetchedOptions =
            await CitasService().obtenerDisponibilidad(fechaFormateada);
        setState(() {
          // Ensure we convert the dynamic values to strings
          opciones = fetchedOptions.map((option) => option.toString()).toList();
        });
      } catch (e) {
        print('Error al procesar los datos: $e');
      }
    }
  }

  String formatearHoraFecha(String hora, DateTime fecha) {
    String horaCompleta = hora.split('T')[1]; // Extrae "12:00:00"
    String? dia;
    if (fecha.day.toInt() < 10) {
      dia = '0${fecha.day}';
      return '${fecha.year}-${fecha.month}-${dia}T$horaCompleta';
    }
    return '${fecha.year}-${fecha.month}-${fecha.day}T$horaCompleta';
  }

  void _submitForm() async {
    if (_formkey.currentState?.validate() == true) {
      _formkey.currentState?.save();
      final values = _formkey.currentState?.value;

      // Get the date from form
      DateTime fecha = values?['Fecha_cita'];
      String hora = values?['Hora_cita'];
      // Use the selectedTime string directly instead of trying to parse it as DateTime
      String fechaHora = formatearHoraFecha(hora, fecha);


      // Create the body with the data
      final body = {
        "nombre_mascota": values?['Nombre_mascota'],
        "nombre_dueño": values?['Nombre_dueño'],
        "correo": values?['Correo_dueño'],
        "telefono": values?['Celular_dueño'],
        "fecha_hora": fechaHora,
        "cedula": values?['Cedula_dueño'],
      };

      try {
        final response = await CitasService().agendarCita(body);
        print('Respuesta del servidor: $response');
        // Guardar el correo en almacenamiento local
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('correo_dueño', values?['Correo_dueño'] ?? '');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Cita agendada con éxito!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        // Limpiar los campos del formulario
        _formkey.currentState?.reset();
        setState(() {
          selectedTime = null; // Restablece la hora seleccionada si aplica
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      print('El formulario contiene errores');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: SafeArea(
          child: FormBuilder(
            key: _formkey,
            child: Column(
              children: [
                FormBuilderCustom(
                  keytype: TextInputType.text,
                  name: 'Nombre_mascota',
                  hinText: 'Nombre de la mascota',
                  icon: Icons.pets,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'El nombre es requerido'),
                    FormBuilderValidators.minLength(3,
                        errorText:
                            'El nombre debe tener al menos 3 caracteres'),
                  ]),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FormBuilderDateTimePicker(
                          name: 'Fecha_cita',
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          inputType: InputType.date,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de la cita',
                            hintText: 'Selecciona la fecha de tu cita',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          validator: (datetime) {
                            if (datetime == null) {
                              return 'La fecha es requerida';
                            }
                            if (datetime.isBefore(DateTime.now())) {
                              return 'La fecha debe ser futura';
                            }
                            return null;
                          },
                          onChanged: (datetime) {
                            if (datetime != null) {
                              setState(() {
                                selectedDate = datetime;
                                opciones = [];
                              });
                              _obtenerOpcionesDropdown();
                            }
                          },
                        ),
                      ),
                      const Icon(
                        Icons.calendar_month,
                        color: Color.fromARGB(255, 173, 173, 173),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: FormBuilderDropdown<String>(
                    name: 'Hora_cita',
                    decoration: const InputDecoration(
                      labelText: 'Hora de la cita',
                      border: InputBorder.none,
                    ),
                    hint: const Text('Selecciona una hora'),
                    items: opciones
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            ))
                        .toList(),
                    validator: FormBuilderValidators.required(
                        errorText: 'La hora es requerida'),
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value;
                      });
                    },
                  ),
                ),

                // Información del dueño
                FormBuilderCustom(
                  keytype: TextInputType.text,
                  name: 'Nombre_dueño',
                  hinText: 'Nombre completo del dueño',
                  icon: Icons.person,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'El nombre es requerido'),
                    FormBuilderValidators.minLength(3,
                        errorText:
                            'El nombre debe tener al menos 3 caracteres'),
                  ]),
                ),

                FormBuilderCustom(
                  keytype: TextInputType.number,
                  name: 'Cedula_dueño',
                  hinText: 'Cédula de ciudadanía',
                  icon: Icons.badge_outlined,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'La cédula es requerida'),
                    CustomValidators.colombianCedula(),
                  ]),
                ),

                FormBuilderCustom(
                  keytype: TextInputType.phone,
                  name: 'Celular_dueño',
                  hinText: 'Número de celular',
                  icon: Icons.phone_android,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'El celular es requerido'),
                    CustomValidators.colombianPhone(),
                  ]),
                ),

                FormBuilderCustom(
                  keytype: TextInputType.emailAddress,
                  name: 'Correo_dueño',
                  hinText: 'Correo electrónico',
                  icon: Icons.email,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'El correo es requerido'),
                    CustomValidators.colombianMail(),
                  ]),
                ),

                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue, width: 2.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Agendar cita',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 71, 180, 75),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Agendar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
