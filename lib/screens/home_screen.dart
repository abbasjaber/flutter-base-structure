import 'dart:async';

import 'package:app/remote/providers/auth_provider.dart';
import 'package:app/screens/sales_home_screen.dart';
import 'package:app/screens/tmr_home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthProvider? authProvider;
  Timer? _locationTimer;
  Future<void> _setEmployeeCoordinates() async {
    try {
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        Geolocator.openLocationSettings();
        Geolocator.checkPermission();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      var locationData = await Geolocator.getCurrentPosition();
      // Call setEmployeeCoordinates now and every 3 minutes
      authProvider?.setEmployeeCoordinates(
          locationData.latitude, locationData.longitude);

      // Set up a timer to repeat every 3 minutes (180 seconds)
      // Using a Timer.periodic is more appropriate for repeated actions at fixed intervals.
      // This avoids the need for a doWhile loop and is easier to manage/cancel.
      // Store the timer so it can be cancelled if needed (e.g., in dispose).
      // Add a Timer? _locationTimer; field to your State class.

      _locationTimer =
          Timer.periodic(const Duration(minutes: 3), (timer) async {
        if (!mounted) {
          timer.cancel();
          return;
        }
        try {
          var locationData = await Geolocator.getCurrentPosition();
          await authProvider?.setEmployeeCoordinates(
              locationData.latitude, locationData.longitude);
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _setEmployeeCoordinates();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userPosition = authProvider.userModel?.position;
        final isTmrUser = userPosition == 'TMR';

        if (isTmrUser) {
          return TmrHomeScreen(title: 'TMR Dashboard'.tr());
        } else {
          return SalesHomeScreen(title: 'Sales Dashboard'.tr());
        }
      },
    );
  }
}
