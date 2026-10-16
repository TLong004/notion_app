class PageRules {
  const PageRules._();

  static const int maxTitleLength = 200;

  static bool isValidTitle(String title) => title.isNotEmpty && title.length <= maxTitleLength;
}
