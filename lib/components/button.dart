import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  BUTTON SIZE ENUM
//  Controls padding and font size across
//  all button variants.
// ─────────────────────────────────────────────

enum MButtonSize { small, medium, large }

// ─────────────────────────────────────────────
//  SHARED BUTTON CONFIG
//  Internal helper to compute size-based
//  padding and font size consistently.
// ─────────────────────────────────────────────

class _MButtonConfig {
  static EdgeInsets padding(MButtonSize size) {
    switch (size) {
      case MButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 8);
      case MButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case MButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 16);
    }
  }

  static double fontSize(MButtonSize size) {
    switch (size) {
      case MButtonSize.small:
        return 12;
      case MButtonSize.medium:
        return 14;
      case MButtonSize.large:
        return 15;
    }
  }

  static double iconSize(MButtonSize size) {
    switch (size) {
      case MButtonSize.small:
        return 14;
      case MButtonSize.medium:
        return 16;
      case MButtonSize.large:
        return 18;
    }
  }

  static double borderRadius(MButtonSize size) {
    switch (size) {
      case MButtonSize.small:
        return 8;
      case MButtonSize.medium:
        return 10;
      case MButtonSize.large:
        return 12;
    }
  }
}

// ─────────────────────────────────────────────
//  LOADING INDICATOR
//  Shared spinner shown when isLoading = true.
//  Color adapts to button variant.
// ─────────────────────────────────────────────

class _MButtonLoadingIndicator extends StatelessWidget {
  final Color color;
  final MButtonSize size;

  const _MButtonLoadingIndicator({required this.color, required this.size});

  double get _indicatorSize {
    switch (size) {
      case MButtonSize.small:
        return 12;
      case MButtonSize.medium:
        return 14;
      case MButtonSize.large:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _indicatorSize,
      height: _indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BUTTON CONTENT BUILDER
//  Builds label + optional leading/trailing
//  icons, or a loading indicator.
// ─────────────────────────────────────────────

class _MButtonContent extends StatelessWidget {
  final String label;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color contentColor;
  final MButtonSize size;

  const _MButtonContent({
    required this.label,
    required this.isLoading,
    required this.contentColor,
    required this.size,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _MButtonLoadingIndicator(color: contentColor, size: size);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Leading icon
        if (leadingIcon != null) ...[
          Icon(
            leadingIcon,
            size: _MButtonConfig.iconSize(size),
            color: contentColor,
          ),
          const SizedBox(width: 6),
        ],

        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: _MButtonConfig.fontSize(size),
            fontWeight: FontWeight.w500,
            color: contentColor,
          ),
        ),

        // Trailing icon
        if (trailingIcon != null) ...[
          const SizedBox(width: 6),
          Icon(
            trailingIcon,
            size: _MButtonConfig.iconSize(size),
            color: contentColor,
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  M ELEVATED BUTTON
//
//  Filled button with background color.
//  Use for primary actions.
//
//  Usage:
//    MElevatedButton(
//      label: 'Save',
//      onPressed: () {},
//    )
//
//    MElevatedButton(
//      label: 'Delete',
//      onPressed: () {},
//      backgroundColor: Colors.red,
//      size: MButtonSize.small,
//    )
//
//    MElevatedButton(
//      label: 'Uploading...',
//      onPressed: null,
//      isLoading: true,
//    )
// ─────────────────────────────────────────────

class MElevatedButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Callback when button is tapped.
  /// Set to null to disable the button.
  final VoidCallback? onPressed;

  /// Optional icon before the label.
  final IconData? leadingIcon;

  /// Optional icon after the label.
  final IconData? trailingIcon;

  /// Shows a loading spinner and disables tap when true.
  final bool isLoading;

  /// Expands button to fill available width when true.
  final bool fullWidth;

  /// Button size — affects padding and font size.
  final MButtonSize size;

  /// Custom background color. Defaults to colorScheme.primary.
  final Color? backgroundColor;

  /// Custom foreground (text + icon) color. Defaults to colorScheme.onPrimary.
  final Color? foregroundColor;

  /// Custom border radius. Falls back to size-based default.
  final double? borderRadius;

  /// Elevation of the button surface.
  final double elevation;

  const MElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
    this.size = MButtonSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.elevation = 0,
  });

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = backgroundColor ?? colorScheme.primary;
    final fgColor = foregroundColor ?? colorScheme.onPrimary;
    final radius = borderRadius ?? _MButtonConfig.borderRadius(size);

    final button = ElevatedButton(
      onPressed: _isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        disabledBackgroundColor: bgColor.withValues(alpha: 0.5),
        disabledForegroundColor: fgColor.withValues(alpha: 0.6),
        elevation: elevation,
        shadowColor: Colors.transparent,
        padding: _MButtonConfig.padding(size),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: _MButtonContent(
        label: label,
        isLoading: isLoading,
        contentColor: _isDisabled ? fgColor.withValues(alpha: 0.6) : fgColor,
        size: size,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

// ─────────────────────────────────────────────
//  M OUTLINED BUTTON
//
//  Transparent button with a visible border.
//  Use for secondary actions alongside
//  a primary elevated button.
//
//  Usage:
//    MOutlinedButton(
//      label: 'Cancel',
//      onPressed: () => Navigator.pop(context),
//    )
//
//    MOutlinedButton(
//      label: 'Export',
//      onPressed: () {},
//      leadingIcon: Icons.download_outlined,
//      borderColor: Colors.green,
//    )
// ─────────────────────────────────────────────

class MOutlinedButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Callback when button is tapped.
  /// Set to null to disable the button.
  final VoidCallback? onPressed;

  /// Optional icon before the label.
  final IconData? leadingIcon;

  /// Optional icon after the label.
  final IconData? trailingIcon;

  /// Shows a loading spinner and disables tap when true.
  final bool isLoading;

  /// Expands button to fill available width when true.
  final bool fullWidth;

  /// Button size — affects padding and font size.
  final MButtonSize size;

  /// Custom border and text color. Defaults to colorScheme.primary.
  final Color? color;

  /// Custom border color. Overrides [color] for the border only.
  final Color? borderColor;

  /// Custom border radius. Falls back to size-based default.
  final double? borderRadius;

  /// Border stroke width.
  final double borderWidth;

  const MOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
    this.size = MButtonSize.medium,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.borderWidth = 1.0,
  });

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final contentColor = color ?? colorScheme.primary;
    final strokeColor = borderColor ?? contentColor;
    final radius = borderRadius ?? _MButtonConfig.borderRadius(size);

    final button = OutlinedButton(
      onPressed: _isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: contentColor,
        disabledForegroundColor: contentColor.withValues(alpha: 0.4),
        padding: _MButtonConfig.padding(size),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        side: BorderSide(
          color: _isDisabled ? strokeColor.withValues(alpha: 0.3) : strokeColor,
          width: borderWidth,
        ),
      ),
      child: _MButtonContent(
        label: label,
        isLoading: isLoading,
        contentColor: _isDisabled
            ? contentColor.withValues(alpha: 0.4)
            : contentColor,
        size: size,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

// ─────────────────────────────────────────────
//  M TEXT BUTTON
//
//  No background, no border. Just text + icon.
//  Use for tertiary / low-emphasis actions,
//  inline links, or destructive actions.
//
//  Usage:
//    MTextButton(
//      label: 'Forgot password?',
//      onPressed: () {},
//    )
//
//    MTextButton(
//      label: 'Delete account',
//      onPressed: () {},
//      color: Colors.red,
//      leadingIcon: Icons.delete_outline,
//    )
// ─────────────────────────────────────────────

class MTextButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Callback when button is tapped.
  /// Set to null to disable the button.
  final VoidCallback? onPressed;

  /// Optional icon before the label.
  final IconData? leadingIcon;

  /// Optional icon after the label.
  final IconData? trailingIcon;

  /// Shows a loading spinner and disables tap when true.
  final bool isLoading;

  /// Button size — affects font size and icon size.
  final MButtonSize size;

  /// Custom text and icon color. Defaults to colorScheme.primary.
  final Color? color;

  /// Whether to show the ripple splash effect on tap.
  final bool showSplash;

  /// Removes internal padding entirely when true.
  /// Useful when placing the button flush inside a layout.
  final bool noPadding;

  const MTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.size = MButtonSize.medium,
    this.color,
    this.showSplash = true,
    this.noPadding = false,
  });

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contentColor = color ?? colorScheme.primary;

    return TextButton(
      onPressed: _isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: contentColor,
        disabledForegroundColor: contentColor.withValues(alpha: 0.4),
        padding: noPadding ? EdgeInsets.zero : _MButtonConfig.padding(size),
        minimumSize: noPadding ? Size.zero : null,
        tapTargetSize: noPadding
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
        overlayColor: showSplash
            ? contentColor.withValues(alpha: 0.08)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            _MButtonConfig.borderRadius(size),
          ),
        ),
      ),
      child: _MButtonContent(
        label: label,
        isLoading: isLoading,
        contentColor: _isDisabled
            ? contentColor.withValues(alpha: 0.4)
            : contentColor,
        size: size,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  M BUTTON ROW
//
//  Convenience widget for placing Cancel +
//  Confirm buttons side by side inside a
//  dialog or bottom sheet.
//
//  Usage:
//    MButtonRow(
//      cancelLabel: 'Cancel',
//      confirmLabel: 'Save',
//      onCancel: () => Navigator.pop(context),
//      onConfirm: () => _save(),
//      isLoading: state.isLoading,
//    )
// ─────────────────────────────────────────────

class MButtonRow extends StatelessWidget {
  /// Label for the left/cancel button.
  final String cancelLabel;

  /// Label for the right/confirm button.
  final String confirmLabel;

  /// Callback for the cancel button.
  final VoidCallback? onCancel;

  /// Callback for the confirm button.
  final VoidCallback? onConfirm;

  /// Shows loading state on the confirm button when true.
  final bool isLoading;

  /// Custom color for the confirm button. Defaults to primary.
  final Color? confirmColor;

  /// Spacing between the two buttons.
  final double gap;

  const MButtonRow({
    super.key,
    this.cancelLabel = 'Cancel',
    this.confirmLabel = 'Save',
    this.onCancel,
    this.onConfirm,
    this.isLoading = false,
    this.confirmColor,
    this.gap = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MOutlinedButton(
            label: cancelLabel,
            onPressed: onCancel,
            fullWidth: true,
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          child: MElevatedButton(
            label: confirmLabel,
            onPressed: onConfirm,
            isLoading: isLoading,
            fullWidth: true,
            backgroundColor: confirmColor,
          ),
        ),
      ],
    );
  }
}
