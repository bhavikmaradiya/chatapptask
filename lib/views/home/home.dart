import 'package:chatapp/config/theme_config.dart';
import 'package:chatapp/const/dimens.dart';
import 'package:chatapp/enums/color_enums.dart';
import 'package:chatapp/utils/color_utils.dart';
import 'package:chatapp/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.getColor(
          context,
          ColorEnums.whiteColor,
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(
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
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Dimens.dimens_20.w,
            vertical: Dimens.dimens_12.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
