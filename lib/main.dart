import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plantidentifier/views/select_identified_plant_view.dart';
import 'package:plantidentifier/widgets/default_image.dart';
import 'package:image_picker/image_picker.dart';


void main() =>
    runApp(new MaterialApp(title: "Plant Identifier", home: PlantIdentifier()));

class PlantIdentifier extends StatefulWidget {
  @override
  _PlantIdentifierState createState() => _PlantIdentifierState();
}

class _PlantIdentifierState extends State<PlantIdentifier> {
  File file;
  final picker = ImagePicker();
  List images = new List();

  Future openCamera(BuildContext context) async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);
    this.setState(() {
      if (pickedFile != null) {
        Navigator.of(context).pop();
        file = File(pickedFile.path);
        images.add(file);
      }
    });
  }

  Future openGallery(BuildContext context) async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      if (pickedFile != null) {
        Navigator.of(context).pop();
        file = File(pickedFile.path);
        images.add(file);
      }
    });
  }

  showChoiceDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Select"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  showMainButton() {
    if (images.length == 0) {
      return Container(
        color: new Color(0X99CC0000),
        child: new Center(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: RaisedButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                showChoiceDialog();
              },
              child: const Text('Take Picture',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              color: Colors.green,
              textColor: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Container(
            color: new Color(0X99CC0000),
            child: new Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    showChoiceDialog();
                  },
                  child: const Text('Take other picture',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  color: Colors.green,
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            color: new Color(0X99CC0000),
            child: new Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    showDialogToConfirmIdentification();
                  },
                  child: const Text('Identify',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  color: Colors.green,
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  showDialogToConfirmIdentification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Identify plant/s'),
          content: Text("Are You Sure Want To Proceed?"),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SelectedIdentifiedPlantView(),
                    settings: RouteSettings(
                      arguments: images,
                    ),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  showMainImage() {
    if (images.length == 0) {
      return DefaultImage();
    } else {
      return getImagesFromPicture();
    }
  }

  getImagesFromPicture() {
    return new Expanded(
      child: new Container(
        padding: const EdgeInsets.only(top: 25.0),
        color: new Color.fromRGBO(135, 211, 124, 1),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          slivers: [
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    constraints: BoxConstraints(
                      maxHeight: double.infinity
                    ),
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, bottom: 15, left: 15, right: 15),
                          child: FlatButton(
                              onPressed: (){
                                showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      child:  Image.file(images[index], height: 300, width: 300,),
                                    );
                                  },
                                );
                              },
                              padding: EdgeInsets.all(0.0),
                              child: Image.file(images[index], height: 120),
                          ),
                        ),
                        Container(
                          child: SizedBox(
                            width: 35,
                            height: 25,
                            child: RaisedButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onPressed: () {
                                showDialogToConfirmDeleteImage(index);
                              },
                              child: const Text('x',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center),
                              color: Colors.green,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: images.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Identifier',
      home: Scaffold(
        body: new Column(
            // This makes each child fill the full width of the screen
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showMainImage(),
              showMainButton(),
            ]),
      ),
    );
  }

  showDialogToConfirmDeleteImage(int indexImage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete image'),
          content: Text("Are You Sure Want To Proceed?"),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                if (images.contains(images[indexImage])) {
                  images.remove(images[indexImage]);
                  setState(() {
                    images = images;
                  });
                }
              },
            ),
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
