import 'package:chatapp/const/dimens.dart';
import 'package:chatapp/enums/color_enums.dart';
import 'package:chatapp/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFilledButton extends StatelessWidget {
  final String title;
  final void Function() onButtonPressed;
  final bool enabled;
  final Color? backgroundColor;
  final Color? textColor;

  const AppFilledButton({
    required this.title,
    required this.onButtonPressed,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Dimens.dimens_50.h,
      child: FilledButton(
        onPressed: enabled ? onButtonPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ??
              ColorUtils.getColor(
                context,
                enabled ? ColorEnums.black33Color : ColorEnums.grayEAColor,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                Dimens.dimens_5.r,
              ),
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor ??
                ColorUtils.getColor(
                  context,
                  enabled ? ColorEnums.whiteColor : ColorEnums.grayA8Color,
                ),
            fontWeight: FontWeight.w700,
            fontSize: Dimens.dimens_14.sp,
          ),
        ),
      ),
    );
  }
}
