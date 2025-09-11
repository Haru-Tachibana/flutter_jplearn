import 'package:flutter/material.dart';
//import 'package:flutter/semantics.dart';

class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final String? semanticHint;
  final bool excludeSemantics;

  const AccessibleButton({
    Key? key,
    required this.child,
    this.onPressed,
    required this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      enabled: onPressed != null,
      excludeSemantics: excludeSemantics,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ),
      ),
    );
  }
}