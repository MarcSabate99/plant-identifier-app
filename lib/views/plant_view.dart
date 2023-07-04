import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlantView extends StatelessWidget {
  buildInfo(data) {
    var plantName = data['plantName'];
    var scientificName = data['scientificName'];
    var image = data['image'];
    var plantUrl = data['plantUrl'];
    var description = data['description'];
    var plantImageCitation = data['plantImageCitation'];
    var plantImageLicence = data['plantImageLicence'];
    var plantImageLicenceUrl = data['plantImageLicenceUrl'];
    var wikiDescriptionCitation = data['wikiDescriptionCitation'];
    var wikiDescriptionLicenceName = data['wikiDescriptionLicenceName'];
    var wikiDescriptionLicenceUrl = data['wikiDescriptionLicenceUrl'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CachedNetworkImage(
            placeholder: (context, url) => CircularProgressIndicator(),
            imageUrl: image,
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: 300,
            height: 300),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text("Name: " + plantName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        new Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(top: 15),
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical, //.horizontal
              child: Text(description, style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Text(plantUrl, style: TextStyle(fontSize: 10), textAlign: TextAlign.center,),
              Text(plantImageLicence +
                      "\n" +
                      plantImageCitation +
                      "\n" +
                      plantImageLicenceUrl +
                      "\n",
                  style: TextStyle(fontSize: 10), textAlign: TextAlign.center,),
              Text(
                  wikiDescriptionLicenceName +
                      "\n" +
                      wikiDescriptionCitation +
                      "\n" +
                      wikiDescriptionLicenceUrl +
                      "\n",
                  style: TextStyle(fontSize: 10), textAlign: TextAlign.center,)
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context).settings.arguments;
    return Material(
      child: Column(
        children: <Widget>[
          new Expanded(
            child: new Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8.0),
              color: Color.fromRGBO(135, 211, 124, 1),
              child: buildInfo(data),
            ),
          ),
        ],
      ),
    );
  }
}
