import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../enums/field_type.dart';
import '../theme/field_pro_theme.dart';
import '../validators/form_validators.dart';
import '../utils/color_utils.dart';
import 'shake_animation_wrapper.dart';

class AppTextField extends StatefulWidget {
  final FieldType fieldType;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isRequired;
  final String? requiredMessage;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final Duration debounceDuration;

  const AppTextField({
    super.key,
    this.fieldType = FieldType.name,
    this.labelText,
    this.hintText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.validator,
    this.isRequired = false,
    this.requiredMessage,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines,
    this.inputFormatters,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = false;
  Timer? _debounceTimer;
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;
  bool _shakeError = false;

  @override
  void initState() {
    super.initState();
    if (widget.fieldType == FieldType.password) {
      _obscureText = true;
    }
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    if (_hasError) {
      // Clear error as user types, to provide real-time feedback
      setState(() {
        _hasError = false;
        _errorText = null;
      });
    }

    if (widget.onChanged == null) return;

    if (widget.fieldType == FieldType.search) {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(widget.debounceDuration, () {
        widget.onChanged!(value);
      });
    } else {
      widget.onChanged!(value);
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.number:
        return TextInputType.number;
      case FieldType.url:
        return TextInputType.url;
      case FieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  int? _getMaxLines() {
    if (widget.fieldType == FieldType.password) return 1;
    if (widget.fieldType == FieldType.multiline) return widget.maxLines ?? 3;
    return 1;
  }

  String? Function(String?) _getAutoValidator() {
    final List<String? Function(String?)> validators = [];

    if (widget.isRequired) {
      validators.add(
        (v) => FormValidators.required(v, message: widget.requiredMessage),
      );
    }

    switch (widget.fieldType) {
      case FieldType.email:
        validators.add(FormValidators.email);
        break;
      case FieldType.password:
        validators.add(FormValidators.passwordStrength);
        break;
      case FieldType.phone:
        validators.add(FormValidators.phone);
        break;
      case FieldType.url:
        validators.add(FormValidators.url);
        break;
      default:
        break;
    }

    return FormValidators.combine(validators);
  }

  void _triggerErrorShake(String error) {
    setState(() {
      _hasError = true;
      _errorText = error;
      _shakeError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<FieldProTheme>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme Extracted values
    final baseColor =
        theme?.shadowBaseColor ??
        (isDark ? Colors.grey.shade900 : Colors.grey.shade200);
    final focusColor = theme?.focusColor ?? Theme.of(context).primaryColor;
    final errorColor = theme?.errorColor ?? Theme.of(context).colorScheme.error;
    final borderRadius = BorderRadius.circular(theme?.borderRadius ?? 12.0);
    final contentPadding =
        theme?.contentPadding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16);

    final labelFocusColor = theme?.labelFocusColor ?? focusColor;
    final labelErrorColor = theme?.labelErrorColor ?? errorColor;
    final fillColor = theme?.fillColor ?? baseColor;

    // Determine current border/shadow state
    Color borderColor = Colors.transparent;
    List<BoxShadow> boxshadows = [];

    if (_hasError) {
      borderColor = errorColor;
    } else if (_isFocused) {
      borderColor = focusColor;
      boxshadows = [
        BoxShadow(
          color: focusColor.withAlpha(76),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ];
    } else {
      // 3D Neumorphic Shadows
      final elevation = theme?.shadowElevation ?? 3.0;
      boxshadows = [
        BoxShadow(
          color: ColorUtils.darken(baseColor, isDark ? 0.05 : 0.1),
          offset: Offset(elevation, elevation),
          blurRadius: elevation * 2,
        ),
        BoxShadow(
          color: ColorUtils.lighten(baseColor, isDark ? 0.05 : 0.6),
          offset: Offset(-elevation, -elevation),
          blurRadius: elevation * 2,
        ),
      ];
    }

    // Determine Label Color
    Color currentLabelColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    if (_hasError) {
      currentLabelColor = labelErrorColor;
    } else if (_isFocused) {
      currentLabelColor = labelFocusColor;
    }

    Widget? actualSuffix = widget.suffixIcon;
    if (widget.fieldType == FieldType.password) {
      actualSuffix = IconButton(
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            key: ValueKey(_obscureText),
            color: Colors.grey,
          ),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.fieldType == FieldType.search && actualSuffix == null) {
      actualSuffix = const Icon(Icons.search, color: Colors.grey);
    }

    final validator = widget.validator ?? _getAutoValidator();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label Section
        if (widget.labelText != null) ...[
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style:
                (theme?.labelStyle ??
                        const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ))
                    .copyWith(color: currentLabelColor),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.labelText!),
                if (widget.isRequired)
                  Text(
                    ' *',
                    style:
                        theme?.requiredLabelStyle ??
                        TextStyle(color: errorColor, fontSize: 14),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Input Field Section
        ShakeWidget(
          shake: _shakeError,
          onAnimationComplete: () {
            if (mounted) {
              setState(() {
                _shakeError = false;
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: borderRadius,
              border: Border.all(
                color: borderColor,
                width: _isFocused
                    ? (theme?.focusedBorderWidth ?? 1.5)
                    : (theme?.borderWidth ?? 1.0),
              ),
              boxShadow: boxshadows,
            ),
            child: FormField<String>(
              validator: (val) {
                final result = validator(val);
                if (result != null && result != _errorText) {
                  // Ensure this is run after build phase
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _triggerErrorShake(result);
                  });
                } else if (result == null && _hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _hasError = false;
                      _errorText = null;
                    });
                  });
                }
                return result;
              },
              builder: (state) {
                return Row(
                  crossAxisAlignment:
                      widget.maxLines != null && widget.maxLines! > 1
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    if (widget.prefixIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: widget.prefixIcon,
                      ),
                    Expanded(
                      child: TextFormField(
                        focusNode: _focusNode,
                        controller: widget.controller,
                        obscureText: _obscureText,
                        keyboardType: _getKeyboardType(),
                        maxLines: _getMaxLines(),
                        enabled: widget.enabled,
                        onChanged: (val) {
                          state.didChange(val);
                          _handleChanged(val);
                        },
                        inputFormatters: widget.inputFormatters,
                        style: theme?.textStyle,
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle:
                              theme?.hintStyle ??
                              const TextStyle(color: Colors.grey),
                          contentPadding: contentPadding,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    if (actualSuffix != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: actualSuffix,
                      ),
                  ],
                );
              },
            ),
          ),
        ),

        // Helper / Error Section
        if (_hasError || widget.helperText != null) ...[
          const SizedBox(height: 6),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _hasError ? _errorText! : widget.helperText!,
              style: _hasError
                  ? (theme?.errorStyle ??
                        TextStyle(color: errorColor, fontSize: 12))
                  : (theme?.helperStyle ??
                        const TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ),
        ],
      ],
    );
  }
}
