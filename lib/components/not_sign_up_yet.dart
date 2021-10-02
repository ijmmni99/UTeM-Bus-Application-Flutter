import 'package:flutter/material.dart';

class NotSignUpTextButton extends StatelessWidget {
  final Function press;

  const NotSignUpTextButton({
    this.press,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Belum mendaftar akaun ? ',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            'Daftar',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}