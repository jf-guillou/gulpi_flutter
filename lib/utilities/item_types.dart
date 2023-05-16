enum ItemType {
  computer;

  @override
  String toString() => name[0].toUpperCase() + name.substring(1);

  get str => toString();
}
