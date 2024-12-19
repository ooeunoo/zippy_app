import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/services/bookmark.service.dart';
import 'package:zippy/app/services/webview.service.dart';
import 'package:zippy/app/utils/share.dart';
import 'package:zippy/app/utils/vibrates.dart';
import 'package:zippy/app/widgets/app_snak_bar.dart';
import 'package:zippy/app/widgets/app_dialog.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/enum/article_view_type.enum.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';
import 'package:zippy/domain/enum/platform_type.enum.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/article_comment.model.dart';
import 'package:zippy/domain/model/params/create_article_comment.params.dart';
import 'package:zippy/domain/model/params/create_bookmark_item.params.dart';
import 'package:zippy/domain/model/params/create_user_interaction.params.dart';
import 'package:zippy/domain/model/params/get_aritlces.params.dart';
import 'package:zippy/domain/model/params/get_random_articles.params.dart';
import 'package:zippy/domain/model/params/get_recommend_aritlces.params.dart';
import 'package:zippy/domain/model/params/update_user_interaction.params.dart';
import 'package:zippy/domain/model/source.model.dart';
import 'package:zippy/domain/model/user.model.dart';
import 'package:zippy/domain/model/user_interaction.model.dart';
import 'package:zippy/domain/usecases/create_article_comment.usecase.dart';
import 'package:zippy/domain/usecases/create_user_interaction.usecase.dart';
import 'package:zippy/domain/usecases/get_article_comments.usecase.dart';
import 'package:zippy/domain/usecases/get_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_random_articles.dart';
import 'package:zippy/domain/usecases/get_recommend_articles.usecase.dart';
import 'package:zippy/domain/usecases/get_sources.usecase.dart';
import 'package:zippy/domain/usecases/update_user_interaction.usecase.dart';
import 'package:zippy/presentation/board/page/widgets/bookmark_folder_modal.dart';
import 'package:zippy/presentation/board/page/widgets/bottom_support_menu.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_comment.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_news_view.dart';
import 'dart:async';

import 'package:zippy/presentation/board/page/widgets/zippy_article_youtube_view.dart';

class ArticleService extends GetxService {
  final provider = Get.find<SupabaseProvider>();
  final authService = Get.find<AuthService>();
  final webViewService = Get.find<WebViewService>();
  final bookmarkService = Get.find<BookmarkService>();

  final GetSources getSources = Get.find();
  final GetArticles getArticles = Get.find();
  final GetRandomArticles getRandomArticles = Get.find();
  final GetRecommendedArticles getRecommendedArticles = Get.find();
  final CreateUserInteraction createUserInteraction = Get.find();
  final UpdateUserInteraction updateUserInteraction = Get.find();

  final GetArticleComments getArticleComments = Get.find();
  final CreateArticleComment createArticleComment = Get.find();

  Rx<ArticleViewType> currentViewType = ArticleViewType.Summary.obs;
  RxMap<int, Source> sources = RxMap<int, Source>({}).obs();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initialize();
  }

  ///*********************************
  /// Public Methods
  ///*********************************
  Source? getSourceById(int sourceId) {
    Source? source = sources.value[sourceId];
    if (source != null) {
      return source;
    } else {
      return null;
    }
  }

  Future<List<Article>> onHandleFetchRandomArticles(
      GetRandomArticlesParams params) async {
    final result = await getRandomArticles.execute(params);
    return result.fold((failure) {
      return [];
    }, (data) {
      return data;
    });
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

  Future<List<Article>> onHandleFetchSearchArticles(
      GetSearchArticlesParams params) async {
    final result = await getArticles.execute(params);
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
    User? user = authService.currentUser.value;

    if (user == null) {
      showLoginDialog();
      return;
    }

    if (bookmarkService.isBookmarked(article.id!) != null) {
      bookmarkService.onHandleDeleteUserBookmark(
          bookmarkService.isBookmarked(article.id!)!.id);
      return;
    }

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      builder: (context) => BookmarkFolderModal(
        article: article,
        onFolderSelected: (folderId) async {
          CreateBookmarkItemParams entity = CreateBookmarkItemParams(
            userId: authService.currentUser.value!.id,
            articleId: article.id!,
            folderId: folderId,
          );
          await bookmarkService.onHandleCreateUserBookmark(entity);
        },
      ),
    );
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

  Future<UserInteraction?> onHandleCreateUserInteraction(
      Article article, InteractionType type) async {
    final result = await createUserInteraction.execute(
      CreateUserInteractionParams(
        userId: authService.currentUser.value!.id,
        articleId: article.id!,
        interactionType: type,
      ),
    );
    return result.fold((l) => null, (r) => r);
  }

  void onHandleChangeViewType(ArticleViewType type) {
    currentViewType.value = type;
  }

  void onHandleGoToArticleView(Article article) async {
    final handleUpdateInteraction =
        await _createViewInteractionCallback(article);

    final source = getSourceById(article.sourceId);
    final type = source!.platform!.type;

    final view = type == PlatformType.News
        ? ZippyArticleNewsView(
            article: article, handleUpdateInteraction: handleUpdateInteraction)
        : ZippyArticleYoutubeView(article: article);

    Get.to(
      () => view,
      transition: Transition.rightToLeftWithFade,
    );
  }

  void onHandleShowArticleComment(Article article) {
    showCommentBottomSheet(
      Get.context!,
      article.id!,
      onHandleGetArticleComments,
      onHandleCreateArticleComment,
    );
  }

  void onHandleOpenOriginalArticle(Article article) async {
    webViewService.showWebView(article.link);
  }

  Future<void> onHandleArticleSupportMenu(Article article) async {
    onHeavyVibration();
    Get.bottomSheet(Obx(() => BottomSupportMenu(
          article: article,
          originalArticle: () => onHandleOpenOriginalArticle(article),
          isBookmarked: bookmarkService.isBookmarked(article.id!) != null,
          bookmark: () => _handleUserAction(
            requiredLoggedIn: true,
            action: () async {
              final bookmark = bookmarkService.isBookmarked(article.id!);
              if (bookmark != null) {
                await bookmarkService.onHandleDeleteUserBookmark(bookmark.id);
              } else {
                await onHandleBookmarkArticle(article);
                await onHandleCreateUserInteraction(
                    article, InteractionType.Bookmark);
              }
            },
          ),
          share: () => _handleUserAction(
            requiredLoggedIn: false,
            action: () async {
              await toShare(article.title, article.link);
              await onHandleCreateUserInteraction(
                  article, InteractionType.Share);
            },
          ),
          report: () => _handleUserAction(
            requiredLoggedIn: true,
            action: () async {
              await onHandleCreateUserInteraction(
                  article, InteractionType.Report);
              notifyReported();
            },
          ),
        )));
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

    if (result == null) return null;

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
    if (requiredLoggedIn && !isLoggedIn) {
      showLoginDialog();
      return;
    }
    await action();
  }

  ///*********************************
  /// Initialization Methods
  ///*********************************
  Future<void> _initialize() async {
    await _setupSources();
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
}
