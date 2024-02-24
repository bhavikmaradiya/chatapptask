import 'package:chatapp/views/auth/model/user.dart';
import 'package:chatapp/views/profile/bloc/profile_bloc.dart';
import 'package:chatapp/widgets/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
            if(state is ProfileLoadedState){
              profileInfo = state.profileInfo;
            }
            return const Column(
              children: [],
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
  }
}
