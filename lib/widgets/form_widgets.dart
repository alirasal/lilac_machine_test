import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 6),
        child: Text(text.toUpperCase(),
            style: const TextStyle(
                fontSize: 10, color: AppColors.grey, letterSpacing: .6)),
      );
}

class AppField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint, prefix;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final int maxLines;
  const AppField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.prefix,
    this.keyboard,
    this.validator,
    this.maxLines = 1,
  });
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabel(label),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            validator: validator,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(hintText: hint, prefixText: prefix),
          ),
        ],
      );
}

class AppDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabel(label),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, size: 20),
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => v == null ? null : onChanged(v),
          ),
        ],
      );
}

class DateField extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabel(label),
          InkWell(
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: value,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (d != null) onChanged(d);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today_outlined, size: 18)),
              child: Text(DateFormat('EEE, dd MMM yyyy').format(value),
                  style: const TextStyle(fontSize: 13)),
            ),
          ),
        ],
      );
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const PrimaryButton(this.text, {super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const StadiumBorder(),
          ),
          child: Text(text, style: const TextStyle(fontSize: 14)),
        ),
      );
}

class FormCard extends StatelessWidget {
  final Widget child;
  const FormCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 3))
          ],
        ),
        child: child,
      );
}

PreferredSizeWidget tealAppBar(String title, {bool back = false}) => AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: back ? const BackButton() : null,
      title: Text(title, style: const TextStyle(fontSize: 15)),
    );

Future<bool> confirmDialog(BuildContext c, String title, String msg) async =>
    await showDialog<bool>(
      context: c,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Delete', style: TextStyle(color: AppColors.red))),
        ],
      ),
    ) ??
    false;

/// Keeps content at a readable width on wide screens; full width on phones.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ResponsiveCenter({super.key, required this.child, this.maxWidth = 640});
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth), child: child),
      );
}
