
import '../utils/app_constants.dart';
import '../utils/services/mongo_services.dart';

class GroupModel{

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
  });

  factory GroupModel.fromMongo({required Map<dynamic,dynamic> data}){
    return GroupModel(
        id: MongoDatabase().idParser(data),
        name: data['name'].toString(),
        members: (data['members'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  String id;
  String name;
  List<String> members;

  Map<String,dynamic> toMap(){
    return {
      'id' : id,
      'name' : name,
      'members' : members
    };
  }

}