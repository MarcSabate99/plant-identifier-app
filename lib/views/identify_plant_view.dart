import 'dart:io';

import 'package:flutter/material.dart';

class IdentifyPlantView extends StatelessWidget {
  getImage(file) {
    if (file != null) {
      return Image.file(file, width: 350, height: 350);
    }
  }

  @override
  Widget build(BuildContext context) {
    final File file = ModalRoute.of(context).settings.arguments;
    return new Column(
      children: <Widget>[
        new Expanded(
          child: new Container(
            padding: new EdgeInsets.all(8.0),
            color: new Color.fromRGBO(135, 211, 124, 1),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[getImage(file)]),
          ),
        ),
      ],
    );
  }
}
