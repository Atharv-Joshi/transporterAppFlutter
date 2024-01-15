import 'package:get/get.dart';

//This function is used to preview the image
class PreviewUploadedImage extends GetxController {
  RxString previewImage = "".obs;
  RxInt index = 0.obs;
  void updatePreviewImage(String value) {
    previewImage.value = value;
  }

  void updateIndex(int value) {
    index.value = value;
  }
}
