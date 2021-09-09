import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/home.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:liveasy/widgets/HelpCardWidget.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class HelpScreen extends StatefulWidget{
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final myController = TextEditingController();
  bool _showData = false;
  //add questions here
  List<String> questions = ['How to add truck?',
    'How to post load?',
    'How to bid?',
    'How to purchase GPS?',
    'How to see my orders?',
    'How to verify my account?',
    'How to add driver?',
    'How to change language?',
    'How to find load for my truck?',
    'Why should I buy GPS?',
  ];
  @override
  Widget build(BuildContext context) {
    var cardWidth;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top:50, right:space_4, left: space_4),
          height: MediaQuery
              .of(context)
              .size
              .height -
              // kBottomNavigationBarHeight -
              space_4,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.only(right: 20),
                            child:
                                Header(
                                    reset: false,
                                    text: 'Help and Support',
                                    backButton: true),
                                // Text(
                                //   'Help and Support',
                                //   style: TextStyle(fontFamily: 'montserrat',
                                //       fontSize: 20,
                                //       fontWeight: FontWeight.w600),
                                //   textAlign: TextAlign.left,
                                // ),
                        )
                      ],
                    ),
                    ContactUsWidget(),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 30),
                  child: Text('What\'s your question?',
                    style: TextStyle(fontFamily: 'montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only( top: 7),
                  child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                  height: 3,
                  width: 80,
                  alignment: Alignment.centerLeft,
                  // margin: EdgeInsets.only(top: 7, bottom: 20),
                  decoration: BoxDecoration(
                      color: Color(0xff09B778),
                  ),
                ),
                ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: SearchLoadWidget(
                    hintText: 'Search',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => NextUpdateAlertDialog());
                    },
                  ),
                ),
               Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: questions.length+1,
                          itemBuilder: (BuildContext context, int index) {
                            return index!=10? Column(
                                children: [
                                  // returning the CardWidget passing only title
                                  HelpCardWidget(
                                      title: questions[index],
                                      index: index
                                  ),
                                ]
                            ):
                            GestureDetector(
                                onTap: (){
                                  setState(() => _showData = !_showData);
                                },
                                child: Container(
                                    margin: EdgeInsets.only(top: 10),

                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(7)
                                    ),
                                    child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: Column(
                                            children: [
                                              ListTile(
                                                title: Text('Ask a question',
                                                  style: TextStyle(fontFamily: 'montserrat', fontWeight: FontWeight.w600, fontSize: 14),
                                                ),
                                                trailing: !_showData?Icon(Icons.arrow_forward_ios,
                                                    color: Colors.black, size: 14): Icon(Icons.keyboard_arrow_down,
                                                    color: Colors.black, size: 25),
                                              ),
                                              _showData ? Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.only(left: 10, bottom: 14, right: 10),
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                            Container(
                                                              // margin: EdgeInsets.only(top: 5, bottom: 5),
                                                              alignment: Alignment.topLeft,
                                                              child: TextFormField(
                                                                maxLines: 5,
                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'montserrat'),
                                                                controller: myController,
                                                                textAlign: TextAlign.start,
                                                                decoration: const InputDecoration(
                                                                  fillColor: Color(0xffF5F5F5),
                                                                  filled: true,
                                                                  contentPadding: EdgeInsets.only(top: 20, left: 10, right: 10),
                                                                border: OutlineInputBorder(),
                                                                hintText: 'Please write to us, we will get in touch with you.',
                                                                  hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'montserrat')
                                                          ),
                                                           ),
                                                            ),
                                                        Container(
                                                          alignment: Alignment.centerRight,
                                                          padding: EdgeInsets.only(left:space_3),
                                                          child: TextButton(
                                                            style: ButtonStyle(
                                                              shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(30),
                                                              )),
                                                              backgroundColor:
                                                              MaterialStateProperty.all<Color>(darkBlueColor),
                                                            ),
                                                            onPressed: () {
                                                              _sendMail(myController.text);
                                                            },
                                                            child: Container(
                                                              child: Text(
                                                                'Submit',
                                                                style: TextStyle(
                                                                  letterSpacing: 0.7,
                                                                  fontWeight: normalWeight,
                                                                  color: white,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                  )
                                              ): SizedBox() // else blank

                                            ]
                                        )
                                    )
                                )
                            );
                          }
                           ),
                       ),
              ]
          ),
        ),
      ),
    );
  }
}

class ContactUsWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
       alignment: Alignment.centerRight,
        padding: EdgeInsets.only(left: 7),

        child: GestureDetector(
        onTap: () {
          _callUs();
        },
        child: Container(
          padding: EdgeInsets.only(left: space_2),
          height: space_6,
          width: space_16,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(width: borderWidth_10, color: darkBlueColor)),
          child: Center(
            child: Row(
              children: [
                Container(
                  height: space_3,
                  width: space_3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icons/helpIcon.png"))),
                ),
                SizedBox(
                  width: space_1,
                ),
                Text(
                  'Call Us',
                  style: TextStyle(fontSize: size_6, color: darkBlueColor),
                ),
              ],
            ),
          ),
        ),
    )
    );
  }
}
_callUs() async{
  String url = 'tel:8290748131';
  UrlLauncher.launch(url);
}
_sendMail(String askedQuestion) async{
  String url = 'mailto:liveasy97@gmail.com?subject=Question&body=${askedQuestion}';
  UrlLauncher.launch(url);
}
