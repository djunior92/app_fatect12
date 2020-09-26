import 'dart:convert';
import 'package:http/http.dart' as http;

String convertFormat(String source) {
  final codeUnits = source.codeUnits;
  return Utf8Decoder().convert(codeUnits);
}
