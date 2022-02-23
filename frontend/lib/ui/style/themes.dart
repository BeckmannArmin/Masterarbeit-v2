import 'package:flutter/material.dart';

ThemeData get lightTheme => ThemeData.from(
      colorScheme: const ColorScheme(
        primary: Color(0xFF593D0C),
        onPrimary: Colors.white,
        secondary: Color(0xFFFAAB21),
        onSecondary: Color(0xFF1A1103),
        background: Colors.white,
        onBackground: Color(0xFF593D0C),
        error: Colors.red,
        onError: Colors.black,
        surface: Colors.white,
        onSurface: Color(0xFF593D0C),
        brightness: Brightness.light,
      ),
    ).copyWith(
      brightness: Brightness.light,
      toggleableActiveColor: const Color(0xFFFAAB21),
      primaryColor: const Color(0xFF593D0C),
      hintColor: const Color(0x80707070),
      hoverColor: const Color(0x0D593D0C),
      selectedRowColor: const Color(0xFF593D0C).withOpacity(0.1),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFFFAAB21)
      )
    );

ThemeData get darkTheme => ThemeData.from(
      colorScheme: const ColorScheme(
        primary: Color(0xFFFAAB21),
        onPrimary: Color(0xFF1A1103),
        secondary: Color(0xFF261A05),
        onSecondary: Color(0xFFFAAB21),
        error: Colors.red,
        onError: Colors.black,
        background: Color(0xFF1A1103),
        onBackground: Color(0xFFFAAB21),
        surface: Color(0xFF261A05),
        onSurface: Color(0xFFFAAB21),
        brightness: Brightness.dark,
      ),
    ).copyWith(
      toggleableActiveColor: const Color(0xFFFAAB21),
      primaryColor: const Color(0xFFFAAB21),
      hintColor: const Color(0x66FAAB21),
      hoverColor: const Color(0x66261A05),
      selectedRowColor: const Color(0xFF261A05),
      highlightColor: const Color(0x44C27C00),
    );
