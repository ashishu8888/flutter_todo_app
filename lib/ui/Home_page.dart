import 'package:flutter/material.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/services/notification.dart';
import 'package:flutter_todo_app/services/theme_service.dart';
import 'package:flutter_todo_app/ui/theme.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
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
            backgroundColor: primaryclr,
            floating: true,
            pinned: true,
            leading: GestureDetector(
                child: const Icon(Icons.dark_mode_sharp),
                onTap: () {
                  setState(() {
                    ThemeService().switchTheme();
                    notifyHelper.initializeNotification();
                    notifyHelper.displayNotification(
                        title: "Theme Changed",
                        body: Get.isDarkMode ? "Light Mode" : "Dark Mode");
                  });
                }),
            expandedHeight: 200,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('ToDo List'),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.black26,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
