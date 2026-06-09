part of '../../core_geometry_area.dart';

class _SizesTable extends StatelessWidget {
  const _SizesTable({
    required this.sizesTitleLabel,
    required this.addSizeLabel,
  });

  final String sizesTitleLabel;
  final String addSizeLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SizesHeader(
          titleLabel: sizesTitleLabel,
          addSizeLabel: addSizeLabel,
        ),
      ],
    );
  }
}
