import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  M COLOR PICKER
//
//  A reusable color picker component built on
//  top of flex_color_picker package.
//  Returns selected color as a hex string (e.g. '#FF5733').
//
//  Dependencies:
//    flex_color_picker: ^3.x.x
//
//  Usage:
//    MColorPicker(
//      initialColor: '#534AB7',
//      onColorChanged: (hexColor) {
//        print(hexColor); // '#FF5733'
//      },
//    )
// ─────────────────────────────────────────────

class MColorPicker extends StatefulWidget {
  /// Initial selected color as a hex string.
  /// Accepts formats: '#RRGGBB', 'RRGGBB', '#AARRGGBB'.
  /// Defaults to primary color if null or invalid.
  final String? initialColor;

  /// Callback fired whenever the selected color changes.
  /// Returns a 7-character hex string e.g. '#534AB7'.
  final ValueChanged<String> onColorChanged;

  /// Label shown above the color preview tile.
  final String? label;

  /// Whether to show the hex input field.
  final bool showHexInput;

  /// Whether to show the opacity/alpha slider.
  final bool showOpacitySlider;

  /// Whether to show the recent colors row.
  final bool showRecentColors;

  /// Max number of recent colors to remember.
  final int maxRecentColors;

  /// Custom set of picker types to display.
  /// Defaults to Wheel + Material.
  final Set<ColorPickerType>? pickerTypes;

  const MColorPicker({
    super.key,
    this.initialColor,
    required this.onColorChanged,
    this.label,
    this.showHexInput = true,
    this.showOpacitySlider = false,
    this.showRecentColors = true,
    this.maxRecentColors = 9,
    this.pickerTypes,
  });

  @override
  State<MColorPicker> createState() => _MColorPickerState();
}

class _MColorPickerState extends State<MColorPicker> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = _parseColor(widget.initialColor);
  }

  // ── Parse hex string → Color
  // Handles: '#RRGGBB', 'RRGGBB', '#AARRGGBB', 'AARRGGBB'
  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF534AB7);
    try {
      final cleaned = hex.replaceAll('#', '').trim();
      if (cleaned.length == 6) {
        return Color(int.parse('FF$cleaned', radix: 16));
      }
      if (cleaned.length == 8) {
        return Color(int.parse(cleaned, radix: 16));
      }
      return const Color(0xFF534AB7);
    } catch (_) {
      return const Color(0xFF534AB7);
    }
  }

  // ── Convert Color → '#RRGGBB' hex string
  String _toHexString(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  void _onColorChanged(Color color) {
    setState(() => _selectedColor = color);
    widget.onColorChanged(_toHexString(color));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Optional label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
        ],

        // ── Color preview tile — tap to open picker dialog
        _ColorPreviewTile(
          color: _selectedColor,
          hexString: _toHexString(_selectedColor),
          onTap: () => _showPickerDialog(context),
        ),
      ],
    );
  }

  // ── Show the full picker inside a dialog
  Future<void> _showPickerDialog(BuildContext context) async {
    // Snapshot current color so we can revert on cancel
    final colorBeforeEdit = _selectedColor;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _ColorPickerDialog(
        initialColor: _selectedColor,
        showHexInput: widget.showHexInput,
        showOpacitySlider: widget.showOpacitySlider,
        showRecentColors: widget.showRecentColors,
        maxRecentColors: widget.maxRecentColors,
        pickerTypes: widget.pickerTypes,
        onColorChanged: _onColorChanged,
        onCancel: () {
          // Revert to color before dialog opened
          _onColorChanged(colorBeforeEdit);
          Navigator.pop(ctx);
        },
        onConfirm: () => Navigator.pop(ctx),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  COLOR PREVIEW TILE
//  Tappable row showing the current color swatch
//  and its hex code string.
// ─────────────────────────────────────────────

class _ColorPreviewTile extends StatelessWidget {
  final Color color;
  final String hexString;
  final VoidCallback onTap;

  const _ColorPreviewTile({
    required this.color,
    required this.hexString,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.4,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.35),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color swatch circle
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Hex code text
            Text(
              hexString,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),

            // Edit icon
            Icon(
              Icons.colorize_outlined,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  COLOR PICKER DIALOG
//  Contains the actual flex_color_picker widget
//  with confirm / cancel actions.
// ─────────────────────────────────────────────

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final bool showHexInput;
  final bool showOpacitySlider;
  final bool showRecentColors;
  final int maxRecentColors;
  final Set<ColorPickerType>? pickerTypes;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _ColorPickerDialog({
    required this.initialColor,
    required this.showHexInput,
    required this.showOpacitySlider,
    required this.showRecentColors,
    required this.maxRecentColors,
    required this.pickerTypes,
    required this.onColorChanged,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Dialog header
            Row(
              children: [
                Text(
                  'Pick a color',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Live preview dot in header
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _currentColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── flex_color_picker
            ColorPicker(
              color: _currentColor,
              onColorChanged: (color) {
                setState(() => _currentColor = color);
                widget.onColorChanged(color);
              },

              // Picker types to display
              pickersEnabled: widget.pickerTypes != null
                  ? {
                      for (final t in ColorPickerType.values)
                        t: widget.pickerTypes!.contains(t),
                    }
                  : {
                      ColorPickerType.wheel: true,
                      ColorPickerType.primary: true,
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.custom: false,
                      ColorPickerType.customSecondary: false,
                    },

              // Picker labels
              pickerTypeLabels: const {
                ColorPickerType.wheel: 'Wheel',
                ColorPickerType.primary: 'Material',
              },

              // Show/hide sections
              enableShadesSelection: true,
              showColorCode: widget.showHexInput,
              colorCodeHasColor: true,
              showRecentColors: widget.showRecentColors,
              maxRecentColors: widget.maxRecentColors,
              enableOpacity: widget.showOpacitySlider,

              // Swatch size & spacing
              width: 36,
              height: 36,
              borderRadius: 8,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 220,
              wheelWidth: 22,

              // Color code field style
              colorCodeTextStyle: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),

              // Picker type selector style
              pickerTypeTextStyle: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),

              // Action buttons — handled externally
              actionButtons: const ColorPickerActionButtons(
                okButton: false,
                closeButton: false,
                dialogActionButtons: false,
              ),
            ),

            const Divider(height: 24),

            // ── Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentColor,
                      foregroundColor: _contrastColor(_currentColor),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Select',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Returns black or white depending on color brightness
  // so the confirm button label is always readable.
  Color _contrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.4 ? Colors.black87 : Colors.white;
  }
}

// ─────────────────────────────────────────────
//  M COLOR PICKER FIELD
//
//  Inline version — no dialog, picker renders
//  directly inside the layout. Useful inside
//  a bottom sheet or dedicated settings page.
//
//  Usage:
//    MColorPickerField(
//      label: 'Event color',
//      initialColor: '#1D9E75',
//      onColorChanged: (hex) => setState(() => _color = hex),
//    )
// ─────────────────────────────────────────────

class MColorPickerField extends StatefulWidget {
  /// Initial selected color as a hex string.
  final String? initialColor;

  /// Callback fired whenever the selected color changes.
  /// Returns a 7-character hex string e.g. '#1D9E75'.
  final ValueChanged<String> onColorChanged;

  /// Label shown above the picker.
  final String? label;

  /// Whether to show the hex input field.
  final bool showHexInput;

  /// Whether to show the opacity/alpha slider.
  final bool showOpacitySlider;

  /// Whether to show the recent colors row.
  final bool showRecentColors;

  const MColorPickerField({
    super.key,
    this.initialColor,
    required this.onColorChanged,
    this.label,
    this.showHexInput = true,
    this.showOpacitySlider = false,
    this.showRecentColors = true,
  });

  @override
  State<MColorPickerField> createState() => _MColorPickerFieldState();
}

class _MColorPickerFieldState extends State<MColorPickerField> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = _parseColor(widget.initialColor);
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF534AB7);
    try {
      final cleaned = hex.replaceAll('#', '').trim();
      if (cleaned.length == 6) return Color(int.parse('FF$cleaned', radix: 16));
      if (cleaned.length == 8) return Color(int.parse(cleaned, radix: 16));
      return const Color(0xFF534AB7);
    } catch (_) {
      return const Color(0xFF534AB7);
    }
  }

  String _toHexString(Color color) =>
      '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Optional label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 10),
        ],

        // ── Inline color picker
        ColorPicker(
          color: _selectedColor,
          onColorChanged: (color) {
            setState(() => _selectedColor = color);
            widget.onColorChanged(_toHexString(color));
          },
          pickersEnabled: const {
            ColorPickerType.wheel: true,
            ColorPickerType.primary: true,
            ColorPickerType.accent: false,
            ColorPickerType.bw: false,
            ColorPickerType.custom: false,
            ColorPickerType.customSecondary: false,
          },
          pickerTypeLabels: const {
            ColorPickerType.wheel: 'Wheel',
            ColorPickerType.primary: 'Material',
          },
          enableShadesSelection: true,
          showColorCode: widget.showHexInput,
          colorCodeHasColor: true,
          showRecentColors: widget.showRecentColors,
          enableOpacity: widget.showOpacitySlider,
          width: 34,
          height: 34,
          borderRadius: 8,
          spacing: 5,
          runSpacing: 5,
          wheelDiameter: 200,
          wheelWidth: 20,
          colorCodeTextStyle: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w500,
          ),
          actionButtons: const ColorPickerActionButtons(
            okButton: false,
            closeButton: false,
            dialogActionButtons: false,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  HELPER — standalone functions
// ─────────────────────────────────────────────

/// Converts a hex string to a Flutter [Color].
/// Accepts '#RRGGBB', 'RRGGBB', '#AARRGGBB'.
/// Returns [fallback] if parsing fails.
Color hexToColor(String hex, {Color fallback = const Color(0xFF534AB7)}) {
  try {
    final cleaned = hex.replaceAll('#', '').trim();
    if (cleaned.length == 6) return Color(int.parse('FF$cleaned', radix: 16));
    if (cleaned.length == 8) return Color(int.parse(cleaned, radix: 16));
    return fallback;
  } catch (_) {
    return fallback;
  }
}

/// Converts a Flutter [Color] to a '#RRGGBB' hex string.
/// Alpha channel is ignored.
String colorToHex(Color color) =>
    '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
