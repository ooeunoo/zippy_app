import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/services/appmetadata.service.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';
import 'package:zippy/app/widgets/app_spacer_v.dart';
import 'package:zippy/app/widgets/app_text.dart';

class DrawerGuideOverlay extends StatefulWidget {
  const DrawerGuideOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<DrawerGuideOverlay> createState() => _DrawerGuideOverlayState();
}

class _DrawerGuideOverlayState extends State<DrawerGuideOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _edgeAnimation;
  final AppMetadataService _appMetadataService = Get.find();
  bool _showGuide = false;
  bool _isInitialCheck = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initGuideCheck();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 30.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 30.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.0),
        weight: 20.0,
      ),
    ]).animate(_controller);

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 60.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.7)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20.0,
      ),
    ]).animate(_controller);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.98)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30.0,
      ),
    ]).animate(_controller);

    _edgeAnimation = Tween<double>(
      begin: 0.0,
      end: 30.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));
  }

  Future<void> _initGuideCheck() async {
    if (!_isInitialCheck) return;
    _isInitialCheck = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasSeenGuide =
          await _appMetadataService.getOnBoardingBoardPageStatus();
      print('Initial guide check - Has seen guide: $hasSeenGuide');

      if (!hasSeenGuide && mounted) {
        setState(() {
          _showGuide = true;
        });
        _controller.repeat();

        // Update the status and stop animation after delay
        Future.delayed(const Duration(milliseconds: 3500), () async {
          if (!mounted) return;

          final result =
              await _appMetadataService.updateOnBoardingBoardPage(status: true);
          result.fold(
              (failure) => print('Failed to update guide status: $failure'),
              (_) => print('Successfully updated guide status'));

          _controller.stop();
          if (mounted) {
            setState(() {
              _showGuide = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showGuide) ...[
          // 반투명 오버레이
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5),
          ),
          // 드로어 힌트 효과
          AnimatedBuilder(
            animation: _edgeAnimation,
            builder: (context, child) {
              return Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: _edgeAnimation.value,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // 가이드 메시지
          Positioned(
            left: AppDimens.width(24),
            top: MediaQuery.of(context).size.height * 0.2,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_animation.value, 0),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: child,
                    ),
                  ),
                );
              },
              child: Container(
                constraints: BoxConstraints(
                    // maxWidth: MediaQuery.of(context).size.width * 0.4,
                    ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.width(24),
                  vertical: AppDimens.height(24),
                ),
                decoration: BoxDecoration(
                  color: AppThemeColors.background(context),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimens.height(12),
                        horizontal: AppDimens.width(12),
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.brand600.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.swipe_right_rounded, // 아이콘 변경
                        size: AppDimens.size(32),
                        color: AppThemeColors.iconHighlight(context),
                      ),
                    ),
                    AppSpacerV(value: AppDimens.height(12)),
                    AppText(
                      '오른쪽으로 스와이프하여', // 텍스트 변경
                      style: Theme.of(context).textTheme.textMD.copyWith(
                            color: AppThemeColors.textHighest(context),
                            fontWeight: AppFontWeight.semibold,
                          ),
                    ),
                    AppText(
                      '메뉴를 열어보세요!',
                      style: Theme.of(context).textTheme.textMD.copyWith(
                            color: AppThemeColors.textHighest(context),
                            fontWeight: AppFontWeight.semibold,
                          ),
                    ),
                    AppSpacerV(value: AppDimens.height(12)),
                    AppText(
                      '게시글 목록과 북마크를\n확인할 수 있어요',
                      style: Theme.of(context).textTheme.textSM.copyWith(
                            color: AppThemeColors.textLow(context),
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
