import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../../controllers/data_controller.dart';
import '../../../models/user_model.dart';
import '../../../models/watched_history.dart';
import '../../../utils/services/mongo_services.dart';

Handler middleware(Handler handler) {


  final mongoDatabase = MongoDatabase();

  return (context) async {

    final resp = await handler(context);
    var responseBody = <dynamic,dynamic>{
      'meta' : {
        'success' : false,
        'message' : 'Something went wrong!'
      }
    };

    try{
      final payload = await context.request.json() as Map;
      final userCol = mongoDatabase.getCollection(colName: MongoDatabase.colUser);

      if(payload['name'].toString().isEmpty){

      }
      else if(payload['phone'].toString().isEmpty){

      }
      else if(payload['dob'].toString().isEmpty){

      }
      else if(payload['password'].toString().isEmpty){

      }
      else{
        final readResult = await userCol.find(
          where.eq('phone', payload['phone'].toString()),).toList();
        if(readResult.isNotEmpty){
          responseBody = {
            'meta' : {
              'success' : false,
              'message' : 'This phone is already registered',
            },
          };
        }
        else{
          final writeResult = await mongoDatabase.insertDataIntoCollection(
            colName: MongoDatabase.colUser,
            data: UserModel(
              id: '',
              name: payload['name'].toString(),
              phone: payload['phone'].toString(),
              dob: DateTime.tryParse(payload['dob'].toString())??DateTime(0),
              password: payload['password'].toString(),
            ).toMap(),
          );

          if(writeResult!.isSuccess){
            responseBody = {
              'meta' : {
                'success' : true,
                'message' : 'User Created Successfully'
              },
            };
          }
          else{
            responseBody = {
              'meta' : {
                'success' : true,
                'message' : 'User Creating Failure'
              },
            };
          }
        }
      }
    }
    catch(e){
      responseBody = {
        'meta' : {
          'success' : false,
          'message' : 'Something went wrong! ${e.toString()}'
        },
      };
    }

    final response = resp.copyWith(
      body: jsonEncode(responseBody),
    );
    // Return a response.
    return response;
  };
}

