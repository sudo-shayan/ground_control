import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/ground_control_config.dart';
import '../theme/ground_control_theme.dart';

/// Non-dismissible dialog that forces the user to navigate to the app store.
class ForceUpdateDialog extends StatelessWidget {
  final ForceUpdateConfig config;
  final GroundControlTheme theme;

  const ForceUpdateDialog({
    super.key,
    required this.config,
    required this.theme,
  });

  Future<void> _launchStore() async {
    String url = '';
    if (kIsWeb) {
      // Handle web if needed, but usually mobile focused
      return;
    }
    if (Platform.isAndroid) {
      url = config.storeUrlAndroid;
    } else if (Platform.isIOS) {
      url = config.storeUrlIos;
    }

    if (url.isNotEmpty && await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope is deprecated in newer Flutter versions, using PopScope
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.forceUpdateDialogBackgroundColor,
            borderRadius: theme.forceUpdateDialogBorderRadius,
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.system_update_rounded, size: 64, color: theme.forceUpdateButtonColor),
              const SizedBox(height: 16),
              Text(
                config.title,
                style: theme.forceUpdateTitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                config.message,
                style: theme.forceUpdateMessageStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _launchStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.forceUpdateButtonColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: theme.forceUpdateDialogBorderRadius),
                  ),
                  child: Text(
                    theme.forceUpdateButtonLabel,
                    style: theme.forceUpdateButtonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
