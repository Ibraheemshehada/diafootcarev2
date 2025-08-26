import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_routes.dart';
import '../../settings/screens/terms_screen.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final settings = context.read<SettingsViewModel>();

    // Load preferences and wait for splash screen display (~2 seconds)
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      settings.loadPrefs(),
    ]);

    if (!mounted) return;

    // Gate on terms acceptance
    if (!settings.acceptedTerms) {
      // Block navigation until terms are accepted
      final accepted = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => const TermsScreen(blocking: true),
        ),
      );

      if (!mounted) return;

      if (accepted == true) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);  // Navigate to login
      } else {
        // If user doesn't accept terms, decide on app behavior.
        // Here we can choose to close the app or stay on the splash screen.
        // For example, we can close the app if terms are not accepted:
        // SystemNavigator.pop();  // To exit the app (you can choose this approach)
        return; // Simply stay on splash screen if user refuses terms
      }
      return;
    }

    // If terms already accepted → Proceed to login
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              'assets/svg/logo_light.svg',
              height: 160.h,
              width: 160.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 24.h),

            // Localized App Name using RichText
            RichText(
              text: TextSpan(
                text: tr('app_name_light'),
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                ),
                children: [
                  TextSpan(
                    text: tr('app_name_dark'),
                    style: TextStyle(color: isDark ? Colors.blue : Colors.blue),
                  ),
                ],
              ),
            ),

            const Spacer(),
            LoadingAnimationWidget.hexagonDots(
              color: const Color(0xff077FFF),
              size: 45.w,
            ),
            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }
}
