import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/lumora_toast.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthSuccess;

  const AuthScreen({super.key, required this.onAuthSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool obscurePassword = true;
  bool isLoading = false;

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showLumoraToast(context, 'Veuillez remplir tous les champs obligatoires');
      return;
    }

    setState(() => isLoading = true);

    if (isLogin) {
      await AuthService.instance.login(email, password);
      if (mounted) showLumoraToast(context, 'Ravi de vous revoir ! 👋');
    } else {
      final name = _nameController.text.trim();
      final username = _usernameController.text.trim();
      if (name.isEmpty || username.isEmpty) {
        setState(() => isLoading = false);
        showLumoraToast(context, 'Veuillez renseigner votre nom et pseudo');
        return;
      }
      await AuthService.instance.register(
        fullName: name,
        username: username,
        email: email,
        password: password,
      );
      if (mounted) showLumoraToast(context, 'Compte créé avec succès ! Bienvenue 🌟');
    }

    if (mounted) {
      setState(() => isLoading = false);
      widget.onAuthSuccess();
    }
  }

  void _loginAsDemo() {
    AuthService.instance.loginAsDemo();
    showLumoraToast(context, 'Connecté en tant que Tsanta Tsiory 🔥');
    widget.onAuthSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    return Scaffold(
      backgroundColor: AppColors.bgOuter,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 440 : double.infinity),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo & Brand Name
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: AppBorders.neo(width: 2.5),
                        boxShadow: AppShadows.neo(offset: 3.5),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/images/lumora_logo.png', fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'lumora',
                    style: heading(28, letterSpacing: -0.8),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nourrissez votre foi quotidiennement 📖✨',
                    style: body(13, color: AppColors.muted, weight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // Mode Switcher (Login / Register)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: AppBorders.neo(width: 2.0),
                      boxShadow: AppShadows.neo(offset: 2.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => isLogin = true),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isLogin ? AppColors.lime : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: isLogin ? AppBorders.neo(width: 1.5) : null,
                              ),
                              child: Text(
                                'Se connecter',
                                style: body(
                                  12.5,
                                  weight: FontWeight.w900,
                                  color: isLogin ? AppColors.surface : AppColors.muted,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => isLogin = false),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: !isLogin ? AppColors.lime : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: !isLogin ? AppBorders.neo(width: 1.5) : null,
                              ),
                              child: Text(
                                'Créer un compte',
                                style: body(
                                  12.5,
                                  weight: FontWeight.w900,
                                  color: !isLogin ? AppColors.surface : AppColors.muted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  if (!isLogin) ...[
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nom complet',
                      hint: 'Ex: Tsanta Tsiory',
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _usernameController,
                      label: 'Nom d\'utilisateur (@pseudo)',
                      hint: 'Ex: tsanta_tsiory',
                      icon: Icons.alternate_email_rounded,
                    ),
                    const SizedBox(height: 14),
                  ],

                  _buildTextField(
                    controller: _emailController,
                    label: 'Adresse email',
                    hint: 'tsanta@lumora.app',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  _buildTextField(
                    controller: _passwordController,
                    label: 'Mot de passe',
                    hint: '••••••••',
                    icon: Icons.lock_outline_rounded,
                    obscureText: obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.text,
                        size: 20,
                      ),
                      onPressed: () => setState(() => obscurePassword = !obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Submit Button
                  InkWell(
                    onTap: isLoading ? null : _submit,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        border: AppBorders.neo(width: 2.2),
                        boxShadow: AppShadows.neo(offset: 3.5),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.surface),
                            )
                          : Text(
                              isLogin ? 'Connexion' : 'Commencer l\'Aventure',
                              style: body(14, weight: FontWeight.w900, color: AppColors.surface),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Demo Login Button
                  InkWell(
                    onTap: _loginAsDemo,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        border: AppBorders.neo(width: 2.0),
                        boxShadow: AppShadows.neo(offset: 2.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.flash_on_rounded, size: 18, color: AppColors.amber),
                          const SizedBox(width: 6),
                          Text(
                            'Connexion Démo Instantanée (Tsanta)',
                            style: body(12.5, weight: FontWeight.w900, color: AppColors.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: body(11.5, weight: FontWeight.w900, color: AppColors.text)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: AppBorders.neo(width: 2.0),
            boxShadow: AppShadows.neo(offset: 2.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: body(13, weight: FontWeight.w700),
            decoration: InputDecoration(
              icon: Icon(icon, color: AppColors.text, size: 20),
              hintText: hint,
              hintStyle: body(13, color: AppColors.muted.withValues(alpha: 0.6)),
              border: InputBorder.none,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
