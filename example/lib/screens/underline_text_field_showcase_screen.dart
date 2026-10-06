import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class UnderlineTextFieldShowcaseScreen extends StatefulWidget {
  const UnderlineTextFieldShowcaseScreen({super.key});

  @override
  State<UnderlineTextFieldShowcaseScreen> createState() =>
      _UnderlineTextFieldShowcaseScreenState();
}

class _UnderlineTextFieldShowcaseScreenState
    extends State<UnderlineTextFieldShowcaseScreen> {
  final _duration = TextEditingController();
  final _durationFocus = FocusNode();
  bool _durationLeft = false;
  bool _rateLookedUp = false;

  @override
  void initState() {
    super.initState();
    _duration.addListener(_refresh);
    _durationFocus.addListener(_onDurationFocus);
  }

  @override
  void dispose() {
    _duration.dispose();
    _durationFocus.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _onDurationFocus() {
    if (!_durationFocus.hasFocus) setState(() => _durationLeft = true);
  }

  String? get _durationError {
    final days = double.tryParse(_duration.text);
    if (!_durationLeft || days == null) return null;
    final isWholeOrHalf = days * 2 == (days * 2).roundToDouble();
    if (days > 0 && isWholeOrHalf) return null;
    return 'Duration must be a whole or half day above zero.';
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Underline Text Field', style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('New equipment cost, by the day'),
            CoreUnderlineTextField(
              label: 'Equipment',
              hintText: 'Name the equipment',
              maxLength: 80,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: CoreSpacing.space3),
            CoreUnderlineTextField(
              label: 'Duration',
              hintText: 'Set the days',
              controller: _duration,
              focusNode: _durationFocus,
              unitText: _duration.text.isEmpty ? null : 'days',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              errorText: _durationError,
            ),
            const SizedBox(height: CoreSpacing.space3),
            CoreUnderlineTextField(
              label: 'Rate',
              hintText: 'Set your rate',
              prefixText: _rateLookedUp ? r'$' : null,
              initialValue: _rateLookedUp ? '145.00' : null,
              unitText: _rateLookedUp ? '/day' : null,
              key: ValueKey(_rateLookedUp),
              keyboardType: TextInputType.number,
              labelTrailing: _rateLookedUp ? _badge(context) : null,
              trailing: _rateLookedUp
                  ? null
                  : _lookupButton(
                      context,
                      () => setState(() => _rateLookedUp = true),
                    ),
              helperText: _rateLookedUp
                  ? null
                  : 'Never priced this? Use the search icon to look it up.',
            ),
            const SizedBox(height: CoreSpacing.space3),
            CoreUnderlineTextField(
              label: 'Quantity',
              initialValue: '3',
              keyboardType: TextInputType.number,
              inlineAccessory: _unitChip(context),
            ),
            const SizedBox(height: CoreSpacing.space3),
            const CoreUnderlineTextField(
              label: 'Delivery',
              prefixText: r'$',
              initialValue: '85',
              keyboardType: TextInputType.number,
              selectAllOnFocus: true,
            ),
            const SizedBox(height: CoreSpacing.space3),
            const CoreUnderlineTextField(
              label: 'Waste',
              suffixText: '%',
              initialValue: '10',
              keyboardType: TextInputType.number,
              showCursor: false,
              selectAllOnFocus: true,
            ),
            _section('A form that asks one question'),
            const CoreUnderlineTextField(
              size: CoreUnderlineTextFieldSize.large,
              label: 'How many days?',
              unitText: 'days',
              initialValue: '3',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: CoreSpacing.space4),
            const CoreUnderlineTextField(
              size: CoreUnderlineTextFieldSize.large,
              label: 'Amount',
              prefixText: r'$',
              initialValue: '450.00',
              unitText: 'job',
              keyboardType: TextInputType.number,
            ),
            _section('Error'),
            const CoreUnderlineTextField(
              label: 'Quantity',
              initialValue: '0',
              errorText: 'Quantity must be more than zero.',
            ),
            _section('Disabled and read-only'),
            const CoreUnderlineTextField(
              enabled: false,
              label: 'Rate',
              prefixText: r'$',
              initialValue: '145.00',
              unitText: '/day',
            ),
            const SizedBox(height: CoreSpacing.space3),
            const CoreUnderlineTextField(
              readOnly: true,
              label: 'Rate',
              prefixText: r'$',
              initialValue: '150.00',
              unitText: '/day',
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: CoreSpacing.space6,
        bottom: CoreSpacing.space2,
      ),
      child: Text(
        title,
        style: Theme.of(context).coreTypography.bodyLargeSemiBold,
      ),
    );
  }

  Widget _badge(BuildContext context) {
    final colors = Theme.of(context).coreColors;
    final typography = Theme.of(context).coreTypography;
    return Container(
      height: CoreSpacing.space5,
      padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.backgroundOrangeLight,
        border: Border.all(color: colors.textWarning),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Sample rate',
        style: typography.bodySmallSemiBold.copyWith(color: colors.textWarning),
      ),
    );
  }

  Widget _unitChip(BuildContext context) {
    final colors = Theme.of(context).coreColors;
    final typography = Theme.of(context).coreTypography;
    return Container(
      height: CoreSpacing.space8,
      padding: const EdgeInsets.fromLTRB(
        CoreSpacing.space3,
        6,
        CoreSpacing.space2,
        6,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: colors.lineMid),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'gal',
            style: typography.bodySmallRegular.copyWith(
              color: colors.textHeadline,
            ),
          ),
          const SizedBox(width: CoreSpacing.space1),
          Icon(Icons.expand_more, size: 20, color: colors.iconGrayMid),
        ],
      ),
    );
  }

  Widget _lookupButton(BuildContext context, VoidCallback onPressed) {
    final colors = Theme.of(context).coreColors;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: CoreSpacing.space9,
        height: CoreSpacing.space9,
        decoration: BoxDecoration(
          border: Border.all(color: colors.lineMid),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(Icons.search, size: 20, color: colors.iconGrayMid),
      ),
    );
  }
}
