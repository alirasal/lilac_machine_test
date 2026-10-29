import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const primary = Color(0xFF2E7D6F);
  static const light = Color(0xFF5BAE9F);
  static const green = Color(0xFF1FA463);
  static const red = Color(0xFFE53935);
  static const grey = Color(0xFF8A8A8A);
  static const border = Color(0xFFE3E3E3);
}

class AppTheme {
  static OutlineInputBorder _b(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: c));

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary, primary: AppColors.primary),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.grey),
          border: _b(AppColors.border),
          enabledBorder: _b(AppColors.border),
          focusedBorder: _b(AppColors.primary),
          errorBorder: _b(AppColors.red),
          focusedErrorBorder: _b(AppColors.red),
        ),
      );
}

String money(double v) => '₹${NumberFormat('#,##0.00').format(v)}';

String dateLabel(DateTime d) {
  final n = DateTime.now();
  final t = DateTime(n.year, n.month, n.day);
  final diff = t.difference(DateTime(d.year, d.month, d.day)).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return DateFormat('MMM dd, yyyy').format(d);
}
