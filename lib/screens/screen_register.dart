import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecomarket_1/auth/google_sign.dart'; // importa tu clase
import 'package:flutter_ecomarket_1/core/color.dart';
import 'package:flutter_ecomarket_1/core/strings.dart';
import '../core/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _paymentController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _paymentController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValid(String text) => text.length >= 3;

  Widget buildTextFormField({
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isPassword = false,
    bool showToggle = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && _obscurePassword,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.gris,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  )
                  : controller.text.isEmpty
                  ? null
                  : Icon(
                    _isValid(controller.text)
                        ? Icons.check_circle
                        : Icons.error,
                    color:
                        _isValid(controller.text) ? Colors.green : Colors.red,
                  ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        backgroundColor: AppColors.blanco,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      Appstrings.appName,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    Appstrings.loginTitle,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Campos de entrada
                  buildTextFormField(
                    hint: Appstrings.nameUser,
                    controller: _nameController,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'El nombre es obligatorio' : null,
                  ),
                  buildTextFormField(
                    hint: Appstrings.adressUser,
                    controller: _emailController,
                    validator:
                        (value) =>
                            !value!.contains('@') ? 'Correo inválido' : null,
                  ),
                  buildTextFormField(
                    hint: Appstrings.paymentMethods,
                    controller: _paymentController,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Método de pago requerido' : null,
                  ),
                  buildTextFormField(
                    hint: Appstrings.confirmPassword,
                    controller: _passwordController,
                    isPassword: true,
                    showToggle: true,
                    validator:
                        (value) =>
                            value!.length < 6 ? 'Contraseña muy corta' : null,
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // Registro en Firebase Auth
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );

                            // Guardar datos en Firestore
                            await FirebaseFirestore.instance
                                .collection('usuarios')
                                .doc(userCredential.user!.uid)
                                .set({
                                  'nombre': _nameController.text.trim(),
                                  'correo': _emailController.text.trim(),
                                  'metodo_pago': _paymentController.text.trim(),
                                  'fehca_registro': Timestamp.now(),
                                });

                            // Mostrar mensaje de éxito
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registro exitoso 🎉'),
                              ),
                            );

                            // Redirigir al homepage
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.homePage,
                            );
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.message}')),
                            );
                          }
                        }
                      }, // Fin

                      child: const Text("Registrarse"),
                    ),
                  ),

                  // Botón de Google
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final userCredential =
                            await GoogleSignInProvider.signInWithGoogle();

                        if (userCredential != null) {
                          // ¡Inicio de sesión exitoso!
                          debugPrint(
                            "Usuario: ${userCredential.user!.displayName}",
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Inicio de sesión con Google exitoso 🎉',
                              ),
                            ),
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.homePage,
                          ); // o tu ruta home
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Inicio de sesión cancelado'),
                            ),
                          );
                        }
                      },
                      icon: Image.asset(
                        'assets/icons/google-logo.png',
                        height: 24,
                        width: 24,
                      ),
                      label: const Text(
                        'Continuar con Google',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),

                  //Boton de login
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/login');
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: Appstrings.loginNoAccountText,
                          children: [
                            TextSpan(
                              text: Appstrings.login,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        style: TextStyle(color: Colors.black54),
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
}
