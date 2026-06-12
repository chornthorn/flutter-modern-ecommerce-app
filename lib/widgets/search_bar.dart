import 'package:flutter/material.dart';

/// A minimal, rounded search input.
///
/// When [readOnly] is true it acts as a tap trigger (used on Home). When false
/// it behaves as a normal text field (used on Search).
class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      autofocus: autofocus,
      onChanged: onChanged,
      onTap: readOnly ? onTap : null,
      textInputAction: TextInputAction.search,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText ?? 'Search products...',
        isDense: true,
        prefixIcon: Icon(
          Icons.search,
          color: theme.colorScheme.onSurface.withAlpha(120),
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller ?? TextEditingValueNotifier.empty(),
          builder: (context, value, child) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(
                Icons.clear,
                color: theme.colorScheme.onSurface.withAlpha(160),
              ),
              onPressed: () {
                controller?.clear();
                onChanged?.call('');
                onClear?.call();
              },
            );
          },
        ),
      ),
    );
  }
}

class TextEditingValueNotifier extends ValueNotifier<TextEditingValue> {
  TextEditingValueNotifier.empty() : super(TextEditingValue.empty);
}
