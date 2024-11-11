import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/widgets/app_spacer_h.dart';

class AppMarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double width;
  final Duration speed;

  const AppMarqueeText({
    super.key,
    required this.text,
    required this.style,
    required this.width,
    this.speed = const Duration(milliseconds: 20),
  });

  @override
  _AppMarqueeTextState createState() => _AppMarqueeTextState();
}

class _AppMarqueeTextState extends State<AppMarqueeText> {
  late ScrollController _scrollController;
  Timer? _timer;
  bool _isOverflow = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  @override
  void didUpdateWidget(AppMarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.width != widget.width) {
      _checkOverflow();
    }
  }

  void _checkOverflow() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final bool newIsOverflow = textPainter.width > widget.width;
    if (newIsOverflow != _isOverflow) {
      setState(() {
        _isOverflow = newIsOverflow;
      });
      if (newIsOverflow) {
        _startMarquee();
      } else {
        _stopMarquee();
      }
    }
  }

  void _startMarquee() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.speed, (_) {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            _scrollController.offset + 2,
            duration: widget.speed,
            curve: Curves.linear,
          );
        }
      }
    });
  }

  void _stopMarquee() {
    _timer?.cancel();
    _timer = null;
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOverflow) {
      return SizedBox(
        width: widget.width,
        child: Text(
          widget.text,
          style: widget.style,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Row(
          children: [
            Text(widget.text, style: widget.style),
            AppSpacerH(value: AppDimens.width(20)),
            Text(widget.text, style: widget.style),
          ],
        ),
      ),
    );
  }
}
