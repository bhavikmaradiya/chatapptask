import 'package:chatapp/const/assets.dart';
import 'package:chatapp/const/dimens.dart';
import 'package:chatapp/enums/color_enums.dart';
import 'package:chatapp/notification/notification_token_helper.dart';
import 'package:chatapp/utils/color_utils.dart';
import 'package:chatapp/views/home/bloc/home_bloc.dart';
import 'package:chatapp/widgets/app_text_field.dart';
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

  @override
  void initState() {
    NotificationTokenHelper.uploadFcmToken();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_homeBlocProvider == null) {
      _homeBlocProvider ??= BlocProvider.of<HomeBloc>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
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
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, pos) {
                    final showTypeing = pos == 6;
                    final showUnread = pos == 3;
                    return Column(
                      children: [
                        if (pos == 0)
                          SizedBox(
                            height: Dimens.dimens_15.h,
                          ),
                        InkWell(
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
                                    child: Image.asset(
                                      pos == 0 || pos == 5
                                          ? Assets.avatar
                                          : pos == 2 || pos == 8
                                              ? Assets.avatar2
                                              : Assets.avatar3,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Dimens.dimens_13.w,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bhavik Maradiya',
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
                                          if (pos != 3 && pos != 6 && pos != 7)
                                            Image.asset(
                                              Assets.doubleCheck,
                                              height: Dimens.dimens_17.h,
                                              width: Dimens.dimens_17.h,
                                              color: pos == 2 || pos == 4
                                                  ? ColorUtils.getColor(
                                                      context,
                                                      ColorEnums.gray99Color,
                                                    )
                                                  : Colors.green,
                                            ),
                                          if (pos != 3 && pos != 6 && pos != 7)
                                            SizedBox(
                                              width: Dimens.dimens_3.w,
                                            ),
                                          Text(
                                            showTypeing
                                                ? 'Typing...'
                                                : pos == 1
                                                    ? 'Good to know'
                                                    : pos == 2
                                                        ? 'Why have you then?'
                                                        : pos == 3
                                                            ? 'Nope'
                                                            : pos == 4
                                                                ? 'Ahh! That\'s not what I mean'
                                                                : pos == 5
                                                                    ? 'See how\'s this app?'
                                                                    : pos == 8
                                                                        ? 'Better you do it today!'
                                                                        : 'Yeah, sure',
                                            style: TextStyle(
                                              fontSize: Dimens.dimens_15.sp,
                                              fontWeight: showUnread
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: showTypeing
                                                  ? Colors.green
                                                  : showUnread
                                                      ? ColorUtils.getColor(
                                                          context,
                                                          ColorEnums.blackColor,
                                                        )
                                                      : ColorUtils.getColor(
                                                          context,
                                                          ColorEnums
                                                              .gray99Color,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      pos == 0 || showUnread
                                          ? 'Today'
                                          : 'Yesterday',
                                      style: TextStyle(
                                        fontSize: Dimens.dimens_16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: ColorUtils.getColor(
                                          context,
                                          ColorEnums.gray6CColor,
                                        ),
                                      ),
                                    ),
                                    if (showUnread)
                                      Container(
                                        padding: EdgeInsets.all(
                                          Dimens.dimens_7.h,
                                        ),
                                        decoration: BoxDecoration(
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
                                      )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
