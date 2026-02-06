import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class KeyboardShowcaseScreen extends StatefulWidget {
  const KeyboardShowcaseScreen({super.key});

  @override
  State<KeyboardShowcaseScreen> createState() => _KeyboardShowcaseScreenState();
}

class _KeyboardShowcaseScreenState extends State<KeyboardShowcaseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openBottomSheet();
    });
  }

  void _openBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColorsExtension.of(context).transparent,
      builder: (sheetContext) {
        GroupNameType currentGroup = GroupNameType(label: "Basic Geometry");
        UnitSystem currentUnitSystem = UnitSystem.imperial;

        final List<FunctionGroup> groups = const [
          FunctionGroup(
            name: GroupNameType(label: "Basic Geometry"),
            keys: [
              KeyType(groupName: 'Basic Geometry', label: 'Width'),
              KeyType(groupName: 'Basic Geometry', label: 'Length'),
              KeyType(groupName: 'Basic Geometry', label: 'Height'),
              KeyType(groupName: 'Basic Geometry', label: 'Pitch'),
              KeyType(groupName: 'Basic Geometry', label: 'Circle'),
              KeyType(groupName: 'Basic Geometry', label: 'Rise'),
              KeyType(groupName: 'Basic Geometry', label: 'Run'),
              KeyType(groupName: 'Basic Geometry', label: 'Radius'),
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

        return StatefulBuilder(builder: (ctx, sheetSetState) {
          void log(String message) => debugPrint('[Keyboard demo] $message');

          void onDigitPressed(DigitType digit) =>
              log('Digit pressed: ${digit.label}');

          void onOperatorPressed(OperatorType operatorType) =>
              log('Operator pressed: ${operatorType.symbol}');

          void onUnitSelected(UnitType unit) {
            log('Unit selected: ${unit.label}');
          }

          void onControlActionTriggered(ControlAction action) =>
              log('Control pressed: ${action.name}');

          void onGroupSelected(GroupNameType group) {
            sheetSetState(() => currentGroup = group);
            log('Group selected: ${group.label}');
          }

          void onUnitSystemChanged(UnitSystem system) {
            sheetSetState(() => currentUnitSystem = system);
            log('Unit system switched to: ${system.label}');
          }

          void onFunctionKeyTapped(KeyType key) {
            log('Function key tapped: ${key.label}');
            FunctionGroup? matched;
            for (final g in groups) {
              if (g.name.label == key.groupName) {
                matched = g;
                break;
              }
            }
            final newGroup =
                matched?.name ?? GroupNameType(label: key.groupName);
            sheetSetState(() => currentGroup = newGroup);
          }

          final colors = AppColorsExtension.of(sheetContext);
          final Map<GroupNameType, Color> groupAccentColors = {
            GroupNameType(label: "Basic Geometry"): colors.keyboardFunctions,
            GroupNameType(label: "Materials"): colors.keyboardUnits,
            GroupNameType(label: "Trigonometry"): colors.textSuccess,
          };

          return Padding(
            padding: const EdgeInsets.only(top: CoreSpacing.space8),
            child: CoreKeyboard(
              currentGroup: currentGroup,
              allGroups: groups,
              onDigitPressed: onDigitPressed,
              onUnitSelected: onUnitSelected,
              onOperatorPressed: onOperatorPressed,
              onControlAction: onControlActionTriggered,
              onResultTapped: () => log('Result tapped'),
              onGroupSelected: onGroupSelected,
              onKeyTapped: onFunctionKeyTapped,
              result: ResultType(label: "="),
              currentUnitSystem: currentUnitSystem,
              onUnitSystemChanged: onUnitSystemChanged,
              groupAccentColors: groupAccentColors,
            ),
          );
        });
      },
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: _openBottomSheet,
                child: const Text('Show keyboard sheet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
