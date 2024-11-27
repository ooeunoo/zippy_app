import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zippy/app/widgets/app_dialog.dart';

class ZippyVersion extends StatefulWidget {
  final Widget child;

  const ZippyVersion({super.key, required this.child});

  @override
  _ZippyVersionState createState() => _ZippyVersionState();
}

class _ZippyVersionState extends State<ZippyVersion> {
  @override
  void initState() {
    super.initState();
    print('ZippyVersion initState');

    // 앱이 완전히 초기화된 후에 버전 체크 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 2), () {
        _checkVersion();
      });
    });
  }

  Future<void> _checkVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      print('currentVersion: $currentVersion');
      final latestVersionInfo = await _getLatestVersionFromServer();
      print('latestVersionInfo: $latestVersionInfo');
      if (_isUpdateRequired(currentVersion, latestVersionInfo)) {
        // 컨텍스트가 유효한지 확인 후 대화 상자 표시
        print("showUpdateDialog");
        if (mounted) {
          _showUpdateDialog(latestVersionInfo);
        }
      }
    } catch (e) {
      print('버전 체크 중 오류 발생: $e');
    }
  }

  Future<Map<String, dynamic>> _getLatestVersionFromServer() async {
    final response = await Supabase.instance.client
        .from('app_versions')
        .select()
        .order('created_at', ascending: false)
        .limit(1)
        .single();
    return response;
  }

  bool _isUpdateRequired(
      String currentVersion, Map<String, dynamic> latestVersionInfo) {
    final latestVersion = latestVersionInfo['version'] as String;
    final isManadatory = latestVersionInfo['is_mandatory'] as bool;
    final minCompatibleVersion =
        latestVersionInfo['min_compatible_version'] as String;

    if (isManadatory &&
        _compareVersions(currentVersion, minCompatibleVersion) < 0) {
      return true;
    }
    return _compareVersions(currentVersion, latestVersion) < 0;
  }

  int _compareVersions(String v1, String v2) {
    var parts1 = v1.split('.').map(int.parse).toList();
    var parts2 = v2.split('.').map(int.parse).toList();
    for (int i = 0; i < parts1.length && i < parts2.length; i++) {
      if (parts1[i] < parts2[i]) return -1;
      if (parts1[i] > parts2[i]) return 1;
    }
    return parts1.length.compareTo(parts2.length);
  }

  void _showUpdateDialog(Map<String, dynamic> latestVersionInfo) {
    print("mounted: ${mounted}");
    if (!mounted) return;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // print("here");
    showVersionUpdateDialog(
      latestVersionInfo['version'],
      latestVersionInfo['release_notes'],
      () {
        _launchAppStore();
        if (latestVersionInfo['is_mandatory']) {
          // 필수 업데이트인 경우 앱 종료
          Timer(const Duration(seconds: 1), () {
            exit(0);
          });
        }
      },
    );
    // });
  }

  void _launchAppStore() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=com.zippy.app"
            : "https://apps.apple.com/app/id6499482037",
      );
      launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
