import 'range.dart';

extension ListExtensions on List {
  Range get listRange => Range.fromLength(length);
}
