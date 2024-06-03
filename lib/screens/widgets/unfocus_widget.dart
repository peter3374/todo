import 'package:flutter/material.dart';

class UnfocusWidget extends StatelessWidget {
  final Widget? child;
  const UnfocusWidget({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
