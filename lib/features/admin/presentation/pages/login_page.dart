import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme.dart';
import '../../providers/admin_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final provider = context.read<AdminProvider>();
    final success = await provider.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );
    if (success && mounted) {
      context.go('/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.darkBg,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.colors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.colors.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Consumer<AdminProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'KURASH JATIM',
                    style: TextStyle(
                      color: context.colors.primaryGold,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Masuk ke Panel Admin',
                    style: TextStyle(color: context.colors.textMuted, fontSize: 14),
                  ),
                  SizedBox(height: 32),
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: context.colors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person, color: context.colors.textMuted),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(color: context.colors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: context.colors.textMuted),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: context.colors.textMuted,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _handleLogin(),
                  ),
                  SizedBox(height: 24),
                  if (provider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: context.colors.errorRed, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _handleLogin,
                      child: provider.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text('Masuk'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


