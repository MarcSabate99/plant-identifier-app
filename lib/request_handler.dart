import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:plantidentifier/identification.dart';

class RequestHandler{
  static Future<Identification> request(String url, HashMap data, HashMap headers) async {
    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : headers['Content-Type'],
        'Api-Key' : headers['Api-Key']
      },
      body: jsonEncode({
        'images':data['images'],
        'plant_details': data['plant_details']
      }),
    );
    if (response.statusCode == 200) {
      return Identification.fromJson(jsonDecode(response.body));
    }else{
      print(response.body);
    }
  }
}