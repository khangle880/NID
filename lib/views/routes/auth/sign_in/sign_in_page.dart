// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/authentication/authentication_bloc.dart';
import 'package:nid/logic/blocs/login/login_bloc.dart';
import 'sign_in_body.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => LoginBloc(
              userRepository:
                  context.read<AuthenticationBloc>().userRepository),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 0),
            child: SignInBody(),
          ),
        ),
      ),
    );
  }
}
