import 'package:flutter/material.dart';
import 'package:ground_control/ground_control.dart';

class MockServerPanel extends StatefulWidget {
  final GroundControlController controller;

  const MockServerPanel({super.key, required this.controller});

  @override
  State<MockServerPanel> createState() => _MockServerPanelState();
}

class _MockServerPanelState extends State<MockServerPanel> {
  // Mock State
  bool _maintenanceEnabled = false;
  bool _forceUpdateEnabled = false;
  bool _whatsNewEnabled = false;
  bool _noInternet = false;
  String _minVersion = '2.0.0';

  @override
  void initState() {
    super.initState();
    // Initialize with current config if available
    final c = widget.controller.currentConfig;
    if (c != null) {
      _maintenanceEnabled = c.maintenance.enabled;
      _forceUpdateEnabled = c.forceUpdate.enabled;
      _whatsNewEnabled = c.whatsNew.enabled;
      _minVersion = c.forceUpdate.minVersion;
    }
  }

  void _update() {
    if (_noInternet) {
      widget.controller.simulateNoInternet = true;
      widget.controller.mockConfig = null;
    } else {
      widget.controller.simulateNoInternet = false;
      widget.controller.mockConfig = GroundControlConfig(
        maintenance: MaintenanceConfig(
          enabled: _maintenanceEnabled,
          title: "Maintenance Mode",
          message: "We're currently fixing some things. We'll be back shortly!",
          estimatedEnd: DateTime.now().add(const Duration(hours: 2)),
        ),
        forceUpdate: ForceUpdateConfig(
          enabled: _forceUpdateEnabled,
          minVersion: _minVersion,
          title: "Newer Version Available",
          message: "A mandatory update is required to keep using the app securely.",
          storeUrlAndroid: "https://play.google.com/store",
          storeUrlIos: "https://apps.apple.com/app",
        ),
        whatsNew: WhatsNewConfig(
          enabled: _whatsNewEnabled,
          version: "2.1.0",
          title: "What's New in 2.1",
          items: [
            const WhatsNewItem(emoji: "✨", title: "New Design", description: "Fresher UI with Material 3 support."),
            const WhatsNewItem(emoji: "🔒", title: "Security", description: "Enhanced encryption for your data."),
            const WhatsNewItem(emoji: "🚀", title: "Performance", description: "Startup time improved by 40%."),
          ],
        ),
      );
    }
    widget.controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Simulate Server Response',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 20),
          _buildToggle('Maintenance Mode', _maintenanceEnabled, (v) {
            setState(() => _maintenanceEnabled = v);
            _update();
          }),
          _buildToggle('Force Update', _forceUpdateEnabled, (v) {
            setState(() => _forceUpdateEnabled = v);
            _update();
          }),
          if (_forceUpdateEnabled)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Minimum Version Required',
                  hintText: 'e.g. 2.0.0',
                  isDense: true,
                ),
                onChanged: (v) {
                  _minVersion = v;
                  _update();
                },
              ),
            ),
          _buildToggle('What\'s New Dialog', _whatsNewEnabled, (v) {
            setState(() => _whatsNewEnabled = v);
            _update();
          }),
          _buildToggle('Simulate No Internet', _noInternet, (v) {
            setState(() => _noInternet = v);
            _update();
          }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await GroundControlVersionStore.clearHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('What\'s New history cleared!')),
                );
                _update();
              },
              icon: const Icon(Icons.history),
              label: const Text('Reset what\'s new history'),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
