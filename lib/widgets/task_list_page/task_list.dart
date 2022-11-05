import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timelines/timelines.dart';
import 'package:todo/controller/common/same_category_finder.dart';
import 'package:todo/controller/common/category_index_controller.dart';
import 'package:todo/data/model/archieve_db/archieve_db.dart';
import 'package:todo/data/model/tasks_db/task_model.dart';
import 'package:todo/data/repository/archieve_repository.dart';
import 'package:todo/data/repository/tasks_repository.dart';
import 'package:todo/widgets/task_list_page/task_body/connectors/connector_done_widget.dart';
import 'package:todo/widgets/task_list_page/task_body/connectors/connector_not_done_widget.dart';
import 'package:todo/widgets/task_list_page/task_body/body/gradient_task_body.dart';
import 'package:todo/widgets/task_list_page/task_body/icons/icon_not_done_widget.dart';
import 'package:todo/widgets/task_list_page/task_body/body/white_task_body.dart';
import 'package:todo/widgets/task_list_page/task_body/icons/icon_done_widget.dart';
import 'package:todo/widgets/task_list_page/task_body/no_tasks_text.dart';

class TaskList extends StatelessWidget {
  final DateTime selectedDate;
  TaskList({Key? key, required this.selectedDate}) : super(key: key);
  final _tasksRepositoryImpl = TasksRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _tasksRepositoryImpl.database.listenable(),
        builder: (_, Box<TaskModel> box, __) {
          return box.values.isEmpty
              ? NoTasksWidget.noTasks
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: box.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, i) {
                    TaskModel? taskBox = box.getAt(i);
                    DateTime? deadline = taskBox!.deadlineDateTime;

                    if (deadline!.toString().substring(0, 11) ==
                        selectedDate.toString().substring(0, 11)) {
                      return Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 2,
                              onPressed: (_) => SameCategoryFinder()
                                  .checkCategoryIsNotEmpty(context, i),
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              flex: 2,
                              onPressed: (taskBox.isDone)
                                  ? null
                                  : (_) async {
                                      //TODO  put in controller
                                      await box.putAt(
                                        i,
                                        TaskModel(
                                          id: CategoryIndexProvider()
                                              .getCategoryIndex(
                                                  taskBox.category),
                                          creationDate: taskBox.creationDate,
                                          deadlineDateTime:
                                              taskBox.deadlineDateTime,
                                          text: taskBox.text,
                                          category: taskBox.category,
                                          isDone: true,
                                        ),
                                      );
                                    },
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.done,
                              label: 'Done',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 2,
                              onPressed: (_) async {
                                // remove
                                ArchieveRepositoryImpl().database.add(
                                      ArchieveModel(
                                        category: taskBox.category,
                                        text: taskBox.text,
                                        deadlineDateTime:
                                            taskBox.deadlineDateTime,
                                      ),
                                    );
                                await box.deleteAt(i);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.archive,
                              label: 'Remove',
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: TimelineTile(
                            node: TimelineNode(
                              indicator: (taskBox.isDone)
                                  ? const IconDoneWidget()
                                  : const IconNotDoneWidget(),
                              startConnector: (taskBox.isDone)
                                  ? const ConnectorDoneWidget()
                                  : const ConnectorNotDoneWidget(),
                              endConnector: (taskBox.isDone)
                                  ? const ConnectorDoneWidget()
                                  : const ConnectorNotDoneWidget(),
                            ),
                            oppositeContents: null,
                            nodeAlign: TimelineNodeAlign.start,
                            contents: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  deadline.toIso8601String().substring(11, 16),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: (taskBox.isDone)
                                      ? GradientDoneTaskBodyWidget(
                                          text: taskBox.text,
                                          category: taskBox.category,
                                        )
                                      : WhiteNotDoneTaskBodyWidget(
                                          text: taskBox.text,
                                          category: taskBox.category,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  });
        });
  }
}
