import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);

  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).accentColor,
                shape: new RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0))
              ),
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: press,
      ),
      ),
    );
  }
}

