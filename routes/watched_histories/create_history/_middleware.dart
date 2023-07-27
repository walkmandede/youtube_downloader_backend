import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../../controllers/data_controller.dart';
import '../../../models/watched_history.dart';
import '../../../utils/services/mongo_services.dart';

Handler middleware(Handler handler) {


  MongoDatabase mongoDatabase = MongoDatabase();

  return (context) async {



    final resp = await handler(context);
    int httpStatusCode = 0;
    var responseBody = {};

    try{
      final payload = await context.request.json();

      var writeResult = await mongoDatabase.insertDataIntoCollection(
          colName: MongoDatabase.colHistory,
          data: WatchedHistory(
              yid: payload['yid'].toString(),
              title: payload['title'].toString(),
              dateTime: DateTime.parse(payload['dateTime'].toString()),
              thumbnail: payload['thumbnail'].toString()
          ).toMap()
      );


      if(writeResult!.isSuccess){
        httpStatusCode = HttpStatus.created;
        responseBody = {
          'meta' : {
            'success' : true,
            'message' : 'History Created Successfully'
          },
        };
      }
      else{
        httpStatusCode = HttpStatus.notAcceptable;
        responseBody = {
          'meta' : {
            'success' : true,
            'message' : 'History Creating Failure'
          },
        };
      }

    }
    catch(e){
      httpStatusCode = HttpStatus.notAcceptable;
      responseBody = {
        'meta' : {
          'success' : false,
          'message' : 'Something went wrong!'
        },
      };
    }

    final response = resp.copyWith(
      body: jsonEncode(responseBody)
    );

    print(DataController().watchedHistories);

    // Return a response.
    return response;
  };
}

