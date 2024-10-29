import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Function()? onLeadingPressed;

  const AppHeader({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColor.transparent,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppDimens.height(64),
          child: Row(
            children: [
              _buildLeading(),
              if (title != null)
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.width(20)),
                    child: title!,
                  ),
                ),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (leading != null) {
      return leading!;
    }

    if (automaticallyImplyLeading && Get.previousRoute.isNotEmpty) {
      return IconButton(
        padding: EdgeInsets.only(left: AppDimens.size(20)),
        icon: const Icon(Icons.arrow_back, color: AppColor.gray50),
        onPressed: onLeadingPressed ?? () => Get.back(),
        splashRadius: 24,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      );
    }

    return const SizedBox(width: 56);
  }

  Widget _buildActions() {
    if (actions == null || actions!.isEmpty) {
      return const SizedBox(width: 56);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions!,
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(
        AppDimens.height(64) + MediaQuery.of(Get.context!).padding.top);
  }
}
