import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bookingApi/getBookingDataWithTransporterId.dart';
import 'package:liveasy/functions/bookingApi/putBookingData_completed=true.dart';
import 'package:liveasy/functions/documentApi/postDocumentApiCall.dart';
import 'package:liveasy/functions/invoiceApi/invoiceApiService.dart';
import 'package:shimmer/shimmer.dart';

class AddInvoiceDialog extends StatefulWidget {
  @override
  _AddInvoiceDialogState createState() => _AddInvoiceDialogState();
}

class _AddInvoiceDialogState extends State<AddInvoiceDialog> {
  static List<String> selectedBookings = [];
  static List<String> uploadedFiles = [];
  static List<int> selectedBookingRate = [];
  static TextEditingController invoiceNumberController =
  TextEditingController();
  static TextEditingController invoiceDateController = TextEditingController();
  static TextEditingController invoicePartyNameController =
  TextEditingController();
  static TextEditingController invoiceBalanceController =
  TextEditingController();
  static String transporterId = '';
  static String transporterName = '';
  static Map<String, dynamic>? storedDocumentInfo;
  List<Map<String, dynamic>> invoices = [];

  @override
  void initState() {
    super.initState();
    fetchBookingData();
  }

  // Function to fetch booking data using the transporter ID
  Future<void> fetchBookingData() async {
    try {
      // Get the transporter ID from the controller
      TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
      transporterId = transporterIdController.transporterId.value;
      transporterName = transporterIdController.name.value;

      // Fetch booking data using the transporter ID
      List<dynamic> data = await ApiService.fetchBookingData(transporterId);

      setState(() {
        invoices = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      print('Error fetching Booking data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
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
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16)),
              ),
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
                    invoicePartyNameController,
                    invoiceBalanceController,
                    context,
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Select Trip223',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),

                  _buildTripDetailsTable(
                    context,
                    invoices,
                    selectedBookings,
                    invoiceBalanceController,
                    selectedBookingRate,
                  ),


                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: bidBackground),
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
                      SizedBox(width: 20),
                      // Create Invoice Button
                      SizedBox(
                        height: 45,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              String? invoiceId =
                              await InvoiceApiService.postInvoiceData(
                                transporterId,
                                invoicePartyNameController.text,
                                invoiceNumberController.text,
                                invoiceDateController.text,
                                invoiceBalanceController.text,
                                selectedBookings,
                              );
                              // once invoice is created for that particular bookings then we have to update the bookings list and make completed status = true
                              for (var bookingIds in selectedBookings) {
                                updateBookingId(bookingId: bookingIds);
                              }
                              // once the invoice is created then we are assigning the invoiceId to entityId
                              if (storedDocumentInfo != null) {
                                storedDocumentInfo!["entityId"] = invoiceId;
                                await postDocumentApiCall(storedDocumentInfo!);
                              }
                              // Reset data when the invoice is created
                              invoicePartyNameController.clear();
                              invoiceNumberController.clear();
                              invoiceDateController.clear();
                              invoiceBalanceController.clear();
                              // Add other reset logic as needed
                              // Close the current screen (AddInvoiceScreen)
                              Navigator.of(context).pop();

                              // Push the InvoiceScreen again to refresh it
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardScreen(
                                    selectedIndex: 2,
                                    index: 2,
                                  ),
                                ),
                              );
                            } catch (e) {
                              print('Error in onPressed: $e');

                              // display a snackbar or dialog to inform the user about the error.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error creating invoice: $e'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
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
            ),
          )
        ],
      ),
    );
  }

  //invoice no,invoice date,upload doc form
  Widget _buildInvoiceDetailsForm(
      invoiceNumberController,
      invoiceDateController,
      invoicePartyNameController,
      invoiceBalanceController,
      context,
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
                    Text(invoiceBalanceController.text ?? '0'),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
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
                    width: 150,
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
              width: 0,
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
                      width: 150,
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

  // upload bill dialog box which appear middle of screen
  void _showUploadBillDialog(BuildContext context) {
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
  Widget _buildUploadBillDialogContent(BuildContext context) {
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
                            try {
                              //call the _storeDocumentInfo function to open the device browse file
                              await _storeDocumentInfo(context);
                            } catch (e) {
                              print('Error in onPressed: $e');
                              //  display a snackbar or dialog to inform the user about the error.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Error creating invoice: $e'),
                                duration: Duration(seconds: 3),
                              ));
                            }
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 45,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      storedDocumentInfo = null;
                      print(storedDocumentInfo);
                      print('removed all file');
                      uploadedFiles.clear();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF000066),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                            color: Color(0xFF000066)), // Set border color
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
                        color: Color(0xFF000066), // Set text color
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  height: 45,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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

// this function handle the operation of file selecting from the device

  Future<void> _storeDocumentInfo(context) async {
    try {
      XFile? pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        String fileName = pickedFile.name;
        uploadedFiles.add(fileName);

        debugPrint('Selected file name: $fileName');
        debugPrint('Picked file path: ${pickedFile.path}');

        List<int> fileBytes = await pickedFile.readAsBytes();
        String photo64code =
        base64Encode(fileBytes); //converting img o byte code

        storedDocumentInfo ??= {
          "entityId": null,
          //at first we are keeping entityId null bends we want invocable as entity id which will created in future so we are storing the files locally in code and once we crate invoice and we are giving entity id as invoiceid $you can check in create invoice button onpressed function
          "documents": [],
        };

        storedDocumentInfo!["documents"].add({
          "documentType": 'invoiceBill',
          "data": photo64code,
        });

        //here we are poping and again opening the upload dialog box to update the screen
        Navigator.of(context).pop();
        _showUploadBillDialog(context);
        print(storedDocumentInfo);
      }
    } catch (e) {
      print('Error in _storeDocumentInfo: $e');
      // Handle the error, e.g., show an error message to the user
    }
  }





  //get current date
  static String _getCurrentDate() {
    DateTime now = DateTime.now();
    return "${now.day}-${now.month}-${now.year}";
  }

  // format date
  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  Widget _buildTripDetailsTable(context, invoices, selectedInvoices,
      invoiceBalance, selectedBookingRate) {
    try {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: tableHeaderColor,
                  ),
                  child: Row(
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
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Column(
                          children: [
                            Column(children: [
                              Container(
                                color: white,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: selectedInvoices
                                          .contains(invoice['bookingId']),
                                      onChanged: (value) {
                                        setState(() {
                                          print(
                                              'Checkbox value changed: $value');

                                          if (value!) {
                                            selectedBookings
                                                .add(invoice['bookingId']);
                                            if (invoice['rate'] != null) {
                                              selectedBookingRate
                                                  .add(invoice['rate']!);
                                            }
                                          } else {
                                            selectedBookings
                                                .remove(invoice['bookingId']);
                                            if (invoice['rate'] != null) {
                                              selectedBookingRate
                                                  .remove(invoice['rate']!);
                                            }
                                          }

                                          _updateInvoiceBalance(
                                              invoiceBalance, setState);
                                        });
                                        (context as Element).markNeedsBuild();
                                      },
                                    ),
                                    _buildTableCell(
                                      invoice['bookingDate'] ?? 'NA',
                                      isHeader: false,
                                    ),
                                    _buildTableCell(
                                      invoice['lr'] ?? 'NA',
                                      isHeader: false,
                                    ),
                                    _buildTableCell(
                                      '${invoice['loadingPointCity'] ?? 'NA'} to ${invoice['unloadingPointCity'] ?? ''}',
                                      isHeader: false,
                                    ),
                                    _buildTableCell(
                                      invoice['truckNo'] ?? 'NA',
                                      isHeader: false,
                                    ),
                                    _buildTableCell(
                                      invoice['rate']?.toString() ?? 'NA',
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
                            ])
                          ],
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('Error in _buildTripDetailsTable: $e');
      print('Stack trace: $stackTrace');
      return Text('An error occurred');
    }
  }

  void _updateInvoiceBalance(invoiceBalanceController, setState) {
    int totalRate = 0;

    for (int rate in selectedBookingRate) {
      totalRate += rate;
    }
    invoiceBalanceController.text = totalRate.toString();

    setState(() {});
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddInvoiceDialog();
      },
    );
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
