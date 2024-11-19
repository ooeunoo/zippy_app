import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/services/webview.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/utils/share.dart';
import 'package:zippy/app/utils/vibrates.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:zippy/domain/enum/article_view_type.enum.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/article_comment.model.dart';
import 'package:zippy/domain/model/params/create_article_comment.params.dart';
import 'package:zippy/domain/model/params/create_user_interaction.params.dart';
import 'package:zippy/domain/model/params/get_aritlces.params.dart';
import 'package:zippy/domain/model/params/get_recommend_aritlces.params.dart';
import 'package:zippy/domain/model/params/update_user_interaction.params.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:zippy/domain/usecases/create_article_comment.usecase.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/create_user_interaction.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_article_comments.usecase.dart';
import 'package:zippy/domain/usecases/get_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_recommend_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_sources.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_subscriptions.usecase.dart';
import 'package:zippy/domain/usecases/update_user_interaction.usecase.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_view.dart';

class ArticleService extends GetxService {
  final authService = Get.find<AuthService>();
  final webViewService = Get.find<WebViewService>();

  final GetSources getSources = Get.find();
  final GetArticles getArticles = Get.find();
  final GetRecommendedArticles getRecommendedArticles = Get.find();
  final SubscribeUserSubscriptions subscribeUserSubscriptions = Get.find();
  final CreateUserInteraction createUserInteraction = Get.find();
  final UpdateUserInteraction updateUserInteraction = Get.find();
  final SubscribeUserBookmark subscribeUserBookmark = Get.find();
  final CreateUserBookmark createUserBookmark = Get.find();
  final DeleteUserBookmark deleteUserBookmark = Get.find();
  final GetUserBookmark getUserBookmark = Get.find();
  final GetUserSubscriptions getUserSubscriptions = Get.find();
  final GetArticleComments getArticleComments = Get.find();
  final CreateArticleComment createArticleComment = Get.find();

  Rx<ArticleViewType> currentViewType = ArticleViewType.Summary.obs;
  RxBool isLoadingUserSubscription = RxBool(true).obs();
  RxMap<int, Source> sources = RxMap<int, Source>({}).obs();
  RxList<UserSubscription> userSubscriptions =
      RxList<UserSubscription>([]).obs();
  RxList<UserBookmark> userBookmarks = RxList<UserBookmark>([]).obs();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initialize();
  }

  ///*********************************
  /// Getter Methods
  ///*********************************
  bool isBookmarked(int itemId) {
    return userBookmarks.any((bookmark) => bookmark.id == itemId);
  }

  ///*********************************
  /// Public Methods
  ///*********************************
  Source? getSourceById(int sourceId) {
    Source? source = sources[sourceId];

    if (source != null) {
      return source;
    } else {
      return null;
    }
  }

  Future<List<Article>> onHandleFetchRecommendedArticles(
      GetRecommendedArticlesParams params) async {
    final result = await getRecommendedArticles.execute(params);
    return result.fold(
      (failure) {
        return [];
      },
      (data) {
        return data;
      },
    );
  }

  Future<List<Article>> onHandleFetchArticle() async {
    final result = await getArticles.execute(const GetArticlesParams(
      limit: 10,
    ));
    return result.fold(
      (failure) {
        return [];
      },
      (data) {
        return data;
      },
    );
  }

  Future<void> onHandleBookmarkArticle(Article article) async {
    UserBookmarkEntity entity = UserBookmark(
      id: article.id!,
      title: article.title,
      link: article.link,
      images: article.images[0],
    ).toCreateEntity();
    onHeavyVibration();
    if (isBookmarked(article.id!)) {
      await deleteUserBookmark.execute(entity);
    } else {
      await createUserBookmark.execute(entity);
    }
  }

  Future<List<ArticleComment>> onHandleGetArticleComments(int articleId) async {
    final result = await getArticleComments.execute(articleId);
    return result.fold((failure) {
      return [];
    }, (data) {
      return data;
    });
  }

  Future<void> onHandleCreateArticleComment(
      CreateArticleCommentParams params) async {
    await createArticleComment.execute(params);
    await createUserInteraction.execute(CreateUserInteractionParams(
      userId: authService.currentUser.value!.id,
      articleId: params.articleId,
      interactionType: InteractionType.Comment,
    ));
  }

  Future<void> onHandleShareArticle(Article article) async {
    await toShare(article.title, article.link);
    await onHandleCreateUserInteraction(article.id!, InteractionType.Share);
  }

  Future<void> onHandleCreateUserInteraction(
      int articleId, InteractionType type) async {
    await createUserInteraction.execute(CreateUserInteractionParams(
      userId: authService.currentUser.value!.id,
      articleId: articleId,
      interactionType: type,
    ));
  }

  void onHandleChangeViewType(ArticleViewType type) {
    currentViewType.value = type;
  }

  void onHandleGoToArticleView(Article article) async {
    final handleUpdateInteraction =
        await _createViewInteractionCallback(article.id!);

    Get.to(
      () => ZippyArticleView(
        article: article,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  void onHandleOpenOriginalArticle(Article article) async {
    webViewService.showWebView(article.link);
  }

  ///*********************************
  /// Private Methods
  ///*********************************
  Future<Function(int, int)?> _createViewInteractionCallback(
      int articleId) async {
    if (!authService.isLoggedIn.value) return null;

    final result = await createUserInteraction.execute(
      CreateUserInteractionParams(
        userId: authService.currentUser.value!.id,
        articleId: articleId,
        interactionType: InteractionType.View,
      ),
    );

    return result.fold(
      (failure) => null,
      (interaction) => (int readPercent, int readDuration) async {
        await updateUserInteraction.execute(UpdateUserInteractionParams(
          id: interaction.id!,
          readPercent: readPercent,
          readDuration: readDuration,
        ));
      },
    );
  }

  ///*********************************
  /// Initialization Methods
  ///*********************************
  ///
  Future<void> _initialize() async {
    await _setupSources();
    await _setupUserBookmark();
    await _setupUserSubscriptions();
    _listenUserBookmark();
  }

  Future<void> _setupSources() async {
    final result = await getSources.execute(withJoin: true);

    result.fold((failure) {
      sources.value = {};
    }, (data) {
      Map<int, Source> map = {};
      for (var source in data) {
        map = source.toIdAssign(map);
      }
      sources.assignAll(map);
    });
  }

  Future<void> _setupUserSubscriptions() async {
    isLoadingUserSubscription.value = true;
    final subscriptions = await getUserSubscriptions.execute();
    subscriptions.fold((failure) {
      userSubscriptions.value = [];
    }, (data) {
      userSubscriptions.assignAll(data);
    });
    isLoadingUserSubscription.value = false;
  }

  Future<void> _setupUserBookmark() async {
    final bookmarks = await getUserBookmark.execute();
    bookmarks.fold((failure) {
      userBookmarks.value = [];
    }, (data) {
      userBookmarks.assignAll(data);
    });
  }

  // void _listenUserSubscriptions() {
  //   if (user != null) {
  //     subscribeUserSubscriptions
  //         .execute(user!.id)
  //         .listen((List<UserSubscription> event) {
  //       userSubscriptions.bindStream(Stream.value(event));
  //     });
  //   }
  // }

  void _listenUserBookmark() {
    subscribeUserBookmark.execute().listen((List<UserBookmark> event) {
      userBookmarks.bindStream(Stream.value(event));
    });
  }
}