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

class InvoiceScreen extends StatefulWidget {
  InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String? selectedMonth;
  DateTime fromTimestamp = DateTime(2000);
  DateTime toTimestamp = DateTime.now();

  DateTime now = DateTime.now().subtract(const Duration(hours: 5, minutes: 30));

  List<Map<String, dynamic>> invoices = [];
  String transporterId = '';
  List<Map<String, dynamic>> filteredList = [];

  // Function to fetch invoice data
  Future<void> _fetchInvoiceData() async {
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
                // Date filter and Add Invoice button
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
                        AddInvoiceDialog.show(context, transporterId);
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add Invoice'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF000066),
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
          Expanded(
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
                                  tableHeaderColor,
                                  isHeader: true,
                                ),
                                buildTableCell(
                                  'Invoice No',
                                  tableHeaderColor,
                                  isHeader: true,
                                ),
                                buildTableCell(
                                  'Invoice Amount',
                                  tableHeaderColor,
                                  isHeader: true,
                                ),
                                buildTableCell(
                                  'Party Name',
                                  tableHeaderColor,
                                  isHeader: true,
                                ),
                                buildTableCell(
                                  'Due Date',
                                  tableHeaderColor,
                                  isHeader: true,
                                ),
                                buildTableCell(
                                  'Invoice Details',
                                  tableHeaderColor,
                                  isHeader: true,
                                ),
                              ],
                            ),
                          ),
                          // Invoice List
                          Expanded(
                            flex: 4,
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
                                            Colors.white,
                                            isHeader: false),
                                        Divider(
                                            thickness: 1,
                                            height: 0,
                                            color: Colors.grey),
                                        buildTableCell(
                                            invoice['invoiceNo'] ?? '',
                                            Colors.white,
                                            isHeader: false),
                                        Divider(
                                            thickness: 1,
                                            height: 0,
                                            color: Colors.grey),
                                        buildTableCell(
                                            '\$${invoice['invoiceAmount'] ?? ''}',
                                            Colors.white,
                                            isHeader: false),
                                        Divider(
                                            thickness: 1,
                                            height: 0,
                                            color: Colors.grey),
                                        buildTableCell(
                                            invoice['partyName'] ?? '',
                                            Colors.white,
                                            isHeader: false),
                                        Divider(
                                            thickness: 1,
                                            height: 0,
                                            color: Colors.grey),
                                        buildTableCell(invoice['dueDate'] ?? '',
                                            Colors.white,
                                            isHeader: false),
                                        Divider(
                                            thickness: 1,
                                            height: 0,
                                            color: Colors.grey),
                                        buildTableCell(
                                            invoice['invoiceDetails'] ?? '',
                                            Colors.white,
                                            isHeader: false),
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
                        ],
                      ),
                    )
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
                                Colors.white,
                                isHeader: false,
                              ),
                              buildTableCell(
                                invoice['invoiceNo'] ?? '',
                                Colors.white,
                                isHeader: false,
                              ),
                              buildTableCell(
                                '\$${invoice['invoiceAmount'] ?? ''}',
                                Colors.white,
                                isHeader: false,
                              ),
                              buildTableCell(
                                invoice['partyName'] ?? '',
                                Colors.white,
                                isHeader: false,
                              ),
                              buildTableCell(
                                invoice['dueDate'] ?? '',
                                Colors.white,
                                isHeader: false,
                              ),
                              buildTableCell(
                                invoice['invoiceDetails'] ?? '',
                                Colors.white,
                                isHeader: false,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
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
        fromTimestamp = DateTime(now.year, now.month, now.day);
        toTimestamp = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'This Week':
        int dayOfWeek = now.weekday;
        fromTimestamp = now.subtract(Duration(days: dayOfWeek - 1));
        toTimestamp = now.add(
            Duration(days: 7 - dayOfWeek, hours: 23, minutes: 59, seconds: 59));
        break;
      case 'This Month':
        fromTimestamp = DateTime(now.year, now.month, 1);
        toTimestamp = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case 'Last Month':
        fromTimestamp = DateTime(now.year, now.month - 1, 1);
        toTimestamp = DateTime(now.year, now.month, 0, 23, 59, 59);
        break;
      case 'This Year':
        fromTimestamp = DateTime(now.year, 1, 1);
        toTimestamp = DateTime(now.year, 12, 31, 23, 59, 59);
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
  Widget buildTableCell(String text, Color backgroundColor,
      {bool isHeader = false}) {
    return Expanded(
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
              color: isHeader ? Colors.black : Colors.black,
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          tileColor: backgroundColor,
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
