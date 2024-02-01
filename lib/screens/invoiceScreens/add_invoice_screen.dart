import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bookingApi/getBookingDataWithTransporterId.dart';
import 'package:liveasy/functions/bookingApi/putBookingData_completed=true.dart';
import 'package:liveasy/functions/documentApi/postDocumentApiCall.dart';
import 'package:liveasy/functions/invoiceApi/invoiceApiService.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

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
  List<Map<String, dynamic>> invoices = [];
  Uint8List? fileBytes;
  final List<Uint8List> imageBytesList = [];
  List<Map<String, String>> documents = [];
  var documentApiPayload;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBookingData();
  }

  @override
  void dispose() {
    // Clear or reset values when the widget is disposed
    invoiceNumberController.clear();
    invoiceDateController.clear();
    invoicePartyNameController.clear();
    invoiceBalanceController.clear();
    selectedBookings.clear();
    uploadedFiles.clear();
    selectedBookingRate.clear();
    transporterId = '';
    transporterName = '';
    fileBytes = null;
    imageBytesList.clear();
    documents.clear();
    documentApiPayload = null;

    super.dispose();
  }

  // Function to fetch booking data using the transporter ID
  Future<void> fetchBookingData() async {
    try {
      isLoading = true;
      // Get the transporter ID from the controller
      TransporterIdController transporterIdController =
          Get.find<TransporterIdController>();
      transporterId = transporterIdController.transporterId.value;
      transporterName = transporterIdController.name.value;

      // Fetch booking data using the transporter ID
      List<dynamic> data = await ApiService.fetchBookingData(transporterId);

      setState(() {
        invoices = List<Map<String, dynamic>>.from(data);
        isLoading = false;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Add invoice',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.37,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
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
                    'Select Trip',
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
                              //getting the invocie id from creating the invocie
                              String? invoiceId =
                                  await InvoiceApiService.postInvoiceData(
                                transporterId,
                                transporterName,
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
                              if (documentApiPayload != null) {
                                documentApiPayload!["entityId"] = invoiceId;
                                await postDocumentApiCall(documentApiPayload!);
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
                          horizontal: 0.0,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 16),
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
                  //implemented the calendar for date picker
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

                              await openSystemFileExplorer(context);
                              Navigator.of(context).pop();
                              _showUploadBillDialog(context);
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: liveasyGreen),
                      ),
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
                                      setState(() {
                                        uploadedFiles.remove(fileName);
                                      });
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
                      //when we click on cancel we are deleteing all the saved value for prevent waste of memeory
                      documentApiPayload = null;
                      uploadedFiles.clear();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: kLiveasyColor,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                            color: kLiveasyColor), // Set border color
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
                        color: kLiveasyColor, // Set text color
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
                      int index = 0;
                      //we are waiting till the upload button is click
                      //when we are converting imageByteList into Uint8List so to further convert into base64code
                      imageBytesList.forEach((Uint8List byteData) {
                        String base64String = base64Encode(byteData);
                        String documentType =
                            "invoiceBill_page-$index"; // Replace with your document type
                        Map<String, String> document = {
                          "documentType": documentType,
                          "data": base64String,
                        };
                        documents.add(document);
                        index++;
                      });
                      documentApiPayload = {
                        "entityId": "entity:UUID",
                        "documents": documents,
                      };

                      Navigator.of(context).pop();
                    },
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

  Future<void> openSystemFileExplorer(context) async {
    try {
      // This open the file explorer to select the file from the device
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        //here we are converting the pdf file obtained from the device to Uint8List
        fileBytes = result.files.first.bytes;
        //here we store the file in pdfdocument class with the help of Uint8List file
        final document = await PdfDocument.openData(fileBytes!);
        final pageCount = document.pagesCount;
        PlatformFile file = result.files.first;
        setState(() {
          uploadedFiles.add(file.name);
        });

        for (int i = 1; i <= pageCount; i++) {
          final page = await document.getPage(i);
          final pageImage =
              await page.render(width: page.width, height: page.height);
          imageBytesList.add(pageImage!.bytes);

          await page.close();
        }
        await document.close();
      }
    } catch (e) {
      print('Error in openSystemFileExplorer: $e');
      // Handle the error, e.g., show an error message to the user
    }
  }

  static String _getCurrentDate() {
    DateTime now = DateTime.now();
    return "${now.day}-${now.month}-${now.year}";
  }

  // format date
  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

// here we have handle the table view and alingment of table
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
                  child: isLoading
                      ? ShimmerEffect()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: invoices.length,
                          itemBuilder: (context, index) {
                            final invoice = invoices[index];

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
                                                invoiceBalance);

                                            (context as Element)
                                                .markNeedsBuild();
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

  void _updateInvoiceBalance(invoiceBalanceController) {
    int totalRate = 0;

    for (int rate in selectedBookingRate) {
      totalRate += rate;
    }
    setState(() {
      invoiceBalanceController.text = totalRate.toString();
    });
    // invoiceBalanceController.text = totalRate.toString();
  }

//handle the property and appearance of single tile of table
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
