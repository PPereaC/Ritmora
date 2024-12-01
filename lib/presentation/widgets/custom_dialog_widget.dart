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
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
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
          child: Text(cancelButtonText),
        ),
        TextButton(
          onPressed: () => onConfirm(controller.text),
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}