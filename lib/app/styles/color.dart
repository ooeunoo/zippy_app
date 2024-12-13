import 'package:flutter/material.dart';

class AppThemeColors {
  static final instance = AppThemeColors._();
  AppThemeColors._();

  static bool isDarkMode(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  static Color transparent(BuildContext context) => AppColor.transparent;

  static Color background(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern950 : AppColor.graymodern50;

  static Color bottomSheetBackground(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern900 : AppColor.graymodern50;

  static Color bottomSheetBorder(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern900 : AppColor.graymodern100;

  static Color bottomNavigationBarBorder(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern700 : AppColor.graymodern200;

  static Color bottomNavigationBarSelectedItem(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern100 : AppColor.graymodern900;

  static Color bottomNavigationBarUnselectedItem(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern600 : AppColor.graymodern400;

  static Color loadingColor(BuildContext context) => AppColor.brand600;

  static Color iconColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern100 : AppColor.graymodern600;

  static Color iconHighlight(BuildContext context) =>
      isDarkMode(context) ? AppColor.brand300 : AppColor.brand700;

  static Color dividerColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern700 : AppColor.graymodern300;

  static Color articleItemBoxBackgroundColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern900 : AppColor.graytrue25;

  static Color articleItemBoxBorderColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern800 : AppColor.graymodern200;

  static Color bookmarkedIconColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.brand500 : AppColor.brand500;

  static Color summaryButtonColor(BuildContext context) => isDarkMode(context)
      ? AppColor.brand700.withOpacity(0.55)
      : AppColor.brand200.withOpacity(0.55);

  static Color summaryButtonBorderColor(BuildContext context) =>
      isDarkMode(context)
          ? AppColor.brand400.withOpacity(0.2)
          : AppColor.brand600.withOpacity(0.2);

  static Color summaryButtonIconColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.brand300 : AppColor.brand700;

  static Color summaryButtonTextColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.brand300 : AppColor.brand700;

  static Color buttonBackgroundColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.brand600 : AppColor.brand600;

  static Color buttonBorderColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.brand700 : AppColor.brand700;

  static Color buttonDisableBackgroundColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.gray200 : AppColor.gray200;

  static Color buttonDisableBorderColor(BuildContext context) =>
      isDarkMode(context) ? AppColor.gray300 : AppColor.gray300;

  static Color textHighest(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern100 : AppColor.graymodern900;

  static Color textHighestHighlight(BuildContext context) =>
      isDarkMode(context) ? AppColor.brand300 : AppColor.brand700;

  static Color textHigh(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern200 : AppColor.graymodern800;

  static Color textMedium(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern300 : AppColor.graymodern700;

  static Color textMediumHighlight(BuildContext context) =>
      isDarkMode(context) ? AppColor.brand300 : AppColor.brand700;

  static Color textLow(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern400 : AppColor.graymodern600;

  static Color textLowest(BuildContext context) =>
      isDarkMode(context) ? AppColor.graymodern500 : AppColor.graymodern500;
}

abstract class AppColor {
  AppColor._();

  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);

  static const Color gray25 = Color(0xffFCFCFD);
  static const Color gray50 = Color(0xffF9FAFB);
  static const Color gray100 = Color(0xffF2F4F7);
  static const Color gray200 = Color(0xffEAECF0);
  static const Color gray300 = Color(0xffD0D5DD);
  static const Color gray400 = Color(0xff98A2B3);
  static const Color gray500 = Color(0xff667085);
  static const Color gray600 = Color(0xff475467);
  static const Color gray700 = Color(0xff344054);
  static const Color gray800 = Color(0xff182230);
  static const Color gray900 = Color(0xff101828);

  // static const Color brand25 = Color(0xffFCFAFF);
  // static const Color brand50 = Color(0xffF9F5FF);
  // static const Color brand100 = Color(0xffF4EBFF);
  // static const Color brand200 = Color(0xffE9D7FE);
  // static const Color brand300 = Color(0xffD6BBFB);
  // static const Color brand400 = Color(0xffB692F6);
  // static const Color brand500 = Color(0xff9E77ED);
  // static const Color brand600 = Color(0xff7F56D9);
  // static const Color brand700 = Color(0xff6941C6);
  // static const Color brand800 = Color(0xff53389E);
  // static const Color brand900 = Color(0xff42307D);

  static const Color error25 = Color(0xffFFFBFA);
  static const Color error50 = Color(0xffFEF3F2);
  static const Color error100 = Color(0xffFEE4E2);
  static const Color error200 = Color(0xffFECDCA);
  static const Color error300 = Color(0xffFDA29B);
  static const Color error400 = Color(0xffF97066);
  static const Color error500 = Color(0xffF04438);
  static const Color error600 = Color(0xffD92D20);
  static const Color error700 = Color(0xffB42318);
  static const Color error800 = Color(0xff912018);
  static const Color error900 = Color(0xff7A271A);
  static const Color error950 = Color(0xff55160C);

  static const Color warning25 = Color(0xffFFFCF5);
  static const Color warning50 = Color(0xffFFFAEB);
  static const Color warning100 = Color(0xffFEF0C7);
  static const Color warning200 = Color(0xffFEDF89);
  static const Color warning300 = Color(0xffFEC84B);
  static const Color warning400 = Color(0xffFDB022);
  static const Color warning500 = Color(0xffF79009);
  static const Color warning600 = Color(0xffDC6803);
  static const Color warning700 = Color(0xffB54708);
  static const Color warning800 = Color(0xff93370D);
  static const Color warning900 = Color(0xff7A2E0E);
  static const Color warning950 = Color(0xff4E1D09);

  static const Color success25 = Color(0xffF6FEF9);
  static const Color success50 = Color(0xffECFDF3);
  static const Color success100 = Color(0xffDCFAE6);
  static const Color success200 = Color(0xffABEFC6);
  static const Color success300 = Color(0xff75E0A7);
  static const Color success400 = Color(0xff47CD89);
  static const Color success500 = Color(0xff17B26A);
  static const Color success600 = Color(0xff079455);
  static const Color success700 = Color(0xff067647);
  static const Color success800 = Color(0xff085D3A);
  static const Color success900 = Color(0xff074D31);
  static const Color success950 = Color(0xff053321);

  static const Color grayblue25 = Color(0xffFCFCFD);
  static const Color grayblue50 = Color(0xffF8F9FC);
  static const Color grayblue100 = Color(0xffEAECF5);
  static const Color grayblue200 = Color(0xffD5D9EB);
  static const Color grayblue300 = Color(0xffB3B8DB);
  static const Color grayblue400 = Color(0xff717BBC);
  static const Color grayblue500 = Color(0xff4E5BA6);
  static const Color grayblue600 = Color(0xff3E4784);
  static const Color grayblue700 = Color(0xff363F72);
  static const Color grayblue800 = Color(0xff293056);
  static const Color grayblue900 = Color(0xff101323);
  static const Color grayblue950 = Color(0xff0D0F1C);

  static const Color graycool25 = Color(0xffFCFCFD);
  static const Color graycool50 = Color(0xffF9F9FB);
  static const Color graycool100 = Color(0xffEFF1F5);
  static const Color graycool200 = Color(0xffDCDFEA);
  static const Color graycool300 = Color(0xffB9C0D4);
  static const Color graycool400 = Color(0xff7D89B0);
  static const Color graycool500 = Color(0xff5D6B98);
  static const Color graycool600 = Color(0xff4A5578);
  static const Color graycool700 = Color(0xff404968);
  static const Color graycool800 = Color(0xff30374F);
  static const Color graycool900 = Color(0xff111322);
  static const Color graycool950 = Color(0xff0E101B);

  static const Color graymodern25 = Color(0xffFCFCFD);
  static const Color graymodern50 = Color(0xffF8FAFC);
  static const Color graymodern100 = Color(0xffEEF2F6);
  static const Color graymodern200 = Color(0xffE3E8EF);
  static const Color graymodern300 = Color(0xffCDD5DF);
  static const Color graymodern400 = Color(0xff9AA4B2);
  static const Color graymodern500 = Color(0xff697586);
  static const Color graymodern600 = Color(0xff4B5565);
  static const Color graymodern700 = Color(0xff364152);
  static const Color graymodern800 = Color(0xff202939);
  static const Color graymodern900 = Color(0xff121926);
  static const Color graymodern950 = Color(0xff0D121C);

  static const Color grayneutral25 = Color(0xffFCFCFD);
  static const Color grayneutral50 = Color(0xffF9FAFB);
  static const Color grayneutral100 = Color(0xffF3F4F6);
  static const Color grayneutral200 = Color(0xffE5E7EB);
  static const Color grayneutral300 = Color(0xffD2D6DB);
  static const Color grayneutral400 = Color(0xff9DA4AE);
  static const Color grayneutral500 = Color(0xff6C737F);
  static const Color grayneutral600 = Color(0xff4D5761);
  static const Color grayneutral700 = Color(0xff384250);
  static const Color grayneutral800 = Color(0xff1F2A37);
  static const Color grayneutral900 = Color(0xff111927);
  static const Color grayneutral950 = Color(0xff0D121C);

  static const Color grayiron25 = Color(0xffFCFCFC);
  static const Color grayiron50 = Color(0xffFAFAFA);
  static const Color grayiron100 = Color(0xffFAF4F5);
  static const Color grayiron200 = Color(0xffE4E4E7);
  static const Color grayiron300 = Color(0xffD1D1D6);
  static const Color grayiron400 = Color(0xffA0A0AB);
  static const Color grayiron500 = Color(0xff70707B);
  static const Color grayiron600 = Color(0xff51525C);
  static const Color grayiron700 = Color(0xff3F3F46);
  static const Color grayiron800 = Color(0xff26272B);
  static const Color grayiron900 = Color(0xff18181B);
  static const Color grayiron950 = Color(0xff131316);

  static const Color graytrue25 = Color(0xffFCFCFC);
  static const Color graytrue50 = Color(0xffFAFAFA);
  static const Color graytrue100 = Color(0xffF5F5F5);
  static const Color graytrue200 = Color(0xffE5E5E5);
  static const Color graytrue300 = Color(0xffD6D6D6);
  static const Color graytrue400 = Color(0xffA3A3A3);
  static const Color graytrue500 = Color(0xff737373);
  static const Color graytrue600 = Color(0xff525252);
  static const Color graytrue700 = Color(0xff424242);
  static const Color graytrue800 = Color(0xff292929);
  static const Color graytrue900 = Color(0xff141414);
  static const Color graytrue950 = Color(0xff0F0F0F);

  static const Color graywarn25 = Color(0xffFDFDFC);
  static const Color graywarn50 = Color(0xffFAFAF9);
  static const Color graywarn100 = Color(0xffF5F5F4);
  static const Color graywarn200 = Color(0xffE7E5E4);
  static const Color graywarn300 = Color(0xffD7D3D0);
  static const Color graywarn400 = Color(0xffA9A29D);
  static const Color graywarn500 = Color(0xff79716B);
  static const Color graywarn600 = Color(0xff57534E);
  static const Color graywarn700 = Color(0xff44403C);
  static const Color graywarn800 = Color(0xff292524);
  static const Color graywarn900 = Color(0xff1C1917);
  static const Color graywarn950 = Color(0xff171412);

  static const Color moss25 = Color(0xffFAFDF7);
  static const Color moss50 = Color(0xffF5FBEE);
  static const Color moss100 = Color(0xffE6F4D7);
  static const Color moss200 = Color(0xffCEEAB0);
  static const Color moss300 = Color(0xffACDC79);
  static const Color moss400 = Color(0xff86CB3C);
  static const Color moss500 = Color(0xff669F2A);
  static const Color moss600 = Color(0xff4F7A21);
  static const Color moss700 = Color(0xff3F621A);
  static const Color moss800 = Color(0xff335015);
  static const Color moss900 = Color(0xff2B4212);
  static const Color moss950 = Color(0xff1A280B);

  static const Color green25 = Color(0xffF6FEF9);
  static const Color green50 = Color(0xffEDFCF2);
  static const Color green100 = Color(0xffD3F8DF);
  static const Color green200 = Color(0xffAAF0C4);
  static const Color green300 = Color(0xff73E2A3);
  static const Color green400 = Color(0xff3CCB7F);
  static const Color green500 = Color(0xff16B364);
  static const Color green600 = Color(0xff099250);
  static const Color green700 = Color(0xff087443);
  static const Color green800 = Color(0xff095C37);
  static const Color green900 = Color(0xff084C2E);
  static const Color green950 = Color(0xff052E1C);

  static const Color teal25 = Color(0xffF6FEFC);
  static const Color teal50 = Color(0xffF0FDF9);
  static const Color teal100 = Color(0xffCCFBEF);
  static const Color teal200 = Color(0xff99F6E0);
  static const Color teal300 = Color(0xff5FE9D0);
  static const Color teal400 = Color(0xff2ED3B7);
  static const Color teal500 = Color(0xff15B79E);
  static const Color teal600 = Color(0xff0E9384);
  static const Color teal700 = Color(0xff107569);
  static const Color teal800 = Color(0xff125D56);
  static const Color teal900 = Color(0xff124E48);
  static const Color teal950 = Color(0xff0A2926);

// 부드러운 파란색 계열의 브랜드 컬러
// 라이트/다크 모드 모두에서 잘 보이는 부드러운 파란색 계열
  static const Color brand25 = Color(0xffF6FAFF); // 배경 - 라이트 모드의 미세한 강조
  static const Color brand50 = Color(0xffF0F7FF); // 라이트 모드 호버 배경
  static const Color brand100 = Color(0xffE3F1FF); // 연한 강조 배경
  static const Color brand200 = Color(0xffC7E2FF); // 밝은 강조 요소
  static const Color brand300 = Color(0xff94C6FF); // 중간 강조 (라이트 모드 텍스트 가능)
  static const Color brand400 = Color(0xff5AA5F5); // 진한 강조 (라이트 모드 주요 텍스트)
  static const Color brand500 = Color(0xff4289DB); // 메인 브랜드 컬러
  static const Color brand600 = Color(0xff3474C2); // 진한 강조
  static const Color brand700 = Color(0xff2860A9); // 다크 모드 텍스트
  static const Color brand800 = Color(0xff1E4B85); // 매우 진한 강조
  static const Color brand900 = Color(0xff153862); // 다크 모드 진한 텍스트
  static const Color brand950 = Color(0xff0F2847); // 가장 진한 강조
  static const Color cyan25 = Color(0xffF5FEFF);
  static const Color cyan50 = Color(0xffECFDFF);
  static const Color cyan100 = Color(0xffCFF9FE);
  static const Color cyan200 = Color(0xffA5F0FC);
  static const Color cyan300 = Color(0xff67E3F9);
  static const Color cyan400 = Color(0xff22CCEE);
  static const Color cyan500 = Color(0xff06AED4);
  static const Color cyan600 = Color(0xff088AB2);
  static const Color cyan700 = Color(0xff0E7090);
  static const Color cyan800 = Color(0xff155B75);
  static const Color cyan900 = Color(0xff164C63);
  static const Color cyan950 = Color(0xff0D2D3A);

  static const Color bluelight25 = Color(0xffF5FBFF);
  static const Color bluelight50 = Color(0xffF0F9FF);
  static const Color bluelight100 = Color(0xffE0F2FE);
  static const Color bluelight200 = Color(0xffB9E6FE);
  static const Color bluelight300 = Color(0xff7CD4FD);
  static const Color bluelight400 = Color(0xff36BFFA);
  static const Color bluelight500 = Color(0xff0BA5EC);
  static const Color bluelight600 = Color(0xff0086C9);
  static const Color bluelight700 = Color(0xff026AA2);
  static const Color bluelight800 = Color(0xff065986);
  static const Color bluelight900 = Color(0xff0B4A6F);
  static const Color bluelight950 = Color(0xff062C41);

  static const Color blue25 = Color(0xffF5FAFF);
  static const Color blue50 = Color(0xffEFF8FF);
  static const Color blue100 = Color(0xffD1E9FF);
  static const Color blue200 = Color(0xffB2DDFF);
  static const Color blue300 = Color(0xff84CAFF);
  static const Color blue400 = Color(0xff53B1FD);
  static const Color blue500 = Color(0xff2E90FA);
  static const Color blue600 = Color(0xff1570EF);
  static const Color blue700 = Color(0xff175CD3);
  static const Color blue800 = Color(0xff1849A9);
  static const Color blue900 = Color(0xff194185);
  static const Color blue950 = Color(0xff102A56);

  static const Color bluedark25 = Color(0xffF5F8FF);
  static const Color bluedark50 = Color(0xffEFF4FF);
  static const Color bluedark100 = Color(0xffD1E0FF);
  static const Color bluedark200 = Color(0xffB2CCFF);
  static const Color bluedark300 = Color(0xff84ADFF);
  static const Color bluedark400 = Color(0xff528BFF);
  static const Color bluedark500 = Color(0xff2970FF);
  static const Color bluedark600 = Color(0xff155EEF);
  static const Color bluedark700 = Color(0xff004EEB);
  static const Color bluedark800 = Color(0xff0040C1);
  static const Color bluedark900 = Color(0xff00359E);
  static const Color bluedark950 = Color(0xff002266);

  static const Color blueindigo25 = Color(0xffF5F8FF);
  static const Color blueindigo50 = Color(0xffEEF4FF);
  static const Color blueindigo100 = Color(0xffE0EAFF);
  static const Color blueindigo200 = Color(0xffC7D7FE);
  static const Color blueindigo300 = Color(0xffA4BCFD);
  static const Color blueindigo400 = Color(0xff8098F9);
  static const Color blueindigo500 = Color(0xff6172F3);
  static const Color blueindigo600 = Color(0xff444CE7);
  static const Color blueindigo700 = Color(0xff3538CD);
  static const Color blueindigo800 = Color(0xff2D31A6);
  static const Color blueindigo900 = Color(0xff2D3282);
  static const Color blueindigo950 = Color(0xff1F235B);

  static const Color violet25 = Color(0xffFBFAFF);
  static const Color violet50 = Color(0xffF5F3FF);
  static const Color violet100 = Color(0xffECE9FE);
  static const Color violet200 = Color(0xffDDD6FE);
  static const Color violet300 = Color(0xffC3B5FD);
  static const Color violet400 = Color(0xffA48AFB);
  static const Color violet500 = Color(0xff875BF7);
  static const Color violet600 = Color(0xff7839EE);
  static const Color violet700 = Color(0xff6927DA);
  static const Color violet800 = Color(0xff5720B7);
  static const Color violet900 = Color(0xff491C96);
  static const Color violet950 = Color(0xff2E125E);

  static const Color purple25 = Color(0xffFAFAFF);
  static const Color purple50 = Color(0xffF4F3FF);
  static const Color purple100 = Color(0xffEBE9FE);
  static const Color purple200 = Color(0xffD9D6FE);
  static const Color purple300 = Color(0xffBDB4FE);
  static const Color purple400 = Color(0xff9B8AFB);
  static const Color purple500 = Color(0xff7A5AF8);
  static const Color purple600 = Color(0xff6938EF);
  static const Color purple700 = Color(0xff5925DC);
  static const Color purple800 = Color(0xff4A1FB8);
  static const Color purple900 = Color(0xff3E1C96);
  static const Color purple950 = Color(0xff27115F);

  static const Color fuchsia25 = Color(0xffFEFAFF);
  static const Color fuchsia50 = Color(0xffFDF4FF);
  static const Color fuchsia100 = Color(0xffFBE8FF);
  static const Color fuchsia200 = Color(0xffF6D0FE);
  static const Color fuchsia300 = Color(0xffEEAAFD);
  static const Color fuchsia400 = Color(0xffE478FA);
  static const Color fuchsia500 = Color(0xffD444F1);
  static const Color fuchsia600 = Color(0xffBA24D5);
  static const Color fuchsia700 = Color(0xff9F1AB1);
  static const Color fuchsia800 = Color(0xff821890);
  static const Color fuchsia900 = Color(0xff6F1877);
  static const Color fuchsia950 = Color(0xff47104C);

  static const Color pink25 = Color(0xffFEF6FB);
  static const Color pink50 = Color(0xffFDF2FA);
  static const Color pink100 = Color(0xffFCE7F6);
  static const Color pink200 = Color(0xffFCCEEE);
  static const Color pink300 = Color(0xffFAA7E0);
  static const Color pink400 = Color(0xffF670C7);
  static const Color pink500 = Color(0xffEE46BC);
  static const Color pink600 = Color(0xffDD2590);
  static const Color pink700 = Color(0xffC11574);
  static const Color pink800 = Color(0xff9E165F);
  static const Color pink900 = Color(0xff851651);
  static const Color pink950 = Color(0xff4E0D30);

  static const Color rose25 = Color(0xffFFF5F6);
  static const Color rose50 = Color(0xffFFF1F3);
  static const Color rose100 = Color(0xffFFE4E8);
  static const Color rose200 = Color(0xffFECDD6);
  static const Color rose300 = Color(0xffFEA3B4);
  static const Color rose400 = Color(0xffFD6F8E);
  static const Color rose500 = Color(0xffF63D68);
  static const Color rose600 = Color(0xffE31B54);
  static const Color rose700 = Color(0xffC01048);
  static const Color rose800 = Color(0xffA11043);
  static const Color rose900 = Color(0xff89123E);
  static const Color rose950 = Color(0xff510B24);

  static const Color orangedark25 = Color(0xffFFF9F5);
  static const Color orangedark50 = Color(0xffFFF4ED);
  static const Color orangedark100 = Color(0xffFFE6D5);
  static const Color orangedark200 = Color(0xffFFD6AE);
  static const Color orangedark300 = Color(0xffFF9C66);
  static const Color orangedark400 = Color(0xffFF692E);
  static const Color orangedark500 = Color(0xffFF4405);
  static const Color orangedark600 = Color(0xffE62E05);
  static const Color orangedark700 = Color(0xffBC1B06);
  static const Color orangedark800 = Color(0xff97180C);
  static const Color orangedark900 = Color(0xff771A0D);
  static const Color orangedark950 = Color(0xff57130A);

  static const Color orange25 = Color(0xffFEFAF5);
  static const Color orange50 = Color(0xffFEF6EE);
  static const Color orange100 = Color(0xffFDEAD7);
  static const Color orange200 = Color(0xffF9DBAF);
  static const Color orange300 = Color(0xffF7B27A);
  static const Color orange400 = Color(0xffF38744);
  static const Color orange500 = Color(0xffEF6820);
  static const Color orange600 = Color(0xffE04F16);
  static const Color orange700 = Color(0xffB93815);
  static const Color orange800 = Color(0xff932F19);
  static const Color orange900 = Color(0xff772917);
  static const Color orange950 = Color(0xff511C10);

  static const Color yellow25 = Color(0xffFEFDF0);
  static const Color yellow50 = Color(0xffFEFBE8);
  static const Color yellow100 = Color(0xffFEF7C3);
  static const Color yellow200 = Color(0xffFEEE95);
  static const Color yellow300 = Color(0xffFDE272);
  static const Color yellow400 = Color(0xffFAC515);
  static const Color yellow500 = Color(0xffEAAA08);
  static const Color yellow600 = Color(0xffCA8504);
  static const Color yellow700 = Color(0xffA15C07);
  static const Color yellow800 = Color(0xff854A0E);
  static const Color yellow900 = Color(0xff713B12);
  static const Color yellow950 = Color(0xff542C0D);

  static const Color kakaoBackground = Color(0xffFEE500);
  static const Color googleBackground = Color(0xffffffff);
  static const Color naverBackground = Color(0xff03C75A);
}
