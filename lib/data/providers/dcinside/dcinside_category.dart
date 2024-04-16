enum DcinsideCategory {
  // 스페셜
  dcbest('실시간 베스트', '/dcbest'),
  // yusik('김유식 대표 에세이'),
  // event_voicere('보이스 리플'),
  // dclottery('디시 로터리'),
  // dc_research('디시설문'),
  // gaejukinft('개죽이 NFT'),
  // hit('HIT'),

  // AI 이미지

  ;

  const DcinsideCategory(this.name, this.path);

  final String name;
  final String path;
}
