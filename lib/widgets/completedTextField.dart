import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenTwo.dart';

class CompletedTextField extends StatefulWidget {
  const CompletedTextField({Key? key}) : super(key: key);

  @override
  _CompletedTextFieldState createState() => _CompletedTextFieldState();
}

class _CompletedTextFieldState extends State<CompletedTextField> {
  TextEditingController completedController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 10, 0, 0));
    Jiffy nextDay = Jiffy(picked);

    if (picked != null && picked != selectedDate)
      setState(() {
        _selectDate(context);
        selectedDate = picked;
        completedController.text = nextDay.MMMEd;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(space_3, space_0, space_0, space_0),
      height: space_8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space_6),
        border: Border.all(color: darkBlueColor, width: borderWidth_8),
        color: widgetBackGroundColor,
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: "Enter Completed Date",
            suffixIcon: IconButton(
                onPressed: () {}, icon: Icon(Icons.ac_unit, size: 27))),
        controller: completedController,
      ),
    );
  }
}
