import 'package:flutter/material.dart';

class AuthFooterSection extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onActionPressed;

  const AuthFooterSection({
    super.key,
    required this.text,
    required this.actionText,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: onActionPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(actionText),
        ),
      ],
    );
  }
}
