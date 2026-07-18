import 'package:app/features/auth/providers/auth_provider.dart';
import 'package:app/features/home/providers/example_provider.dart';
import 'package:app/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/core/di/di_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  
  // AuthProvider is global to track login state.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // ExampleProvider is scoped only to where it's needed
      home: ChangeNotifierProvider(
        create: (context) => di.sl<ExampleProvider>(),
        child: const HomeScreen(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}
