import 'package:flutter/material.dart';
import '../enums/field_type.dart';
import 'app_text_field.dart';

class AppDatePickerField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final bool isRequired;
  final String? requiredMessage;
  final Widget? prefixIcon;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime)? onDateSelected;
  final String Function(DateTime)? dateFormat;
  final String? Function(String?)? validator;

  const AppDatePickerField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.isRequired = false,
    this.requiredMessage,
    this.prefixIcon,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.dateFormat,
    this.validator,
  });

  @override
  State<AppDatePickerField> createState() => _AppDatePickerFieldState();
}

class _AppDatePickerFieldState extends State<AppDatePickerField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _updateText();
    }
  }

  void _updateText() {
    if (_selectedDate != null) {
      if (widget.dateFormat != null) {
        _controller.text = widget.dateFormat!(_selectedDate!);
      } else {
        _controller.text =
            "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
      }
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateText();
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: AbsorbPointer(
        child: AppTextField(
          fieldType: FieldType.datePicker,
          labelText: widget.labelText,
          hintText: widget.hintText,
          helperText: widget.helperText,
          controller: _controller,
          isRequired: widget.isRequired,
          requiredMessage: widget.requiredMessage,
          prefixIcon: widget.prefixIcon ?? const Icon(Icons.calendar_today),
          validator: widget.validator,
        ),
      ),
    );
  }
}
