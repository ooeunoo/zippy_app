enum BobaedreamCategory {
  // 스페셜
  best('베스트 글', '/best'),
  // yusik('김유식 대표 에세이'),
  // event_voicere('보이스 리플'),
  // dclottery('디시 로터리'),
  // dc_research('디시설문'),
  // gaejukinft('개죽이 NFT'),
  // hit('HIT'),

  // AI 이미지

  ;

  const BobaedreamCategory(this.name, this.path);

  final String name;
  final String path;
}
