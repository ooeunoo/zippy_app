import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/auth.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/domain/enum/article_view_type.enum.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/params/create_user_interaction.params.dart';
import 'package:zippy/domain/model/params/update_user_interaction.params.dart';
import 'package:zippy/domain/usecases/create_user_interaction.usecase.dart';
import 'package:zippy/domain/usecases/update_user_interaction.usecase.dart';
import 'package:zippy/presentation/board/page/widgets/zippy_article_view.dart';

class ArticleService extends GetxService {
  final authService = Get.find<AuthService>();
  final CreateUserInteraction createUserInteraction = Get.find();
  final UpdateUserInteraction updateUserInteraction = Get.find();

  Rx<ArticleViewType> currentViewType = ArticleViewType.Keypoint.obs;

  void onHandleChangeViewType(ArticleViewType type) {
    currentViewType.value = type;
  }

  void showArticleViewModal(Article article) async {
    final handleUpdateInteraction = await _createViewInteraction(article.id!);

    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      elevation: 0,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        maxChildSize: 0.95,
        snap: true,
        snapSizes: const [0.95],
        builder: (context, scrollController) {
          return ClipRRect(
            // 추가
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
                decoration: const BoxDecoration(
                  color: AppColor.transparent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Obx(
                  () => ZippyArticleView(
                    scrollController: scrollController,
                    article: article,
                    handleUpdateUserInteraction: handleUpdateInteraction,
                    viewType: currentViewType.value, // 현재 뷰 타입 전달
                    onViewTypeChanged: onHandleChangeViewType, // 상태 변경 콜백 전달
                  ),
                )),
          );
        },
      ),
    );
  }

  Future<Function(int, int)?> _createViewInteraction(int articleId) async {
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
        await _handleUpdateUserInteraction(
          interaction.id!,
          readPercent,
          readDuration,
        );
      },
    );
  }

  Future<void> _handleUpdateUserInteraction(
      int id, int readPercent, int readDuration) async {
    await updateUserInteraction.execute(UpdateUserInteractionParams(
      id: id,
      readPercent: readPercent,
      readDuration: readDuration,
    ));
  }
}
