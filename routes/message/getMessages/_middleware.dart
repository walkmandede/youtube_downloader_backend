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
      final messageCol = mongoDatabase.getCollection(colName: MongoDatabase.colMessage);
      if(payload['from']==null){

      }
      else if(payload['to']==null){

      }
      else{

        final fromId = ObjectId.parse(payload['from'].toString());
        final toId = ObjectId.parse(payload['to'].toString());

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
          final readResult = await messageCol.find(
              where
                  .eq('from', fromId.$oid)
                  .eq('to', toId.$oid)
                  .or(
                where.eq('to', fromId.$oid)
                    .eq('from', toId.$oid)
              )
          ).toList();
          responseBody = {
            'meta' : {
              'success' : true,
              'message' : 'Message fetched Successfully',
            },
            'data' : readResult.map((e) {
              return MessageModel.fromMongo(data: e).toMap();
            }).toList()
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
      body: jsonEncode(responseBody),
    );
    // Return a response.
    return response;
  };
}

