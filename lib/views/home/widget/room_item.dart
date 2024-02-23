import 'package:chatapp/const/assets.dart';
import 'package:chatapp/const/dimens.dart';
import 'package:chatapp/enums/color_enums.dart';
import 'package:chatapp/enums/room_type_enums.dart';
import 'package:chatapp/utils/color_utils.dart';
import 'package:chatapp/views/auth/model/room.dart';
import 'package:chatapp/views/auth/model/user.dart';
import 'package:chatapp/views/home/room_bloc/room_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomItem extends StatelessWidget {
  final Room roomInfo;
  final String currentUserId;

  const RoomItem({
    required this.roomInfo,
    required this.currentUserId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final roomBlocProvider = BlocProvider.of<RoomBloc>(context);

    final isOneToOne = roomInfo.roomType == RoomTypeEnum.oneToOne.name;
    final receiverId = isOneToOne
        ? roomInfo.members
            ?.firstWhere(
              (element) => element.memberId != currentUserId,
            )
            .memberId
        : null;
    final roomName = roomInfo.roomName;
    final roomImage = roomInfo.roomImage;

    if (isOneToOne && receiverId != null) {
      StreamBuilder(
        stream: roomBlocProvider.buildStreamOfUser(receiverId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final receiverInfo = User.fromSnapshot(snapshot.data!);

            return _buildRoomChatItem(
              context,
              chatTitle: receiverInfo.name,
              profileAvatar: receiverInfo.photo,
            );
          }
          return const SizedBox();
        },
      );
    }
    return _buildRoomChatItem(
      context,
      chatTitle: roomName,
      profileAvatar: roomImage,
    );
  }

  Widget _buildRoomChatItem(
    BuildContext context, {
    required String? chatTitle,
    String? profileAvatar,
  }) {
    final isImageAvailable = (profileAvatar ?? '').trim().isNotEmpty;
    return InkWell(
      onTap: () {},
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
              child: SizedBox.fromSize(
                size: Size(
                  Dimens.dimens_62.h,
                  Dimens.dimens_62.h,
                ), // Image radius
                child: Image.network(
                  isImageAvailable ? profileAvatar! : Assets.userPlaceholder,
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, __) {
                    return Image.asset(
                      Assets.userPlaceholder,
                      fit: BoxFit.cover,
                    );
                  },
                  loadingBuilder: (context, _, __) {
                    return Image.asset(
                      Assets.userPlaceholder,
                      fit: BoxFit.cover,
                    );
                  },
                ),
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
                  Text(
                    chatTitle ?? '',
                    style: TextStyle(
                      fontSize: Dimens.dimens_16.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorUtils.getColor(
                        context,
                        ColorEnums.blackColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.dimens_2.h,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        Assets.doubleCheck,
                        height: Dimens.dimens_17.h,
                        width: Dimens.dimens_17.h,
                        color: ColorUtils.getColor(
                          context,
                          ColorEnums.gray99Color,
                        ),
                      ),
                      SizedBox(
                        width: Dimens.dimens_3.w,
                      ),
                      Text(
                        'Yeah, sure',
                        style: TextStyle(
                          fontSize: Dimens.dimens_15.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorUtils.getColor(
                            context,
                            ColorEnums.gray99Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: Dimens.dimens_16.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.getColor(
                      context,
                      ColorEnums.gray6CColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(
                    Dimens.dimens_7.h,
                  ),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: ColorUtils.getColor(
                        context,
                        ColorEnums.whiteColor,
                      ),
                      fontWeight: FontWeight.w600,
                      fontSize: Dimens.dimens_14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
