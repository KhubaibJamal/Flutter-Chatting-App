import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget({
    super.key,
    required this.label,
    required this.isObscure,
    required this.prefixIcon,
    required this.onChange,
    required this.validator,
  });
  final String label;
  final IconData prefixIcon;
  final bool isObscure;
  String? Function(String?)? validator;
  String? Function(String?)? onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).primaryColor,
        ),
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff6B728E), width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff6B728E), width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff6B728E), width: 2),
        ),
      ),
      onChanged: onChange,
      validator: validator,
    );
  }
}
