import 'package:flutter/material.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/services/notification.dart';
import 'package:flutter_todo_app/services/theme_service.dart';
import 'package:flutter_todo_app/ui/button.dart';
import 'package:flutter_todo_app/ui/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                          const MyButton(
                            label: '+ Add Task',
                            onTap: null,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
