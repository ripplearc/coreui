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
  GroupNameType _currentGroup = GroupNameType(label: "Basic Geometry");
  UnitSystem _currentUnitSystem = UnitSystem.imperial;

  final List<FunctionGroup> _groups = const [
    FunctionGroup(
      name: GroupNameType(label: "Basic Geometry"),
      keys: [
        KeyType(groupName: 'Basic Geometry', label: 'Width'),
        KeyType(groupName: 'Basic Geometry', label: 'Length'),
        KeyType(groupName: 'Basic Geometry', label: 'Height'),
        KeyType(groupName: 'Basic Geometry', label: 'Pitch'),
        KeyType(groupName: 'Basic Geometry', label: 'Circle'),
      ],
    ),
    FunctionGroup(
      name: GroupNameType(label: "Materials"),
      keys: [
        KeyType(groupName: 'Materials', label: 'Lbs'),
        KeyType(groupName: 'Materials', label: 'Kg'),
        KeyType(groupName: 'Materials', label: 'Tons'),
        KeyType(groupName: 'Materials', label: 'Drywall'),
      ],
    ),
    FunctionGroup(
      name: GroupNameType(label: "Trigonometry"),
      keys: [
        KeyType(groupName: 'Trigonometry', label: 'SIN'),
        KeyType(groupName: 'Trigonometry', label: 'COS'),
        KeyType(groupName: 'Trigonometry', label: 'TAN'),
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

  void _handleKey(KeyType key) {
    _log('Function key tapped: ${key.label}');
    FunctionGroup? matched;
    for (final g in _groups) {
      if (g.name.label == key.groupName) {
        matched = g;
        break;
      }
    }
    setState(() {
      _currentGroup = matched?.name ?? GroupNameType(label: key.groupName);
    });
  }

  Map<GroupNameType, Color> _groupAccentColors(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    return {
      GroupNameType(label: "Basic Geometry"):
          colors?.keyboardFunctions ?? CoreKeyboardColors.functions,
      GroupNameType(label: "Materials"):
          colors?.keyboardUnits ?? CoreKeyboardColors.units,
      GroupNameType(label: "Trigonometry"):
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
      result: ResultType(label: "="),
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
