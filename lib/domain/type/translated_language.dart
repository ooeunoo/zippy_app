class TranslatedLanguageMap {
  final String ko;
  final String en;

  const TranslatedLanguageMap({required this.en, required this.ko});

  factory TranslatedLanguageMap.fromJson(Map<String, dynamic> json) {
    return TranslatedLanguageMap(en: json['en'], ko: json['ko']);
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'ko': ko,
    };
  }
}
