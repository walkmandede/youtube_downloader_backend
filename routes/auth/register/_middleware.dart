import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../../controllers/data_controller.dart';
import '../../../models/user_model.dart';
import '../../../models/watched_history.dart';
import '../../../utils/services/mongo_services.dart';

Handler middleware(Handler handler) {


  final mongoDatabase = MongoDatabase();

  return (context) async {

    final resp = await handler(context);
    var responseBody = <dynamic,dynamic>{};

    try{
      final payload = await context.request.json() as Map;

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
    catch(e){
      responseBody = {
        'meta' : {
          'success' : false,
          'message' : 'Something went wrong! ${e.toString()}'
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

