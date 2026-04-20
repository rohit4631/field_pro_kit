# Field Pro Kit

A complete, modern, and highly customizable form input system with 3D neumorphism, separated labels, animations, and advanced fields like dropdowns and date pickers.

[![Pub Version](https://img.shields.io/pub/v/field_pro_kit?color=blue)](https://pub.dev/packages/field_pro_kit)
[![Flutter Platform](https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

**Field Pro Kit** is designed to elevate the user experience of Flutter forms by providing premium, production-ready input fields. It moves away from standard Material Design defaults, offering a sleek, modern UI with features like smart shadow generation (neumorphism) and built-in error shaking animations.

---

## ✨ Features

- **3D Neumorphic Styling**: Smooth, depth-based designs that adapt automatically to light and dark modes.
- **Separated Label System**: Clean UI with labels placed elegantly outside the input container.
- **Animated Error Feedback**: Built-in horizontal shake animations for validation errors to catch the user's attention.
- **Advanced Field Types**: Built-in support for text fields, custom dropdowns, and date pickers.
- **Auto Validation**: Pre-configured validators for common types (Email, Password, Phone, URL).
- **Password Visibility Toggle**: Automatic suffix icon to toggle password visibility.
- **Debounced Search**: Built-in debounce mechanism for search fields to prevent excessive API calls.
- **Highly Customizable**: Easily theme all your fields globally or override styles per instance.

---

## 📦 Installation

Add `field_pro_kit` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  field_pro_kit: ^1.0.0
```

Run the following command to fetch the package:
```bash
flutter pub get
```

---

## 🚀 Quick Setup

To apply a consistent look across your entire app, you can configure the `FieldProTheme` within your app's `ThemeData` extensions.

```dart
import 'package:flutter/material.dart';
import 'package:field_pro_kit/field_pro_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Pro Kit Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        extensions: [
          FieldProTheme(
            borderRadius: 16.0,
            shadowElevation: 4.0,
            shadowBaseColor: Colors.grey.shade200,
            focusColor: Colors.blueAccent,
            errorColor: Colors.redAccent,
          ),
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: [
          FieldProTheme(
            borderRadius: 16.0,
            shadowElevation: 3.0,
            shadowBaseColor: Colors.grey.shade900,
            focusColor: Colors.lightBlue,
            errorColor: Colors.redAccent,
          ),
        ],
      ),
      themeMode: ThemeMode.system,
      home: const FormDemo(),
    );
  }
}
```

---

## 💡 Usage Examples

Import the package in your Dart file:
```dart
import 'package:field_pro_kit/field_pro_kit.dart';
```

### 1. Standard Text Field

```dart
AppTextField(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  fieldType: FieldType.name,
  isRequired: true,
  prefixIcon: const Icon(Icons.person_outline),
  onChanged: (val) => print(val),
)
```

### 2. Password Field (With Auto Strength Validation & Toggle)

```dart
AppTextField(
  labelText: 'Password',
  hintText: 'Enter a strong password',
  fieldType: FieldType.password,
  isRequired: true,
  prefixIcon: const Icon(Icons.lock_outline),
)
```

### 3. Email Field (With Auto Validation)

```dart
AppTextField(
  labelText: 'Email Address',
  hintText: 'john.doe@example.com',
  fieldType: FieldType.email,
  isRequired: true,
  prefixIcon: const Icon(Icons.email_outlined),
)
```

### 4. Search Field (With Debounce)

```dart
AppTextField(
  hintText: 'Search items...',
  fieldType: FieldType.search,
  debounceDuration: const Duration(milliseconds: 600),
  onChanged: (query) {
    // This will only be called 600ms after the user stops typing
    print("Searching for: $query");
  },
)
```

### 5. Dropdown Field

```dart
AppDropdownField<String>(
  labelText: 'Select Country',
  hintText: 'Choose an option',
  items: const ['USA', 'UK', 'Canada', 'Australia'],
  value: null, // Set initial value here
  onChanged: (value) {
    print("Selected: $value");
  },
)
```

### 6. Date Picker Field

```dart
AppDatePickerField(
  labelText: 'Date of Birth',
  hintText: 'Select your birthday',
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
  onDateSelected: (date) {
    print("Selected Date: $date");
  },
)
```

---

## 🎨 Field Types Available

The `FieldType` enum allows you to easily switch keyboard types, validators, and built-in behaviors:

- `FieldType.name` (Standard text input)
- `FieldType.email` (Email keyboard + auto-validation)
- `FieldType.password` (Obscured text + toggle suffix + strength validation)
- `FieldType.phone` (Number keyboard + phone validation)
- `FieldType.number` (Numeric keyboard)
- `FieldType.url` (URL keyboard + url validation)
- `FieldType.search` (Debounced `onChanged` + search suffix)
- `FieldType.multiline` (Expands to multiple lines)

---

## 🛠 Advanced Customization

You can fully customize the look and feel by modifying the `FieldProTheme` in your `ThemeData` extension, or you can provide custom validators directly to each field:

```dart
AppTextField(
  labelText: 'Custom Validator',
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (value.length < 5) {
      return 'Must be at least 5 characters long'; // Will trigger shake animation
    }
    return null;
  },
)
```

---

## 🐛 Bug Reports & Feature Requests

If you encounter any issues or have ideas for new features, please open an issue on our [GitHub repository](https://github.com/your-username/field_pro_kit/issues).

---

## 📄 License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
