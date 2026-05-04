import 'package:flutter/material.dart';

import '../core/extensions/color_theme_extension.dart';
import '../utils/date_formatting.dart';

// ─────────────────────────────────────────────
//  M TIME PICKER
//
//  A reusable time picker component that wraps
//  Flutter's showTimePicker with a styled
//  preview tile. Returns selected time as a
//  formatted string and as a TimeOfDay object.
//
//  Usage:
//    MTimePicker(
//      label: 'Start time',
//      initialTime: TimeOfDay(hour: 9, minute: 0),
//      onTimeChanged: (time, formatted) {
//        print(formatted); // '09:00 AM'
//      },
//    )
// ─────────────────────────────────────────────

/// Format options for the displayed time string.
enum MTimeFormat {
  /// 12-hour format with AM/PM — e.g. '09:30 AM'
  h12,

  /// 24-hour format — e.g. '09:30'
  h24,
}

class MTimePicker extends StatefulWidget {
  /// Initial time to display. Defaults to current time if null.
  final TimeOfDay? initialTime;

  /// Callback fired when time changes.
  /// Provides both the [TimeOfDay] object and the formatted string.
  final void Function(TimeOfDay time, String formatted)? onTimeChanged;

  /// Label shown above the time preview tile.
  final String? label;

  /// Hint text shown when no time is selected yet.
  final String? hint;

  /// Helper text shown below the tile.
  final String? helperText;

  /// Error text shown below the tile. Overrides helperText.
  final String? errorText;

  /// Time display format — 12h (AM/PM) or 24h.
  final MTimeFormat timeFormat;

  /// Prefix icon on the left side of the tile.
  final IconData prefixIcon;

  /// Whether the widget is enabled and tappable.
  final bool enabled;

  /// Whether the time is required (shows asterisk on label).
  final bool required;

  /// Custom entry mode for the time picker dialog.
  final TimePickerEntryMode initialEntryMode;

  const MTimePicker({
    super.key,
    this.initialTime,
    this.onTimeChanged,
    this.label,
    this.hint = 'Select time',
    this.helperText,
    this.errorText,
    this.timeFormat = MTimeFormat.h12,
    this.prefixIcon = Icons.access_time_outlined,
    this.enabled = true,
    this.required = false,
    this.initialEntryMode = TimePickerEntryMode.dial,
  });

  // ─────────────────────────────────────────────
  //  NAMED CONSTRUCTORS
  // ─────────────────────────────────────────────

  /// Time picker in 24-hour format.
  const MTimePicker.h24({
    super.key,
    this.initialTime,
    this.onTimeChanged,
    this.label,
    this.hint = 'Select time',
    this.helperText,
    this.errorText,
    this.prefixIcon = Icons.access_time_outlined,
    this.enabled = true,
    this.required = false,
    this.initialEntryMode = TimePickerEntryMode.dial,
  }) : timeFormat = MTimeFormat.h24;

  /// Time picker that opens in keyboard/input mode instead of dial.
  const MTimePicker.input({
    super.key,
    this.initialTime,
    this.onTimeChanged,
    this.label,
    this.hint = 'Select time',
    this.helperText,
    this.errorText,
    this.timeFormat = MTimeFormat.h12,
    this.prefixIcon = Icons.keyboard_outlined,
    this.enabled = true,
    this.required = false,
  }) : initialEntryMode = TimePickerEntryMode.input;

  @override
  State<MTimePicker> createState() => _MTimePickerState();
}

class _MTimePickerState extends State<MTimePicker> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  // ── Format TimeOfDay to readable string based on chosen format
  String _formatTime(TimeOfDay time) {
    switch (widget.timeFormat) {
      case MTimeFormat.h12:
        return DateTimeHelper.timeToH12(time);
      case MTimeFormat.h24:
        return DateTimeHelper.timeToH24(time);
    }
  }

  Future<void> _openPicker() async {
    if (!widget.enabled) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      initialEntryMode: widget.initialEntryMode,
      // Apply primary color theme to the picker dialog
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primaryContainer: context.primaryColor,
              onPrimaryContainer: context.onPrimaryColor,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              dayPeriodColor: context.primaryColor,
              dayPeriodTextColor: context.onPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
      widget.onTimeChanged?.call(picked, _formatTime(picked));
    }
  }

  // ── Border color logic — matches AppTextField style
  Color _borderColor(BuildContext context, bool hasError) {
    if (hasError) return Theme.of(context).colorScheme.error;
    if (!widget.enabled) {
      return Theme.of(context).colorScheme.outline.withValues(alpha: 0.15);
    }
    return Theme.of(context).colorScheme.outline.withValues(alpha: 0.35);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasError = widget.errorText != null;
    final hasValue = _selectedTime != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label
        if (widget.label != null) ...[
          _TimePickerLabel(
            label: widget.label!,
            required: widget.required,
            theme: theme,
          ),
          const SizedBox(height: 6),
        ],

        // ── Tappable tile
        InkWell(
          onTap: widget.enabled ? _openPicker : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: widget.enabled
                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                  : colorScheme.onSurface.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _borderColor(context, hasError),
                width: hasError ? 1.0 : 0.5,
              ),
            ),
            child: Row(
              children: [
                // Prefix icon
                Icon(
                  widget.prefixIcon,
                  size: 18,
                  color: hasValue
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 10),

                // Time text or hint
                Expanded(
                  child: Text(
                    hasValue ? _formatTime(_selectedTime!) : widget.hint!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: hasValue
                          ? FontWeight.w500
                          : FontWeight.normal,
                      color: hasValue
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.35),
                    ),
                  ),
                ),

                // Clear button — shown only when a time is selected
                if (hasValue && widget.enabled)
                  GestureDetector(
                    onTap: () {
                      setState(() => _selectedTime = null);
                      // Notify parent with cleared state
                      widget.onTimeChanged?.call(
                        const TimeOfDay(hour: 0, minute: 0),
                        '',
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.35),
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.expand_more,
                    size: 18,
                    color: colorScheme.onSurface.withValues(alpha: 0.35),
                  ),
              ],
            ),
          ),
        ),

        // ── Error or helper text
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: 5),
          _TimePickerSubText(
            text: widget.errorText ?? widget.helperText!,
            isError: hasError,
            theme: theme,
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  M TIME RANGE PICKER
//
//  Two connected time pickers for start and
//  end time. Automatically validates that
//  end time is after start time.
//
//  Usage:
//    MTimeRangePicker(
//      label: 'Event duration',
//      onRangeChanged: (start, end, startFmt, endFmt) {
//        print('$startFmt → $endFmt');
//      },
//    )
// ─────────────────────────────────────────────

class MTimeRangePicker extends StatefulWidget {
  /// Initial start time. Defaults to current hour.
  final TimeOfDay? initialStartTime;

  /// Initial end time. Defaults to one hour after start.
  final TimeOfDay? initialEndTime;

  /// Label shown above the range picker row.
  final String? label;

  /// Time display format — 12h or 24h.
  final MTimeFormat timeFormat;

  /// Whether the widget is enabled.
  final bool enabled;

  /// Whether to show a validation error when end ≤ start.
  final bool validateRange;

  /// Callback fired whenever start or end time changes.
  /// Provides both raw [TimeOfDay] and formatted strings.
  final void Function(
    TimeOfDay start,
    TimeOfDay end,
    String startFormatted,
    String endFormatted,
  )?
  onRangeChanged;

  const MTimeRangePicker({
    super.key,
    this.initialStartTime,
    this.initialEndTime,
    this.label,
    this.timeFormat = MTimeFormat.h12,
    this.enabled = true,
    this.validateRange = true,
    this.onRangeChanged,
  });

  @override
  State<MTimeRangePicker> createState() => _MTimeRangePickerState();
}

class _MTimeRangePickerState extends State<MTimeRangePicker> {
  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;
  String? _rangeError;

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialStartTime;
    _endTime = widget.initialEndTime;
  }

  // ── Convert TimeOfDay to total minutes for comparison
  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  // ── Validate that end time is after start time
  void _validate() {
    if (!widget.validateRange) {
      setState(() => _rangeError = null);
      return;
    }
    if (_startTime != null && _endTime != null) {
      if (_toMinutes(_endTime!) <= _toMinutes(_startTime!)) {
        setState(() => _rangeError = 'End time must be after start time');
        return;
      }
    }
    setState(() => _rangeError = null);
  }

  String _formatTime(TimeOfDay time) {
    switch (widget.timeFormat) {
      case MTimeFormat.h12:
        final period = time.hour >= 12 ? 'PM' : 'AM';
        final hour = time.hour == 0
            ? 12
            : time.hour > 12
            ? time.hour - 12
            : time.hour;
        final minute = time.minute.toString().padLeft(2, '0');
        return '$hour:$minute $period';
      case MTimeFormat.h24:
        final hour = time.hour.toString().padLeft(2, '0');
        final minute = time.minute.toString().padLeft(2, '0');
        return '$hour:$minute';
    }
  }

  void _onStartChanged(TimeOfDay time, String formatted) {
    setState(() => _startTime = time);
    _validate();
    if (_startTime != null && _endTime != null && _rangeError == null) {
      widget.onRangeChanged?.call(
        _startTime!,
        _endTime!,
        formatted,
        _formatTime(_endTime!),
      );
    }
  }

  void _onEndChanged(TimeOfDay time, String formatted) {
    setState(() => _endTime = time);
    _validate();
    if (_startTime != null && _endTime != null && _rangeError == null) {
      widget.onRangeChanged?.call(
        _startTime!,
        _endTime!,
        _formatTime(_startTime!),
        formatted,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label
        if (widget.label != null) ...[
          _TimePickerLabel(label: widget.label!, theme: theme),
          const SizedBox(height: 6),
        ],

        // ── Start + End pickers in a row
        Row(
          children: [
            // Start time
            Expanded(
              child: MTimePicker(
                hint: 'Start',
                initialTime: _startTime,
                timeFormat: widget.timeFormat,
                enabled: widget.enabled,
                prefixIcon: Icons.play_circle_outline,
                onTimeChanged: _onStartChanged,
              ),
            ),

            // Arrow separator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.arrow_forward,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ),

            // End time
            Expanded(
              child: MTimePicker(
                hint: 'End',
                initialTime: _endTime,
                timeFormat: widget.timeFormat,
                enabled: widget.enabled,
                prefixIcon: Icons.stop_circle_outlined,
                errorText: _rangeError != null ? '' : null,
                onTimeChanged: _onEndChanged,
              ),
            ),
          ],
        ),

        // ── Range validation error
        if (_rangeError != null) ...[
          const SizedBox(height: 5),
          _TimePickerSubText(text: _rangeError!, isError: true, theme: theme),
        ],

        // ── Duration badge — shown when both times are valid
        if (_startTime != null && _endTime != null && _rangeError == null) ...[
          const SizedBox(height: 6),
          _DurationBadge(
            startTime: _startTime!,
            endTime: _endTime!,
            theme: theme,
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  SHARED SUB-WIDGETS
// ─────────────────────────────────────────────

/// Label row with optional required asterisk
class _TimePickerLabel extends StatelessWidget {
  final String label;
  final bool required;
  final ThemeData theme;

  const _TimePickerLabel({
    required this.label,
    required this.theme,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        if (required) ...[
          const SizedBox(width: 3),
          Text(
            '*',
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Helper / error text below the picker
class _TimePickerSubText extends StatelessWidget {
  final String text;
  final bool isError;
  final ThemeData theme;

  const _TimePickerSubText({
    required this.text,
    required this.isError,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 11,
          color: isError
              ? theme.colorScheme.error
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

/// Duration badge shown between the two time pickers
/// when a valid range is selected — e.g. '1h 30m'
class _DurationBadge extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final ThemeData theme;

  const _DurationBadge({
    required this.startTime,
    required this.endTime,
    required this.theme,
  });

  String get _duration {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final diff = endMinutes - startMinutes;
    final hours = diff ~/ 60;
    final minutes = diff % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timelapse_outlined,
                size: 12,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                _duration,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
