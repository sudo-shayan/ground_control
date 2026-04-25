import 'package:flutter/material.dart';
import '../models/ground_control_config.dart';
import '../theme/ground_control_theme.dart';

/// Full-screen blocking UI shown when maintenance mode is enabled.
class MaintenanceScreen extends StatefulWidget {
  final MaintenanceConfig config;
  final GroundControlTheme theme;

  const MaintenanceScreen({
    super.key,
    required this.config,
    required this.theme,
  });

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dt) {
    // Basic human-readable format without external intl package
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute $ampm on ${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.maintenanceBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: _rotationController,
                child: widget.theme.maintenanceIcon ??
                    Icon(
                      Icons.settings_suggest_rounded,
                      size: 80,
                      color: widget.theme.maintenanceIconColor,
                    ),
              ),
              const SizedBox(height: 32),
              Text(
                widget.config.title,
                style: widget.theme.maintenanceTitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                widget.config.message,
                style: widget.theme.maintenanceMessageStyle,
                textAlign: TextAlign.center,
              ),
              if (widget.theme.showEstimatedTime && widget.config.estimatedEnd != null) ...[
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: widget.theme.maintenanceIconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.theme.estimatedTimePrefix}${_formatDateTime(widget.config.estimatedEnd!)}',
                    style: widget.theme.maintenanceEstimatedTimeStyle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
