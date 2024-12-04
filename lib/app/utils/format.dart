List<String> convertToStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  return [];
}

String cleanMarkdownText(String text) {
  // 이미지 마크다운 구문 제거
  final imagePattern = RegExp(r'!\[.*?\]\(.*?\)');
  String cleaned = text.replaceAll(imagePattern, '');

  // [언론사 기자명] 패턴 제거
  final reporterPattern = RegExp(r'\[.*?기자\]');
  cleaned = cleaned.replaceAll(reporterPattern, '');

  // 이메일 링크 제거
  final emailPattern = RegExp(r'\[.*?\]\(mailto:.*?\)');
  cleaned = cleaned.replaceAll(emailPattern, '');

  // 일반 링크 제거 [텍스트](URL)
  final linkPattern = RegExp(r'\[.*?\]\(.*?\)');
  cleaned = cleaned.replaceAll(linkPattern, '');

  // 불필요한 공백 정리
  cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

  return cleaned;
}
