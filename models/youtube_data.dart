
class YoutubeData{

  final String id;
  final String thumbnail;
  final String title;
  final DateTime publishedDate;

  YoutubeData({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.publishedDate
  });

  factory YoutubeData.fromApi({required Map<String,dynamic> data}){
    try{
      return YoutubeData(
        id: data['id']['videoId'].toString(),
        title: data['snippet']['title'].toString(),
        publishedDate: DateTime.tryParse(data['snippet']['publishedAt'].toString())??DateTime(2000),
        thumbnail: data['snippet']['thumbnails']['medium']['url'].toString()
      );
    }
    catch(e){
      return YoutubeData(id: '', title: '', thumbnail: '', publishedDate: DateTime(2000));
    }
  }

}