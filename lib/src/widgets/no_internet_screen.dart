import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/ground_control_theme.dart';

/// Full-screen blocking UI shown when connectivity is lost and no config is cached.
class NoInternetScreen extends StatefulWidget {
  final VoidCallback onRetry;
  final GroundControlTheme theme;
  final Duration retryDelay;

  const NoInternetScreen({
    super.key,
    required this.onRetry,
    required this.theme,
    required this.retryDelay,
  });

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.retryDelay.inSeconds;
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _secondsRemaining = widget.retryDelay.inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        widget.onRetry();
        _startCountdown(); // Restart after retry
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.noInternetBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.1).animate(
                  CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                ),
                child: widget.theme.noInternetIcon ??
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 80,
                      color: widget.theme.noInternetIconColor,
                    ),
              ),
              const SizedBox(height: 32),
              Text(
                widget.theme.noInternetTitle,
                style: widget.theme.noInternetTitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                widget.theme.noInternetMessage,
                style: widget.theme.noInternetMessageStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: widget.onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.theme.retryButtonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: widget.theme.retryButtonBorderRadius),
                ),
                child: Text(
                  '${widget.theme.retryButtonLabel} ($_secondsRemaining s)',
                  style: widget.theme.retryButtonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
