import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../../controllers/data_controller.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../models/watched_history.dart';
import '../../../utils/services/mongo_services.dart';

Handler middleware(Handler handler) {


  final mongoDatabase = MongoDatabase();

  return (context) async {

    final resp = await handler(context);
    var responseBody = <String,dynamic>{
      'meta' : {
        'success' : false,
        'message' : 'Please fill all required data'
      }
    };

    try{
      final payload = await context.request.json() as Map;
      final userCol = mongoDatabase.getCollection(colName: MongoDatabase.colUser);


      if(payload['message']==null){

      }
      else if(payload['from']==null){

      }
      else if(payload['to']==null){

      }
      else{
        final readResult = await userCol.find(
            where
                .eq('_id', ObjectId.parse(payload['from'].toString()))
                .or(where
                .eq('_id', ObjectId.parse(payload['to'].toString())),
            )
        ).toList();

        if(readResult.isEmpty){
          responseBody['meta']['message'] = 'There is no such users';
        }
        else{
          final writeResult = await mongoDatabase.insertDataIntoCollection(
            colName: MongoDatabase.colMessage,
            data: MessageModel(
              id: '',
              message: payload['message'].toString(),
              from: payload['from'].toString(),
              to: payload['to'].toString(),
              dateTime: DateTime.now(),).toMap(),
          );
          if(writeResult!.isSuccess){
            responseBody = {
              'meta' : {
                'success' : true,
                'message' : 'Message Created Successfully'
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
          'message' : 'Something went wrong! ${e}'
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

