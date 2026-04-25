import 'package:flutter/material.dart';
import '../models/ground_control_config.dart';
import '../theme/ground_control_theme.dart';

/// Dismissible dialog displaying a list of new features/changes.
class WhatsNewDialog extends StatelessWidget {
  final WhatsNewConfig config;
  final GroundControlTheme theme;
  final VoidCallback onDismiss;

  const WhatsNewDialog({
    super.key,
    required this.config,
    required this.theme,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: theme.whatsNewDialogBackgroundColor,
          borderRadius: theme.whatsNewDialogBorderRadius,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.whatsNewHeaderColor,
                borderRadius: BorderRadius.only(
                  topLeft: theme.whatsNewDialogBorderRadius.topLeft,
                  topRight: theme.whatsNewDialogBorderRadius.topRight,
                ),
              ),
              child: Text(
                config.title,
                style: theme.whatsNewTitleStyle.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Content
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(24),
                itemCount: config.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final item = config.items[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.emoji, style: TextStyle(fontSize: theme.whatsNewEmojiSize)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: theme.whatsNewItemTitleStyle),
                            const SizedBox(height: 4),
                            Text(item.description, style: theme.whatsNewItemDescStyle),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: onDismiss,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.whatsNewDismissButtonColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  theme.whatsNewDismissLabel,
                  style: theme.whatsNewDismissButtonStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
