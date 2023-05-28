enum ItemType {
  computer;

  @override
  String toString() => name;

  String get str => toString();

  List<int> get searchCols {
    switch (this) {
      case computer:
        return [1, 2, 5];
      default:
        return [];
    }
  }

  static List<ItemType> searchable() {
    return [computer];
  }
}
