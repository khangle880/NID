// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🌎 Project imports:
import 'package:nid/views/routes/home/add_pages/add_check_list/components/add_check_list_form.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';

class AddCheckListPage extends StatefulWidget {
  const AddCheckListPage({Key? key}) : super(key: key);

  @override
  _AddCheckListPageState createState() => _AddCheckListPageState();
}

class _AddCheckListPageState extends State<AddCheckListPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ExpandedColor.fromHex("#F96060"),
        title: Text(
          'Add Check List',
          style: textTheme.subtitle1!
              .copyWith(color: Colors.white, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Container(
                height: 44.h,
                color: ExpandedColor.fromHex("#F96060"),
              ),
              Spacer(),
              Container(
                height: 60.h,
                color: ExpandedColor.fromHex("#292E4E"),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: Container(
                // height: 700.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(3.h, 3.h),
                      color: Color.fromRGBO(221, 221, 221, 0.5),
                      blurRadius: 3.w,
                    )
                  ],
                ),
                child: AddCheckListForm()),
          )
        ],
      ),
    );
  }
}
