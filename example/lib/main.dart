import 'package:flutter/material.dart';
import 'package:field_pro_kit/field_pro_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Pro Kit Example',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        extensions: const [
          FieldProTheme(
            borderRadius: 16.0,
            borderWidth: 1.0,
            focusedBorderWidth: 2.0,
            shadowElevation: 4.0,
          ),
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        extensions: const [
          FieldProTheme(
            borderRadius: 16.0,
            borderWidth: 1.0,
            focusedBorderWidth: 2.0,
            shadowElevation: 3.0,
          ),
        ],
      ),
      home: ExampleScreen(onToggleTheme: _toggleTheme),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const ExampleScreen({super.key, required this.onToggleTheme});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Pro Kit V2 Demo'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const AppTextField(
                fieldType: FieldType.name,
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline),
                isRequired: true,
              ),
              const SizedBox(height: 24),
              const AppTextField(
                fieldType: FieldType.email,
                labelText: 'Email Address',
                hintText: 'hello@example.com',
                helperText: 'We will never share your email with anyone.',
                prefixIcon: Icon(Icons.email_outlined),
                isRequired: true,
              ),
              const SizedBox(height: 24),
              const AppTextField(
                fieldType: FieldType.password,
                labelText: 'Secure Password',
                hintText: 'Enter a strong password',
                prefixIcon: Icon(Icons.lock_outline),
                isRequired: true,
              ),

              const SizedBox(height: 40),
              const Text(
                'Advanced Components',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              AppDropdownField<String>(
                labelText: 'Select Plan',
                hintText: 'Choose your subscription plan',
                prefixIcon: const Icon(Icons.star_outline),
                items: const [
                  'Basic (Free)',
                  'Pro (\$9.99/mo)',
                  'Enterprise (Contact Us)',
                ],
                itemAsString: (item) => item,
                isRequired: true,
              ),

              const SizedBox(height: 24),
              AppDatePickerField(
                labelText: 'Date of Birth',
                hintText: 'YYYY-MM-DD',
                prefixIcon: const Icon(Icons.cake_outlined),
                isRequired: true,
              ),

              const SizedBox(height: 24),
              const AppTextField(
                fieldType: FieldType.multiline,
                labelText: 'Bio / Notes',
                hintText: 'Tell us about yourself...',
                maxLines: 4,
              ),

              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Form successfully validated!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fix the errors in the form.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Submit Form',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
