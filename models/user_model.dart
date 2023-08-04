
import '../utils/services/mongo_services.dart';

class UserModel{

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.dob,
    required this.password,
  });

  factory UserModel.fromMongo({required Map<dynamic,dynamic> data}){
    return UserModel(
      id: MongoDatabase().idParser(data),
      name: data['name'].toString(),
      password: data['password'].toString(),
      dob: DateTime.tryParse(data['dob'].toString())??DateTime(0),
      phone: data['phone'].toString()
    );
  }

  String id;
  String name;
  String phone;
  String password;
  DateTime dob;

  Map<String,dynamic> toMap(){
    return {
      'id' : id,
      'name' : name,
      'phone' : phone,
      'dob' : dob.toString(),
      'password' : password
    };
  }

}