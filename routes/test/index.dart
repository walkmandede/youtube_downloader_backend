import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

import '../../utils/app_constants.dart';

Future<Response> onRequest(RequestContext context) async{

  switch (context.request.method) {
    case HttpMethod.get:
      return _middleware(context);
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(
        statusCode: HttpStatus.methodNotAllowed,
        body: 'Method Not Allowed'
      );
  }
}

Future<Response> _middleware(RequestContext context) async {

  superPrint(context.request);

  await Future.delayed(const Duration(seconds: 2));

  return Response.json(
    statusCode: HttpStatus.created,
    body: 'aye pr kwar'
  );
}