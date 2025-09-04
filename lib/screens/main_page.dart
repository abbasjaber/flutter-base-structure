import 'package:app/remote/providers/auth_provider.dart';
import 'package:app/remote/providers/employee_provider.dart';
import 'package:app/utils/theme.dart';
import 'package:app/utils/common_widgets.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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
  AuthProvider? _authProvider;
  EmployeeProvider? _employeeProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final userPosition = _authProvider?.userModel?.position;
    final isTmrUser = userPosition == 'TMR';

    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _confirmExit();
        },
        child: widget.child,
      ),
      floatingActionButton: _shouldShowFAB(context)
          ? CommonFloatingActionButton(
              label: 'New Visit'.tr(),
              icon: Icons.add,
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final isGranted = await Geolocator.requestPermission();
                if (isGranted == LocationPermission.denied) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Location permissions are denied'.tr(),
                      ),
                      backgroundColor: PrimeColors.primaryRed,
                    ),
                  );
                  return;
                }
                if (isGranted == LocationPermission.deniedForever) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Location permissions are denied forever'.tr(),
                      ),
                      backgroundColor: PrimeColors.primaryRed,
                    ),
                  );
                  return;
                }

                BarcodeScanner.scan().then((result) {
                  if (result.rawContent.isNotEmpty) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please wait for the client to be loaded'.tr(),
                        ),
                        backgroundColor: PrimeColors.successGreen,
                      ),
                    );
                    _employeeProvider
                        ?.startVisit(
                      result.rawContent,
                    )
                        .then((value) {
                      if (value?.isSuccess == true) {
                        if (context.mounted) {
                          context.push('/client-details',
                              extra: _employeeProvider?.client);
                        }
                      } else {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              value?.message ?? '',
                            ),
                            backgroundColor: PrimeColors.primaryRed,
                          ),
                        );
                      }
                    });
                  }
                });
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

  Future<void> _confirmExit() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit App'.tr()),
          content: Text('Are you sure you want to exit?'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'.tr()),
            ),
          ],
        );
      },
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }
}
