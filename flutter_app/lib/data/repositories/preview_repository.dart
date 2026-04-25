import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final previewRepositoryProvider = Provider<PreviewRepository>((ref) {
  return PreviewRepository();
});

class GeneratePreviewResult {
  const GeneratePreviewResult({
    required this.previewId,
    required this.imageUrl,
    required this.openingText,
    required this.childName,
  });

  final String previewId;
  final String imageUrl;
  final String openingText;
  final String childName;

  factory GeneratePreviewResult.fromMap(Map<String, dynamic> map) {
    return GeneratePreviewResult(
      previewId: map['previewId'] as String,
      imageUrl: map['imageUrl'] as String,
      openingText: map['openingText'] as String,
      childName: map['childName'] as String,
    );
  }
}

class ClaimPreviewResult {
  const ClaimPreviewResult({
    required this.heroRevealImageUrl,
    required this.childName,
    required this.artStyle,
  });

  final String heroRevealImageUrl;
  final String childName;
  final String artStyle;

  factory ClaimPreviewResult.fromMap(Map<String, dynamic> map) {
    return ClaimPreviewResult(
      heroRevealImageUrl: map['heroRevealImageUrl'] as String,
      childName: map['childName'] as String,
      artStyle: map['artStyle'] as String,
    );
  }
}

class PreviewRepository {
  final _functions = FirebaseFunctions.instance;

  Future<GeneratePreviewResult> generatePreview({
    required String childName,
    required String adventureChoice,
    required String artStyle,
    required File photoFile,
  }) async {
    final photoBytes = await photoFile.readAsBytes();
    final photoBase64 = base64Encode(photoBytes);
    final deviceFingerprint = await _getDeviceFingerprint();

    final callable = _functions.httpsCallable(
      'generatePreview',
      options: HttpsCallableOptions(timeout: const Duration(minutes: 3)),
    );

    final result = await callable.call({
      'childName': childName,
      'adventureChoice': adventureChoice,
      'artStyle': artStyle,
      'photoBase64': photoBase64,
      'deviceFingerprint': deviceFingerprint,
    });

    return GeneratePreviewResult.fromMap(
      Map<String, dynamic>.from(result.data as Map),
    );
  }

  Future<ClaimPreviewResult> claimPreview(String previewId) async {
    final callable = _functions.httpsCallable('claimPreview');
    final result = await callable.call({'previewId': previewId});
    return ClaimPreviewResult.fromMap(
      Map<String, dynamic>.from(result.data as Map),
    );
  }

  Future<String> _getDeviceFingerprint() async {
    final info = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final ios = await info.iosInfo;
      return ios.identifierForVendor ?? 'unknown-ios';
    } else if (Platform.isAndroid) {
      final android = await info.androidInfo;
      return android.id;
    }
    return 'unknown-platform';
  }
}
