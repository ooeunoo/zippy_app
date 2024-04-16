import 'package:cocomu/data/providers/bobaedream/bobaedream.dart';
import 'package:cocomu/data/providers/dcinside/dcinside.dart';
import 'package:cocomu/data/providers/dcinside/dcinside_category.dart';
import 'package:cocomu/data/providers/ppomppu/ppomppu.dart';
import 'package:cocomu/data/repositories/community_repository_impl.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as html_parser;

void main() {
  group('BobaedreamAPI 테스트', () {
    test('getArticle 호출 테스트', () async {
      final api = BobaedreamAPI();
      const category = 'best';
      const page = 733982;

      // 테스트할 때 주석을 해제하고, 로컬 서버가 실행 중이어야 합니다.
      final result = await api.getArticle(category, page);
      print(result);
    });
  });
}
