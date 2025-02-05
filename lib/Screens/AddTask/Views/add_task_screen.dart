// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vexa_todo/Common/GlobalFunctions.dart';
import 'package:vexa_todo/Common/Notification.dart';
import 'package:vexa_todo/Common/SQLiteHelper.dart';
import 'package:vexa_todo/Screens/AddTask/Models/TaskTags.dart';
import 'package:vexa_todo/Screens/Home/Models/Task.dart';
import 'package:vexa_todo/Screens/Home/Models/Type.dart';
import 'package:vexa_todo/Screens/AddTask/Widgets/AddTaskScreenWidgets.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  AddTaskWidget widgetsScreen = AddTaskWidget();

  List<TypeTask> listType = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Nova Tarefa", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700)),
          ],
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, false);
                //NavigatorController().navigatorBack(context);
              },
              icon: Icon(Icons.cancel),
              color: Colors.red)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      widgetsScreen.TitleTextField(context, titleEditingController),
                      widgetsScreen.boolValidationTitle ? widgetsScreen.ErrorIcon() : SizedBox(),
                    ],
                  ),
                  widgetsScreen.StarPriority(context),
                ],
              ),
              widgetsScreen.ColorsWidgets(context),
              widgetsScreen.PhasesWidgets(context, listType),
              widgetsScreen.TextAreaDescription(context, descriptionEditingController),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widgetsScreen.DateTimeProTextField(context),
                  Row(
                    children: [
                      widgetsScreen.DateTimeTextField(context),
                      widgetsScreen.TagsSelect(context)
                    ],
                  ),
                ],
              ),
              widgetsScreen.ButtonScreen(context, () async {
                if (titleEditingController.text.isNotEmpty) {
                  int id_task = await DatabaseHelper().insertDatabase(
                      "task",
                      Task(
                          title: titleEditingController.text,
                          text: descriptionEditingController.text,
                          color: widgetsScreen.colorString,
                          finish: "N",
                          date_create: DateTime.now().toIso8601String(),
                          priority: widgetsScreen.boolPriority ? 1 : 0,
                          date_programmed: widgetsScreen.selectNotificationPro.toIso8601String(),
                          notifications: !widgetsScreen.boolSelectNotification ? null : widgetsScreen.selectNotification.toIso8601String()));
                  for (var element in listType) {
                    element.id_task = id_task;
                    element.check_task = "N";
                    DatabaseHelper().insertDatabase("task_type", element);
                  }

                  for (var element in widgetsScreen.tagsSelect) {
                    DatabaseHelper().insertDatabase("task_tags", TaskTags(id_tag: element, id_task: id_task));
                  }
                  
                  if (widgetsScreen.boolSelectNotification && DateTime.now().isBefore(widgetsScreen.selectNotification) ) {
                    NotificationCommon notification = NotificationCommon();
                    await notification.startClass();
                    await notification.creteNotification("${titleEditingController.text} ${widgetsScreen.boolPriority ? "🌟" : ""}", "Marque como concluida ✅",
                        widgetsScreen.selectNotification.millisecondsSinceEpoch + 10000, "todo", id_task);
                  }

                  Navigator.pop(context, true);
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
