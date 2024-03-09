import 'package:chatapp/const/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class RoomItemSkeleton extends StatelessWidget {
  const RoomItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.withOpacity(0.3),
      child: Container(
        margin: EdgeInsets.only(
          top: Dimens.dimens_20.h / 2,
          bottom: Dimens.dimens_20.h / 2,
          left: Dimens.dimens_20.w,
          right: Dimens.dimens_20.w,
        ),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                height: Dimens.dimens_62.w,
                width: Dimens.dimens_62.w,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: Dimens.dimens_13.w,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Dimens.dimens_100.w,
                    height: Dimens.dimens_15.h,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: Dimens.dimens_5.h,
                  ),
                  Container(
                    width: Dimens.dimens_100.w,
                    height: Dimens.dimens_15.h,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
