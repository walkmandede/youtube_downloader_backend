import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) {

  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.get:
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

Future<Response> _post(RequestContext context) async {


  return Response.json(
    statusCode: HttpStatus.created,
    body: ''
  );
}