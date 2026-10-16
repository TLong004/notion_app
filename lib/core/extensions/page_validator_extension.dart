extension PageValidatorExtension on String {
  static const int _maxTitleLength = 200;

  bool get isPageTitleValid => isNotEmpty && length <= _maxTitleLength;
}
