// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/authentication/authentication_bloc.dart';
import 'package:nid/logic/blocs/login/login_bloc.dart';
import 'package:nid/logic/utils/validator/auth_validators.dart';
import 'package:nid/routing/app_routes.dart';
import 'package:nid/routing/routes.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';
import 'package:nid/views/widgets/normal_text_field.dart';
import 'package:nid/views/widgets/obscure_text_field.dart';
import 'package:nid/views/widgets/rounded_button.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? input) {
    if (input != null && AuthValidators.isValidEmail(input)) {
      return null;
    } else {
      return "Invalid email";
    }
  }

  String? _validatePassword(String? input) {
    if (input != null && AuthValidators.isValidPassword(input)) {
      return null;
    } else {
      return "Invalid field";
    }
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginFailure) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(ExpandedSnackBar.failureSnackBar(
            context,
            state.errorMessage,
          ));
      }

      if (state is LoginLoading) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(ExpandedSnackBar.loadingSnackBar(
            context,
            'Logging In...',
          ));
      }

      if (state is LoginSuccess) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(ExpandedSnackBar.successSnackBar(
            context,
            'Login Success',
          ));
        context.read<AuthenticationBloc>().add(
              AuthenticationLoggedIn(),
            );
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      }
    }, builder: (context, state) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username',
              style: Theme.of(context).textTheme.headline6,
            ),
            NormalTextField(
              controller: _emailController,
              hintText: "Enter your email",
              validator: _validateEmail,
            ),
            SizedBox(height: 30.h),
            Text(
              'Password',
              style: Theme.of(context).textTheme.headline6,
            ),
            ObscureTextField(
                controller: _passwordController,
                hintText: "Enter your password",
                validator: _validatePassword),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    AppRoutes.appNav.currentState!
                        .pushNamed(AppRouteNames.forgotPasswordRoute);
                  },
                  child: Text(
                    "Forgot password",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100.h,
            ),
            RoundedButton(
              text: 'Log In',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _onFormSubmitted();
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
