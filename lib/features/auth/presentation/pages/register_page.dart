import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../core/presentation/main_layout.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'legal_docs_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedDate;
  bool _isAdult = true; // Default true to not show error initially
  bool _obscurePassword = true;
  bool _acceptedTerms = false;
  bool _isLoading = false;

  // Password Validation State
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_validatePassword);
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final pass = _passwordController.text;
    setState(() {
      _hasMinLength = pass.length >= 8;
      _hasUppercase = pass.contains(RegExp(r'[A-Z]'));
      _hasLowercase = pass.contains(RegExp(r'[a-z]'));
      _hasNumber = pass.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = pass.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    });
  }

  void _generateSecurePassword() {
    const length = 12;
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final rnd = Random();
    final password = String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );

    _passwordController.text = password;
    _confirmPasswordController.text = password;
    setState(() {
      _obscurePassword = false; // Show generated password
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF0040),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.black),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      final age = DateTime.now().difference(picked).inDays / 365;
      setState(() {
        _selectedDate = picked;
        _isAdult = age >= 18;
      });
    }
  }

  void _register() async {
    if (!_acceptedTerms || !_isAdult || !_isPasswordValid()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona tu fecha de nacimiento'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepository = AuthRepositoryImpl();
      await authRepository.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        birthDate: _selectedDate!,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  bool _isPasswordValid() {
    return _hasMinLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasNumber &&
        _hasSpecialChar;
  }

  void _openLegalDoc(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegalDocsPage(
          title: title,
          content:
              "Contenido legal simulado para $title.\n\nLorem ipsum dolor sit amet...",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Crear Cuenta',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Datos Personales',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Full Name
              _buildTextField(
                controller: _fullNameController,
                label: 'Nombre Completo (Real)',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              // Username
              _buildTextField(
                controller: _usernameController,
                label: 'Nombre de Usuario (Público)',
                icon: Icons.alternate_email,
              ),
              const SizedBox(height: 16),

              // Date of Birth
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Fecha de Nacimiento'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Colors.grey
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_isAdult)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.error_outline, color: Colors.red, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Debes ser mayor de edad para entrar en Swingo',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              const Text(
                'Seguridad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Email
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade800),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Color(0xFFFF0040)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 8),

              // Password Requirements
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _RequirementCheck(
                    label: '8+ carácteres',
                    isValid: _hasMinLength,
                  ),
                  _RequirementCheck(label: 'Mayúscula', isValid: _hasUppercase),
                  _RequirementCheck(label: 'Minúscula', isValid: _hasLowercase),
                  _RequirementCheck(label: 'Número', isValid: _hasNumber),
                  _RequirementCheck(label: 'Símbolo', isValid: _hasSpecialChar),
                ],
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _generateSecurePassword,
                  icon: const Icon(
                    Icons.vpn_key,
                    size: 16,
                    color: Color(0xFFFF0040),
                  ),
                  label: const Text(
                    'Generar Segura',
                    style: TextStyle(color: Color(0xFFFF0040)),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Confirm Password
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade800),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Color(0xFFFF0040)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 32),

              // Legal Suite
              const Text(
                'Al registrarte, aceptas nuestros:',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                children: [
                  _LegalLink(
                    text: '📜 Términos y Condiciones',
                    onTap: () => _openLegalDoc('Términos y Condiciones'),
                  ),
                  _LegalLink(
                    text: '🔒 Política de Privacidad',
                    onTap: () => _openLegalDoc('Política de Privacidad'),
                  ),
                  _LegalLink(
                    text: '🍪 Política de Cookies',
                    onTap: () => _openLegalDoc('Política de Cookies'),
                  ),
                  _LegalLink(
                    text: '⚖️ Aviso Legal',
                    onTap: () => _openLegalDoc('Aviso Legal'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.grey),
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFFFF0040),
                  title: const Text(
                    'He leído y acepto todos los documentos legales anteriores',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  value: _acceptedTerms,
                  onChanged: (val) =>
                      setState(() => _acceptedTerms = val ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              const SizedBox(height: 32),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0040),
                    disabledBackgroundColor: Colors.grey.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      (_acceptedTerms &&
                          _isAdult &&
                          _isPasswordValid() &&
                          !_isLoading)
                      ? _register
                      : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'REGISTRARSE',
                          style: TextStyle(
                            color:
                                (_acceptedTerms &&
                                    _isAdult &&
                                    _isPasswordValid())
                                ? Colors.white
                                : Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿Ya tienes cuenta? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Inicia aquí',
                      style: TextStyle(
                        color: Color(0xFFFF0040),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFFFF0040)),
        ),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
      ),
    );
  }
}

class _RequirementCheck extends StatelessWidget {
  final String label;
  final bool isValid;

  const _RequirementCheck({required this.label, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle_outlined,
          color: isValid ? Colors.green : Colors.grey,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _LegalLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _LegalLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.blueAccent,
            decoration: TextDecoration.underline,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
