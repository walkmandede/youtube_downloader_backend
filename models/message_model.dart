
import '../utils/services/mongo_services.dart';

class MessageModel{

  MessageModel({
    required this.id,
    required this.message,
    required this.from,
    required this.to,
    required this.dateTime
  });

  factory MessageModel.fromMongo({required Map<dynamic,dynamic> data}){
    return MessageModel(
        id: MongoDatabase().idParser(data),
        message: data['message'].toString(),
        from: data['from'].toString(),
        to: data['to'].toString(),
        dateTime: DateTime.tryParse(data['dateTime'].toString())??DateTime(0)
    );
  }

  String id;
  String message;
  String from;
  String to;
  DateTime dateTime;

  Map<String,dynamic> toMap(){
    return {
      'id' : id,
      'message' : message,
      'from' : from,
      'to' : to,
      'dateTime' : dateTime.toString()
    };
  }

}