import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todo/data/model/archieve/archieve_db.dart';
import 'package:todo/data/model/category/category_model.dart';
import 'package:todo/data/model/tasks/task_model.dart';
import 'package:todo/data/repository/archieve/archieve_repository.dart';
import 'package:todo/data/repository/category/category_repository.dart';
import 'package:todo/data/repository/task/tasks_repository.dart';
import 'package:todo/screens/add_edit_task/edit_task/edit_task_controller.dart';
import 'package:todo/screens/add_edit_task/add_task/widgets/category_list_widget.dart';
import 'package:todo/screens/add_edit_task/add_task/widgets/textfield_widget.dart';
import 'package:todo/screens/widgets/gradient_appbar_widget.dart';
import 'package:todo/screens/widgets/unfocus_widget.dart';
import 'package:todo/screens/task_list/controller/task_validator.dart';
import 'package:todo/services/common/category_index_provider.dart';
import 'package:todo/services/locator_service.dart';

@RoutePage()
class EditTaskPage extends StatefulWidget {
  final int taskIndex;
  final TaskModel model;

  const EditTaskPage({
    super.key,
    required this.taskIndex,
    required this.model,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _titleTextController = TextEditingController();
  final _dateTextController = TextEditingController();
  final _timeTextController = TextEditingController();

  final _editTaskController = EditTaskController(
    archieveRepository: serviceLocator<ArchieveRepository<ArchieveModel>>(),
    categoryIndexerProvider: CategoryIndexProvider(),
    categoryRepository: serviceLocator<CategoryRepository<CategoryModel>>(),
    taskValidator: TaskValidator(),
    tasksRepository: serviceLocator<TasksRepository<TaskModel>>(),
  );

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _editTaskController.getEditData(
      index: widget.taskIndex,
      timeTextController: _timeTextController,
      dateTextController: _dateTextController,
      titleTextController: _titleTextController,
    );

    super.initState();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _dateTextController.dispose();
    _timeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBarWidget(
        context: context,
        showActions: false,
        title: 'Edit task',
      ),
      body: UnfocusWidget(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextfieldWidget(
                  validator: (title) => _editTaskController.taskValidator
                      .isTitleValid(text: title),
                  textEditingController: _titleTextController,
                  hintText: 'Text:',
                  enabled: true,
                ),
                TextfieldWidget(
                  validator: (date) =>
                      _editTaskController.taskValidator.isDateValid(text: date),
                  textEditingController: _dateTextController,
                  hintText: 'Finish date:',
                ),
                OutlinedButton.icon(
                  onPressed: () async => await _editTaskController.pickDate(
                    context: context,
                    dateTextController: _dateTextController,
                  ),
                  icon: const Icon(Icons.date_range_outlined),
                  label: const Text('Pick date'),
                ),
                TextfieldWidget(
                  validator: (time) =>
                      _editTaskController.taskValidator.isTimeValid(text: time),
                  textEditingController: _timeTextController,
                  hintText: 'Finish time:',
                ),
                OutlinedButton.icon(
                  onPressed: () => _editTaskController.pickTime(
                      timeTextController: _timeTextController,
                      context: context),
                  icon: const Icon(Icons.schedule_outlined),
                  label: const Text('Pick time'),
                ),
                CategoryListWidget(
                  taskController: _editTaskController,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _editTaskController.isSubmitActive,
                  builder: (context, value, _) {
                    return OutlinedButton.icon(
                      onPressed: _editTaskController.isSubmitActive.value
                          ? () {
                              _editTaskController.validateForm(
                                  context: context,
                                  callback: () async =>
                                      await _editTaskController.updateTask(
                                        selectedCategory: widget.model.category,
                                        title: _titleTextController.text,
                                        index: widget.taskIndex,
                                        context: context,
                                      ),
                                  formKey: _formKey);
                            }
                          : null,
                      icon: const Icon(Icons.add),
                      label: const Text('Update task'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
