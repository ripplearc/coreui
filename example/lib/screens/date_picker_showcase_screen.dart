import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class DatePickerShowcaseScreen extends StatefulWidget {
  const DatePickerShowcaseScreen({super.key});

  @override
  State<DatePickerShowcaseScreen> createState() =>
      _DatePickerShowcaseScreenState();
}

class _DatePickerShowcaseScreenState extends State<DatePickerShowcaseScreen> {
  DateTime _inlineSelectedDate = DateTime.now();
  DateTime? _lastPickedDate;

  Future<void> _showBasicPicker(BuildContext context) async {
    final picked = await CoreDatePicker.show(
      context: context,
      initialDate: _lastPickedDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() => _lastPickedDate = picked);
    }
  }

  Future<void> _showBoundedPicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await CoreDatePicker.show(
      context: context,
      initialDate: _lastPickedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year, now.month, now.day + 30),
      label: 'Select due date',
    );
    if (picked != null) {
      setState(() => _lastPickedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Scaffold(
      backgroundColor: colors.pageBackground,
      appBar: AppBar(
        title: const Text('CoreDatePicker Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dialog – basic',
              style: typography.titleMediumMedium.copyWith(
                color: colors.textHeadline,
              ),
            ),
            const SizedBox(height: CoreSpacing.space2),
            ElevatedButton(
              onPressed: () => _showBasicPicker(context),
              child: const Text('Open date picker'),
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text(
              'Dialog – bounded to the next 30 days',
              style: typography.titleMediumMedium.copyWith(
                color: colors.textHeadline,
              ),
            ),
            const SizedBox(height: CoreSpacing.space2),
            ElevatedButton(
              onPressed: () => _showBoundedPicker(context),
              child: const Text('Pick a due date'),
            ),
            if (_lastPickedDate case final lastPickedDate?) ...[
              const SizedBox(height: CoreSpacing.space2),
              Text(
                'Last picked: ${lastPickedDate.year}-${lastPickedDate.month}-${lastPickedDate.day}',
                style: typography.bodyMediumRegular.copyWith(
                  color: colors.textBody,
                ),
              ),
            ],
            const SizedBox(height: CoreSpacing.space8),
            Text(
              'Inline, controlled by the caller',
              style: typography.titleMediumMedium.copyWith(
                color: colors.textHeadline,
              ),
            ),
            const SizedBox(height: CoreSpacing.space2),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CoreSpacing.space3),
                border: Border.all(color: colors.lineLight),
              ),
              clipBehavior: Clip.antiAlias,
              child: CoreDatePicker(
                selectedDate: _inlineSelectedDate,
                onDateChanged: (date) =>
                    setState(() => _inlineSelectedDate = date),
                onCancel: () {},
                onConfirm: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
