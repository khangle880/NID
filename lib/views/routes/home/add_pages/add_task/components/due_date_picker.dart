// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/task/add_task/add_task_bloc.dart';
import 'package:nid/logic/utils/extensions/datetime_extensions.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';
import 'package:nid/views/widgets/rounded_button.dart';

class DueDatePicker extends StatefulWidget {
  const DueDatePicker({Key? key}) : super(key: key);

  @override
  _DueDatePickerState createState() => _DueDatePickerState();
}

class _DueDatePickerState extends State<DueDatePicker>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 66.h,
      color: ExpandedColor.fromHex("#F4F4F4"),
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 17.h),
      child: Row(
        children: [
          Text("Due Date", style: textTheme.button),
          SizedBox(width: 8.w),
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeIn,
            child: Container(
              height: 32.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: ExpandedColor.fromHex("#6074F9"),
              ),
              child: BlocBuilder<AddTaskBloc, AddTaskState>(
                builder: (context, state) => Center(
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _showDatePicker(context);
                    },
                    child: Text(
                      state.dueDate == null
                          ? "Any Time"
                          : state.dueDate!.formatOrAroundToday("dd/MM/yyyy"),
                      style: textTheme.bodyText1!.copyWith(
                          fontSize: 14.sp,
                          color: ExpandedColor.fromHex("#FFFFFF")),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    DateTime? datePicked;
    TimeOfDay? timePicked;

    showDialog(
      context: context,
      builder: (popContext) {
        final textTheme = Theme.of(context).textTheme;
        final datePickerStyle =
            textTheme.bodyText1!.copyWith(fontSize: 13.5.sp);
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
          child: SizedBox(
              height: 450.h,
              width: 345.w,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.h),
                  SfDateRangePicker(
                    onSelectionChanged: (dateSelected) =>
                        datePicked = dateSelected.value as DateTime,
                    initialSelectedDate:
                        context.watch<AddTaskBloc>().state.dueDate,
                    selectionColor: ExpandedColor.fromHex('#6074F9'),
                    headerHeight: 50.h,
                    headerStyle: DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center,
                        textStyle: textTheme.subtitle2),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        textStyle: textTheme.subtitle2,
                      ),
                      showTrailingAndLeadingDates: true,
                    ),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: datePickerStyle,
                      leadingDatesTextStyle: datePickerStyle.toBlurColor(),
                      todayTextStyle: datePickerStyle,
                    ),
                    yearCellStyle: DateRangePickerYearCellStyle(
                      disabledDatesTextStyle: datePickerStyle,
                      leadingDatesTextStyle: datePickerStyle,
                      textStyle: datePickerStyle,
                      todayTextStyle: datePickerStyle,
                    ),
                  ),
                  SizedBox(height: 35.h),
                  SizedBox(
                    width: 150.w,
                    height: 48.h,
                    child: RoundedButton(
                      text: "Done",
                      onPressed: () => Navigator.of(popContext).pop(),
                    ),
                  )
                ],
              )),
        );
      },
    ).then(
      (value) async {
        timePicked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (timePickerContext, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  helpTextStyle: Theme.of(context).textTheme.subtitle2,
                ),
                textTheme:
                    TextTheme(button: Theme.of(context).textTheme.subtitle1),
                splashColor: Colors.black,
                accentColor: Colors.black,
                colorScheme: ColorScheme.light(
                  primary: Colors.pinkAccent,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child ?? Text(""),
            );
          },
        );
      },
    ).then((value) {
      context
          .read<AddTaskBloc>()
          .add(DueDateOnChange(dueDate: datePicked, timeOfDay: timePicked));
    });
  }
}
