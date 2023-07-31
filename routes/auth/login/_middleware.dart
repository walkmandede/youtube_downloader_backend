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

      var readResult = await mongoDatabase.getCollectionAllData(colName: MongoDatabase.colUser);

      UserModel? resultUser;

      for (var element in readResult) {
        UserModel userModel = UserModel.fromMongo(data: element);

        if(
        userModel.phone == payload['phone'].toString() &&
            userModel.password == payload['password'].toString()
        ){
          resultUser = userModel;
        }
      }

      print(resultUser);

      if(resultUser!=null){
        responseBody = {
          'meta' : {
            'success' : false,
            'message' : 'Login Successfully',
          },
          'data' : resultUser.toMap()
        };
      }
      else{
        responseBody = {
          'meta' : {
            'success' : false,
            'message' : 'Invalid Login',
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

