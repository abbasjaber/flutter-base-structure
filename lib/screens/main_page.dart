import 'package:app/remote/providers/auth_provider.dart';
import 'package:app/utils/theme.dart';
import 'package:app/utils/common_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({
    super.key,
    required this.child,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final userPosition = _authProvider.userModel?.position;
    final isTmrUser = userPosition == 'TMR';

    return Scaffold(
      body: widget.child,
      floatingActionButton: _shouldShowFAB(context)
          ? CommonFloatingActionButton(
              label: 'New Visit'.tr(),
              icon: Icons.add,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Add new client or start visit'.tr(),
                    ),
                    backgroundColor: PrimeColors.primaryRed,
                  ),
                );
              },
            )
          : null,
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        isTmrUser: isTmrUser,
        onTap: (index) {
          _navigateToIndex(context, index);
        },
      ),
    );
  }

  bool _shouldShowFAB(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return location == '/';
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/':
        return 0;
      // case '/history':
      //   return 1;
      // case '/analytics':
      //   return 2;
      case '/profile':
        return 1;
      default:
        return 0;
    }
  }

  void _navigateToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      // case 1:
      //   context.go('/history');
      //   break;
      // case 2:
      //   context.go('/analytics');
      //   break;
      case 1:
        context.go('/profile');
        break;
    }
  }
}
