import 'package:flutter/material.dart';
import 'package:utem_bus_app/components/text_field_container.dart';


class RoundedPasswordField extends StatefulWidget {

  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final Function(String) validator;
  const RoundedPasswordField({
    Key key,
    this.controller,
    this.onChanged,
    this.validator
  }) : super(key: key);

  @override
  RoundedPasswordFieldState createState() => RoundedPasswordFieldState();
}

class RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    
    return TextFieldContainer(
      child: TextFormField(
        validator: widget.validator,
        onChanged: widget.onChanged,
        controller: widget.controller,
        obscureText: passwordVisible,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Kata Laluan',
          hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
          errorStyle: TextStyle(fontSize: 16.0),
          icon: Icon(
            Icons.lock,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
            color: Colors.white,
            onPressed: _togglePasswordView,
          ),
          border: InputBorder.none,
      ),
    )
    // LoginField(
    //   emailController: emailController,
    //   passwordController: passwordController
    //   )
    );
  }

  void _togglePasswordView() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }
}

