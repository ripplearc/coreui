import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class TextFieldScreen extends StatefulWidget {
  const TextFieldScreen({Key? key}) : super(key: key);

  @override
  State<TextFieldScreen> createState() => _TextFieldScreenState();
}

class _TextFieldScreenState extends State<TextFieldScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _disabledPhoneController =
      TextEditingController(text: '555-123-4567');
  String? _validationError;
  String _phonePrefix = '+1';

  // List of phone prefixes to show in the bottom sheet
  final List<String> _phonePrefixes = [
    '+1', // USA/Canada
    '+44', // UK
    '+33', // France
    '+49', // Germany
    '+61', // Australia
    '+81', // Japan
    '+86', // China
    '+91', // India
    '+52', // Mexico
    '+55', // Brazil
  ];

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    _disabledPhoneController.dispose();
    super.dispose();
  }

  void _validateTextField() {
    setState(() {
      if (_controller.text.isEmpty) {
        _validationError = 'Field cannot be empty';
      } else if (_controller.text.length < 3) {
        _validationError = 'Text must be at least 3 characters';
      } else {
        _validationError = null;
      }
    });
  }

  void _onPhonePrefixChanged(String? newPrefix) {
    if (newPrefix != null) {
      setState(() {
        _phonePrefix = newPrefix;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Field', style: CoreTypography.bodyLargeSemiBold()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Default', style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            CoreTextField(
              label: 'Label',
              helperText: 'Helper text',
              controller: _controller,
              errorTextList: _validationError != null ? [_validationError!] : null,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _validateTextField,
              child: const Text('Validate'),
            ),
            const SizedBox(height: 24),
            Text('With Error', style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            const CoreTextField(
              label: 'Label',
              errorTextList: ['Error message'],
            ),
            const SizedBox(height: 24),
            Text('Disabled', style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            const CoreTextField(
              label: 'Label',
              enabled: false,
              helperText: 'Helper text',
            ),
            const SizedBox(height: 24),
            Text('With Prefix and Suffix',
                style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            const CoreTextField(
              label: 'Label',
              helperText: 'Helper text',
            ),
            const SizedBox(height: 24),
            Text('Password Field', style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            const CoreTextField(
              label: 'Password',
              obscureText: true,
              suffix: Icon(Icons.visibility),
              helperText: 'Helper text',
            ),
            const SizedBox(height: 24),
            Text('Phone Number Field - Default',
                style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            CoreTextField(
              label: 'Phone Number',
              helperText: 'Enter your phone number',
              controller: _phoneController,
              isPhoneNumber: true,
              phonePrefix: _phonePrefix,
              onPhonePrefixChanged: _onPhonePrefixChanged,
              phonePrefixes: _phonePrefixes,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Text('Phone Number Field - Error',
                style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            CoreTextField(
              label: 'Phone Number',
              helperText: 'Enter your phone number',
              isPhoneNumber: true,
              errorTextList: ['Invalid phone number'],
              phonePrefix: '+44',
              phonePrefixes: _phonePrefixes,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Text('Phone Number Field - Disabled',
                style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            CoreTextField(
              label: 'Phone Number',
              helperText: 'Enter your phone number',
              isPhoneNumber: true,
              enabled: false,
              phonePrefix: '+33',
              phonePrefixes: _phonePrefixes,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Text('Phone Number Field - Disabled with Value',
                style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            CoreTextField(
              label: 'Phone Number',
              helperText: 'This field is disabled but has a value',
              isPhoneNumber: true,
              enabled: false,
              controller: _disabledPhoneController,
              phonePrefix: '+44',
              phonePrefixes: _phonePrefixes,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}
