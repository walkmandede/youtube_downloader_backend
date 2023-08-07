import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../../controllers/data_controller.dart';
import '../../../models/group_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../models/watched_history.dart';
import '../../../utils/app_constants.dart';
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
      final groupCol = mongoDatabase.getCollection(colName: MongoDatabase.colGroup);
      final userCol = mongoDatabase.getCollection(colName: MongoDatabase.colUser);

      if(payload['name']==null){

      }
      else if(payload['members']==null){

      }
      else{
        final rawPayloadMembers = payload['members'] as List<dynamic>;
        final payloadMembers = rawPayloadMembers.map((e) => ObjectId.parse(e.toString())).toList();
        final readResult = await userCol.find(
            where.oneFrom('_id', payloadMembers)
        ).toList();
        if(readResult.isEmpty){
          responseBody['meta']['message'] = 'There is no such users';
        }
        else{
          final writeResult = await mongoDatabase.insertDataIntoCollection(
            colName: MongoDatabase.colGroup,
            data: GroupModel(
              id: '',
              name: payload['name'].toString(),
              members: payloadMembers.map((e) => e.$oid).toList()
            ).toMap()
          );
          if(writeResult!.isSuccess){
            responseBody = {
              'meta' : {
                'success' : true,
                'message' : 'Group Created Successfully'
              },
            };
          }
          else{
            responseBody = {
              'meta' : {
                'success' : true,
                'message' : 'Group Creating Failure'
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

