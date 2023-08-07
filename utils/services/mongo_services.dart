import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase{

  static String colHistory = 'history';
  static String colUser = 'user';
  static String colMessage = 'message';
  static String colGroup = 'group';

  static Db db = Db('');

  String idParser(Map data){
    try{
      var objectId = data['_id'] as ObjectId;
      return objectId.$oid;
    }
    catch(e){
      return '';
    }
  }

  static Future<void> connect() async{
    try{
      db = await Db.create('mongodb+srv://walkmandede:sio64ati7o@cluster0.qag8tm8.mongodb.net/ytmd?retryWrites=true&w=majority');
      await db.open();
    }
    catch(e){
      null;
    }
  }

  DbCollection getCollection({required String colName}){
    return db.collection(colName);
  }

  Future<List<Map>> getCollectionAllData({required String colName}) async{
    return db.collection(colName).find().toList();
  }

  Future<Map<dynamic,dynamic>> deleteDocument({required String colName,required String objectId}) async{
    return db.collection(colName).remove({'_id' : ObjectId.parse(objectId)});
  }

  Future<void> updateDocument({required String colName,required String objectId,required Map<String,dynamic> json}) async{
    await db.collection(colName).replaceOne({"_id" : ObjectId.parse(objectId)},json);
  }

  Future<WriteResult?> insertDataIntoCollection({required String colName,required Map<String,dynamic> data}) async{
    WriteResult? writeResult;
    try{
      var collection = MongoDatabase().getCollection(colName: colName);
      writeResult = await collection.insertOne(data);
    }
    catch(e){
      null;
    }
    return writeResult;
  }

  Map<String,dynamic> findThatInArray({required dynamic data}){
    return {r'$elemMatch': {r'$eq': data}};
  }

}