import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/invoiceApi/invoiceApiService.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/invoiceScreens/add_invoice_screen.dart';
import 'package:liveasy/widgets/check_invocie_dialogBox.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class InvoiceScreen extends StatefulWidget {
  InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String? selectedMonth;
  DateTime fromTimestamp = DateTime(2000);
  DateTime toTimestamp = DateTime.now();
  late RefreshController
      _refreshController; //refresh controller to control state

  DateTime now = DateTime.now().subtract(const Duration(hours: 5, minutes: 30));

  List<Map<String, dynamic>> invoices = [];
  String transporterId = '';
  List<Map<String, dynamic>> filteredList = [];
  //this is the refresh function which handle the operation on refresh of screen
  void _onRefresh() async {
    _fetchInvoiceData();

    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    // if failed, use refreshFailed()
    _refreshController.refreshCompleted();
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = true; // Flag to track whether data is being loaded

  @override
  void dispose() {
//dispose the refresh controller once it been used
    _refreshController.dispose();
    super.dispose();
  }

  // Function to fetch invoice data
  Future<void> _fetchInvoiceData() async {
    setState(() {
      isLoading = true;
    });
    TransporterIdController transporterIdController =
        Get.find<TransporterIdController>();

    transporterId = transporterIdController.transporterId.value;
    try {
      List<dynamic> data = await InvoiceApiService.getInvoiceData(
        transporterId,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(fromTimestamp),
        DateFormat('yyyy-MM-dd HH:mm:ss').format(toTimestamp),
      );

      // Check if the widget is mounted before calling setState
      if (mounted) {
        setState(() {
          invoices = List<Map<String, dynamic>>.from(data);
          isLoading = false; // Set isLoading to false after data is fetched
        });
      }
    } catch (e) {
      print('Error fetching invoice data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchInvoiceData();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header section with back button and title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    //Handle back button press
                  },
                ),
                Text(
                  'Invoice Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 30),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 50,
                    child: Card(
                      elevation: 10,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 5.0,
                          right: 5.0,
                          top: 10,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search by name, invoice no',
                            hintStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            filterInvoices(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Date filter
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            // right: 8.0,
                            // top: 8.0,
                            // left: 20,
                            ),
                        child: Text(
                          "Date",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Dropdown for month filter
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: selectedMonth,
                        items: [
                          'Today',
                          'This Week',
                          'This Month',
                          'Last Month',
                          'This Year',
                          'Custom'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          // Handle dropdown menu selection
                          setState(() {
                            selectedMonth = value;
                            // Call the respective function based on the selected value
                            handleDateRangeSelection(value!);
                            _fetchInvoiceData();
                            // You can perform actions based on the selected value
                            // print("Selected Month: $selectedMonth");
                          });
                        },
                        hint: Text(
                          'All Month',
                          style: GoogleFonts.montserrat(),
                        ),
                        underline: Container(),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Add Invoice button
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddInvoiceDialog();
                          },
                        );
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add Invoice'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kLiveasyColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          // Invoice list section
          // here we are invoking the buildtable for invoice info table
          buildDesktopTable(invoices, filteredList)
        ],
      ),
    );
  }
//table for invoice data from the api
  Widget buildDesktopTable(List<Map<String, dynamic>> invoices,
      List<Map<String, dynamic>> filteredList) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: (kIsWeb && Responsive.isDesktop(context))
            ? Card(
                surfaceTintColor: Colors.transparent,
                margin: EdgeInsets.only(bottom: 5),
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Table Header
                    Container(
                      height: 69,
                      color: Color.fromRGBO(234, 238, 255, 1),
                      child: Row(
                        children: [
                          buildTableCell(
                            'Invoice Date',
                            isHeader: true,
                          ),
                          buildTableCell(
                            'Invoice No',
                            isHeader: true,
                          ),
                          buildTableCell(
                            'Invoice Amount',
                            isHeader: true,
                          ),
                          buildTableCell(
                            'Party Name',
                            isHeader: true,
                          ),
                          buildTableCell(
                            'Due Date',
                            isHeader: true,
                          ),
                          buildTableCell(
                            'Invoice Details',
                            isHeader: true,
                          ),
                        ],
                      ),
                    ),
                    // Invoice List
                    /*
                      This is the list of invoices, and here we use pull-to-refresh to fetch data from the API.
                      For mobile, we use the pull-to-refresh plugin directly.
                     For web, we add ScrollConfiguration to specify the allowed drag devices (touch, mouse, trackpad, stylus) for pull-down.
                   */

                    Expanded(
                        flex: 4,
                        child: isLoading
                            ? ShimmerEffect()
                            : ScrollConfiguration(
                                behavior:
                                    //scroll configuration is added because normal pull to refresh plugin don't work for the web so to handle the drag of touch or mouse we are using it
                                    ScrollConfiguration.of(context).copyWith(
                                  dragDevices: {
                                    PointerDeviceKind.touch,
                                    PointerDeviceKind.mouse,
                                    PointerDeviceKind.trackpad,
                                    PointerDeviceKind.stylus,
                                  },
                                ),
                                child: SmartRefresher(
                                  enablePullDown: true,
                                  header: ClassicHeader(),
                                  footer: CustomFooter(
                                    builder: (BuildContext context,
                                        LoadStatus? mode) {
                                      Widget body;
                                      if (mode == LoadStatus.idle) {
                                        body = Text("pull up load");
                                      } else if (mode == LoadStatus.loading) {
                                        body = CupertinoActivityIndicator();
                                      } else if (mode == LoadStatus.failed) {
                                        body = Text("Load Failed!Click retry!");
                                      } else if (mode ==
                                          LoadStatus.canLoading) {
                                        body = Text("release to load more");
                                      } else {
                                        body = Text("No more Data");
                                      }
                                      return Container(
                                        height: 55.0,
                                        child: Center(child: body),
                                      );
                                    },
                                  ),
                                  controller: _refreshController,
                                  onRefresh: _onRefresh,
                                  // Building the list of invoices
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: filteredList.isNotEmpty
                                        ? filteredList.length
                                        : invoices.length,
                                    itemBuilder: (context, index) {
                                      final invoice = filteredList.isNotEmpty
                                          ? filteredList[index]
                                          : invoices[index];

                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              buildTableCell(
                                                  invoice['invoiceDate'] ?? '',
                                                  isHeader: false),
                                              buildTableCell(
                                                  invoice['invoiceNo'] ?? '',
                                                  isHeader: false),
                                              buildTableCell(
                                                  '\$${invoice['invoiceAmount'] ?? ''}',
                                                  isHeader: false),
                                              buildTableCell(
                                                  invoice['partyName'] ?? '',
                                                  isHeader: false),
                                              buildTableCell(
                                                  invoice['dueDate'] ?? '',
                                                  isHeader: false),
                                              buildTableCell(
                                                  invoice['invoiceDetails'] ??
                                                      'check invoice',
                                                  isHeader: false,
                                                  invoiceId:
                                                      invoice['invoiceId']),
                                            ],
                                          ),
                                          Divider(
                                              thickness: 1,
                                              height: 0,
                                              color: Colors.grey),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              )),
                  ],
                ),
              )
            : isLoading
                ? ShimmerEffect()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];

                      return Container(
                        height: 90,
                        color: Colors.white,
                        child: Row(
                          children: [
                            buildTableCell(
                              invoice['invoiceDate'] ?? '',
                              isHeader: false,
                            ),
                            buildTableCell(
                              invoice['invoiceNo'] ?? '',
                              isHeader: false,
                            ),
                            buildTableCell(
                              '\$${invoice['invoiceAmount'] ?? ''}',
                              isHeader: false,
                            ),
                            buildTableCell(
                              invoice['partyName'] ?? '',
                              isHeader: false,
                            ),
                            buildTableCell(
                              invoice['dueDate'] ?? '',
                              isHeader: false,
                            ),
                            buildTableCell(
                              invoice['invoiceDetails'] ?? '',
                              isHeader: false,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  // This functions filters the displayed invoice list based on the entered search text
  void filterInvoices(String searchText) {
    setState(() {
      filteredList = invoices
          .where((invoice) =>
              (invoice['invoiceNo']
                      ?.toLowerCase()
                      .contains(searchText.toLowerCase()) ??
                  false) ||
              (invoice['partyName']
                      ?.toLowerCase()
                      .contains(searchText.toLowerCase()) ??
                  false))
          .toList();
    });
  }

  void handleDateRangeSelection(String value) {
    switch (value) {
      case 'Today':
        setState(() {
          fromTimestamp = DateTime(now.year, now.month, now.day);
          toTimestamp = DateTime(now.year, now.month, now.day, 23, 59, 59);
        });

        break;
      case 'This Week':
        int dayOfWeek = now.weekday;
        setState(() {
          fromTimestamp = now.subtract(Duration(days: dayOfWeek - 1));
          toTimestamp = now.add(Duration(
              days: 7 - dayOfWeek, hours: 23, minutes: 59, seconds: 59));
        });
        break;
      case 'This Month':
        setState(() {
          fromTimestamp = DateTime(now.year, now.month, 1);
          toTimestamp = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        });

        break;
      case 'Last Month':
        setState(() {
          fromTimestamp = DateTime(now.year, now.month - 1, 1);
          toTimestamp = DateTime(now.year, now.month, 0, 23, 59, 59);
        });

        break;
      case 'This Year':
        setState(() {
          fromTimestamp = DateTime(now.year, 1, 1);
          toTimestamp = DateTime(now.year, 12, 31, 23, 59, 59);
        });

        break;
      case 'Custom':
        // Handle custom date range if needed
        break;
      default:
        // Default case
        break;
    }
  }

  // Widget to build table cell
  Widget buildTableCell(String text,
      {bool isHeader = false, String? invoiceId}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (text == 'check invoice') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return InvoiceDetailsDialog(invoiceId: invoiceId!);
                });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border:
                Border.symmetric(vertical: BorderSide(width: 0.5, color: grey)),
          ),
          child: ListTile(
            title: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: (text == 'check invoice') ? kLiveasyColor : Colors.black,
                fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
                decoration: text == 'check invoice'
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
            tileColor: isHeader ? tableHeaderColor : white,
            contentPadding: EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }

  // Shimmer effect widget
  Widget ShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 500, // Adjust the height as needed
        margin: EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(
            6, // Number of shimmer items you want
            (index) => Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 50.0,
            ),
          ),
        ),
      ),
    );
  }
}
