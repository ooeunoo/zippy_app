import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/dimens.dart';
import 'package:zippy/app/styles/font.dart';
import 'package:zippy/app/styles/theme.dart';

class AppTextInput extends StatefulWidget {
  final String? hintText;
  final TextStyle? hintTextStyle;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? prefixText;
  final Widget? prefix;
  final String? suffixText;
  final Widget? suffix;
  final TextInputType? inputType;
  final TapRegionCallback? onTapOutside;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final FocusNode? focusNode;

  const AppTextInput({
    super.key,
    this.onChanged,
    this.hintText,
    this.hintTextStyle,
    this.prefix,
    this.suffix,
    this.prefixText,
    this.suffixText,
    this.inputType = TextInputType.text,
    this.onTapOutside,
    this.initialValue,
    this.controller,
    this.textInputAction,
    this.autofocus = true,
    this.focusNode,
  });

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.size(12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.size(12)),
        border: Border.all(
          color: _isFocused
              ? AppThemeColors.buttonBorderColor(context).withOpacity(0.8)
              : AppThemeColors.buttonBorderColor(context).withOpacity(0.4),
          width: _isFocused ? 2.0 : 1.5,
        ),
        color: AppThemeColors.background(context),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textLow(context).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          if (widget.prefix != null) ...[
            widget.prefix!,
            SizedBox(width: AppDimens.width(8)),
          ],
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              onTapOutside: widget.onTapOutside,
              autofocus: widget.autofocus,
              focusNode: _focusNode,
              initialValue: widget.initialValue,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              textAlignVertical: TextAlignVertical.center,
              style: Theme.of(context).textTheme.textMD.copyWith(
                    color: AppThemeColors.textHigh(context),
                    fontWeight: AppFontWeight.regular,
                  ),
              cursorHeight: AppDimens.height(16),
              cursorColor: AppThemeColors.textMedium(context),
              keyboardType: widget.inputType,
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                prefixText: widget.prefixText,
                alignLabelWithHint: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimens.height(12),
                ),
                hintText: widget.hintText,
                hintStyle: widget.hintTextStyle ??
                    Theme.of(context).textTheme.textMD.copyWith(
                          color:
                              AppThemeColors.textLow(context).withOpacity(0.5),
                          fontWeight: AppFontWeight.regular,
                        ),
                suffixText: widget.suffixText,
                suffixStyle: Theme.of(context).textTheme.textMD.copyWith(
                      color: AppThemeColors.textHigh(context),
                      fontWeight: AppFontWeight.regular,
                    ),
              ),
            ),
          ),
          if (widget.suffix != null) ...[
            SizedBox(width: AppDimens.width(8)),
            widget.suffix!,
          ],
        ],
      ),
    );
  }
}
