import 'package:flutter/foundation.dart';

@immutable
sealed class DisplayAreaExpansionEvent {}

final class SwipeDownEvent extends DisplayAreaExpansionEvent {
  final bool exceedsTwoRows;

  SwipeDownEvent({required this.exceedsTwoRows});
}

final class SwipeUpEvent extends DisplayAreaExpansionEvent {
  final bool exceedsTwoRows;

  SwipeUpEvent({required this.exceedsTwoRows});
}

final class CollapseEvent extends DisplayAreaExpansionEvent {}
