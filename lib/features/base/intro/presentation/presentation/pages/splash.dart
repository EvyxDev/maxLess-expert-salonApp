import 'package:flutter/material.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/base/intro/presentation/presentation/pages/on-boarding/on_boarding.dart';
import 'package:maxless/features/home/presentation/pages/home.dart';
import 'package:upgrader/upgrader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _updateRequired = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _checkForUpdate();
  }

  void _checkForUpdate() async {
    final upgrader = Upgrader.sharedInstance;
    await upgrader.initialize();

    if (upgrader.isUpdateAvailable()) {
      setState(() {
        _updateRequired = true;
      });
    } else {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final token = sl<CacheHelper>().getData(key: AppConstants.token);
        navigateAndFinish(
            context, token != null ? HomePage() : const OnboardingScreen());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/gifs/splash.gif',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (_updateRequired)
            UpgradeAlert(
              shouldPopScope: () => false,
              showIgnore: false,
              showLater: false,
              dialogStyle: UpgradeDialogStyle.material,
              barrierDismissible: false,
              showReleaseNotes: true,
            ),
        ],
      ),
    );
  }
}
