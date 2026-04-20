import 'package:flutter/material.dart';

class FieldProTheme extends ThemeExtension<FieldProTheme> {
  // Label Styling
  final TextStyle? labelStyle;
  final TextStyle? requiredLabelStyle;
  final TextStyle? helperStyle;
  final Color? labelFocusColor;
  final Color? labelErrorColor;

  // Container Styling
  final Color? focusColor;
  final Color? errorColor;
  final Color? fillColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  // Text Styling
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;

  // Border & Shadows
  final double? borderWidth;
  final double? focusedBorderWidth;
  final Color? shadowBaseColor; // Used to generate neumorphic shadows
  final double? shadowElevation; // Intensity of the 3D effect

  const FieldProTheme({
    this.labelStyle,
    this.requiredLabelStyle,
    this.helperStyle,
    this.labelFocusColor,
    this.labelErrorColor,
    this.focusColor,
    this.errorColor,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.errorStyle,
    this.borderWidth,
    this.focusedBorderWidth,
    this.shadowBaseColor,
    this.shadowElevation,
  });

  @override
  FieldProTheme copyWith({
    TextStyle? labelStyle,
    TextStyle? requiredLabelStyle,
    TextStyle? helperStyle,
    Color? labelFocusColor,
    Color? labelErrorColor,
    Color? focusColor,
    Color? errorColor,
    Color? fillColor,
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    double? borderWidth,
    double? focusedBorderWidth,
    Color? shadowBaseColor,
    double? shadowElevation,
  }) {
    return FieldProTheme(
      labelStyle: labelStyle ?? this.labelStyle,
      requiredLabelStyle: requiredLabelStyle ?? this.requiredLabelStyle,
      helperStyle: helperStyle ?? this.helperStyle,
      labelFocusColor: labelFocusColor ?? this.labelFocusColor,
      labelErrorColor: labelErrorColor ?? this.labelErrorColor,
      focusColor: focusColor ?? this.focusColor,
      errorColor: errorColor ?? this.errorColor,
      fillColor: fillColor ?? this.fillColor,
      borderRadius: borderRadius ?? this.borderRadius,
      contentPadding: contentPadding ?? this.contentPadding,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      borderWidth: borderWidth ?? this.borderWidth,
      focusedBorderWidth: focusedBorderWidth ?? this.focusedBorderWidth,
      shadowBaseColor: shadowBaseColor ?? this.shadowBaseColor,
      shadowElevation: shadowElevation ?? this.shadowElevation,
    );
  }

  @override
  FieldProTheme lerp(ThemeExtension<FieldProTheme>? other, double t) {
    if (other is! FieldProTheme) {
      return this;
    }
    return FieldProTheme(
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      requiredLabelStyle: TextStyle.lerp(
        requiredLabelStyle,
        other.requiredLabelStyle,
        t,
      ),
      helperStyle: TextStyle.lerp(helperStyle, other.helperStyle, t),
      labelFocusColor: Color.lerp(labelFocusColor, other.labelFocusColor, t),
      labelErrorColor: Color.lerp(labelErrorColor, other.labelErrorColor, t),
      focusColor: Color.lerp(focusColor, other.focusColor, t),
      errorColor: Color.lerp(errorColor, other.errorColor, t),
      fillColor: Color.lerp(fillColor, other.fillColor, t),
      borderRadius: _lerpDouble(borderRadius, other.borderRadius, t),
      contentPadding: EdgeInsetsGeometry.lerp(
        contentPadding,
        other.contentPadding,
        t,
      ),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      hintStyle: TextStyle.lerp(hintStyle, other.hintStyle, t),
      errorStyle: TextStyle.lerp(errorStyle, other.errorStyle, t),
      borderWidth: _lerpDouble(borderWidth, other.borderWidth, t),
      focusedBorderWidth: _lerpDouble(
        focusedBorderWidth,
        other.focusedBorderWidth,
        t,
      ),
      shadowBaseColor: Color.lerp(shadowBaseColor, other.shadowBaseColor, t),
      shadowElevation: _lerpDouble(shadowElevation, other.shadowElevation, t),
    );
  }

  double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b! * t;
    if (b == null) return a * (1.0 - t);
    return a + (b - a) * t;
  }
}
