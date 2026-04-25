import 'package:flutter/material.dart';
import 'package:ground_control/ground_control.dart';
import 'mock_server_panel.dart';

class HomeScreen extends StatelessWidget {
  final GroundControlController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GroundControl Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refresh(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final status = controller.currentStatus;
          final config = controller.currentConfig;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusBadge(status),
                const SizedBox(height: 24),
                const Text(
                  'Current Config Info',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (config != null) ...[
                  _buildInfoCard(
                    'Maintenance',
                    config.maintenance.enabled ? 'Enabled' : 'Disabled',
                    Icons.settings,
                  ),
                  _buildInfoCard(
                    'Min Required Version',
                    config.forceUpdate.minVersion,
                    Icons.system_update,
                  ),
                  _buildInfoCard(
                    'Whats New Version',
                    config.whatsNew.version,
                    Icons.new_releases,
                  ),
                ] else
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          'No config loaded yet. Tap refresh or use the panel below.'),
                    ),
                  ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            MockServerPanel(controller: controller),
                      );
                    },
                    icon: const Icon(Icons.developer_mode),
                    label: const Text('Open Simulation Panel'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(GroundControlStatus status) {
    Color color;
    switch (status) {
      case GroundControlStatus.normal:
        color = Colors.green;
        break;
      case GroundControlStatus.loading:
        color = Colors.blue;
        break;
      case GroundControlStatus.noInternet:
        color = Colors.red;
        break;
      case GroundControlStatus.maintenance:
        color = Colors.orange;
        break;
      case GroundControlStatus.forceUpdate:
        color = Colors.deepPurple;
        break;
      case GroundControlStatus.whatsNew:
        color = Colors.teal;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 12, color: color),
          const SizedBox(width: 8),
          Text(
            'Status: ${status.name.toUpperCase()}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
