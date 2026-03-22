import 'dart:io';
import 'package:flutter/foundation.dart';

String get kBaseUrl {
  if (kIsWeb) return 'http://localhost:8080';
  if (Platform.isAndroid) return 'http://34.169.167.67';
  return 'http://34.169.167.67';
}
const String kOrderPath = '/order';
