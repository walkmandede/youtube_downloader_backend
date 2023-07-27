import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../../controllers/data_controller.dart';
import '../../../utils/services/mongo_services.dart';

Handler middleware(Handler handler) {

  final dataController = DataController();
  MongoDatabase mongoDatabase = MongoDatabase();

  return (context) async {



    final resp = await handler(context);

    var responseBody = {};

    List<Map> result = [];

    var dbResult = await mongoDatabase.getCollectionAllData(colName: MongoDatabase.colHistory);

    responseBody = {
      'meta' : {
        'success' : true
      },
      'body' : dbResult.map((each) {
        return {
          'yid' : each['yid'].toString(),
          'title' : each['title'].toString(),
          'thumbnail' : each['thumbnail'].toString(),
          'dateTime' : each['dateTime:'].toString()
        };
      }).toList()
    };

    var response = resp.copyWith(
      body: jsonEncode(responseBody)
    );

    // Return a response.
    return response;
  };
}

