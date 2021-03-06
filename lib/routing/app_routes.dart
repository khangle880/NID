// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../logic/blocs/reset_password/reset_password_bloc.dart';
import '../logic/blocs/task/process_task/process_task_bloc.dart';
import '../logic/utils/exceptions/route_exception.dart';
import '../views/animation/route_animation/bouncy_page_route.dart';
import '../views/routes/auth/change_pass_success/success_screen.dart';
import '../views/routes/auth/forgot_password/forgot_password_page.dart';
import '../views/routes/auth/reset_password/reset_password_screen.dart';
import '../views/routes/auth/sign_in/sign_in_page.dart';
import '../views/routes/exception/exception_page.dart';
import '../views/routes/home/add_pages/add_check_list/add_check_list_page.dart';
import '../views/routes/home/add_pages/add_note/add_note_page.dart';
import '../views/routes/home/add_pages/add_task/add_task_page.dart';
import '../views/routes/home/home_page.dart';
import '../views/routes/home/tabs/work_list/view_task_details/task_details_page.dart';
import '../views/routes/splash/splash_screen.dart';
import '../views/routes/wrapper/wrapper.dart';
import 'routes.dart';

class AppRoutes {
  AppRoutes._();
  static GlobalKey<NavigatorState> mainNav = GlobalKey();
  static GlobalKey<NavigatorState> appNav = GlobalKey();

  static Route<dynamic> onGenerateAppRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppRouteNames.wrapperRoute:
        return BouncyPageRoute(widget: Wrapper());
      case AppRouteNames.signInRoute:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case AppRouteNames.forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
      case AppRouteNames.resetPasswordRoute:
        if (settings.arguments == null) {
          debugPrint("Miss bloc value, can't to route");
          return MaterialPageRoute(builder: (_) => ExceptionPage());
        } else {
          return MaterialPageRoute(
            builder: (_) => ResetPasswordPage(
              resetPasswordBloc: settings.arguments! as ResetPasswordBloc,
            ),
          );
        }
      case AppRouteNames.resetPassSuccessRoute:
        return MaterialPageRoute(builder: (_) => SuccessScreen());
      default:
        throw RouteException("Route not found");
    }
  }

  static Route<dynamic> onGenerateMainRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainRouteNames.initHomeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case MainRouteNames.addTaskRoute:
        return MaterialPageRoute(builder: (_) => AddTaskPage());
      case MainRouteNames.addNoteRoute:
        return MaterialPageRoute(builder: (_) => AddNotePage());
      case MainRouteNames.addCheckListRoute:
        return MaterialPageRoute(builder: (_) => AddCheckListPage());
      case MainRouteNames.viewTaskDetailsRoute:
        if (settings.arguments == null) {
          debugPrint("Miss bloc value, can't to route");
          return MaterialPageRoute(builder: (_) => ExceptionPage());
        } else {
          return MaterialPageRoute(
            builder: (_) => TaskDetailsPage(
              processTaskBloc: settings.arguments! as ProcessTaskBloc,
            ),
          );
        }
      default:
        throw RouteException("Route not found");
    }
  }
}
