import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:flutter/material.dart';

class SuccessModalShowcaseScreen extends StatelessWidget {
  const SuccessModalShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success Modal Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Success Modal System',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Our success modal system provides feedback to users through modal dialogs that can be customized with different messages and button labels.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            // Dismissible Success Modal
            _buildModalSection(
              context,
              title: 'Dismissible Success Modal',
              description: 'A success modal that can be dismissed by tapping outside',
              onPressed: () {
                SuccessModal.show(
                  context,
                  message: 'Settings saved successfully!',
                  isDismissible: true,
                  enableDrag: true,
                  buttonLabel: 'Continue',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),

            // Non Dismissible Success Modal
            _buildModalSection(
              context,
              title: 'Non Dismissible Success Modal',
              description: 'A success modal that can not be dismissed when tapping outside',
              onPressed: () {
                SuccessModal.show(
                  context,
                  message: 'File uploaded successfully!',
                  buttonLabel: 'Continue',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalSection(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('Show Modal'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
} 