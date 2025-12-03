import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/src/components/keyboard/core_keyboard.dart';
import 'package:ripplearc_coreui/src/components/keyboard/keyboard_models.dart';
import 'package:ripplearc_coreui/src/theme/color_tokens.dart';
import 'package:ripplearc_coreui/src/theme/spacing.dart';
import 'package:ripplearc_coreui/src/theme/theme_extensions.dart';

class KeyboardShowcaseScreen extends StatefulWidget {
  const KeyboardShowcaseScreen({super.key});

  @override
  State<KeyboardShowcaseScreen> createState() => _KeyboardShowcaseScreenState();
}

class _KeyboardShowcaseScreenState extends State<KeyboardShowcaseScreen> {
  GroupNameType _currentGroup = GroupNameType.basicGeometry;
  UnitSystem _currentUnitSystem = UnitSystem.imperial;

  final List<FunctionGroup> _groups = const [
    FunctionGroup(
      name: GroupNameType.basicGeometry,
      keys: [
        KeyType(id: 'width', label: 'Width'),
        KeyType(id: 'length', label: 'Length'),
        KeyType(id: 'height', label: 'Height'),
        KeyType(id: 'pitch', label: 'Pitch'),
        KeyType(id: 'circle', label: 'Circle'),
      ],
    ),
    FunctionGroup(
      name: GroupNameType.materials,
      keys: [
        KeyType(id: 'lbs', label: 'Lbs'),
        KeyType(id: 'kg', label: 'Kg'),
        KeyType(id: 'tons', label: 'Tons'),
        KeyType(id: 'drywall', label: 'Drywall'),
      ],
    ),
    FunctionGroup(
      name: GroupNameType.trigonometry,
      keys: [
        KeyType(id: 'sin', label: 'SIN'),
        KeyType(id: 'cos', label: 'COS'),
        KeyType(id: 'tan', label: 'TAN'),
      ],
    ),
  ];

  void _log(String message) {
    // ignore: avoid_print
    print('[Keyboard demo] $message');
  }

  void _handleDigit(DigitType digit) => _log('Digit pressed: ${digit.label}');

  void _handleOperator(OperatorType operatorType) =>
      _log('Operator pressed: ${operatorType.symbol}');

  void _handleUnit(UnitType unit) {
    _log('Unit selected: ${unit.label}');
  }

  void _handleControl(ControlAction action) =>
      _log('Control pressed: ${action.name}');

  void _handleGroup(GroupNameType group) {
    setState(() => _currentGroup = group);
    _log('Group selected: ${group.label}');
  }

  void _handleUnitSystem(UnitSystem system) {
    setState(() => _currentUnitSystem = system);
    _log('Unit system switched to: ${system.label}');
  }

  void _handleKey(KeyType key) => _log('Function key tapped: ${key.label}');

  Map<GroupNameType, Color> _groupAccentColors(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    return {
      GroupNameType.basicGeometry:
          colors?.keyboardFunctions ?? CoreKeyboardColors.functions,
      GroupNameType.materials:
          colors?.keyboardUnits ?? CoreKeyboardColors.units,
      GroupNameType.trigonometry:
          colors?.keyboardActions ?? CoreKeyboardColors.actions,
    };
  }

  Widget _buildKeyboard(BuildContext context) {
    final accentColors = _groupAccentColors(context);
    return CoreKeyboard(
      currentGroup: _currentGroup,
      allGroups: _groups,
      onDigitPressed: _handleDigit,
      onUnitSelected: _handleUnit,
      onOperatorPressed: _handleOperator,
      onControlAction: _handleControl,
      onResultTapped: () => _log('Result tapped'),
      onGroupSelected: _handleGroup,
      onKeyTapped: _handleKey,
      result: ResultType.equals,
      currentUnitSystem: _currentUnitSystem,
      onUnitSystemChanged: _handleUnitSystem,
      groupAccentColors: accentColors,
    );
  }

  void _openBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: const EdgeInsets.only(top: CoreSpacing.space8),
        child: _buildKeyboard(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Keyboard Component', style: theme.titleLarge),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(CoreSpacing.space4),
              child: Text(
                'Interact with the keyboard below or open it as a bottom sheet. '
                'Each tap prints to the console for quick inspection.',
                style: theme.bodyLarge,
              ),
            ),
            ElevatedButton(
              onPressed: _openBottomSheet,
              child: const Text('Show keyboard sheet'),
            ),
            const SizedBox(height: CoreSpacing.space4),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildKeyboard(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

