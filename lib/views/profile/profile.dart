import 'package:chatapp/const/assets.dart';
import 'package:chatapp/const/dimens.dart';
import 'package:chatapp/enums/color_enums.dart';
import 'package:chatapp/routes.dart';
import 'package:chatapp/utils/color_utils.dart';
import 'package:chatapp/views/auth/model/user.dart';
import 'package:chatapp/views/profile/bloc/profile_bloc.dart';
import 'package:chatapp/widgets/app_text_field.dart';
import 'package:chatapp/widgets/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatelessWidget {
  final _emailTextEditingController = TextEditingController();

  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous != current && current is! ProfileInitialState,
          buildWhen: (previous, current) =>
              previous != current && current is ProfileLoadedState,
          builder: (context, state) {
            User? profileInfo;
            if (state is ProfileLoadedState) {
              profileInfo = state.profileInfo;
              _emailTextEditingController.text = profileInfo.email ?? '';
            }
            return Column(
              children: [
                AppTextField(
                  title: appLocalizations.email,
                  textEditingController: _emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  keyboardAction: TextInputAction.next,
                  hint: 'test@gmail.com',
                  isEnabled: false,
                  hintStyle: TextStyle(
                    color: ColorUtils.getColor(
                      context,
                      ColorEnums.grayA8Color,
                    ),
                  ),
                  onTextChange: (email) {},
                ),
                Spacer(),
                OutlinedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimens.dimens_7.r,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (profileInfo != null) {
                      final profileBlocProvider =
                          BlocProvider.of<ProfileBloc>(context);
                      profileBlocProvider.add(
                        ProfileUpdateEvent(
                          email: profileInfo.email!,
                          name: profileInfo.name!,
                          photo: profileInfo.photo!,
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.dimens_10.h,
                      horizontal: Dimens.dimens_15.w,
                    ),
                    child: Text(
                      appLocalizations.googleSignIn,
                      style: TextStyle(
                        fontSize: Dimens.dimens_17.sp,
                        color: ColorUtils.getColor(
                          context,
                          ColorEnums.black1AColor,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          listener: (context, state) => _listenProfileState(
            context,
            state,
            appLocalizations,
          ),
        ),
      ),
    );
  }

  void _listenProfileState(
    BuildContext context,
    ProfileState state,
    AppLocalizations appLocalizations,
  ) {
    LoadingProgress.showHideProgress(
      context,
      state is ProfileLoadingState,
    );
    if (state is ProfileUpdatedState) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }
}
