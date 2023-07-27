
class WatchedHistory{

  String yid;
  String title;
  String thumbnail;
  DateTime dateTime;

  WatchedHistory({
    required this.dateTime,
    required this.yid,
    required this.thumbnail,
    required this.title
  });

  factory WatchedHistory.fromMap({required Map data}){
    return WatchedHistory(
      title: data['title'].toString(),
      thumbnail: data['thumbnail'].toString(),
      dateTime: DateTime.tryParse(data['dateTime'].toString())??DateTime(0),
      yid: data['yid'].toString()
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'title' : title,
      'thumbnail' : thumbnail,
      'yid' : yid,
      'dateTime' : dateTime.toString()
    };
  }

}