extension ContextExtensions on String {
  bool get isStrictEmpty => isEmpty || trim() == "";
}
