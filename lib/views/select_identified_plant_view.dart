import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:plantidentifier/identification.dart';
import 'package:plantidentifier/utils/tools.dart';
import 'package:plantidentifier/views/plant_view.dart';

import '../api.dart';
import '../main.dart';
import '../request_handler.dart';

class SelectedIdentifiedPlantView extends StatefulWidget {
  @override
  SelectedIdentifiedPlantViewState createState() =>
      SelectedIdentifiedPlantViewState();
}

class SelectedIdentifiedPlantViewState
    extends State<SelectedIdentifiedPlantView> {
  Widget content;
  bool hasData = false;

  buildImages(Identification identification, context, itemIndex,
      buttonCarouselController) {
    List suggestions = identification.suggestions;
    var plantName = suggestions[itemIndex]['plant_name'] != null
        ? suggestions[itemIndex]['plant_name']
        : "";
    var plantDetails = suggestions[itemIndex]['plant_details'] != null
        ? suggestions[itemIndex]['plant_details']
        : "";
    var scientificName = suggestions[itemIndex]['scientific_name'] != null
        ? suggestions[itemIndex]['scientific_name']
        : "";
    var wikiDescriptionValue = "";
    var wikiDescriptionCitation = "";
    var wikiDescriptionLicenceName = "";
    var wikiDescriptionLicenceUrl = "";
    var plantImageValue = "";
    var plantImageCitation = "";
    var plantImageLicence = "";
    var plantImageLicenceUrl = "";
    var plantUrl = "";
    if (plantDetails != "") {
      if (plantDetails['wiki_description'] != null) {
        wikiDescriptionValue = plantDetails['wiki_description']['value'] != null
            ? plantDetails['wiki_description']['value']
            : "";
        wikiDescriptionCitation =
            plantDetails['wiki_description']['citation'] != null
                ? plantDetails['wiki_description']['citation']
                : "";
        wikiDescriptionLicenceName =
            plantDetails['wiki_description']['license_name'] != null
                ? plantDetails['wiki_description']['license_name']
                : "";
        wikiDescriptionLicenceUrl =
            plantDetails['wiki_description']['license_url'] != null
                ? plantDetails['wiki_description']['license_url']
                : "";
      }
      plantUrl = plantDetails['url'] != null ? plantDetails['url'] : "";
      if (plantDetails['wiki_image'] != null) {
        plantImageValue = plantDetails['wiki_image']['value'] != null
            ? plantDetails['wiki_image']['value']
            : "";
        plantImageCitation = plantDetails['wiki_image']['citation'] != null
            ? plantDetails['wiki_image']['citation']
            : "";
        plantImageLicence = plantDetails['wiki_image']['license_name'] != null
            ? plantDetails['wiki_image']['license_name']
            : "";
        plantImageLicenceUrl = plantDetails['wiki_image']['license_url'] != null
            ? plantDetails['wiki_image']['license_url']
            : "";
      }
    }
    var probability = suggestions[itemIndex]['probability'];
    probability = probability * 100;
    probability = probability.toString();
    int indexOfDot = probability.indexOf('.');
    probability = probability.substring(0, indexOfDot);
    return new Column(
      children: [
        CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl: plantImageValue,
          width: 300,
          height: 300,
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: Text(plantName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: Text(probability + "% probability",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
        Container(
          margin: const EdgeInsets.only(top: 25.0),
          child: SizedBox(
            width: 300,
            height: 50,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlantView(),
                    settings: RouteSettings(
                      arguments: {
                        'plantName': plantName,
                        'scientificName': scientificName,
                        'image': plantImageValue,
                        'plantImageCitation': plantImageCitation,
                        'plantImageLicence': plantImageLicence,
                        'plantImageLicenceUrl': plantImageLicenceUrl,
                        'description': wikiDescriptionValue,
                        'wikiDescriptionCitation': wikiDescriptionCitation,
                        'wikiDescriptionLicenceName':
                            wikiDescriptionLicenceName,
                        'wikiDescriptionLicenceUrl': wikiDescriptionLicenceUrl,
                        'plantUrl': plantUrl,
                      },
                    ),
                  ),
                );
              },
              child: Text(
                'Information',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              color: Colors.green,
              textColor: Colors.white,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          child: SizedBox(
            width: 150,
            height: 40,
            child: RaisedButton(
              onPressed: () {
                buttonCarouselController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              child: const Text('Next Plant', style: TextStyle(fontSize: 15)),
              color: Colors.green,
              textColor: Colors.white,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 25.0),
          child: Text(
              plantImageCitation +
                  " " +
                  plantImageLicence +
                  " " +
                  plantImageLicenceUrl,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }

  getIndexOfMaxProbability(List suggestions) {
    if (suggestions.length > 0) {
      double maxProb =
          suggestions.map<double>((e) => e['probability']).reduce(max);
      List probs = new List();
      suggestions.forEach((element) {
        double currentProb = element['probability'];
        probs.add(currentProb);
      });
      return probs.indexOf(maxProb);
    }
    return 1;
  }

  showLoader(context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          color: new Color.fromRGBO(135, 211, 124, 1),
          child: Center(
            child: new CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  getIdentification(context) {
    dynamic images = ModalRoute.of(context).settings.arguments;
    HashMap<String, dynamic> data = new HashMap();
    HashMap<String, dynamic> headers = new HashMap();
    List imageFiles = images;
    List base64Images = new List();
    for (int i = 0; i < imageFiles.length; i++) {
      Future<dynamic> base64FutureImage = Tools.getImageInBase64(imageFiles[i]);
      base64FutureImage.then((base64Image) {
        base64Images.add(base64Image);
        if (i + 1 == imageFiles.length) {
          data['images'] = base64Images;
          data['plant_details'] = ["wiki_description", "url", "wiki_image"];
          headers['Content-Type'] = 'application/json';
          headers['Api-Key'] = Api.API_KEY;
          Future<Identification> futureIdentification = RequestHandler.request(
              Tools.IDENTIFY_PLANT_ENDPOINT, data, headers);
          futureIdentification.then((identification) {
            if (identification != null) {
              if (identification.suggestions.length > 0) {
                setState(() {
                  print("Update");
                  CarouselController buttonCarouselController =
                      CarouselController();
                  List suggestions = identification.suggestions;
                  int indexMaxProb = getIndexOfMaxProbability(suggestions);
                  hasData = true;
                  content = Expanded(
                    child: Container(
                      color: new Color.fromRGBO(135, 211, 124, 1),
                      child: Center(
                        child: CarouselSlider.builder(
                          carouselController: buttonCarouselController,
                          itemCount: identification.suggestions.length,
                          options: CarouselOptions(
                              autoPlay: false,
                              viewportFraction: 1,
                              initialPage: indexMaxProb,
                              height: 700),
                          itemBuilder: (BuildContext context, int itemIndex) =>
                              Flex(
                            direction: Axis.vertical,
                            children: [
                              Center(
                                  child: buildImages(identification, context,
                                      itemIndex, buttonCarouselController)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              } else {
                // Navigator.of(context).pop();
              }
            } else {
              //Navigator.of(context).pop();
            }
          });
        }
      });
    }
  }

  showContent(context) {
    content = showLoader(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!hasData) {
      showContent(context);
      getIdentification(context);
    }
    return Material(
        child: Column(
      children: [content],
    ));
  }
}
