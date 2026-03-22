import 'dart:io';
import 'package:flutter/foundation.dart';

String get kBaseUrl {
  if (kIsWeb) return 'http://localhost:8080';
  if (Platform.isAndroid) return 'http://localhost:8080';
  return 'http://localhost:8080';
}
const String kOrderPath = '/order';
const String kGoogleMapsApiKey = 'AIzaSyAxZ31DcQSS6Bl-zT_eV-E39M_m-XQpXF4';
