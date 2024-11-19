import 'package:get/get.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/services/webview.service.dart';
import 'package:zippy/app/utils/share.dart';
import 'package:zippy/app/utils/vibrates.dart';
import 'package:zippy/app/widgets/app.snak_bar.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
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
import 'package:zippy/domain/usecases/create_article_comment.usecase.dart';
import 'package:zippy/domain/usecases/create_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/create_user_interaction.usecase.dart';
import 'package:zippy/domain/usecases/delete_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/get_article_comments.usecase.dart';
import 'package:zippy/domain/usecases/get_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_recommend_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_sources.usecase.dart';
import 'package:zippy/domain/usecases/get_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/subscirbe_user_bookmark.usecase.dart';
import 'package:zippy/domain/usecases/update_user_interaction.usecase.dart';
import 'package:zippy/presentation/board/page/widgets/bottom_extension_menu.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_view.dart';
import 'dart:async';

class ArticleService extends GetxService {
  final provider = Get.find<SupabaseProvider>();
  final authService = Get.find<AuthService>();
  final webViewService = Get.find<WebViewService>();

  final GetSources getSources = Get.find();
  final GetArticles getArticles = Get.find();
  final GetRecommendedArticles getRecommendedArticles = Get.find();
  final CreateUserInteraction createUserInteraction = Get.find();
  final UpdateUserInteraction updateUserInteraction = Get.find();
  final SubscribeUserBookmark subscribeUserBookmark = Get.find();
  final CreateUserBookmark createUserBookmark = Get.find();
  final DeleteUserBookmark deleteUserBookmark = Get.find();
  final GetUserBookmark getUserBookmark = Get.find();
  final GetArticleComments getArticleComments = Get.find();
  final CreateArticleComment createArticleComment = Get.find();

  Rx<ArticleViewType> currentViewType = ArticleViewType.Summary.obs;
  RxMap<int, Source> sources = RxMap<int, Source>({}).obs();
  RxList<UserBookmark> userBookmarks = RxList<UserBookmark>([]).obs();

  StreamSubscription? _userBookmarksSubscription;
  StreamSubscription? _authUserSubscription;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initialize();
  }

  @override
  void onClose() {
    _authUserSubscription?.cancel();
    super.onClose();
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
    await onHandleCreateUserInteraction(article, InteractionType.Share);
  }

  Future<Article> onHandleCreateUserInteraction(
      Article article, InteractionType type) async {
    try {
      article.copyWithOptimisticUpdate(type, increment: true);

      final result = await createUserInteraction.execute(
        CreateUserInteractionParams(
          userId: authService.currentUser.value!.id,
          articleId: article.id!,
          interactionType: type,
        ),
      );
      return result.fold((failure) => article, (data) => article);
    } catch (e) {
      article.copyWithOptimisticUpdate(type, increment: false);
      rethrow;
    }
  }

  void onHandleChangeViewType(ArticleViewType type) {
    currentViewType.value = type;
  }

  void onHandleGoToArticleView(Article article) async {
    final handleUpdateInteraction =
        await _createViewInteractionCallback(article);

    Get.to(
      () => ZippyArticleView(
        article: article,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  void onHandleOpenOriginalArticle(Article article) async {
    Get.back(); // bottomSheet 닫기
    // 약간의 딜레이를 주어 bottomSheet가 완전히 닫힌 후 다이얼로그 표시
    Future.delayed(const Duration(milliseconds: 100), () {
      webViewService.showWebView(article.link);
    });
  }

  Future<void> onHandleArticleSupportMenu(Article article) async {
    onHeavyVibration();
    Get.bottomSheet(BottomExtensionMenu(
      article: article,
      openOriginalArticle: () => onHandleOpenOriginalArticle(article),
      share: () => _handleUserAction(
        requiredLoggedIn: false,
        action: () async {
          await toShare(article.title, article.link);
          await onHandleCreateUserInteraction(article, InteractionType.Share);
        },
      ),
      report: () => _handleUserAction(
        requiredLoggedIn: true,
        action: () async {
          await onHandleCreateUserInteraction(article, InteractionType.Report);
          notifyReported();
        },
      ),
    ));
  }

  ///*********************************
  /// Private Methods
  ///*********************************
  Future<Function(int, int)?> _createViewInteractionCallback(
      Article article) async {
    if (!authService.isLoggedIn.value) return null;

    final result = await onHandleCreateUserInteraction(
      article,
      InteractionType.View,
    );

    updateInteraction(int readPercent, int readDuration) async {
      await updateUserInteraction.execute(
        UpdateUserInteractionParams(
          id: result.id!,
          readPercent: readPercent,
          readDuration: readDuration,
        ),
      );
    }

    return updateInteraction;
  }

  Future<void> _handleUserAction({
    required bool requiredLoggedIn,
    required Future<void> Function() action,
  }) async {
    bool isLoggedIn = authService.isLoggedIn.value;
    // requiredLoggedIn가 true이고 로그인이 되어있지 않으면 로그인 다이얼로그 표시
    if (!requiredLoggedIn && !isLoggedIn) {
      Get.back(); // bottomSheet 닫기
      // 약간의 딜레이를 주어 bottomSheet가 완전히 닫힌 후 다이얼로그 표시
      Future.delayed(const Duration(milliseconds: 100), () {
        showLoginDialog();
      });
      return;
    }
    await action();
  }

  ///*********************************
  /// Initialization Methods
  ///*********************************
  ///
  Future<void> _initialize() async {
    await _setupSources();
    await _setupUserBookmark();
    _setupSubscriptions();
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

  Future<void> _setupUserBookmark() async {
    final bookmarks = await getUserBookmark.execute();
    bookmarks.fold((failure) {
      userBookmarks.value = [];
    }, (data) {
      userBookmarks.assignAll(data);
    });
  }

  void _listenUser() {
    _authUserSubscription = authService.currentUser.listen((user) {
      _cancelSubscriptions();
      if (user != null) {
        _setupSubscriptions();
      }
    });
  }

  void _setupSubscriptions() {
    _userBookmarksSubscription =
        subscribeUserBookmark.execute().listen((List<UserBookmark> event) {
      userBookmarks.bindStream(Stream.value(event));
    });
  }

  void _cancelSubscriptions() {
    _userBookmarksSubscription?.cancel();
    _userBookmarksSubscription = null;
  }
}
