import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF7B1FA2); // Morado suave para pestañas
  static const background = Colors.white;
  static const cardBackground = Color(0xFFF5F5F5);
  static const textPrimary = Colors.black87;
  static const textSecondary = Colors.grey; // Gris más suave
  static const miniPlayerGradient = LinearGradient(
    colors: [
      Color(0xFF42A5F5), // Azul claro
      Color(0xFFAB47BC), // Morado
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}