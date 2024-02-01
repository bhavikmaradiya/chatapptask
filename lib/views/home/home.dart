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
            horizontal: Dimens.dimens_20.w,
            vertical: Dimens.dimens_12.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.dimens_10.w,
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
                AppTextField(
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
                SizedBox(
                  height: Dimens.dimens_20.h,
                ),
                ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, pos){
                    return Container(

                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
