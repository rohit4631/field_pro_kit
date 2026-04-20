import 'package:flutter/material.dart';
import '../enums/field_type.dart';
import '../theme/field_pro_theme.dart';
import 'app_text_field.dart';

class AppDropdownField<T> extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final bool isRequired;
  final String? requiredMessage;
  final Widget? prefixIcon;
  final List<T> items;
  final T? value;
  final String Function(T) itemAsString;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const AppDropdownField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.isRequired = false,
    this.requiredMessage,
    this.prefixIcon,
    required this.items,
    this.value,
    required this.itemAsString,
    this.onChanged,
    this.validator,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  T? _selectedValue;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _selectedValue = widget.value;
    if (_selectedValue != null) {
      _controller.text = widget.itemAsString(_selectedValue as T);
    }
  }

  @override
  void didUpdateWidget(AppDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedValue = widget.value;
      if (_selectedValue != null) {
        _controller.text = widget.itemAsString(_selectedValue as T);
      } else {
        _controller.text = '';
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _closeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeOverlay();
    } else {
      _openOverlay();
    }
  }

  void _openOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final theme = Theme.of(context).extension<FieldProTheme>();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeOverlay,
          child: Stack(
            children: [
              Positioned(
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height + 5.0),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(
                      theme?.borderRadius ?? 12.0,
                    ),
                    child: SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOut,
                      ),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 250),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(
                            theme?.borderRadius ?? 12.0,
                          ),
                          border: Border.all(
                            color: Colors.grey.withAlpha(51),
                          ),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = item == _selectedValue;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedValue = item;
                                  _controller.text = widget.itemAsString(item);
                                });
                                widget.onChanged?.call(item);
                                _closeOverlay();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).primaryColor.withAlpha(25)
                                    : Colors.transparent,
                                child: Text(
                                  widget.itemAsString(item),
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    _animationController.forward();
  }

  void _closeOverlay() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() => _isOpen = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: AbsorbPointer(
          child: AppTextField(
            fieldType: FieldType.dropdown,
            labelText: widget.labelText,
            hintText: widget.hintText,
            helperText: widget.helperText,
            controller: _controller,
            isRequired: widget.isRequired,
            requiredMessage: widget.requiredMessage,
            prefixIcon: widget.prefixIcon,
            suffixIcon: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(_animationController),
              child: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ),
            validator: (value) {
              if (widget.validator != null) {
                return widget.validator!(_selectedValue);
              }
              if (widget.isRequired && _selectedValue == null) {
                return widget.requiredMessage ?? 'This field is required';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
