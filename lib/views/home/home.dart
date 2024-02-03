import 'package:chatapp/config/firestore_config.dart';
import 'package:chatapp/const/assets.dart';
import 'package:chatapp/const/dimens.dart';
import 'package:chatapp/enums/color_enums.dart';
import 'package:chatapp/enums/room_type_enums.dart';
import 'package:chatapp/notification/notification_token_helper.dart';
import 'package:chatapp/utils/color_utils.dart';
import 'package:chatapp/views/auth/model/room.dart';
import 'package:chatapp/views/home/home_bloc/home_bloc.dart';
import 'package:chatapp/views/home/room_bloc/room_bloc.dart';
import 'package:chatapp/widgets/app_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeBloc? _homeBlocProvider;
  RoomBloc? _roomBlocProvider;
  String? currentUserId;

  @override
  void initState() {
    NotificationTokenHelper.uploadFcmToken();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_homeBlocProvider == null) {
      _homeBlocProvider ??= BlocProvider.of<HomeBloc>(context);
      _homeBlocProvider?.add(FetchCurrentUserInfo());
    }
    if (_roomBlocProvider == null) {
      _roomBlocProvider ??= BlocProvider.of<RoomBloc>(context);
      _roomBlocProvider?.add(ListenRoomChangesEvent());
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, current) => current is UserInfoUpdatedState,
      builder: (context, state) {
        if (state is UserInfoUpdatedState) {
          currentUserId = state.user.userId;
        }
        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: Dimens.dimens_12.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.dimens_10.w,
                      horizontal: Dimens.dimens_20.w,
                    ),
                    child: Text(
                      appLocalizations.conversation,
                      style: TextStyle(
                        color: ColorUtils.getColor(
                          context,
                          ColorEnums.black33Color,
                        ),
                        fontWeight: FontWeight.bold,
                        fontSize: Dimens.dimens_32.sp,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.dimens_20.w,
                    ),
                    child: AppTextField(
                      textEditingController: TextEditingController(),
                      keyboardType: TextInputType.emailAddress,
                      keyboardAction: TextInputAction.next,
                      hint: appLocalizations.searchHint,
                      hintStyle: TextStyle(
                        color: ColorUtils.getColor(
                          context,
                          ColorEnums.grayA8Color,
                        ),
                      ),
                      fieldBgColor: ColorEnums.blackColor5Opacity,
                      borderRadius: Dimens.dimens_12.r,
                      onTextChange: (email) {},
                      borderWidth: 0,
                      suffixIcon: Icon(
                        Icons.search,
                        color: ColorUtils.getColor(
                          context,
                          ColorEnums.grayA8Color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.dimens_15.h,
                  ),
                  Expanded(
                    child: BlocBuilder<RoomBloc, RoomState>(
                      buildWhen: (prev, current) =>
                          prev != current && current is RoomListUpdated,
                      builder: (context, state) {
                        var roomList = <Room>[];
                        if (state is RoomListUpdated && currentUserId != null) {
                          roomList = state.roomList;
                        }
                        return ListView.builder(
                          itemCount: roomList.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {

                            return ;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
