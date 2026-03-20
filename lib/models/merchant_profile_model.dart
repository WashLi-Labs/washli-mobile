import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Operating hours for a single day.
class DayOperatingHours {
  final String day;
  final bool isOpen;
  final String openTime;
  final String closeTime;

  const DayOperatingHours({
    required this.day,
    this.isOpen = false,
    this.openTime = '',
    this.closeTime = '',
  });

  factory DayOperatingHours.fromMap(Map<String, dynamic> map) {
    return DayOperatingHours(
      day: (map['day'] as String?) ?? '',
      isOpen: (map['isOpen'] as bool?) ?? false,
      openTime: (map['openTime'] as String?) ?? '',
      closeTime: (map['closeTime'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'day': day,
        'isOpen': isOpen,
        'openTime': openTime,
        'closeTime': closeTime,
      };

  DayOperatingHours copyWith({
    String? day,
    bool? isOpen,
    String? openTime,
    String? closeTime,
  }) =>
      DayOperatingHours(
        day: day ?? this.day,
        isOpen: isOpen ?? this.isOpen,
        openTime: openTime ?? this.openTime,
        closeTime: closeTime ?? this.closeTime,
      );
}

/// Location coordinates stored as a sub-map.
class MerchantLocation {
  final double lat;
  final double lng;

  const MerchantLocation({this.lat = 0.0, this.lng = 0.0});

  factory MerchantLocation.fromMap(Map<String, dynamic> map) {
    return MerchantLocation(
      lat: _parseDouble(map['lat']),
      lng: _parseDouble(map['lng']),
    );
  }

  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  Map<String, dynamic> toMap() => {'lat': lat, 'lng': lng};

  MerchantLocation copyWith({double? lat, double? lng}) =>
      MerchantLocation(lat: lat ?? this.lat, lng: lng ?? this.lng);
}

/// Full merchant profile model matching the Firestore schema exactly.
class MerchantProfileModel {
  // ── Identity ────────────────────────────────────────────────
  final String uid;
  final String? merchantId;
  final String merchantType;

  // ── Outlet info ─────────────────────────────────────────────
  final String outletName;
  final String outletAddress;
  final String? outletLogo;
  final String city;
  final MerchantLocation? location;

  // ── Owner / contact ─────────────────────────────────────────
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  final String email;
  final String? phoneNumber;
  final bool isEmailVerified;

  // ── Manager ─────────────────────────────────────────────────
  final String managerName;
  final String managerEmail;
  final String managerPhone;
  final String parentName;

  // ── Business registration ────────────────────────────────────
  final bool businessRegistered;
  final String brNumber;
  final String? brDocument;

  // ── Tax / VAT / TDL ─────────────────────────────────────────
  final bool vatRegistered;
  final String vatNumber;
  final bool taxRegistered;
  final String tinNumber;
  final String? taxCertificate;
  final String? tdlDocument;

  // ── Banking ─────────────────────────────────────────────────
  final String bankName;
  final String branchName;
  final String branchCode;
  final String accountNumber;
  final String beneficiaryName;
  final String? bankStatement;

  // ── NIC / documents ─────────────────────────────────────────
  final String? nicFront;
  final String? nicBack;
  final String? menuDocument;
  final List<String> itemImages;
  final bool hasImages;

  // ── Operating hours ─────────────────────────────────────────
  final List<DayOperatingHours> operatingHours;

  // ── Status / misc ────────────────────────────────────────────
  final String status;
  final bool isActive;
  final String? howDidYouHear;
  final DateTime? createdAt;

  const MerchantProfileModel({
    required this.uid,
    this.merchantId,
    this.merchantType = '',
    this.outletName = '',
    this.outletAddress = '',
    this.outletLogo,
    this.city = '',
    this.location,
    this.ownerName = '',
    this.ownerEmail = '',
    this.ownerPhone = '',
    this.email = '',
    this.phoneNumber,
    this.isEmailVerified = false,
    this.managerName = '',
    this.managerEmail = '',
    this.managerPhone = '',
    this.parentName = '',
    this.businessRegistered = false,
    this.brNumber = '',
    this.brDocument,
    this.vatRegistered = false,
    this.vatNumber = '',
    this.taxRegistered = false,
    this.tinNumber = '',
    this.taxCertificate,
    this.tdlDocument,
    this.bankName = '',
    this.branchName = '',
    this.branchCode = '',
    this.accountNumber = '',
    this.beneficiaryName = '',
    this.bankStatement,
    this.nicFront,
    this.nicBack,
    this.menuDocument,
    this.itemImages = const [],
    this.hasImages = false,
    this.operatingHours = const [],
    this.status = 'pending',
    this.isActive = true,
    this.howDidYouHear,
    this.createdAt,
  });

  // ── fromMap ─────────────────────────────────────────────────

  factory MerchantProfileModel.fromMap(Map<String, dynamic> map) {
    // Parse operating hours list — handles List or missing/null
    final List<DayOperatingHours> hours = [];
    final rawHours = map['operatingHours'];
    if (rawHours is List) {
      for (final item in rawHours) {
        if (item is Map<String, dynamic>) {
          hours.add(DayOperatingHours.fromMap(item));
        }
      }
    }

    // Parse location sub-map
    MerchantLocation? loc;
    final rawLoc = map['location'];
    if (rawLoc is Map<String, dynamic>) {
      loc = MerchantLocation.fromMap(rawLoc);
    }

    // Safely parse itemImages — handle String, List, or null
    final List<String> images = _parseStringList(map['itemImages']);

    return MerchantProfileModel(
      uid: _parseString(map['uid'],
          defaultValue: FirebaseAuth.instance.currentUser?.uid ?? ''),
      merchantId: _parseStringNullable(map['merchantId']),
      merchantType: _parseString(map['merchantType']),
      outletName: _parseString(map['outletName']),
      outletAddress: _parseString(map['outletAddress'] ??
          map['shopAddress'] ??
          map['address']),
      outletLogo: _parseStringNullable(map['outletLogo']),
      city: _parseString(map['city']),
      location: loc,
      ownerName: _parseString(map['ownerName']),
      ownerEmail: _parseString(map['ownerEmail'] ?? map['email']),
      ownerPhone: _parseString(map['ownerPhone'] ?? map['phone']),
      email: _parseString(map['email']),
      phoneNumber: _parseStringNullable(map['phoneNumber']),
      isEmailVerified: _parseBool(map['isEmailVerified']),
      managerName: _parseString(map['managerName']),
      managerEmail: _parseString(map['managerEmail']),
      managerPhone: _parseString(map['managerPhone']),
      parentName: _parseString(map['parentName']),
      businessRegistered: _parseBool(map['businessRegistered']),
      brNumber: _parseString(map['brNumber']),
      brDocument: _parseStringNullable(map['brDocument']),
      vatRegistered: _parseBool(map['vatRegistered']),
      vatNumber: _parseString(map['vatNumber']),
      taxRegistered: _parseBool(map['taxRegistered']),
      tinNumber: _parseString(map['tinNumber']),
      taxCertificate: _parseStringNullable(map['taxCertificate']),
      tdlDocument: _parseStringNullable(map['tdlDocument']),
      bankName: _parseString(map['bankName']),
      branchName: _parseString(map['branchName']),
      branchCode: _parseString(map['branchCode']),
      accountNumber: _parseString(map['accountNumber']),
      beneficiaryName: _parseString(map['beneficiaryName']),
      bankStatement: _parseStringNullable(map['bankStatement']),
      nicFront: _parseStringNullable(map['nicFront']),
      nicBack: _parseStringNullable(map['nicBack']),
      menuDocument: _parseStringNullable(map['menuDocument']),
      itemImages: images,
      hasImages: _parseBool(map['hasImages']),
      operatingHours: hours,
      status: _parseString(map['status'], defaultValue: 'pending'),
      isActive: _parseBool(map['isActive'], defaultValue: true),
      howDidYouHear: _parseStringNullable(map['howDidYouHear']),
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  /// Safely parses a [dynamic] value into a [DateTime].
  /// Handles Firestore [Timestamp] and ISO 8601 [String].
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  /// Safely parses a [dynamic] value into a [String].
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  /// Safely parses a [dynamic] value into a [String?].
  static String? _parseStringNullable(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  /// Safely parses a [dynamic] value into a [bool].
  /// Handles boolean values, "true"/"false" strings, and 1/0 integers.
  static bool _parseBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) {
      final lowercaseValue = value.toLowerCase();
      if (lowercaseValue == 'true' || lowercaseValue == 'yes' || lowercaseValue == '1') return true;
      if (lowercaseValue == 'false' || lowercaseValue == 'no' || lowercaseValue == '0') return false;
    }
    if (value is int) {
      return value != 0;
    }
    return defaultValue;
  }

  /// Converts a Firestore field that might be a [String], [List], or null
  /// into a [List<String>] without throwing.
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String && value.isNotEmpty) return [value];
    return [];
  }

  // ── toMap ───────────────────────────────────────────────────

  /// Serialises to a Firestore-compatible map.
  /// Excludes [uid] (stored as document ID).
  Map<String, dynamic> toMap() {
    return {
      'merchantId': merchantId,
      'merchantType': merchantType,
      'outletName': outletName,
      'outletAddress': outletAddress,
      'outletLogo': outletLogo,
      'city': city,
      'location': location?.toMap(),
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'ownerPhone': ownerPhone,
      'email': email,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'managerName': managerName,
      'managerEmail': managerEmail,
      'managerPhone': managerPhone,
      'parentName': parentName,
      'businessRegistered': businessRegistered,
      'brNumber': brNumber,
      'brDocument': brDocument,
      'vatRegistered': vatRegistered,
      'vatNumber': vatNumber,
      'taxRegistered': taxRegistered,
      'tinNumber': tinNumber,
      'taxCertificate': taxCertificate,
      'tdlDocument': tdlDocument,
      'bankName': bankName,
      'branchName': branchName,
      'branchCode': branchCode,
      'accountNumber': accountNumber,
      'beneficiaryName': beneficiaryName,
      'bankStatement': bankStatement,
      'nicFront': nicFront,
      'nicBack': nicBack,
      'menuDocument': menuDocument,
      'itemImages': itemImages,
      'hasImages': hasImages,
      'operatingHours': operatingHours.map((h) => h.toMap()).toList(),
      'status': status,
      'isActive': isActive,
      'howDidYouHear': howDidYouHear,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // ── copyWith ─────────────────────────────────────────────────

  MerchantProfileModel copyWith({
    String? uid,
    String? merchantId,
    String? merchantType,
    String? outletName,
    String? outletAddress,
    String? outletLogo,
    String? city,
    MerchantLocation? location,
    String? ownerName,
    String? ownerEmail,
    String? ownerPhone,
    String? email,
    String? phoneNumber,
    bool? isEmailVerified,
    String? managerName,
    String? managerEmail,
    String? managerPhone,
    String? parentName,
    bool? businessRegistered,
    String? brNumber,
    String? brDocument,
    bool? vatRegistered,
    String? vatNumber,
    bool? taxRegistered,
    String? tinNumber,
    String? taxCertificate,
    String? tdlDocument,
    String? bankName,
    String? branchName,
    String? branchCode,
    String? accountNumber,
    String? beneficiaryName,
    String? bankStatement,
    String? nicFront,
    String? nicBack,
    String? menuDocument,
    List<String>? itemImages,
    bool? hasImages,
    List<DayOperatingHours>? operatingHours,
    String? status,
    bool? isActive,
    String? howDidYouHear,
    DateTime? createdAt,
  }) {
    return MerchantProfileModel(
      uid: uid ?? this.uid,
      merchantId: merchantId ?? this.merchantId,
      merchantType: merchantType ?? this.merchantType,
      outletName: outletName ?? this.outletName,
      outletAddress: outletAddress ?? this.outletAddress,
      outletLogo: outletLogo ?? this.outletLogo,
      city: city ?? this.city,
      location: location ?? this.location,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      managerName: managerName ?? this.managerName,
      managerEmail: managerEmail ?? this.managerEmail,
      managerPhone: managerPhone ?? this.managerPhone,
      parentName: parentName ?? this.parentName,
      businessRegistered: businessRegistered ?? this.businessRegistered,
      brNumber: brNumber ?? this.brNumber,
      brDocument: brDocument ?? this.brDocument,
      vatRegistered: vatRegistered ?? this.vatRegistered,
      vatNumber: vatNumber ?? this.vatNumber,
      taxRegistered: taxRegistered ?? this.taxRegistered,
      tinNumber: tinNumber ?? this.tinNumber,
      taxCertificate: taxCertificate ?? this.taxCertificate,
      tdlDocument: tdlDocument ?? this.tdlDocument,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      branchCode: branchCode ?? this.branchCode,
      accountNumber: accountNumber ?? this.accountNumber,
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      bankStatement: bankStatement ?? this.bankStatement,
      nicFront: nicFront ?? this.nicFront,
      nicBack: nicBack ?? this.nicBack,
      menuDocument: menuDocument ?? this.menuDocument,
      itemImages: itemImages ?? this.itemImages,
      hasImages: hasImages ?? this.hasImages,
      operatingHours: operatingHours ?? this.operatingHours,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      howDidYouHear: howDidYouHear ?? this.howDidYouHear,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
