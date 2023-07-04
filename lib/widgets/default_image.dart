import 'package:flutter/material.dart';

class DefaultImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Container(
        padding: new EdgeInsets.all(8.0),
        color: new Color.fromRGBO(135, 211, 124, 1),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage('images/plant.png'),
                  width: 100,
                  height: 100),
            ]),
      ),
    );
  }
}
