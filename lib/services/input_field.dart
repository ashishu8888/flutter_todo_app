import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/ui/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InputField extends StatefulWidget {
  final String title;
  String hint;
  TextEditingController? textEditingController;
  bool? iswidget;
  bool? iscalender;
  bool? isclock;

  InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.textEditingController,
    this.iswidget,
    this.iscalender,
    this.isclock,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  String? date;
  DateTime _selectedDate = DateTime.now();
  Themes th = Themes();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
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
                    readOnly: widget.iswidget == null ? false : true,
                    autofocus: false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[400],
                    controller: widget.textEditingController,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        hintText: widget.iscalender == null
                            ? widget.hint
                            : DateFormat.yMMMMd().format(_selectedDate),
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
                widget.iswidget != null && widget.iscalender != null
                    ? Container(
                        child: IconButton(
                            onPressed: () {
                              _showDate(context);
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

  _showDate(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
    });
  }
}
