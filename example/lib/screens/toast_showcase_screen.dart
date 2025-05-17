import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ToastShowcaseScreen extends StatelessWidget {
  const ToastShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toast Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Toast System',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Our toast system provides feedback to users through non-intrusive titles.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Error Toast
            _buildToastSection(
              context,
              title: 'Error Toast',
              toast: Toast.error(
                  title: 'This is an error title',
                  onClose: () {},
                  description: "This is an error description"),
            ),

            // Warning Toast
            _buildToastSection(
              context,
              title: 'Warning Toast',
              toast: Toast.warning(
                title: 'This is a warning title',
                onClose: () {},
              ),
            ),

            // Info Toast
            _buildToastSection(
              context,
              title: 'Info Toast',
              toast: Toast.info(
                title: 'This is an info title',
                onClose: () {},
              ),
            ),

            // Success Toast
            _buildToastSection(
              context,
              title: 'Success Toast',
              toast: Toast.success(
                title: 'This is a success title',
                onClose: () {},
              ),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _showAllToasts(context);
              },
              child: const Text('Show All Toasts'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToastSection(
    BuildContext context, {
    required String title,
    required Widget toast,
    String? description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        toast,
        const SizedBox(height: 32),
      ],
    );
  }

  void _showAllToasts(BuildContext context) {
    // Show error toast
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Toast.error(
          title: 'This is an error title',
          onClose: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 4),
      ),
    );

    // Show warning toast after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Toast.warning(
            title: 'This is a warning title',
            onClose: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 4),
        ),
      );
    });

    // Show info toast after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Toast.info(
            title: 'This is an info title',
            onClose: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 4),
        ),
      );
    });

    // Show success toast after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Toast.success(
            title: 'This is a success title',
            onClose: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }
}
