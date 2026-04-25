import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'models/ground_control_config.dart';
import 'models/ground_control_status.dart';
import 'services/ground_control_checker.dart';
import 'services/ground_control_version_store.dart';
import 'theme/ground_control_theme.dart';
import 'widgets/no_internet_screen.dart';
import 'widgets/maintenance_screen.dart';
import 'widgets/force_update_dialog.dart';
import 'widgets/whats_new_dialog.dart';

/// Controller to programmatically interact with [GroundControlShell].
class GroundControlController extends ChangeNotifier {
  GroundControlStatus _status = GroundControlStatus.loading;
  GroundControlConfig? _config;
  GroundControlConfig? _mockConfig;
  bool _simulateNoInternet = false;

  /// The current [GroundControlStatus].
  GroundControlStatus get currentStatus => _status;

  /// The current [GroundControlConfig], if available.
  GroundControlConfig? get currentConfig => _config;

  /// Internal: Sets a mock config for the example app simulator.
  set mockConfig(GroundControlConfig? config) {
    _mockConfig = config;
    notifyListeners();
  }

  /// Internal: Toggles simulated network failure.
  set simulateNoInternet(bool value) {
    _simulateNoInternet = value;
    notifyListeners();
  }

  final _refreshController = StreamController<void>.broadcast();
  Stream<void> get onRefreshRequested => _refreshController.stream;

  /// Manually trigger a config re-fetch.
  void refresh() {
    _refreshController.add(null);
  }

  void _update(GroundControlStatus status, GroundControlConfig? config) {
    _status = status;
    _config = config;
    notifyListeners();
  }

  @override
  void dispose() {
    _refreshController.close();
    super.dispose();
  }
}

/// The main entry-point widget that wraps your application.
/// 
/// It handles maintenance mode, force updates, "what's new" dialogs, and no-internet states.
class GroundControlShell extends StatefulWidget {
  /// The app widget (e.g. [MaterialApp]).
  final Widget child;

  /// URL of the remote JSON configuration.
  final String configUrl;

  /// Current app version (e.g. "1.0.0").
  final String appVersion;

  /// How often to silently re-check the remote config.
  final Duration checkInterval;

  /// Whether to re-check when the app resumes from the background.
  final bool checkOnResume;

  /// Visual theme for all internal screens and dialogs.
  final GroundControlTheme theme;

  /// Optional controller for programmatic access.
  final GroundControlController? controller;

  // --- Customization Overrides ---
  final Widget? customNoInternetScreen;
  final Widget Function(MaintenanceConfig)? customMaintenanceScreen;
  final Widget Function(ForceUpdateConfig)? customForceUpdateDialog;
  final Widget Function(WhatsNewConfig, VoidCallback onDismiss)? customWhatsNewDialog;

  // --- Callbacks ---
  final void Function(GroundControlStatus status)? onStatusChanged;
  final void Function(Object error)? onError;

  // --- Behavior Toggles ---
  final bool showNoInternetOnStartup;
  final bool allowDismissWhatsNew;
  final Duration retryDelay;
  final Map<String, String>? configHeaders;

  const GroundControlShell({
    super.key,
    required this.child,
    required this.configUrl,
    this.appVersion = '1.0.0',
    this.checkInterval = const Duration(minutes: 30),
    this.checkOnResume = true,
    this.theme = const GroundControlTheme(),
    this.controller,
    this.customNoInternetScreen,
    this.customMaintenanceScreen,
    this.customForceUpdateDialog,
    this.customWhatsNewDialog,
    this.onStatusChanged,
    this.onError,
    this.showNoInternetOnStartup = true,
    this.allowDismissWhatsNew = true,
    this.retryDelay = const Duration(seconds: 5),
    this.configHeaders,
  });

  @override
  State<GroundControlShell> createState() => _GroundControlShellState();
}

class _GroundControlShellState extends State<GroundControlShell> with WidgetsBindingObserver {
  late GroundControlController _controller;
  Timer? _refreshTimer;
  bool _isWhatsNewDismissed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = widget.controller ?? GroundControlController();
    _controller.onRefreshRequested.listen((_) => _checkStatus());
    _checkStatus(isStartup: true);
    _startPeriodicCheck();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.checkOnResume && state == AppLifecycleState.resumed) {
      _checkStatus();
      _startPeriodicCheck(); // Reset timer on resume
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _startPeriodicCheck() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(widget.checkInterval, (_) => _checkStatus());
  }

  Future<void> _checkStatus({bool isStartup = false}) async {
    try {
      if (_controller._simulateNoInternet) {
        throw const SocketException('Simulated network failure');
      }

      if (_controller._mockConfig != null) {
        await _determineStatus(_controller._mockConfig!);
        return;
      }

      final config = await GroundControlChecker.fetchConfig(
        widget.configUrl,
        headers: widget.configHeaders,
      );

      // Cache successful config
      await GroundControlVersionStore.cacheConfig(json.encode(config.toJson()));

      await _determineStatus(config);
    } catch (e) {
      widget.onError?.call(e);
      
      // Attempt to use cached config on failure
      final cachedJson = await GroundControlVersionStore.getCachedConfig();
      if (cachedJson != null) {
        final config = GroundControlConfig.fromJson(json.decode(cachedJson));
        await _determineStatus(config);
      } else {
        if (isStartup || widget.showNoInternetOnStartup) {
          _updateStatus(GroundControlStatus.noInternet, null);
        }
      }
    }
  }

  Future<void> _determineStatus(GroundControlConfig config) async {
    // 1. Maintenance (Highest priority)
    if (config.maintenance.enabled) {
      _updateStatus(GroundControlStatus.maintenance, config);
      return;
    }

    // 2. Force Update
    if (config.forceUpdate.enabled) {
      if (GroundControlVersionComparator.isGreater(config.forceUpdate.minVersion, widget.appVersion)) {
        _updateStatus(GroundControlStatus.forceUpdate, config);
        return;
      }
    }

    // 3. What's New
    if (config.whatsNew.enabled && !_isWhatsNewDismissed) {
      final lastSeen = await GroundControlVersionStore.getLastSeenVersion();
      if (lastSeen != config.whatsNew.version) {
        _updateStatus(GroundControlStatus.whatsNew, config);
        return;
      }
    }

    // 4. Normal
    _updateStatus(GroundControlStatus.normal, config);
  }

  void _updateStatus(GroundControlStatus status, GroundControlConfig? config) {
    if (_controller.currentStatus != status) {
      setState(() {
        _controller._update(status, config);
      });
      widget.onStatusChanged?.call(status);
    }
  }

  void _dismissWhatsNew() async {
    if (_controller.currentConfig?.whatsNew.version != null) {
      await GroundControlVersionStore.saveLastSeenVersion(_controller.currentConfig!.whatsNew.version);
      setState(() {
        _isWhatsNewDismissed = true;
      });
      _checkStatus(); // Re-evaluate status to move to 'normal'
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          // The base application
          widget.child,

          // Overlays based on status
          if (_controller.currentStatus != GroundControlStatus.normal)
            _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    final status = _controller.currentStatus;
    final config = _controller.currentConfig;

    switch (status) {
      case GroundControlStatus.loading:
        return Container(
          color: widget.theme.noInternetBackgroundColor,
          child: const Center(child: CircularProgressIndicator()),
        );

      case GroundControlStatus.noInternet:
        return widget.customNoInternetScreen ??
            NoInternetScreen(
              theme: widget.theme,
              retryDelay: widget.retryDelay,
              onRetry: _checkStatus,
            );

      case GroundControlStatus.maintenance:
        if (config == null) return const SizedBox.shrink();
        return widget.customMaintenanceScreen?.call(config.maintenance) ??
            MaintenanceScreen(config: config.maintenance, theme: widget.theme);

      case GroundControlStatus.forceUpdate:
        if (config == null) return const SizedBox.shrink();
        return Material(
          color: widget.theme.overlayBarrierColor,
          child: widget.customForceUpdateDialog?.call(config.forceUpdate) ??
              ForceUpdateDialog(config: config.forceUpdate, theme: widget.theme),
        );

      case GroundControlStatus.whatsNew:
        if (config == null) return const SizedBox.shrink();
        return Material(
          color: widget.theme.overlayBarrierColor,
          child: widget.customWhatsNewDialog?.call(config.whatsNew, _dismissWhatsNew) ??
              WhatsNewDialog(
                config: config.whatsNew,
                theme: widget.theme,
                onDismiss: _dismissWhatsNew,
              ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
