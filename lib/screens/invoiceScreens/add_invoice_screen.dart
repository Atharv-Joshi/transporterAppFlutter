import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bookingApi/getBookingDataWithTransporterId.dart';
import 'package:liveasy/functions/invoiceApi/invoiceApiService.dart';
import 'package:shimmer/shimmer.dart';

class AddInvoiceDialog {
  static List<Map<String, dynamic>> selectedBookings = [];
  static List<String> uploadedFiles = [];

  // Function to fetch booking data using the transporter ID
  static Future<List<Map<String, dynamic>>> fetchBookingData() async {
    try {
      // Get the transporter ID from the controller
      TransporterIdController transporterIdController =
          Get.find<TransporterIdController>();
      String transporterId = transporterIdController.transporterId.value;

// Fetch booking data using the transporter ID
      List<dynamic> data = await ApiService.fetchBookingData(transporterId);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching Booking data: $e');
      return [];
    }
  }

//Dialog box for addinvoice
  static void show(BuildContext context, String transporterId) {
    TextEditingController invoiceNumberController = TextEditingController();
    TextEditingController invoiceDateController = TextEditingController();
    TextEditingController invoicePartyName = TextEditingController();
    TextEditingController invoiceBalance = TextEditingController();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Invoice',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 14),
                    _buildInvoiceDetailsForm(
                        invoiceNumberController,
                        invoiceDateController,
                        invoicePartyName,
                        invoiceBalance,
                        context),
                    SizedBox(height: 14),
                    Text(
                      'Select Trip',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.4,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: fetchBookingData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildShimmerEffect();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<Map<String, dynamic>> invoices =
                                  snapshot.data!;
                              return _buildTripDetailsTable(context, invoices,
                                  selectedBookings, invoiceBalance);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle onTap action
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: bidBackground),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Back',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: bidBackground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        //Create Invoice Button
                        SizedBox(
                          height: 45,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              InvoiceApiService.postInvoiceData(
                                transporterId,
                                invoicePartyName.text,
                                invoiceNumberController.text,
                                invoiceDateController.text,
                                invoiceBalance.text,
                                selectedBookings
                                    .map((invoice) => invoice['bookingId'])
                                    .toList(),
                              );
                            },
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
                            child: Text(
                              'Create Invoice',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //invoice no,invoice date,upload doc form
  static Widget _buildInvoiceDetailsForm(
    TextEditingController invoiceNumberController,
    TextEditingController invoiceDateController,
    TextEditingController invoicePartyNameController,
    TextEditingController invoiceBalanceController,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Party Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 150,
                    height: 30,
                    child: TextField(
                      controller: invoicePartyNameController,
                      decoration: InputDecoration(
                        hintText: 'partyname',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(invoiceBalanceController.text),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice Number',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity, // Take full available width
                    height: 30,
                    child: TextField(
                      controller: invoiceNumberController,
                      decoration: InputDecoration(
                        hintText: 'ABX-002',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //implemented the calender for date picker
                  GestureDetector(
                    onTap: () async {
                      final config =
                          CalendarDatePicker2WithActionButtonsConfig();

                      final List<DateTime?>? pickedDates =
                          await showCalendarDatePicker2Dialog(
                        context: context,
                        config: config,
                        dialogSize: const Size(325, 400),
                        borderRadius: BorderRadius.circular(15),
                        dialogBackgroundColor: Colors.white,
                      );

                      if (pickedDates != null && pickedDates.isNotEmpty) {
                        invoiceDateController.text =
                            formatDateTime(pickedDates.first!);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 30,
                      child: TextField(
                        controller: invoiceDateController,
                        decoration: InputDecoration(
                          hintText: _getCurrentDate(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        enabled: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Column(
                children: [
                  SizedBox(
                    height: 27,
                  ),
                  //upload bill button
                  GestureDetector(
                    onTap: () {
                      // Handle onTap action
                      _showUploadBillDialog(
                          context); // upload bill dialog box function
                    },
                    child: Container(
                      height: 32,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: bidBackground),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/solar_upload-linear.png',
                            color: bidBackground,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Upload Bill',
                            style: TextStyle(
                              fontSize: 15,
                              color: bidBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  //get current date
  static String _getCurrentDate() {
    DateTime now = DateTime.now();
    return "${now.day}-${now.month}-${now.year}";
  }

  // format date
  static String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  // upload bill dialog box which appear middle of screen
  static void _showUploadBillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildUploadBillDialogContent(context),
        );
      },
    );
  }

  // upload bill dialog box UI
  static Widget _buildUploadBillDialogContent(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Upload Bill',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(242, 243, 254, 1)),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.28,
            child: DottedBorder(
              dashPattern: [6, 5],
              borderType: BorderType.RRect,
              radius: Radius.circular(10),
              color: bidBackground,
              strokeWidth: 0.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/uploadIcon_invoice.png',
                          color: bidBackground,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Drag or Drop File or',
                          style: TextStyle(
                            fontSize: 14,
                            color: black,
                          ),
                        ),

                        // implemented the feature to get the file from the device
                        TextButton(
                          onPressed: () async {
                            XFile? pickedFile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);

                            if (pickedFile != null) {
                              String fileName = pickedFile.name;

                              uploadedFiles.add(fileName);

                              debugPrint('Selected file name: $fileName');

                              debugPrint(
                                  'Picked file path: ${pickedFile.path}');
                              Navigator.of(context).pop();
                              _showUploadBillDialog(context);
                            }

                            // Implement file browsing logic here
                          },
                          child: Text(
                            'Browse File',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: bidBackground),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Uploaded Files:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 40,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(9, 183, 120, 1))),
                      width: double.infinity,
                      child: Column(
                        children: [
                          for (String fileName in uploadedFiles)
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(fileName,
                                      style: TextStyle(fontSize: 14)),
                                  GestureDetector(
                                    onTap: () {
                                      // Handle delete logic
                                      uploadedFiles.remove(fileName);
                                      (context as Element).markNeedsBuild();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF000066),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {},
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
                    child: Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // handle the table view and table content from api
  static Widget _buildTripDetailsTable(
    BuildContext context,
    List<Map<String, dynamic>> invoices,
    List<Map<String, dynamic>> selectedInvoices,
    TextEditingController invoiceBalance,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: Card(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: tableHeaderColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTableCell(
                      'Booking Date',
                      isHeader: true,
                    ),
                    _buildTableCell(
                      'LR No',
                      isHeader: true,
                    ),
                    _buildTableCell(
                      'Route',
                      isHeader: true,
                    ),
                    _buildTableCell(
                      'Truck No',
                      isHeader: true,
                    ),
                    _buildTableCell(
                      'Freight',
                      isHeader: true,
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: invoices.isEmpty
                    ? _buildShimmerEffect()
                    : ListView.builder(
                        itemCount: invoices.length,
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];

                          return Column(
                            children: [
                              Container(
                                color: white,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: selectedInvoices.contains(invoice),
                                      onChanged: (value) {
                                        if (value!) {
                                          selectedInvoices.add(invoice);
                                        } else {
                                          selectedInvoices.remove(invoice);
                                        }
                                        _updateInvoiceBalance(invoiceBalance);
                                        (context as Element).markNeedsBuild();
                                      },
                                    ),
                                    _buildTableCell(
                                      invoice['bookingDate'] ?? '',
                                      isHeader: false,
                                    ),
                                    _buildTableCell(
                                      invoice['lr'] ?? '',
                                      isHeader: false,
                                    ),
                                    _buildTableCell(
                                      '${invoice['loadingPointCity'] ?? ''} to ${invoice['unloadingPointCity'] ?? ''}',
                                      isHeader: false,
                                    ),
                                    _buildTableCell(
                                      invoice['truckNo'] ?? '',
                                      isHeader: false,
                                    ),
                                    _buildTableCell(
                                      invoice['rate'] ?? '',
                                      isHeader: false,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                height: 0,
                                color: Colors.grey,
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //invoice balance the sum of selected bookings

  static void _updateInvoiceBalance(
      TextEditingController invoiceBalanceController) {
    double totalAmount = AddInvoiceDialog.selectedBookings
        .map((invoice) => double.parse(invoice['rate'] ?? '0'))
        .reduce((sum, rate) => sum + rate);

    invoiceBalanceController.text = totalAmount.toString();
  }

  static Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Expanded(
      child: Container(
        child: ListTile(
          title: Text(
            text,
            style: TextStyle(
              fontSize: isHeader ? 17 : 16,
              color: isHeader ? black : black,
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          tileColor: isHeader ? tableHeaderColor : white,
          contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 10),
        ),
      ),
    );
  }

  //this is shimmer the grey background while fetching the data from the server
  static Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => Column(
          children: [
            Container(
              color: white,
              child: Row(
                children: [
                  SizedBox(width: 24),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 12,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 0,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
