
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/youtube_response.dart';

class YoutubeController{

  final String _apiKey = 'AIzaSyDkY3mkpO8YPLgJntejt4HElxoaGwRqLXY';


  Future<YoutubeResponse?> getYoutubeVideos({required String query}) async {

    // List<YouTubeVideo> youTubeVideos = [];

    try {
      var response = await http.get(
          Uri.parse('https://youtube.googleapis.com/youtube/v3/search?part=snippet&q=$query&key=$_apiKey&maxResults=50'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });

      return YoutubeResponse.formApi(data: jsonDecode(response.body) as Map<String,dynamic>);
      
    } catch (error) {
      print(error);
    }

    return null;

  }
}