import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

// Widget base para estilos compartidos
class FormBuilderBase extends StatelessWidget {
  final Widget child;
  final String hinText;
  final IconData icon;

  const FormBuilderBase({
    super.key,
    required this.child,
    required this.hinText,
    required this.icon,
  });

  InputDecoration get baseDecoration => InputDecoration(
        errorStyle: TextStyle(color: Colors.red, fontSize: 11.sp),
        hintText: hinText,
        hintStyle: const TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        suffixIcon: Icon(icon, color: Colors.grey),
        fillColor: Colors.white,
        filled: true,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: child,
    );
  }
}

// Campo de texto personalizado
class FormBuilderCustom extends StatelessWidget {
  final String name;
  final String hinText;
  final String? Function(String?)? validator;
  final IconData icon;
  final TextInputType keytype;

  const FormBuilderCustom({
    super.key,
    required this.name,
    required this.hinText,
    this.validator,
    required this.icon,
    required this.keytype,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderBase(
      hinText: hinText,
      icon: icon,
      child: FormBuilderTextField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: name,
        style: const TextStyle(color: Colors.black),
        decoration: FormBuilderBase(
          hinText: hinText,
          icon: icon,
          child: Container(),
        ).baseDecoration,
        keyboardType: keytype,
        validator: validator,
      ),
    );
  }
}

// Campo de fecha personalizado
class FormBuilderDateCustom extends StatelessWidget {
  final String name;
  final String hinText;
  final IconData icon;
  final String? Function(DateTime?)? validator;

  const FormBuilderDateCustom({
    super.key,
    required this.name,
    required this.hinText,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderBase(
      hinText: hinText,
      icon: icon,
      child: FormBuilderDateTimePicker(
        name: name,
        inputType: InputType.date,
        format: DateFormat('dd/MM/yyyy'),
        decoration: FormBuilderBase(
          hinText: hinText,
          icon: icon,
          child: Container(),
        ).baseDecoration,
        validator: validator,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

// Campo de hora personalizado
class FormBuilderTimeCustom extends StatelessWidget {
  final String name;
  final String hinText;
  final IconData icon;
  final String? Function(DateTime?)? validator;

  const FormBuilderTimeCustom({
    super.key,
    required this.name,
    required this.hinText,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderBase(
      hinText: hinText,
      icon: icon,
      child: FormBuilderDateTimePicker(
        name: name,
        inputType: InputType.time,
        decoration: FormBuilderBase(
          hinText: hinText,
          icon: icon,
          child: Container(),
        ).baseDecoration,
        validator: validator,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

// Validadores personalizados
class CustomValidators {
  static String? Function(String?) colombianPhone() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'El número de teléfono es requerido'),
      FormBuilderValidators.numeric(errorText: 'Solo se permiten números'),
      FormBuilderValidators.minLength(10, errorText: 'El número debe tener 10 dígitos'),
      FormBuilderValidators.maxLength(10, errorText: 'El número debe tener 10 dígitos'),
    ]);
  }

  static String? Function(String?) colombianCedula() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'La cédula es requerida'),
      FormBuilderValidators.numeric(errorText: 'Solo se permiten números'),
      FormBuilderValidators.minLength(8, errorText: 'La cédula debe tener entre 8 y 10 dígitos'),
      FormBuilderValidators.maxLength(10, errorText: 'La cédula debe tener entre 8 y 10 dígitos'),
    ]);
  }

  static String? Function(String?) colombianMail() {
  return FormBuilderValidators.compose([
    FormBuilderValidators.required(errorText: 'El correo es requerido'),
    FormBuilderValidators.email(errorText: 'Ingrese un correo válido'),
    FormBuilderValidators.match(
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'), // Usa RegExp en lugar de String
      errorText: 'El formato del correo no es válido',),
      ]);
  }

}