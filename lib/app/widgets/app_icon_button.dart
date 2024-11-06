import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback? onPressed;
  final bool showBadge;
  final String? badgeText;
  final bool isActive;

  const AppIconButton({
    Key? key,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.iconColor,
    this.labelColor,
    this.onPressed,
    this.showBadge = false,
    this.badgeText,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: label != null ? 16 : 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor ??
                      AppColor.graymodern800.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: isActive
                          ? AppColor.rose500
                          : (iconColor ?? AppColor.graymodern200),
                    ),
                    if (label != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        label!,
                        style: TextStyle(
                          color: labelColor ?? AppColor.graymodern200,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showBadge)
          Positioned(
            top: -8,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColor.rose500,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeText ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
