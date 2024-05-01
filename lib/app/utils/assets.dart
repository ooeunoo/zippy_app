class Assets {
  Assets._();

  static String env = '.env';

  // icons
  static const String logo = 'assets/icons/logo.svg';
  static const String home01 = 'assets/icons/home-01.svg';
  static const String user01 = 'assets/icons/user-01.svg';
  static const String search = 'assets/icons/search-md.svg';
  static const String bookmark = 'assets/icons/bookmark.svg';
  static const String bookmarkLine = 'assets/icons/bookmark-line.svg';
  static const String sliders04 = 'assets/icons/sliders-04.svg';
  static const String file02 = 'assets/icons/file-02.svg';
  static const String file06 = 'assets/icons/file-06.svg';
  static const String avatarDefault = 'assets/icons/avatar-default.svg';
  static const String message = 'assets/icons/message.svg';

  // images
  static const String humorunivLogo = 'assets/images/humoruniv.png';
  static const String dcinsideLogo = 'assets/images/dcinside.png';
  static const String ppomppuLogo = 'assets/images/ppomppu.png';
  static const String instizLogo = 'assets/images/instiz.png';
  static const String clienLogo = 'assets/images/clien.png';

  // animation
  static const String gestureSwipeUp = 'assets/animation/gesture_swipe_up.json';

  static String randomImage(String number) =>
      'https://source.unsplash.com/random/$number';
}
