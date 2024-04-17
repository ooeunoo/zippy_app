import 'dart:async';
import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:cocomu/presentation/pages/board/transformer/transformer.dart';
import 'package:cocomu/presentation/pages/board/widgets/cocomu_card.dart';
import 'package:cocomu/presentation/pages/board/widgets/cocomu_webview.dart';
import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  const Board({
    super.key,
  });

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final PageController _pageController = PageController();
  final StreamController<int> _pageStreamController = StreamController<int>();

  List<Color> colors = [Colors.red, Colors.blue, Colors.yellow, Colors.green];
  @override
  void dispose() {
    _pageController.dispose();
    _pageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('페이지 뷰'),
        ),
        body: TransformerPageView(
            scrollDirection: Axis.vertical,
            curve: Curves.easeInBack,
            transformer: DeepthPageTransformer(),
            pageSnapping: true,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data = mock[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CocomuWebview(
                                uri:
                                    'https://gall.dcinside.com/board/view/?id=dcbest&no=223850&_dcbest=1&page=1',
                              )));
                },
                child: CocomuCard(
                    urlImage: data['image'],
                    title: data['title'],
                    subtitle: data['subtitle']),
              );
            },
            itemCount: 3));
  }
}

List<Map<String, dynamic>> mock = [
  {
    "image":
        "https://cdn.pixabay.com/photo/2020/05/25/17/10/french-bulldog-5219522_1280.jpg",
    "title": "이제와서 딩크 해제하자는 와이프",
    "subtitle": "헮어런ㅇㅁㄹㅁㅇㄴ말ㅇㄴㅁㄹ",
    "author": "헤븐투헤븐",
    "numViews": 1006,
    "numRecommendations": 1200,
    "createdAt": "2022-01-02",
  },
  {
    "image":
        "https://media.istockphoto.com/id/1175647482/ko/%EC%82%AC%EC%A7%84/%EC%A7%91-%EC%95%88%ED%8C%8E%EC%97%90%EC%84%9C-%EB%86%80%EA%B3%A0-%ED%99%9C%EB%8F%99%ED%95%98%EB%8A%94-%EC%A0%8A%EC%9D%80-%EA%B0%95%EC%95%84%EC%A7%80-%ED%94%84%EB%A0%8C%EC%B9%98-%EB%B6%88%EB%8F%85-%EC%84%B8%ED%8A%B8.jpg?s=2048x2048&w=is&k=20&c=Oli_bJVLrLbYk6uWw5K6Ppw0aF3g83GP63w33Q3BH5E=",
    "title": "이제와서 딩크 해제하자는 와이프",
    "subtitle": "헮어런ㅇㅁㄹㅁㅇㄴ말ㅇㄴㅁㄹ",
    "author": "헤븐투헤븐",
    "numViews": 1006,
    "numRecommendations": 1200,
    "createdAt": "2022-01-02",
  },
  {
    "image":
        "https://media.istockphoto.com/id/1725496782/ko/%EC%82%AC%EC%A7%84/%ED%91%B8%EB%A5%B8-%EC%9E%94%EB%94%94-%EB%B0%B0%EA%B2%BD%EC%97%90-%EC%9E%AC%EB%AF%B8-%EC%9E%88%EC%9D%80-%EA%B0%88%EC%83%89-%ED%94%84%EB%9E%91%EC%8A%A4-%EB%B6%88%EB%8F%85.jpg?s=2048x2048&w=is&k=20&c=0Q0Cd4U2_QdWTtOd7kgF9Ugs6Nu-s9OAevU7a0oW8Zw=",
    "title": "이제와서 딩크 해제하자는 와이프",
    "subtitle": "헮어런ㅇㅁㄹㅁㅇㄴ말ㅇㄴㅁㄹ",
    "author": "헤븐투헤븐",
    "numViews": 1006,
    "numRecommendations": 1200,
    "createdAt": "2022-01-02",
  }
];
