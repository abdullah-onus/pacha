class Range extends Iterable<int> {
  const Range(this.start, this.end) : assert(start <= end || end == -1);
  const Range.fromLength(int length) : this(0, length - 1);
  final int start;
  final int end;
  // ignore: annotate_overrides
  int get length => end - start + 1;
  @override
  Iterator<int> get iterator => Iterable.generate(length, (i) => start + i).iterator;
  @override
  // ignore: avoid_renaming_method_parameters
  bool contains(Object? index) {
    if (index == null || index is! int) return false;
    return index >= start && index <= end;
  }

  @override
  String toString() => '[$start, $end]';
}
