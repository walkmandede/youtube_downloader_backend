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

      final userCol = mongoDatabase.getCollection(colName: MongoDatabase.colUser);
      final readResult = await userCol.find(
          where.eq('phone', payload['phone'].toString()),).toList();
      if(readResult.isEmpty){
        responseBody = {
          'meta' : {
            'success' : false,
            'message' : 'There is no such phone registered',
          },
        };
      }
      else{
        final userModel = UserModel.fromMongo(data: readResult.first);

        if(userModel.password == payload['password']){
          responseBody = {
            'meta' : {
              'success' : true,
              'message' : 'Login Success',
            },
            'body' : userModel.toMap()
          };
        }
        else{
          responseBody = {
            'meta' : {
              'success' : false,
              'message' : 'Incorrect Password!',
            },
          };
        }
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

