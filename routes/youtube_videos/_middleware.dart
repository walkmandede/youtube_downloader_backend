import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../controllers/youtube_controller.dart';
import '../../models/youtube_data.dart';
import '../../models/youtube_response.dart';

Handler middleware(Handler handler) {

  YoutubeController youtubeController = YoutubeController();
  const keyQuery = 'query';

  return (context) async {

    final query = context.request.uri.queryParameters[keyQuery]??'';


    final resp = await handler(context);
    final youtubeData = await youtubeController.getYoutubeVideos(query: query);

    var responseBody = {};

    if(youtubeData==null){
      responseBody = {
        'meta' : {
          'success' : false
        },
        'body' : [

        ]
      };
    }
    else{
      responseBody = {
        'meta' : {
          'success' : true
        },
        'body' : youtubeData.data.map((e) {
          return {
            'id' : e.id,
            'title' : e.title,
            'thumbnail' : e.thumbnail,
            'dateTime' : e.publishedDate.toString()
          };
        }).toList()
      };
    }

    var response = resp.copyWith(
      body: jsonEncode(responseBody)
    );

    // Return a response.
    return response;
  };
}

