enum ArticleCategoryType {
  TOP("🔥 실시간 HOT", "TOP"),
  DAILY("💫 오늘의 트렌드", "DAILY"),
  WEEKLY("⭐️ 이번주 인기", "WEEKLY"),
  MONTHLY("✨ 이달의 베스트", "MONTHLY"),
  ;

  final String value;
  final String apiValue;

  const ArticleCategoryType(this.value, this.apiValue);
}
