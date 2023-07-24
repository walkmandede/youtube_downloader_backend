import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {


  final params = context.request.uri.queryParameters;
  return Response(body: "");
}