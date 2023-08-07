import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../../models/group_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/mongo_services.dart';

Handler middleware(Handler handler) {


  final mongoDatabase = MongoDatabase();

  return (context) async {

    final resp = await handler(context);
    var responseBody = <dynamic,dynamic>{};
    final parameters = context.request.url.queryParameters;
    responseBody = {
      'meta' : {
        'success' : false,
        'message' : 'Invalid Request',
      },
    };


    if(parameters.isNotEmpty){
      try{
        final id = parameters['id']!;
        final groupCol = mongoDatabase.getCollection(colName: MongoDatabase.colGroup);
        final result = await groupCol.find(
          where.eq('members', {r'$elemMatch': {r'$eq': id}}),
        ).toList();
        responseBody = {
          'meta' : {
            'success' : true,
            'message' : result
          },
        };
      }
      catch(e){
        responseBody = {
          'meta' : {
            'success' : false,
            'message' : 'Something went wrong! ${e}'
          },
        };
      }
    }

    final response = resp.copyWith(
      body: jsonEncode(responseBody)
    );


    return response;
  };
}

