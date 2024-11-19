import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:vetucaldas/custom/form_builder.dart';

class PaginaFormulario extends StatefulWidget {
  static const String routename = 'formulario';

  const PaginaFormulario({super.key});

  @override
  State<PaginaFormulario> createState() => _PaginaFormularioState();
}

class _PaginaFormularioState extends State<PaginaFormulario> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  void _submitForm() {
    if (_formkey.currentState?.validate() == true) {
      final values = _formkey.currentState?.value;
      // Aquí puedes procesar los valores del formulario
      print('Nombre mascota: ${values?['Nombre_mascota']}');
      print('Fecha cita: ${values?['Fecha_cita']}');
      print('Hora cita: ${values?['Hora_cita']}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cita agendada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
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
                // Header con título y botón
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue, width: 2.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
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
                          backgroundColor: const Color.fromARGB(255, 71, 180, 75),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Agendar'),
                      ),
                    ],
                  ),
                ),

                // Información de la mascota
                FormBuilderCustom(
                  keytype: TextInputType.text,
                  name: 'Nombre_mascota',
                  hinText: 'Nombre de la mascota',
                  icon: Icons.pets,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'El nombre es requerido'),
                    FormBuilderValidators.minLength(3, errorText: 'El nombre debe tener al menos 3 caracteres'),
                  ]),
                ),

                // Fecha y hora
                FormBuilderDateCustom(
                  name: 'Fecha_cita',
                  hinText: 'Fecha de la cita',
                  icon: Icons.calendar_month,
                  validator: (datetime) {
                    if (datetime == null) return 'La fecha es requerida';
                    if (datetime.isBefore(DateTime.now())) {
                      return 'La fecha debe ser futura';
                    }
                    return null;
                  },
                ),

                FormBuilderTimeCustom(
                  name: 'Hora_cita',
                  hinText: 'Hora de la cita',
                  icon: Icons.access_time,
                  validator: (datetime) {
                    if (datetime == null) return 'La hora es requerida';
                    return null;
                  },
                ),

                const Divider(
                  color: Colors.white,
                  thickness: 1.5,
                  indent: 20,
                  endIndent: 20,
                ),

                // Información del dueño
                FormBuilderCustom(
                  keytype: TextInputType.text,
                  name: 'Nombre_dueño',
                  hinText: 'Nombre completo del dueño',
                  icon: Icons.person,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'El nombre es requerido'),
                    FormBuilderValidators.minLength(3, errorText: 'El nombre debe tener al menos 3 caracteres'),
                  ]),
                ),

                FormBuilderCustom(
                  keytype: TextInputType.number,
                  name: 'Cedula_dueño',
                  hinText: 'Cédula de ciudadanía',
                  icon: Icons.badge_outlined,
                  validator: CustomValidators.colombianCedula(),
                ),

                FormBuilderCustom(
                  keytype: TextInputType.phone,
                  name: 'Celular_dueño',
                  hinText: 'Número de celular',
                  icon: Icons.phone_android,
                  validator: CustomValidators.colombianPhone(),
                ),

                FormBuilderCustom(
                  keytype: TextInputType.emailAddress,
                  name: 'Correo_dueño',
                  hinText: 'Correo electrónico',
                  icon: Icons.email,
                  validator: CustomValidators.colombianMail(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
