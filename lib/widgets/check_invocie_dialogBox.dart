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
  int currentIndex = 0;
  final String proxy = dotenv.get('placeAutoCompleteProxy');

  @override
  void initState() {
    super.initState();
    // Fetch document links when the dialog is opened
    _fetchDocumentLinks();
  }

  // This function creates PDF and download it
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

  // This function converts network image to byte
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          Expanded(
            child: Text(
              'Invoice.png',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
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
                  ? MediaQuery.of(context).size.width * 0.5
                  : MediaQuery.of(context).size.width * 0.2,
              height: docLinks.isEmpty
                  ? MediaQuery.of(context).size.height * 0.15
                  : MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  // Miniature view with right and left arrows
                  Row(
                    children: docLinks.isNotEmpty
                        ? [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                      'assets/icons/left_arrow.png'),
                                  onPressed: () {
                                    setState(() {
                                      currentIndex =
                                          (currentIndex - 1) % docLinks.length;
                                    });
                                  },
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 70,
                                  child: PageView.builder(
                                    itemCount: docLinks.length,
                                    controller:
                                        PageController(viewportFraction: 0.2),
                                    onPageChanged: (index) {
                                      // Set the currentIndex directly when miniature image is changed
                                      setState(() {
                                        currentIndex = index;
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      // Construct the URL for the miniature image
                                      String miniatureImageUrl =
                                          '$proxy${docLinks[index]}';

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 2),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Set the currentIndex when miniature image is tapped
                                            setState(() {
                                              currentIndex = index;
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              // Image
                                              Positioned.fill(
                                                child: Image.network(
                                                  miniatureImageUrl,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              // Overlay color
                                              Positioned.fill(
                                                child: Container(
                                                  color: currentIndex == index
                                                      ? Colors.blue
                                                          .withOpacity(0.5)
                                                      : Colors.transparent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Image.asset(
                                      'assets/icons/right_arrow.png'),
                                  onPressed: () {
                                    setState(() {
                                      currentIndex =
                                          (currentIndex + 1) % docLinks.length;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ]
                        : [],
                  ),

// Larger image display

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: docLinks.isNotEmpty
                            ? [
                                Column(
                                  children: [
                                    Image.network(
                                        '$proxy${docLinks[currentIndex]}',
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                      // when there is an error in fetching the image
                                      return const Text(
                                        'Error in fetching Invoice',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(158, 158, 158, 1),
                                        ),
                                      );
                                    }),
                                    const Divider(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ]
                            // when there is no invoice uploaded
                            : [
                                SizedBox(
                                  height: 100,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Invoice not found",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: normalWeight),
                                    ),
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            docLinks.isEmpty
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          child: Container(
                            color: kLiveasyColor,
                            height: space_10,
                            child: Center(
                              child: Text(
                                "close",
                                style: TextStyle(
                                  color: white,
                                  fontSize: size_8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            docLinks.isEmpty
                ? Container()
                : SizedBox(
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        child: Container(
                          color: kLiveasyColor,
                          height: space_10,
                          child: Center(
                            child: downloading
                                ? const CircularProgressIndicator(
                                    color: white,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.download, color: white),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Download",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: size_8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        onTap: () async {
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
                      ),
                    ),
                  ),
          ],
        )
      ],
      surfaceTintColor: Colors.transparent,
    );
  }
}
