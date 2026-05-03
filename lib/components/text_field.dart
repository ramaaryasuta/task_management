import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  APP TEXT FIELD — Reusable & Customizable
//
//  Cara pakai:
//
//  MTextField(
//    label: 'Email',
//    hint: 'contoh@email.com',
//    prefixIcon: Icons.email_outlined,
//    keyboardType: TextInputType.emailAddress,
//    validator: (v) => v!.isEmpty ? 'Email wajib diisi' : null,
//  )
// ─────────────────────────────────────────────

enum MTextFieldSize { small, medium, large }

class MTextField extends StatefulWidget {
  // ── Content
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText; // override validator error dari luar
  final String? initialValue;

  // ── Controller & Focus
  final TextEditingController? controller;
  final FocusNode? focusNode;

  // ── Input config
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool autocorrect;
  final bool readOnly;
  final bool enabled;
  final int? maxLength;
  final int maxLines;
  final int? minLines;

  // ── Icons & actions
  final IconData? prefixIcon;
  final Widget? prefixWidget; // custom prefix (avatar, flag, dll)
  final IconData? suffixIcon;
  final Widget? suffixWidget; // custom suffix (button, badge, dll)
  final VoidCallback? onSuffixTap;
  final VoidCallback? onPrefixTap;

  // ── Callbacks
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  // ── Style
  final MTextFieldSize size;
  final bool filled;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextCapitalization textCapitalization;

  const MTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.obscureText = false,
    this.autocorrect = true,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.onSuffixTap,
    this.onPrefixTap,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.size = MTextFieldSize.medium,
    this.filled = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textStyle,
    this.labelStyle,
    this.textCapitalization = TextCapitalization.none,
  });

  // ─────────────────────────────────────────────
  //  NAMED CONSTRUCTORS — shortcut untuk use case umum
  // ─────────────────────────────────────────────

  /// TextField untuk password dengan toggle show/hide
  const MTextField.password({
    super.key,
    this.label = 'Password',
    this.hint = '••••••••',
    this.helperText,
    this.errorText,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.size = MTextFieldSize.medium,
    this.filled = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textStyle,
    this.labelStyle,
  }) : obscureText = true,
       autocorrect = false,
       maxLines = 1,
       minLines = null,
       prefixIcon = Icons.lock_outline,
       prefixWidget = null,
       suffixIcon = null, // dihandle internal (toggle icon)
       suffixWidget = null,
       onSuffixTap = null,
       onPrefixTap = null,
       keyboardType = TextInputType.visiblePassword,
       textCapitalization = TextCapitalization.none;

  /// TextField untuk search
  const MTextField.search({
    super.key,
    this.hint = 'Cari...',
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.size = MTextFieldSize.medium,
    this.filled = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textStyle,
  }) : label = null,
       helperText = null,
       errorText = null,
       initialValue = null,
       textInputAction = TextInputAction.search,
       inputFormatters = null,
       obscureText = false,
       autocorrect = false,
       maxLength = null,
       maxLines = 1,
       minLines = null,
       prefixIcon = Icons.search,
       prefixWidget = null,
       suffixIcon = Icons.close,
       suffixWidget = null,
       onSuffixTap = null,
       onPrefixTap = null,
       validator = null,
       labelStyle = null,
       keyboardType = TextInputType.text,
       textCapitalization = TextCapitalization.none;

  /// TextField untuk multiline / textarea
  const MTextField.multiline({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 5,
    this.minLines = 3,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.size = MTextFieldSize.medium,
    this.filled = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textStyle,
    this.labelStyle,
    this.textCapitalization = TextCapitalization.sentences,
  }) : obscureText = false,
       autocorrect = true,
       prefixIcon = null,
       prefixWidget = null,
       suffixIcon = null,
       suffixWidget = null,
       onSuffixTap = null,
       onPrefixTap = null,
       keyboardType = TextInputType.multiline,
       textInputAction = TextInputAction.newline;

  @override
  State<MTextField> createState() => _MTextFieldState();
}

class _MTextFieldState extends State<MTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  // ── Size config
  double get _contentPaddingV {
    switch (widget.size) {
      case MTextFieldSize.small:
        return 10;
      case MTextFieldSize.medium:
        return 14;
      case MTextFieldSize.large:
        return 18;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case MTextFieldSize.small:
        return 13;
      case MTextFieldSize.medium:
        return 14;
      case MTextFieldSize.large:
        return 15;
    }
  }

  // ── Colors from theme
  Color _borderColor(BuildContext context) {
    if (!widget.enabled) {
      return Theme.of(context).disabledColor.withValues(alpha: 0.2);
    }
    if (_isFocused) {
      return widget.focusedBorderColor ?? Theme.of(context).colorScheme.primary;
    }
    return widget.borderColor ??
        Theme.of(context).colorScheme.outline.withValues(alpha: 0.4);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label di atas field (bukan floating)
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style:
                widget.labelStyle ??
                theme.textTheme.labelMedium?.copyWith(
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
          ),
          const SizedBox(height: 6),
        ],

        // ── Text Field
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          initialValue: widget.controller == null ? widget.initialValue : null,
          keyboardType: widget.maxLines > 1
              ? TextInputType.multiline
              : widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          obscureText: _obscureText,
          autocorrect: widget.autocorrect,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          textCapitalization: widget.textCapitalization,
          style:
              widget.textStyle ??
              theme.textTheme.bodyMedium?.copyWith(fontSize: _fontSize),
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.35),
              fontSize: _fontSize,
            ),

            // ── Error override dari luar
            errorText: widget.errorText,

            // ── Helper text
            helperText: widget.helperText,
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),

            // ── Counter (kalau ada maxLength)
            counterStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 11,
            ),

            // ── Fill
            filled: widget.filled,
            fillColor: widget.enabled
                ? (widget.fillColor ??
                      colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.4,
                      ))
                : colorScheme.onSurface.withValues(alpha: 0.04),

            // ── Padding
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: _contentPaddingV,
            ),

            // ── Borders
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _borderColor(context), width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color:
                    widget.borderColor ??
                    colorScheme.outline.withValues(alpha: 0.35),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ?? colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.error, width: 0.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),

            // ── Prefix
            prefixIcon: widget.prefixWidget != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: widget.prefixWidget,
                  )
                : widget.prefixIcon != null
                ? GestureDetector(
                    onTap: widget.onPrefixTap,
                    child: Icon(
                      widget.prefixIcon,
                      size: 18,
                      color: _isFocused
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 42,
              minHeight: 42,
            ),

            // ── Suffix
            suffixIcon: _buildSuffix(context),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 42,
              minHeight: 42,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Password toggle — prioritas pertama
    if (widget.obscureText) {
      return GestureDetector(
        onTap: () => setState(() => _obscureText = !_obscureText),
        child: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 18,
          color: colorScheme.onSurface.withValues(alpha: 0.45),
        ),
      );
    }

    // Custom suffix widget
    if (widget.suffixWidget != null) return widget.suffixWidget;

    // Suffix icon biasa
    if (widget.suffixIcon != null) {
      return GestureDetector(
        onTap: widget.onSuffixTap,
        child: Icon(
          widget.suffixIcon,
          size: 18,
          color: colorScheme.onSurface.withValues(alpha: 0.45),
        ),
      );
    }

    return null;
  }
}
