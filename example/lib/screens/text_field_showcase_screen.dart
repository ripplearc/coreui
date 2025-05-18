import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class TextFieldScreen extends StatelessWidget {
  const TextFieldScreen({Key? key}) : super(key: key);

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
            const CoreTextField(
              label: 'Label',
              helperText: 'Helper text',
            ),
            const SizedBox(height: 24),
            Text('With Error', style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            const CoreTextField(
              label: 'Label',
              errorText: 'Error message',
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
              prefix: Icon(Icons.search),
              suffix: Icon(Icons.visibility),
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
          ],
        ),
      ),
    );
  }
}
