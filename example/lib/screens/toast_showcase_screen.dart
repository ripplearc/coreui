import 'package:ripplearc_coreui/ripplearc_coreui.dart';
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
            Text(
              'Our toast system provides feedback to users through '
              'non-intrusive titles.',
              style: Theme.of(context).coreTypography.bodyLargeRegular,
            ),
            const SizedBox(height: 32),

            // Error Toast
            _buildToastSection(
              context,
              title: 'Error Toast',
              toast: Toast.error(
                  description: "This is an error description",
                  title: 'This is an error title',
                  closeLabel: 'Close',
                  onClose: () {}),
            ),

            // Warning Toast
            _buildToastSection(
              context,
              title: 'Warning Toast',
              toast: Toast.warning(
                description: 'This is a warning description',
                title: 'This is a warning title',
                closeLabel: 'Close',
                onClose: () {},
              ),
            ),

            // Info Toast
            _buildToastSection(
              context,
              title: 'Info Toast',
              toast: Toast.info(
                description: 'This is an info description',
                title: 'This is an info title',
                closeLabel: 'Close',
                onClose: () {},
              ),
            ),

            // Success Toast
            _buildToastSection(
              context,
              title: 'Success Toast',
              toast: Toast.success(
                description: 'This is a success description',
                title: 'This is a success title',
                closeLabel: 'Close',
                onClose: () {},
              ),
            ),

            // Toast without title
            _buildToastSection(
              context,
              title: 'Toast Without Title',
              toast: Toast.info(
                description: 'This description appears with title styling',
                closeLabel: 'Close',
                onClose: () {},
              ),
            ),

            // Receipt Toast
            _buildToastSection(
              context,
              title: 'Receipt Toast',
              toast: Toast.receipt(
                description: 'Saved to history',
                highlight: 'Calc 60ft²',
                actionLabel: 'Undo',
                onAction: () {},
                // Static preview: the live one is behind the button below.
                duration: null,
              ),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _showAllToasts(context);
              },
              child: const Text('Show All Toasts'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showReceiptToast(context),
              child: const Text('Show Receipt Toast (dismisses in 5s)'),
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

  // The live receipt: it banks itself after five seconds unless an action
  // answers it first.
  void _showReceiptToast(BuildContext context) {
    CoreToast.showReceipt(
      context,
      'Saved to history',
      'Undo',
      () => _report(context, 'Undo tapped — the session comes back'),
      highlight: 'Calc 60ft²',
    );
  }

  void _report(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showAllToasts(BuildContext context) {
    // Toast types and their messages
    final toastData = [
      {
        'type': 'error',
        'title': 'This is an error title',
        'description': 'This is an error description',
        'delay': 0
      },
      {
        'type': 'warning',
        'title': 'This is a warning title',
        'description': 'This is a warning description',
        'delay': 1
      },
      {
        'type': 'info',
        'title': 'This is an info title',
        'description': 'This is an info description',
        'delay': 2
      },
      {
        'type': 'success',
        'title': 'This is a success title',
        'description': 'This is a success description',
        'delay': 3
      },
    ];

    // Show each toast with appropriate delay
    for (final data in toastData) {
      Future.delayed(Duration(seconds: data['delay'] as int), () {
        Widget toast;
        switch (data['type']) {
          case 'error':
            toast = Toast.error(
              description: data['description'] as String,
              closeLabel: 'Close',
              onClose: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            );
            break;
          case 'warning':
            toast = Toast.warning(
              description: data['description'] as String,
              closeLabel: 'Close',
              onClose: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            );
            break;
          case 'info':
            toast = Toast.info(
              description: data['description'] as String,
              closeLabel: 'Close',
              onClose: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            );
            break;
          case 'success':
          default:
            toast = Toast.success(
              description: data['description'] as String,
              closeLabel: 'Close',
              onClose: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            );
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: toast,
              backgroundColor: Theme.of(context).coreColors.transparent,
              elevation: 0,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      });
    }
  }
}
