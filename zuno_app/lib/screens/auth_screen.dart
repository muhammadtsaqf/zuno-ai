import 'package:flutter/material';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success;

    if (_isLogin) {
      success = await authProvider.login(
        identifier: _loginIdController.text,
        password: _passwordController.text,
      );
    } else {
      success = await authProvider.register(
        username: _usernameController.text,
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (authProvider.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: AppTheme.accentPink,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(size: 100, showGlow: true),
                const SizedBox(height: 20),
                Text(
                  _isLogin ? 'Selamat Datang Kembali' : 'Buat Akun Zuno AI',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _isLogin
                      ? 'Masuk untuk mengakses kecerdasan Zuno AI'
                      : 'Daftar sekarang untuk memulai obrolan AI',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 32),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppTheme.primaryNeon.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryNeon.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isLogin) ...[
                          const Text(
                            'Username / Email',
                            style: TextStyle(
                              color: AppTheme.textLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _loginIdController,
                            style: const TextStyle(color: Colors.white),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Masukkan Username atau Email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'zzamcode / user@email.com',
                              hintStyle: TextStyle(color: AppTheme.textMuted.withOpacity(0.5)),
                              filled: true,
                              fillColor: AppTheme.bgDark,
                              prefixIcon: const Icon(Icons.account_circle_outlined, color: AppTheme.secondaryNeon),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ] else ...[
                          const Text(
                            'Username',
                            style: TextStyle(
                              color: AppTheme.textLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _usernameController,
                            style: const TextStyle(color: Colors.white),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Masukkan username Anda';
                              }
                              if (val.trim().length < 3) {
                                return 'Username minimal 3 karakter';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'zzamcode',
                              hintStyle: TextStyle(color: AppTheme.textMuted.withOpacity(0.5)),
                              filled: true,
                              fillColor: AppTheme.bgDark,
                              prefixIcon: const Icon(Icons.alternate_email, color: AppTheme.secondaryNeon),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nama Lengkap',
                            style: TextStyle(
                              color: AppTheme.textLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Masukkan nama lengkap Anda';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Muhammad Tsaqif Noor Az Zamil',
                              hintStyle: TextStyle(color: AppTheme.textMuted.withOpacity(0.5)),
                              filled: true,
                              fillColor: AppTheme.bgDark,
                              prefixIcon: const Icon(Icons.badge_outlined, color: AppTheme.secondaryNeon),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              color: AppTheme.textLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            validator: (val) {
                              if (val == null || !val.contains('@')) {
                                return 'Masukkan email yang valid';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'user@example.com',
                              hintStyle: TextStyle(color: AppTheme.textMuted.withOpacity(0.5)),
                              filled: true,
                              fillColor: AppTheme.bgDark,
                              prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.secondaryNeon),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        const Text(
                          'Password',
                          style: TextStyle(
                            color: AppTheme.textLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          validator: (val) {
                            if (val == null || val.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: TextStyle(color: AppTheme.textMuted.withOpacity(0.5)),
                            filled: true,
                            fillColor: AppTheme.bgDark,
                            prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.secondaryNeon),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: AppTheme.textMuted,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryNeon,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 5,
                            ),
                            onPressed: authProvider.isLoading ? null : _submit,
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _isLogin ? 'Masuk' : 'Daftar Sekarang',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Switch Login/Register Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? 'Belum punya akun?' : 'Sudah punya akun?',
                      style: const TextStyle(color: AppTheme.textMuted),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Daftar' : 'Masuk',
                        style: const TextStyle(
                          color: AppTheme.secondaryNeon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
