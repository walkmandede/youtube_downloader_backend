

import 'youtube_data.dart';

class YoutubeResponse{

  final String eTag;
  final String nextPageToken;
  final int totalResults;
  final int resultsPerPage;
  final List<YoutubeData> data;

  YoutubeResponse({
    required this.eTag,
    required this.nextPageToken,
    required this.totalResults,
    required this.resultsPerPage,
    required this.data
  });

  factory YoutubeResponse.formApi({required Map<String,dynamic> data}){

    List<YoutubeData> youtubeData = [];

    Iterable items = data['items'] as Iterable;

    youtubeData = items.map((e) => YoutubeData.fromApi(data: e as Map<String,dynamic>)).toList();

    return YoutubeResponse(
      eTag: data['etag'].toString(),
      nextPageToken: data['nextPageToken'].toString(),
      totalResults: int.tryParse(data['pageInfo']['totalResults'].toString())??0,
      resultsPerPage: int.tryParse(data['pageInfo']['resultsPerPage'].toString())??0,
      data: youtubeData
    );
  }

}