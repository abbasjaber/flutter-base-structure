import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/client_details_screen.dart';
import 'package:app/screens/main_page.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/history_screen.dart';
import 'package:app/screens/analytics_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/remote/models/client_model.dart';
import 'package:app/remote/providers/auth_provider.dart';
import 'package:app/remote/providers/employee_provider.dart';
import 'package:app/utils/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'remote/di/di_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await EasyLocalization.ensureInitialized();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<EmployeeProvider>()),
      ],
      child: EasyLocalization(
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('ar'),
          startLocale: const Locale('ar'),
          useOnlyLangCode: true,
          child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  AuthProvider? authProvider;
  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider!.isLoggedIn()) {
      authProvider!.getUserModel();
      authProvider!.getLocaleCountry();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: rootNavigatorKey,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      title: 'Prime App',
      theme: PrimeTheme.getLightTheme(
        context.locale.languageCode == 'ar' ? 'Tajawal' : 'Gothic',
      ),
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          // Shell route for main app with bottom navigation
          ShellRoute(
            builder: (context, state, child) {
              return MainPage(child: child);
            },
            routes: [
              // Home route
              GoRoute(
                path: '/',
                builder: (context, state) {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  if (authProvider.userModel != null) {
                    return const HomeScreen();
                  }
                  return const NotFoundWidget();
                },
                redirect: (context, state) {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  if (!authProvider.isLoggedIn()) {
                    return '/login';
                  }
                  return null;
                },
              ),
              // History route
              GoRoute(
                path: '/history',
                builder: (context, state) {
                  return const HistoryScreen();
                },
              ),
              // Analytics route
              GoRoute(
                path: '/analytics',
                builder: (context, state) {
                  return const AnalyticsScreen();
                },
              ),
              // Profile route
              GoRoute(
                path: '/profile',
                builder: (context, state) {
                  return const ProfileScreen();
                },
              ),
            ],
          ),
          // Login route (outside shell)
          GoRoute(
            path: '/login',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            },
          ),
          // Client details route (outside shell)
          GoRoute(
            path: '/client-details',
            builder: (BuildContext context, GoRouterState state) {
              final client = state.extra as ClientModel;
              return ClientDetailsScreen(client: client);
            },
          ),
        ],
      ),
    );
  }
}

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Not Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              context.go('/login');
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

Page getPage({
  required Widget child,
  required GoRouterState state,
}) {
  return MaterialPage(
    key: state.pageKey,
    child: child,
  );
}
