import 'package:chatapp/const/dimens.dart';
import 'package:chatapp/enums/color_enums.dart';
import 'package:chatapp/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FieldBorderDecoration {
  static InputDecoration fieldBorderDecoration(
    BuildContext context, {
    double contentPadding = 0,
    ColorEnums fillColor = ColorEnums.whiteColor,
    ColorEnums borderColor = ColorEnums.grayE0Color,
    bool isMultiLine = false,
    Widget? suffixIcon,
    String? hint,
    TextStyle? hintStyle,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: hintStyle,
      fillColor: ColorUtils.getColor(
        context,
        fillColor,
      ),
      enabledBorder: _fieldBorder(
        context,
        borderColor: borderColor,
      ),
      disabledBorder: _fieldBorder(
        context,
        borderColor: borderColor,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorUtils.getColor(
            context,
            ColorEnums.black33Color,
          ),
          width: Dimens.dimens_1.w,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: contentPadding.w,
        vertical: isMultiLine ? contentPadding.h : 0,
      ),
      suffixIcon: suffixIcon,
      filled: true,
    );
  }

  static OutlineInputBorder _fieldBorder(
    BuildContext context, {
    ColorEnums borderColor = ColorEnums.grayE0Color,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimens.dimens_5.r,
        ),
      ),
      borderSide: BorderSide(
        color: ColorUtils.getColor(
          context,
          borderColor,
        ),
        width: Dimens.dimens_1.w,
      ),
    );
  }
}
