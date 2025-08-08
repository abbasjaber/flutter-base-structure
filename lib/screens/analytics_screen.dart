import 'package:app/remote/providers/auth_provider.dart';
import 'package:app/utils/theme.dart';
import 'package:app/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userPosition = authProvider.userModel?.position;
        final isTmrUser = userPosition == 'TMR';

        return Scaffold(
          appBar: CommonAppBar(
            title: isTmrUser ? 'Reports & Analytics' : 'Sales Analytics',
            showBackButton: false,
            showMenu: false,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics,
                  size: 64,
                  color: PrimeColors.lightGray,
                ),
                const SizedBox(height: 16),
                Text(
                  isTmrUser ? 'Reports & Analytics' : 'Sales Analytics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: PrimeColors.pureBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coming soon...',
                  style: TextStyle(
                    fontSize: 16,
                    color: PrimeColors.lightGray,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
