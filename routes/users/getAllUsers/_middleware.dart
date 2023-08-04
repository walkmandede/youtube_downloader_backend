import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../../models/user_model.dart';
import '../../../utils/services/mongo_services.dart';

Handler middleware(Handler handler) {


  final mongoDatabase = MongoDatabase();

  return (context) async {

    final resp = await handler(context);
    var responseBody = <dynamic,dynamic>{};

    try{
      final payload = await context.request.json() as Map;

      final readResult = await mongoDatabase.getCollectionAllData(colName: MongoDatabase.colUser);
      if(readResult.isEmpty){
        responseBody = {
          'meta' : {
            'success' : false,
            'message' : 'There is no such phone registered',
          },
        };
      }
      else{

        final result = <dynamic>[];

        for (final each in readResult) {
          final userModel = UserModel.fromMongo(data: each);
          result.add(userModel.toMap());
        }

        responseBody = {
          'meta' : {
            'success' : true,
            'message' : 'Login Success',
          },
          'body' : result
        };
      }

    }
    catch(e){
      responseBody = {
        'meta' : {
          'success' : false,
          'message' : 'Something went wrong! ${e}'
        },
      };
    }

    final response = resp.copyWith(
      body: jsonEncode(responseBody)
    );


    return response;
  };
}

