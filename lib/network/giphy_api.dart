import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/gif.dart';

class API {
  final http.Client _client = http.Client();
  static const String _apiKey = 'Huc8spoIkFUQ5YNVSdauECdPru5qlAmA';
  static const String _url =
      'https://api.giphy.com/v1/gifs/search?api_key=$_apiKey&limit=6';

  Future<List<Gif>> get({String query, int offset}) async {
    final response = await _client.get('$_url&q=$query&offset=$offset');

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((rawGif) {
        return Gif(
          id: rawGif['id'],
          url: rawGif['images']['fixed_height']['url'],
        );
      }).toList();
    } else {
      throw Exception('error fetching gifs');
    }
  }
}
