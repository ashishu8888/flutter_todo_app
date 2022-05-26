import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/services/notification.dart';
import 'package:flutter_todo_app/services/theme_service.dart';
import 'package:flutter_todo_app/ui/addTask.dart';
import 'package:flutter_todo_app/ui/button.dart';
import 'package:flutter_todo_app/ui/taskTile.dart';
import 'package:flutter_todo_app/ui/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../db/db_helper.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selected = DateTime.now();
  // ignore: prefer_typing_uninitialized_variables
  var notifyHelper;
  var db = DatabaseHelper.instance;
  Themes th = Themes();
  var _selectedId;
  @override
  void initState() {
    super.initState();
    notifyHelper = Notify();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Get.isDarkMode ? context.theme.backgroundColor : Colors.white10,
        elevation: 0,
        title: Text(
          'To Do',
          style: TextStyle(
              color: context.theme.backgroundColor,
              fontWeight: FontWeight.bold,
              fontSize: 27),
        ),
        centerTitle: true,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('lib/ui/images/3551739.jpg'),
          )
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: GestureDetector(
            child: Icon(
              Get.isDarkMode ? Icons.sunny : Icons.dark_mode_sharp,
              color: Get.isDarkMode == false ? Colors.grey : Colors.white,
            ),
            onTap: () {
              setState(() {
                ThemeService().switchTheme();

                notifyHelper.initializeNotification();
                notifyHelper.displayNotification(
                    title: "Theme Changed",
                    body: Get.isDarkMode ? "Light Mode" : "Dark Mode");
                //Notify().scheduledNotification();
              });
            }),
      ),
      body: Container(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(
                          DateTime.now(),
                        ),
                        style: th.subHeadingStyle,
                      ),
                      Text('Today', style: th.HeadingStyle)
                    ],
                  ),
                ),
                MyButton(
                  label: '+ Add Task',
                  onTap: () async {
                    await Get.to(() => const Addtask());
                    setState(() {
                      _showTasks();
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryclr,
              selectedTextColor: Colors.white,
              monthTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              dateTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              onDateChange: (date) {
                setState(() {
                  _selected = date;
                  _showTasks();
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 360,
            width: 380,
            child: _showTasks(),
          )
        ],
      )),
    );
  }

  _showTasks() {
    return FutureBuilder<List>(
        future: DatabaseHelper.instance.getToDo(),
        initialData: const [],
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    if (snapshot.data![index].date ==
                        DateFormat.yMMMMd().format(_selected)) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                            child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedId = snapshot.data![index].id;
                                  });
                                  _showBottomSheet(
                                      context, snapshot.data![index]);
                                },
                                child: TaskTile(snapshot.data![index]),
                              )
                            ],
                          ),
                        )),
                      );
                    } else {
                      return Container();
                    }
                  })
              : Center(
                  child: Container(
                  height: 100,
                  width: 100,
                  // color: Colors.blue,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Get.isDarkMode
                          ? const AssetImage('lib/ui/images/efg.png')
                          : const AssetImage('lib/ui/images/abc.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                  ),
                ));
        });
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.20
          : MediaQuery.of(context).size.height * 0.32,
      child: Column(children: [
        Container(
          height: 6,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[600]),
        ),
        task.isCompleted == 1
            ? Container()
            : const SizedBox(
                height: 20,
              ),
        task.isCompleted == 0
            ? _bottomSheetButton(
                label: "Task Completed",
                onTap: () async {
                  await DatabaseHelper.instance.update(Task(
                      id: _selectedId,
                      isCompleted: 1,
                      title: task.title,
                      note: task.note,
                      date: task.date,
                      color: task.color));
                  setState(() {
                    DatabaseHelper.instance.getToDo();
                    _showTasks();
                  });
                  Get.back();
                },
                clr: primaryclr,
                context: context)
            : Container(),
        const SizedBox(
          height: 20,
        ),
        _bottomSheetButton(
            label: "Delete",
            onTap: () async {
              await DatabaseHelper.instance.remove(_selectedId);
              setState(() {
                DatabaseHelper.instance.getToDo();
                _showTasks();
              });
              Get.back();
            },
            clr: Colors.red,
            context: context),
        const SizedBox(
          height: 20,
        ),
      ]),
    ));
  }

  _bottomSheetButton(
      {required String? label,
      required Function()? onTap,
      required Color? clr,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: clr,
            border: Border.all(
              width: 2,
              color: Get.isDarkMode == false && clr == Colors.white
                  ? Colors.black
                  : clr!,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            label!,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
