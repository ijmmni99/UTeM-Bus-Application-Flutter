import 'package:flutter/material.dart';
import 'package:utem_bus_app/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hinText;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Function(String) validator;
  const RoundedInputField({
    Key key,
    this.hinText,
    this.controller,
    this.icon,
    this.onChanged,
    this.validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: validator,
        onChanged: onChanged,
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 16.0),
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          hintText: hinText,
          hintStyle: TextStyle(
            color: Colors.white.withAlpha(100)
          ),
          border: InputBorder.none
        ),

      ),
    );
  }
}