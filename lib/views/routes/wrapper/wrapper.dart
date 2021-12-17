// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/authentication/authentication_bloc.dart';
import 'package:nid/views/routes/home/main_page.dart';
import 'package:nid/views/routes/walkthrough/walkthrough_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthenticationFailure) {
        return WalkthroughPage();
      }

      if (state is AuthenticationSuccess) {
        // return HomePage(user: state.firebaseUser);
        return MainPage(uid: state.firebaseUser.uid);
      }

      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    });
  }
}
