import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/task.dart';
import 'package:flutter_todo_app/services/input_field.dart';
import 'package:flutter_todo_app/ui/button.dart';
import 'package:flutter_todo_app/ui/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../db/db_helper.dart';

class Addtask extends StatefulWidget {
  const Addtask({Key? key}) : super(key: key);

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  TextEditingController txt = TextEditingController();
  TextEditingController note = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    Themes th = Themes();
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Get.isDarkMode ? context.theme.backgroundColor : Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Get.isDarkMode ? Colors.white : primaryclr,
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('lib/ui/images/3551739.jpg'),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Add Task',
                  style: th.HeadingStyle,
                ),
              ),
              InputField(
                title: 'Title',
                hint: 'Enter your title',
                textEditingController: txt,
              ),
              const SizedBox(
                height: 40,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter your note',
                textEditingController: note,
              ),
              const SizedBox(
                height: 40,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMMMMd().format(_selectedDate),
                iswidget: true,
                iscalender: true,
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Color',
                        style: th.subHeadingStyle,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Wrap(
                        children: List<Widget>.generate(3, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(right: 8),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: index == 0
                                    ? primaryclr
                                    : index == 1
                                        ? pinkclr
                                        : yellowishclr,
                                child: _selectedColor == index
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      )
                                    : Container(),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  MyButton(
                    label: "Create Task",
                    onTap: () {
                      _validateDate();
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() async {
    if (txt.text.isNotEmpty && note.text.isNotEmpty) {
      _addTaskToDb();

      Get.back();
    } else if (txt.text.isEmpty || note.text.isEmpty) {
      Get.snackbar("Required", "All Fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Get.isDarkMode ? primaryclr : Colors.grey[800],
          backgroundColor: Get.isDarkMode ? Colors.grey : Colors.white,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Get.isDarkMode ? primaryclr : Colors.grey[800],
          ));
    }
  }

  _addTaskToDb() async {
    try {
      int v = await DatabaseHelper.instance.add(Task(
          title: (txt.text).toString(),
          note: note.text,
          isCompleted: 0,
          date: DateFormat.yMMMMd().format(_selectedDate),
          color: _selectedColor));
      setState(() {
        txt.clear();
      });
    } catch (e) {
      print('hi $e');
    }
  }

  _getDateTimeFromUSer(BuildContext context) async {
    DateTime? _selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(DateTime.now().year + 5));

    if (_selected != null) {
      _selectedDate = _selected;
    }
  }
}
