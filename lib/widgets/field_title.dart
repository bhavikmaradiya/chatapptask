import 'package:chatapp/const/dimens.dart';
import 'package:chatapp/enums/color_enums.dart';
import 'package:chatapp/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FieldTitle extends StatelessWidget {
  final String title;
  final ColorEnums textColorEnum;

  const FieldTitle({
    required this.title,
    super.key,
    this.textColorEnum = ColorEnums.gray6CColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: ColorUtils.getColor(
          context,
          textColorEnum,
        ),
        fontSize: Dimens.dimens_14.sp,
      ),
    );
  }
}
