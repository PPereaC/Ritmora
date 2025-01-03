import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String hintText;
  final String cancelButtonText;
  final String confirmButtonText;
  final Function(String) onConfirm;
  final VoidCallback onCancel;
  final TextEditingController controller;
  final Widget? imageWidget;

  const CustomDialog({
    super.key,
    required this.title,
    this.hintText = '',
    required this.cancelButtonText,
    required this.confirmButtonText,
    required this.onConfirm,
    required this.onCancel,
    required this.controller,
    this.imageWidget,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
  
    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: colors.primary.withOpacity(0.5),
          width: 2,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.primary),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.primary),
              ),
            ),
          ),
          if (imageWidget != null) 
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: imageWidget!,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            cancelButtonText,
            style: TextStyle(color: colors.primary, fontSize: 18),
          ),
        ),
        TextButton(
          onPressed: () => onConfirm(controller.text),
          child: Text(
            confirmButtonText,
            style: TextStyle(color: colors.primary, fontSize: 18),
          ),
        ),
      ],
    );
  }
}