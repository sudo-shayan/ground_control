import 'package:flutter/material.dart';

/// Full visual customization system for all GroundControl screens and dialogs.
class GroundControlTheme {
  // --- No Internet Screen ---

  /// Background color for the no-internet screen.
  final Color noInternetBackgroundColor;

  /// Icon color for the no-internet screen.
  final Color noInternetIconColor;

  /// Text style for the no-internet title.
  final TextStyle noInternetTitleStyle;

  /// Text style for the no-internet message.
  final TextStyle noInternetMessageStyle;

  /// Text style for the retry button label.
  final TextStyle retryButtonStyle;

  /// Background color for the retry button.
  final Color retryButtonColor;

  /// Border radius for the retry button.
  final BorderRadius retryButtonBorderRadius;

  /// Title text for the no-internet screen.
  final String noInternetTitle;

  /// Message text for the no-internet screen.
  final String noInternetMessage;

  /// Label for the retry button.
  final String retryButtonLabel;

  /// Custom icon widget for no-internet.
  final Widget? noInternetIcon;

  // --- Maintenance Screen ---

  /// Background color for the maintenance screen.
  final Color maintenanceBackgroundColor;

  /// Icon color for the maintenance screen.
  final Color maintenanceIconColor;

  /// Text style for the maintenance title.
  final TextStyle maintenanceTitleStyle;

  /// Text style for the maintenance message.
  final TextStyle maintenanceMessageStyle;

  /// Text style for the estimated end time.
  final TextStyle maintenanceEstimatedTimeStyle;

  /// Whether to show the estimated end time.
  final bool showEstimatedTime;

  /// Prefix for the estimated end time (e.g. "Expected back: ").
  final String estimatedTimePrefix;

  /// Custom icon widget for maintenance.
  final Widget? maintenanceIcon;

  // --- Force Update Dialog ---

  /// Background color for the force update dialog.
  final Color forceUpdateDialogBackgroundColor;

  /// Color for the update button.
  final Color forceUpdateButtonColor;

  /// Text style for the force update title.
  final TextStyle forceUpdateTitleStyle;

  /// Text style for the force update message.
  final TextStyle forceUpdateMessageStyle;

  /// Text style for the force update button label.
  final TextStyle forceUpdateButtonTextStyle;

  /// Label for the update button.
  final String forceUpdateButtonLabel;

  /// Border radius for the force update dialog.
  final BorderRadius forceUpdateDialogBorderRadius;

  /// Whether the dialog can be dismissed by tapping outside (always false for force update).
  final bool barrierDismissible;

  // --- What's New Dialog ---

  /// Background color for the what's new dialog.
  final Color whatsNewDialogBackgroundColor;

  /// Header color for the what's new dialog.
  final Color whatsNewHeaderColor;

  /// Text style for the what's new title.
  final TextStyle whatsNewTitleStyle;

  /// Text style for what's new item titles.
  final TextStyle whatsNewItemTitleStyle;

  /// Text style for what's new item descriptions.
  final TextStyle whatsNewItemDescStyle;

  /// Color for the dismiss button.
  final Color whatsNewDismissButtonColor;

  /// Text style for the dismiss button.
  final TextStyle whatsNewDismissButtonStyle;

  /// Label for the dismiss button.
  final String whatsNewDismissLabel;

  /// Border radius for the what's new dialog.
  final BorderRadius whatsNewDialogBorderRadius;

  /// Font size for the emojis in what's new items.
  final double whatsNewEmojiSize;

  // --- Global ---

  /// Color of the overlay barrier behind dialogs.
  final Color overlayBarrierColor;

  /// Duration for entrance animations.
  final Duration animationDuration;

  /// Curve for entrance animations.
  final Curve animationCurve;

  const GroundControlTheme({
    // Defaults for No Internet
    this.noInternetBackgroundColor = Colors.white,
    this.noInternetIconColor = Colors.blueGrey,
    this.noInternetTitleStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    this.noInternetMessageStyle = const TextStyle(fontSize: 16, color: Colors.grey),
    this.retryButtonStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    this.retryButtonColor = Colors.blue,
    this.retryButtonBorderRadius = const BorderRadius.all(Radius.circular(12)),
    this.noInternetTitle = 'No Internet Connection',
    this.noInternetMessage = 'Please check your connection and try again.',
    this.retryButtonLabel = 'Retry Now',
    this.noInternetIcon,

    // Defaults for Maintenance
    this.maintenanceBackgroundColor = Colors.white,
    this.maintenanceIconColor = Colors.orange,
    this.maintenanceTitleStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    this.maintenanceMessageStyle = const TextStyle(fontSize: 16, color: Colors.grey),
    this.maintenanceEstimatedTimeStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.orange),
    this.showEstimatedTime = true,
    this.estimatedTimePrefix = 'Expected back: ',
    this.maintenanceIcon,

    // Defaults for Force Update
    this.forceUpdateDialogBackgroundColor = Colors.white,
    this.forceUpdateButtonColor = Colors.blue,
    this.forceUpdateTitleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    this.forceUpdateMessageStyle = const TextStyle(fontSize: 16, color: Colors.black87),
    this.forceUpdateButtonTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    this.forceUpdateButtonLabel = 'Update Now',
    this.forceUpdateDialogBorderRadius = const BorderRadius.all(Radius.circular(16)),
    this.barrierDismissible = false,

    // Defaults for What's New
    this.whatsNewDialogBackgroundColor = Colors.white,
    this.whatsNewHeaderColor = Colors.blue,
    this.whatsNewTitleStyle = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
    this.whatsNewItemTitleStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    this.whatsNewItemDescStyle = const TextStyle(fontSize: 14, color: Colors.black54),
    this.whatsNewDismissButtonColor = Colors.blue,
    this.whatsNewDismissButtonStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    this.whatsNewDismissLabel = 'Got it!',
    this.whatsNewDialogBorderRadius = const BorderRadius.all(Radius.circular(16)),
    this.whatsNewEmojiSize = 28.0,

    // Global Defaults
    this.overlayBarrierColor = Colors.black54,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeOutQuart,
  });
}
