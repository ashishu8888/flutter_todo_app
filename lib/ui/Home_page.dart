import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/services/notification.dart';
import 'package:flutter_todo_app/services/theme_service.dart';
import 'package:flutter_todo_app/ui/addTask.dart';
import 'package:flutter_todo_app/ui/button.dart';
import 'package:flutter_todo_app/ui/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selected = DateTime.now();
  var notifyHelper;
  Themes th = Themes();
  @override
  void initState() {
    super.initState();
    notifyHelper = Notify();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: context.theme.backgroundColor,
            elevation: 0,
            // backgroundColor: primaryclr,
            floating: true,
            pinned: true,
            leading: GestureDetector(
                child:
                    Icon(Get.isDarkMode ? Icons.sunny : Icons.dark_mode_sharp),
                onTap: () {
                  setState(() {
                    ThemeService().switchTheme();
                    notifyHelper.initializeNotification();
                    notifyHelper.displayNotification(
                        title: "Theme Changed",
                        body: Get.isDarkMode ? "Light Mode" : "Dark Mode");
                    // Notify().scheduledNotification();
                  });
                }),
            expandedHeight: 100,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('ToDo List'),
              centerTitle: true,
            ),
            actions: const [
              CircleAvatar(
                backgroundImage: AssetImage('lib/ui/images/3551739.jpg'),
              )
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(20),
          //       child: Container(
          //         height: 400,
          //         color: Colors.green,
          //       ),
          //     ),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
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
                            onTap: () => Get.to(() => const Addtask()),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
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
                  _selected = date;
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
