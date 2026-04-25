import 'package:flutter/material.dart';
import 'package:ground_control/ground_control.dart';
import 'home_screen.dart';

void main() {
  runApp(const GroundControlExampleApp());
}

class GroundControlExampleApp extends StatefulWidget {
  const GroundControlExampleApp({super.key});

  @override
  State<GroundControlExampleApp> createState() => _GroundControlExampleAppValidState();
}

class _GroundControlExampleAppValidState extends State<GroundControlExampleApp> {
  final GroundControlController _groundControlController = GroundControlController();

  @override
  void initState() {
    super.initState();
    // Initialize with a mock config so the example app starts even if the remote URL is unreachable.
    // This allows users to use the Mock Server Panel immediately.
    _groundControlController.mockConfig = const GroundControlConfig(
      maintenance: MaintenanceConfig(
        enabled: false,
        title: 'Maintenance',
        message: 'We are currently performing maintenance.',
      ),
      forceUpdate: ForceUpdateConfig(
        enabled: false,
        minVersion: '1.0.0',
        title: 'Update Required',
        message: 'Please update to continue.',
        storeUrlAndroid: '',
        storeUrlIos: '',
      ),
      whatsNew: WhatsNewConfig(
        enabled: false,
        version: '1.0.0',
        title: "What's New",
        items: [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GroundControlShell(
      controller: _groundControlController,
      // In a real app, this would be your server URL
      // For this example, we manipulate the state internally via the Mock Panel
      configUrl: 'https://raw.githubusercontent.com/USER/ground_control/main/example/mock_config.json',
      appVersion: '1.5.0',
      theme: GroundControlTheme(
        // Customizing the theme to match our demo's aesthetic
        noInternetBackgroundColor: const Color(0xFFF0F4F8),
        retryButtonColor: Colors.teal,
        whatsNewHeaderColor: Colors.teal,
        forceUpdateButtonColor: Colors.deepOrange,
        maintenanceIconColor: Colors.amber,
      ),
      onStatusChanged: (status) {
        debugPrint('GroundControl Status Changed: $status');
      },
      onError: (error) {
        debugPrint('GroundControl Error: $error');
      },
      child: MaterialApp(
        title: 'GroundControl Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: HomeScreen(controller: _groundControlController),
      ),
    );
  }
}
