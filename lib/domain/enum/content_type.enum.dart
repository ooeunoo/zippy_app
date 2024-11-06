
enum ContentType {
  Politics("정치", "정치 관련 뉴스와 분석", "assets/images/politics.png"),
  Economy("경제", "경제, 금융, 시장 동향", "assets/images/economy.png"),
  International("국제", "세계 뉴스와 국제 관계", "assets/images/international.png"),
  Technology("기술", "IT, 신기술, 디지털 트렌드", "assets/images/technology.png"),
  Science("과학", "과학 발견과 연구 동향", "assets/images/science.png"),
  Health("건강", "건강, 의학, 웰빙 정보", "assets/images/health.png"),
  Environment("환경", "환경 보호와 기후 변화", "assets/images/environment.png"),
  Weather("날씨", "일기 예보와 기상 정보", "assets/images/weather.png"),
  Education("교육", "교육 정책과 학습 정보", "assets/images/education.png"),
  Culture("문화", "문화, 예술, 라이프스타일", "assets/images/culture.png"),
  Sports("스포츠", "스포츠 경기와 선수 소식", "assets/images/sports.png"),
  Entertainment("연예", "연예인과 엔터테인먼트", "assets/images/entertainment.png"),
  Business("비즈니스", "기업과 산업 동향", "assets/images/business.png"),
  Society("사회", "사회 이슈와 현상", "assets/images/society.png"),
  Crime("범죄", "사건, 사고, 법률 소식", "assets/images/crime.png"),
  Travel("여행", "여행지와 관광 정보", "assets/images/travel.png"),
  RealEstate("부동산", "부동산 시장과 주거 정보", "assets/images/realestate.png"),
  ;

  final String title;
  final String description;
  final String image;

  const ContentType(this.title, this.description, this.image);
}
