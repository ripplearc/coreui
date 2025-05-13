import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ColorShowcaseScreen extends StatelessWidget {
  const ColorShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Tokens'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Brand Colors', [
                _ColorItem('Orient', CoreColorTokens.brandOrient),
              ]),
              _buildSection('Gray Scale', [
                _ColorItem('Gray 25', CoreColorTokens.gray25),
                _ColorItem('Gray 50', CoreColorTokens.gray50),
                _ColorItem('Gray 100', CoreColorTokens.gray100),
                _ColorItem('Gray 200', CoreColorTokens.gray200),
                _ColorItem('Gray 300', CoreColorTokens.gray300),
                _ColorItem('Gray 400', CoreColorTokens.gray400),
                _ColorItem('Gray 500', CoreColorTokens.gray500),
                _ColorItem('Gray 600', CoreColorTokens.gray600),
                _ColorItem('Gray 700', CoreColorTokens.gray700),
                _ColorItem('Gray 800', CoreColorTokens.gray800),
                _ColorItem('Gray 900', CoreColorTokens.gray900),
              ]),
              _buildSection('Orient Scale', [
                _ColorItem('Orient 25', CoreColorTokens.orient25),
                _ColorItem('Orient 50', CoreColorTokens.orient50),
                _ColorItem('Orient 100', CoreColorTokens.orient100),
                _ColorItem('Orient 200', CoreColorTokens.orient200),
                _ColorItem('Orient 300', CoreColorTokens.orient300),
                _ColorItem('Orient 400', CoreColorTokens.orient400),
                _ColorItem('Orient 500', CoreColorTokens.orient500),
                _ColorItem('Orient 600', CoreColorTokens.orient600),
                _ColorItem('Orient 700', CoreColorTokens.orient700),
                _ColorItem('Orient 800', CoreColorTokens.orient800),
                _ColorItem('Orient 900', CoreColorTokens.orient900),
              ]),
              _buildSection('Text Colors', [
                _ColorItem('Headline', CoreColorTokens.textHeadline),
                _ColorItem('Dark', CoreColorTokens.textDark),
                _ColorItem('Body', CoreColorTokens.textBody),
                _ColorItem('Disable', CoreColorTokens.textDisable),
                _ColorItem('Inverse', CoreColorTokens.textInverse),
                _ColorItem('Link', CoreColorTokens.textLink),
                _ColorItem('Info', CoreColorTokens.textInfo),
                _ColorItem('Warning', CoreColorTokens.textWarning),
                _ColorItem('Error', CoreColorTokens.textError),
                _ColorItem('Success', CoreColorTokens.textSuccess),
              ]),
              _buildSection('Background Colors', [
                _ColorItem('Page BG', CoreColorTokens.pageBg),
                _ColorItem('Grey Light', CoreColorTokens.greyLight),
                _ColorItem('Grey Mid', CoreColorTokens.greyMid),
                _ColorItem('Blue Light', CoreColorTokens.blueLight),
                _ColorItem('Blue Mid', CoreColorTokens.blueMid),
                _ColorItem('Orient Light', CoreColorTokens.orientLight),
                _ColorItem('Orient Mid', CoreColorTokens.orientMid),
                _ColorItem('Red Light', CoreColorTokens.redLight),
                _ColorItem('Red Mid', CoreColorTokens.redMid),
                _ColorItem('Orange Light', CoreColorTokens.orangeLight),
                _ColorItem('Orange Mid', CoreColorTokens.orangeMid),
                _ColorItem('Green Light', CoreColorTokens.greenLight),
                _ColorItem('Green Mid', CoreColorTokens.greenMid),
                _ColorItem('Dark Grey', CoreColorTokens.darkGrey),
                _ColorItem('Dark Orient', CoreColorTokens.darkOrient),
              ]),
              _buildSection('Border Colors', [
                _ColorItem('Line Light', CoreColorTokens.lineLight),
                _ColorItem('Line Mid', CoreColorTokens.lineMid),
                _ColorItem('Line Dark', CoreColorTokens.lineDark),
                _ColorItem('Line Highlight', CoreColorTokens.lineHighlight),
                _ColorItem('Outline Hover', CoreColorTokens.outlineHover),
                _ColorItem('Outline Focus', CoreColorTokens.outlineFocus),
              ]),
              _buildSection('State Colors', [
                _ColorItem('Error', CoreColorTokens.stateError),
                _ColorItem('Success', CoreColorTokens.stateSuccess),
              ]),
              _buildSection('Button Colors', [
                _ColorItem('Surface', CoreColorTokens.btnSurface),
                _ColorItem('Hover', CoreColorTokens.btnHover),
                _ColorItem('Press', CoreColorTokens.btnPress),
                _ColorItem('Disable', CoreColorTokens.btnDisable),
              ]),
              _buildSection('Icon Colors', [
                _ColorItem('Dark', CoreColorTokens.iconDark),
                _ColorItem('Grey Dark', CoreColorTokens.iconGreyDark),
                _ColorItem('Grey Mid', CoreColorTokens.iconGreyMid),
                _ColorItem('Grey Light', CoreColorTokens.iconGreyLight),
                _ColorItem('White', CoreColorTokens.iconWhite),
                _ColorItem('Red', CoreColorTokens.iconRed),
                _ColorItem('Orient', CoreColorTokens.iconOrient),
                _ColorItem('Orange', CoreColorTokens.iconOrange),
                _ColorItem('Blue', CoreColorTokens.iconBlue),
                _ColorItem('Green', CoreColorTokens.iconGreen),
              ]),
              _buildSection('Chip Colors', [
                _ColorItem('Grey', CoreColorTokens.chipGrey),
                _ColorItem('Primary', CoreColorTokens.chipPrimary),
                _ColorItem('Red', CoreColorTokens.chipRed),
                _ColorItem('Orange', CoreColorTokens.chipOrange),
                _ColorItem('Blue', CoreColorTokens.chipBlue),
                _ColorItem('Green', CoreColorTokens.chipGreen),
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
