// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/firestore/firestore_bloc.dart';
import 'package:nid/logic/blocs/task/add_task/add_task_bloc.dart';
import 'package:nid/logic/models/project.dart';
import 'package:nid/logic/utils/extensions/list_extensions.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';

class ProjectTextField extends StatefulWidget {
  const ProjectTextField({
    Key? key,
  }) : super(key: key);

  @override
  _ProjectTextFieldState createState() => _ProjectTextFieldState();
}

class _ProjectTextFieldState extends State<ProjectTextField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskBloc, AddTaskState>(
      builder: (context, state) {
        final projectInfo = context
            .watch<FirestoreBloc<Project>>()
            .allDoc
            .findById(state.projectId) as Project?;
        final inputStyle =
            Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.sp);
        return Container(
          width: 90.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: ExpandedColor.fromHex("#F4F4F4"),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: state.focusingStatus == FocusingStatus.project
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Center(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: inputStyle,
                      autofocus: true,
                      decoration: InputDecoration().toNoneBorder(),
                      onChanged: (val) {
                        context.read<AddTaskBloc>().add(
                            ProjectSearchStringOnChange(
                                projectSearchString: val));
                      },
                    ),
                  ),
                )
              : InkWell(
                  onTap: () async {
                    context.read<AddTaskBloc>().add(FocusingStatusOnChange(
                        focusingStatus: FocusingStatus.project));
                  },
                  child: Center(
                      child: Text(
                          projectInfo != null ? projectInfo.title : "Project",
                          style: inputStyle)),
                ),
        );
      },
    );
  }
}
