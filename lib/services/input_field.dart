import 'package:flutter/material.dart';
import 'package:flutter_todo_app/ui/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InputField extends StatelessWidget {
  final String title;
  String hint;
  String? date;
  final TextEditingController? textEditingController;
  bool? iswidget;
  bool? iscalender;
  bool? isclock;

  InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.textEditingController,
      this.iswidget,
      this.iscalender,
      this.isclock})
      : super(key: key);

  Themes th = Themes();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: th.subHeadingStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 52,
            padding: const EdgeInsets.only(left: 10),
            //color: Colors.grey,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    // ignore: unnecessary_null_comparison
                    readOnly: iswidget == null ? false : true,
                    autofocus: false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[400],
                    controller: textEditingController,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        hintText: date == null ? hint : date,
                        hintStyle: const TextStyle(fontSize: 16),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Get.isDarkMode ? Colors.grey : Colors.white,
                              width: 0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Get.isDarkMode ? Colors.grey : Colors.white,
                                width: 0))),
                  ),
                ),
                iswidget != null && iscalender != null
                    ? Container(
                        child: IconButton(
                            onPressed: () {
                              _getDateTimeFromUSer(context);
                            },
                            icon: const Icon(Icons.calendar_month_rounded)),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getDateTimeFromUSer(BuildContext context) async {
    DateTime? _selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2024));

    if (_selected != null) {
      date = DateFormat.yMMMMd().format(_selected);
      textEditingController!.text = date!;
    }
  }
}
