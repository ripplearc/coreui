import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A showcase screen for [CoreInlineErrorRow]: the message alone, with an
/// action, and a long message that wraps.
class InlineErrorRowShowcaseScreen extends StatefulWidget {
  const InlineErrorRowShowcaseScreen({super.key});

  @override
  State<InlineErrorRowShowcaseScreen> createState() =>
      _InlineErrorRowShowcaseScreenState();
}

class _InlineErrorRowShowcaseScreenState
    extends State<InlineErrorRowShowcaseScreen> {
  int _retries = 0;

  Widget _section(String title, Widget row) {
    final typography = Theme.of(context).coreTypography;

    return Padding(
      padding: const EdgeInsets.only(bottom: CoreSpacing.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: typography.bodyLargeSemiBold),
          const SizedBox(height: CoreSpacing.space2),
          row,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;

    return Scaffold(
      appBar: AppBar(
        title: Text('Inline Error Row', style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _section(
              'Message only',
              const CoreInlineErrorRow(message: 'Could not add this line'),
            ),
            _section(
              'With an action (tried again $_retries times)',
              CoreInlineErrorRow(
                message: 'Could not load your rates',
                actionLabel: 'Try again',
                onAction: () => setState(() => _retries++),
              ),
            ),
            _section(
              'Long message',
              const CoreInlineErrorRow(
                message: 'Could not add this line because the connection '
                    'dropped, so check it and add the line once more',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
