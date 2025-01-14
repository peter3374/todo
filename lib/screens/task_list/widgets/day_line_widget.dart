import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/screens/task_list/controller/task_list_controller.dart';
import 'package:todo/screens/task_list/widgets/date_line_fonts.dart';

class DayLineWidget extends StatefulWidget {
  final TaskListController taskListController;
  final Function(DateTime) changeDay;

  const DayLineWidget({
    super.key,
    required this.changeDay,
    required this.taskListController,
  });

  @override
  State<DayLineWidget> createState() => _DayLineWidgetState();
}

class _DayLineWidgetState extends State<DayLineWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.taskListController.calendar,
      builder: (__, calendarList, _) => ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 80,
          maxHeight: 140,
        ),
        child: PageView.builder(
          controller: widget.taskListController.pageController,
          itemCount: calendarList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                widget.changeDay(widget.taskListController.selectedDate.value =
                    calendarList[i]);

                widget.taskListController.scrollToSelectedIndex();
              },
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      DateFormat('d').format(calendarList[i]),
                      style: (widget.taskListController.selectedDate.value ==
                              calendarList[i])
                          ? DateLineFonts.selected
                          : DateLineFonts.unSelected,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      DateFormat('EEEE')
                          .format(calendarList[i])
                          .substring(0, 3),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
