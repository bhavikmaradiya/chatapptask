import 'package:chatapp/config/app_config.dart';
import 'package:chatapp/const/dimens.dart';
import 'package:chatapp/enums/color_enums.dart';
import 'package:chatapp/routes.dart';
import 'package:chatapp/utils/app_utils.dart';
import 'package:chatapp/utils/color_utils.dart';
import 'package:chatapp/views/auth/bloc/auth_bloc.dart';
import 'package:chatapp/widgets/app_filled_button.dart';
import 'package:chatapp/widgets/app_text_field.dart';
import 'package:chatapp/widgets/loading_progress.dart';
import 'package:chatapp/widgets/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Authentication extends StatelessWidget {
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous != current && current is! AuthInitialState,
          listener: (context, state) => _authStateChangeListener(
            context,
            state,
            appLocalizations,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _loginContentWidget(
                  context,
                  appLocalizations,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginContentWidget(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final authBlocProvider = BlocProvider.of<AuthBloc>(context);
    final errorTextStyle = TextStyle(
      color: ColorUtils.getColor(
        context,
        ColorEnums.redColor,
      ),
      fontSize: Dimens.dimens_12.sp,
    );
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.dimens_20.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.login,
            style: TextStyle(
              fontSize: Dimens.dimens_24.sp,
              color: ColorUtils.getColor(
                context,
                ColorEnums.black33Color,
              ),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: Dimens.dimens_60.w,
            child: Divider(
              color: ColorUtils.getColor(
                context,
                ColorEnums.grayE0Color,
              ),
              thickness: Dimens.dimens_2.h,
            ),
          ),
          SizedBox(
            height: Dimens.dimens_20.h,
          ),
          AppTextField(
            title: appLocalizations.email,
            textEditingController: _emailTextEditingController,
            keyboardType: TextInputType.emailAddress,
            keyboardAction: TextInputAction.next,
            hint: 'test@gmail.com',
            hintStyle: TextStyle(
              color: ColorUtils.getColor(
                context,
                ColorEnums.grayA8Color,
              ),
            ),
            onTextChange: (email) {
              authBlocProvider.add(
                EmailFieldTextChangeEvent(
                  email,
                ),
              );
            },
          ),
          SizedBox(
            height: Dimens.dimens_5.h,
          ),
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) =>
                current is AuthEmailFieldValidationState,
            builder: (context, state) {
              if (state is AuthEmailFieldValidationState && !state.isValid) {
                return Text(
                  appLocalizations.invalidEmail,
                  style: errorTextStyle,
                );
              }
              return const SizedBox();
            },
          ),
          SizedBox(
            height: Dimens.dimens_20.h,
          ),
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) =>
                previous != current &&
                (current is VisiblePasswordFieldState ||
                    current is InVisiblePasswordFieldState),
            builder: (context, state) {
              final passwordVisibleState = state is VisiblePasswordFieldState;
              return AppTextField(
                title: appLocalizations.password,
                textEditingController: _passwordTextEditingController,
                keyboardType: TextInputType.visiblePassword,
                hint: 'Test@123',
                hintStyle: TextStyle(
                  color: ColorUtils.getColor(
                    context,
                    ColorEnums.grayA8Color,
                  ),
                ),
                isPassword: !passwordVisibleState,
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisibleState
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  color: ColorUtils.getColor(
                    context,
                    ColorEnums.gray99Color,
                  ),
                  onPressed: () {
                    authBlocProvider.add(
                      passwordVisibleState
                          ? InVisiblePasswordFieldEvent()
                          : VisiblePasswordFieldEvent(),
                    );
                  },
                ),
                onTextChange: (password) {
                  authBlocProvider.add(
                    PasswordFieldTextChangeEvent(
                      password,
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(
            height: Dimens.dimens_5.h,
          ),
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) =>
                current is AuthPasswordFieldValidationState,
            builder: (context, state) {
              if (state is AuthPasswordFieldValidationState && !state.isValid) {
                return Text(
                  appLocalizations.passwordHint,
                  style: errorTextStyle,
                );
              }
              return const SizedBox();
            },
          ),
          SizedBox(
            height: Dimens.dimens_20.h,
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state) {
              final email = _emailTextEditingController.text.trim();
              final password = _passwordTextEditingController.text;
              final isValid = email.isNotEmpty &&
                  password.isNotEmpty &&
                  AppUtils.isValidEmail(email.trim()) &&
                  AppUtils.isValidPasswordToRegister(password);
              return AppFilledButton(
                title: appLocalizations.loginBtn,
                // enabled: isValid,
                onButtonPressed: () {
                  _onLoginButtonClicked(
                    authBlocProvider,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _onLoginButtonClicked(
    AuthBloc authBlocProvider,
  ) {
    final email = _emailTextEditingController.text.trim();
    final password = _passwordTextEditingController.text;
    if (email.isEmpty && password.isEmpty) {
      authBlocProvider.add(
        EmailFieldTextChangeEvent(
          email,
        ),
      );
      authBlocProvider.add(
        PasswordFieldTextChangeEvent(
          password,
        ),
      );
      return;
    } else if (email.isEmpty) {
      authBlocProvider.add(
        EmailFieldTextChangeEvent(
          email,
        ),
      );
      return;
    } else if (password.isEmpty) {
      authBlocProvider.add(
        PasswordFieldTextChangeEvent(
          password,
        ),
      );
      return;
    } else {
      authBlocProvider.add(
        EmailFieldTextChangeEvent(
          email,
        ),
      );
      authBlocProvider.add(
        PasswordFieldTextChangeEvent(
          password,
        ),
      );
    }
    authBlocProvider.add(
      VerifyCredentialEvent(
        email,
        password,
      ),
    );
  }

  void _authStateChangeListener(
    BuildContext context,
    AuthState state,
    AppLocalizations appLocalizations,
  ) {
    LoadingProgress.showHideProgress(
      context,
      state is AuthLoadingState,
    );
    if (state is FirebaseLoginInvalidUserState) {
      // invalid user
      _createNewUserDialog(
        context,
        state,
        appLocalizations,
      );
    } else if (state is FirebaseLoginInvalidPasswordState) {
      // invalid password
      SnackBarView.showSnackBar(
        context,
        appLocalizations.invalidFirebasePassword,
      );
    } else if (state is FirebaseLoginFailedState) {
      // failed with firebase message
      SnackBarView.showSnackBar(
        context,
        state.errorMessage ?? appLocalizations.somethingWentWrong,
      );
    } else if (state is FirebaseLoginSuccessProfileState) {
      // success
      Navigator.pushReplacementNamed(context, Routes.home);
    } else if (state is FirebaseLoginSuccessHomeState) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }

  void _createNewUserDialog(
    BuildContext context,
    AuthState state,
    AppLocalizations appLocalizations,
  ) {
    final shouldCreate = showModalBottomSheet<bool>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Dimens.dimens_15.r,
        ),
      ),
      backgroundColor: ColorUtils.getColor(
        context,
        ColorEnums.whiteColor,
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimens.dimens_20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appLocalizations.userNotFoundTitle,
                  style: TextStyle(
                    fontSize: Dimens.dimens_22.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.getColor(
                      context,
                      ColorEnums.black33Color,
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimens.dimens_10.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: Dimens.dimens_15.w,
                  ),
                  child: Text(
                    appLocalizations.userNotFoundSubtitle,
                    style: TextStyle(
                      fontSize: Dimens.dimens_19.sp,
                      color: ColorUtils.getColor(
                        context,
                        ColorEnums.black1AColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimens.dimens_35.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppFilledButton(
                        title: appLocalizations.cancel,
                        onButtonPressed: () {
                          Navigator.pop(context, false);
                        },
                        backgroundColor: ColorUtils.getColor(
                          context,
                          ColorEnums.grayE0Color,
                        ),
                        textColor: ColorUtils.getColor(
                          context,
                          ColorEnums.gray6CColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Dimens.dimens_10.w,
                    ),
                    Expanded(
                      child: AppFilledButton(
                        title: appLocalizations.createAc,
                        onButtonPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
