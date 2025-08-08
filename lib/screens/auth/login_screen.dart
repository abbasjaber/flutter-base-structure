import 'package:app/remote/models/user_model.dart';
import 'package:app/remote/providers/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  AuthProvider? authProvider;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // PRIME Logo/Brand Section
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset(
                        'assets/images/logo/Logo-01.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome back'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: PrimeColors.lightGray,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Login Form
              Text(
                'Sign In'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: PrimeColors.pureBlack,
                ),
              ),

              const SizedBox(height: 32),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'username'.tr(),
                  prefixIcon: Icon(Icons.person_rounded),
                  hintText: 'Enter your username'.tr(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username'.tr();
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password'.tr(),
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  hintText: 'Enter your password'.tr(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password'.tr();
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters'.tr();
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                height: 50,
                child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                  return ElevatedButton(
                    onPressed: authProvider.isLoading!
                        ? null
                        : () {
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            if (_formKey.currentState!.validate()) {
                              authProvider
                                  .login(UserModel(
                                      username: _emailController.text,
                                      password: _passwordController.text))
                                  .then((value) {
                                if (value != null) {
                                  if (value.isSuccess!) {
                                    if (context.mounted) {
                                      context.go('/');
                                    }
                                  } else {
                                    scaffoldMessenger.showSnackBar(SnackBar(
                                      content: Text(value.message!),
                                      backgroundColor: PrimeColors.primaryRed,
                                    ));
                                  }
                                }
                              });
                            }
                          },
                    child: authProvider.isLoading!
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  PrimeColors.pureWhite),
                            ),
                          )
                        : Text(
                            'Sign In'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
