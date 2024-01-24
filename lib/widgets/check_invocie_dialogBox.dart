import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/documentApi/getInvoiceDocApiCall.dart';
import 'package:liveasy/functions/uploadingDoc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

class InvoiceDetailsDialog extends StatefulWidget {
  final String invoiceId;

  InvoiceDetailsDialog({required this.invoiceId});

  @override
  State<InvoiceDetailsDialog> createState() => _InvoiceDetailsDialogState();
}

class _InvoiceDetailsDialogState extends State<InvoiceDetailsDialog> {
  List<String> docLinks = [];
  bool loading = true;
  final String proxy = dotenv.get('placeAutoCompleteProxy');

  @override
  void initState() {
    super.initState();
    // Fetch document links when the dialog is opened
    _fetchDocumentLinks();
  }

  // This function  creates PDF and download it
  Future<void> createPdfAndDownload(List<String> imageUrls) async {
    final pdf = pw.Document();

    for (var imageUrl in imageUrls) {
      final image = await networkImageToByte(imageUrl);
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(pw.MemoryImage(image)),
        );
      }));
    }
    final bytes = await pdf.save();

    // Trigger the file download
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'invoice.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // This function  converts network image to byte
  Future<Uint8List> networkImageToByte(String imageUrl) async {
    final response = await http.get(Uri.parse('$proxy$imageUrl'));
    final bytes = response.bodyBytes;
    return bytes;
  }

  // Fetch document links from the API
  Future<void> _fetchDocumentLinks() async {
    try {
      // Fetch document links using the provided API function
      List<String> links =
          await getInvoiceDocApiCall(widget.invoiceId, "InvoiceBill");
      // Decode the URLs before setting them to docLinks

      docLinks = links.map((link) => Uri.decodeFull(link)).toList();
    } catch (e) {
      print("Error fetching document links: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
          ),
          const Text(
            'Invoice.png',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      content: loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: white,
              width: docLinks.isNotEmpty
                  ? MediaQuery.of(context).size.width * 0.6
                  : MediaQuery.of(context).size.width * 0.2,
              height: docLinks.isEmpty
                  ? MediaQuery.of(context).size.height * 0.15
                  : MediaQuery.of(context).size.height * 0.6,
              child: SingleChildScrollView(
                child: docLinks.isNotEmpty
                    ? Column(
                        children: docLinks.map<Widget>((link) {
                          return Column(
                            children: [
                              Image.network('$proxy$link',
                                  errorBuilder: (context, error, stackTrace) {
                                // when there is error in fetching image
                                return const Text('Error in fetching Invoice',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(158, 158, 158, 1)));
                              }),
                              const Divider(
                                height: 10,
                              ),
                            ],
                          );
                        }).toList(),
                      )
                    // when there is no invoice uploaded
                    : SizedBox(
                        height: 100,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Invoice not found",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: normalWeight),
                            )),
                      ),
              ),
            ),
      actions: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 45,
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  if (docLinks.isNotEmpty) {
                    setState(() {
                      downloading = true;
                    });
                    await createPdfAndDownload(docLinks.cast<String>());
                    setState(() {
                      downloading = false;
                    });
                  }
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
                  'Download',
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
      ],
      surfaceTintColor: Colors.transparent,
    );
  }
}
