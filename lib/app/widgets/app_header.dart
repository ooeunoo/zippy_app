import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';

class AppHeaderWrap extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;

  const AppHeaderWrap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(AppDimens.height(64));
  }
}

class AppHeader extends StatelessWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Function()? onLeadingPressed;
  final bool noLeading;

  const AppHeader({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.onLeadingPressed,
    this.noLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppDimens.height(64),
          child: Row(
            children: [
              if (!noLeading) _buildLeading(context),
              if (title != null)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.width(20),
                    ),
                    child: noLeading
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: title!,
                          )
                        : Center(child: title!),
                  ),
                ),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading!;
    }
    if (automaticallyImplyLeading && Get.previousRoute.isNotEmpty) {
      return IconButton(
        padding: EdgeInsets.all(AppDimens.width(20)),
        icon: Icon(
          Icons.arrow_back,
          color: AppThemeColors.iconColor(context),
        ),
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
}
