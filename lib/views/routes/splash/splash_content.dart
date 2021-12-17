// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🌎 Project imports:
import 'package:nid/global/constants/assets_path.dart';
import 'package:nid/routing/app_routes.dart';
import 'package:nid/routing/routes.dart';
import 'package:nid/views/widgets/fade_widget.dart';
import 'package:nid/views/widgets/simple_rive_widget.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 5000), () {
      AppRoutes.appNav.currentState!
          .pushReplacementNamed(AppRouteNames.wrapperRoute);
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SimpleRiveWidget(
          rivePath: AssetPathConstants.splashRive,
          simpleAnimation: AssetPathConstants.splashSimpleAnimation,
          width: 210.w,
          height: 180.w,
        ),
        FadeWidget(
          milliseconds: 2500,
          child: Text(text,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                shadows: const <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 4.0),
                    blurRadius: 4.0,
                    color: Color.fromARGB(64, 0, 0, 0),
                  ),
                ],
              )),
        )
      ],
    );
  }
}
