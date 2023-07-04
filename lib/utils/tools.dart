import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

class Tools {
  static const IDENTIFY_PLANT_ENDPOINT = "https://api.plant.id/v2/identify";
  static const CONFIRM_PLANT_ENDPOINT =
      "https://api.plant.id/v2/confirm_suggestion/%suggestion_id%";
  static const UNCONFIRM_PLANT_ENDPOINT =
      "https://api.plant.id/v2/unconfirm_suggestion/%suggestion_id%";

  static getImageInBase64(File file) async {
    var imageBytes = await file.readAsBytes();
    String base64 = base64Encode(imageBytes);
    return base64;
  }
}
