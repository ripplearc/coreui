// ignore_for_file: deprecated_member_use

import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:flutter/material.dart';

class ColorShowcaseScreen extends StatelessWidget {
  const ColorShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Color System'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Text Colors', [
                _ColorItem('Headline', colors.textHeadline),
                _ColorItem('Dark', colors.textDark),
                _ColorItem('Body', colors.textBody),
                _ColorItem('Disable', colors.textDisable),
                _ColorItem('Inverse', colors.textInverse),
                _ColorItem('Link', colors.textLink),
                _ColorItem('Info', colors.textInfo),
                _ColorItem('Warning', colors.textWarning),
                _ColorItem('Error', colors.textError),
                _ColorItem('Success', colors.textSuccess),
              ]),
              _buildSection('Background Colors', [
                _ColorItem('Page Background', colors.pageBackground),
                _ColorItem('Gray Light', colors.backgroundGrayLight),
                _ColorItem('Gray Mid', colors.backgroundGrayMid),
                _ColorItem('Blue Light', colors.backgroundBlueLight),
                _ColorItem('Blue Mid', colors.backgroundBlueMid),
                _ColorItem('Green Light', colors.backgroundGreenLight),
                _ColorItem('Green Mid', colors.backgroundGreenMid),
                _ColorItem('Red Light', colors.backgroundRedLight),
                _ColorItem('Red Mid', colors.backgroundRedMid),
                _ColorItem('Orange Light', colors.backgroundOrangeLight),
                _ColorItem('Orange Mid', colors.backgroundOrangeMid),
                _ColorItem('Dark Gray', colors.backgroundDarkGray),
                _ColorItem('Dark Orient', colors.backgroundDarkOrient),
                _ColorItem('Orient Light', colors.orientLight),
                _ColorItem('Orient Mid', colors.orientMid),
              ]),
              _buildSection('Border Colors', [
                _ColorItem('Line Light', colors.lineLight),
                _ColorItem('Line Mid', colors.lineMid),
                _ColorItem('Line Dark Outline', colors.lineDarkOutline),
                _ColorItem('Line Highlight', colors.lineHighlight),
                _ColorItem('Outline Hover', colors.outlineHover),
                _ColorItem('Outline Focus', colors.outlineFocus),
                _ColorItem('Tabs Highlight', colors.tabsHighlight),
              ]),
              _buildSection('Status Colors', [
                _ColorItem('Error', colors.statusError),
                _ColorItem('Success', colors.statusSuccess),
              ]),
              _buildSection('Button Colors', [
                _ColorItem('Surface', colors.buttonSurface),
                _ColorItem('Hover', colors.buttonHover),
                _ColorItem('Disable', colors.buttonDisable),
                _ColorItem('Press', colors.buttonPress),
              ]),
              _buildSection('Icon Colors', [
                _ColorItem('Dark', colors.iconDark),
                _ColorItem('Gray Dark', colors.iconGrayDark),
                _ColorItem('Gray Mid', colors.iconGrayMid),
                _ColorItem('Gray Light', colors.iconGrayLight),
                _ColorItem('White', colors.iconWhite),
                _ColorItem('Red', colors.iconRed),
                _ColorItem('Green', colors.iconGreen),
                _ColorItem('Orange', colors.iconOrange),
                _ColorItem('Blue', colors.iconBlue),
                _ColorItem('Orient', colors.iconOrient),
              ]),
              _buildSection('Chip Colors', [
                _ColorItem('Grey', colors.chipGrey),
                _ColorItem('Primary', colors.chipPrimary),
                _ColorItem('Red', colors.chipRed),
                _ColorItem('Orange', colors.chipOrange),
                _ColorItem('Blue', colors.chipBlue),
                _ColorItem('Green', colors.chipGreen),
              ]),
              _buildSection('Alert Colors', [
                _ColorItem('Red', colors.alertRed),
                _ColorItem('Orange', colors.alertOrange),
                _ColorItem('Blue', colors.alertBlue),
                _ColorItem('Green', colors.alertGreen),
              ]),
              _buildSection('Keyboard Colors', [
                _ColorItem('Numbers', colors.keyboardNumbers),
                _ColorItem('Calculate', colors.keyboardCalculate),
                _ColorItem('Units', colors.keyboardUnits),
                _ColorItem('Functions', colors.keyboardFunctions),
                _ColorItem('Actions', colors.keyboardActions),
                _ColorItem('Main', colors.keyboardMain),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<_ColorItem> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
          children: colors.map((color) => _buildColorCard(color)).toList(),
        ),
      ],
    );
  }

  Widget _buildColorCard(_ColorItem color) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: color.color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          color.name,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ColorItem {
  final String name;
  final Color color;

  _ColorItem(this.name, this.color);
}
