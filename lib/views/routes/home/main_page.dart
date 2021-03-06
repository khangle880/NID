// 🎯 Dart imports:
import 'dart:developer';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🌎 Project imports:
import 'package:nid/global/constants/assets_path.dart';
import 'package:nid/logic/blocs/firestore/firestore_bloc.dart';
import 'package:nid/logic/blocs/task/get_task/task_bloc.dart';
import 'package:nid/logic/models/project.dart';
import 'package:nid/logic/models/public_user_info.dart';
import 'package:nid/logic/models/quick_note.dart';
import 'package:nid/logic/models/task.dart';
import 'package:nid/logic/repositories/firestore/project_repository.dart';
import 'package:nid/logic/repositories/firestore/public_user_info_repository.dart';
import 'package:nid/logic/repositories/firestore/quick_note_repository.dart';
import 'package:nid/logic/repositories/firestore/task_repository.dart';
import 'package:nid/routing/app_routes.dart';
import 'package:nid/routing/routes.dart';
import 'package:nid/views/widgets/simple_rive_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _statusList = List.generate(4, (index) => false);
  void changeLoadStatus({required int index, required bool status}) {
    setState(() {
      _statusList[index] = status;
    });
  }

  @override
  void initState() {
    super.initState();
    //TODO: popup "not responding" after 30s (future.delay)
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (_) => TaskBloc(context.read<TaskRepository>())
            ..add(LoadFirestore<Task>(widget.uid)),
          lazy: false,
        ),
        BlocProvider<FirestoreBloc<PublicUserInfo>>(
          create: (_) => FirestoreBloc<PublicUserInfo>(
              context.read<PublicUserInfoRepository>())
            ..add(LoadFirestore<PublicUserInfo>(widget.uid)),
          lazy: false,
        ),
        BlocProvider<FirestoreBloc<Project>>(
          create: (_) =>
              FirestoreBloc<Project>(context.read<ProjectRepository>())
                ..add(LoadFirestore<Project>(widget.uid)),
          lazy: false,
        ),
        BlocProvider<FirestoreBloc<QuickNote>>(
          create: (_) =>
              FirestoreBloc<QuickNote>(context.read<QuickNoteRepository>())
                ..add(LoadFirestore<QuickNote>(widget.uid)),
          lazy: false,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<TaskBloc, FirestoreState<Task>>(
            listener: (context, state) {
              changeLoadStatus(
                  index: 0, status: state is FirestoreLoaded<Task>);
            },
          ),
          BlocListener<FirestoreBloc<Project>, FirestoreState<Project>>(
            listener: (context, state) {
              changeLoadStatus(
                  index: 1, status: state is FirestoreLoaded<Project>);
            },
          ),
          BlocListener<FirestoreBloc<PublicUserInfo>,
              FirestoreState<PublicUserInfo>>(
            listener: (context, state) {
              changeLoadStatus(
                  index: 2, status: state is FirestoreLoaded<PublicUserInfo>);
            },
          ),
          BlocListener<FirestoreBloc<QuickNote>, FirestoreState<QuickNote>>(
            listener: (context, state) {
              print("listen ${state.runtimeType}");
              changeLoadStatus(
                  index: 3, status: state is FirestoreLoaded<QuickNote>);
            },
          ),
        ],
        child: _statusList.contains(false)
            ? Scaffold(
                body: Center(
                  child: SimpleRiveWidget(
                    rivePath: AssetPathConstants.loader1Rive,
                    simpleAnimation: AssetPathConstants.loader1SimpleAnimation,
                    width: 80.w,
                    height: 120.h,
                  ),
                ),
              )
            : Navigator(
                key: AppRoutes.mainNav,
                initialRoute: MainRouteNames.initHomeRoute,
                onGenerateRoute: AppRoutes.onGenerateMainRoute,
              ),
      ),
    );
  }
}
