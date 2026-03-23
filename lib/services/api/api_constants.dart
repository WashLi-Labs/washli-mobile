import 'dart:io';
import 'package:flutter/foundation.dart';

String get kBaseUrl {
  if (kIsWeb) return 'http://34.169.167.67';
  if (Platform.isAndroid) return 'http://34.169.167.67';
  return 'http://34.169.167.67';
}
const String kOrderPath = '/order';
const String kGoogleMapsApiKey = 'AIzaSyAxZ31DcQSS6Bl-zT_eV-E39M_m-XQpXF4';
