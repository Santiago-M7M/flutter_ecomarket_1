import 'package:flutter/material.dart';
import 'package:flutter_ecomarket_1/core/color.dart';
import '../core/routes.dart';
import '../core/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() => _scale = 0.95); // efecto al presionar
  }

  void _onTapUp(_) {
    setState(() => _scale = 1.0); // vuelve a tamaño normal
    Navigator.pushNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanco,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Ícono decorativo arriba 🌱
              const Icon(
                Icons.local_florist,
                color: AppColors.primary,
                size: 40,
              ),

              const SizedBox(height: 20),

              // Logo con sombra sutil
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/icons/app_logo.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // Mensaje de bienvenida
              Text(
                Appstrings.welcomeMessage,
                style: TextStyle(
                  color: AppColors.fontColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Descripción
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  Appstrings.messageHome,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.subtitle, fontSize: 20),
                ),
              ),

              const SizedBox(height: 30),

              // Botón con animación
              GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                child: Transform.scale(
                  scale: _scale,
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint('Botón presionado');
                      Navigator.pushNamed(context, Routes.register);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: AppColors.secondary, width: 2),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      Appstrings.homestartButton,
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Botón "Regístrate" con iconito 👤
              TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.register);
                },
                icon: const Icon(
                  Icons.person_add_alt_1,
                  color: AppColors.registration,
                ),
                label: Text(
                  Appstrings.homeRegisterButton,
                  style: TextStyle(
                    color: AppColors.registration,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
