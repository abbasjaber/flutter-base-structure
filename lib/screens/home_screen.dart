import 'package:app/remote/providers/auth_provider.dart';
import 'package:app/screens/sales_home_screen.dart';
import 'package:app/screens/tmr_home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
