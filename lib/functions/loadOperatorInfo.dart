import 'package:liveasy/functions/numverifyAPIs.dart';

class OperatorUtils {
  static String mapOperatorName(String apiOperator) {
    if (apiOperator == 'Bharti Airtel Ltd') {
      return 'Airtel';
    } else if (apiOperator ==
        'Vodafone Idea Ltd (formerly Idea Cellular Ltd)') {
      return 'Vodafone';
    } else if (apiOperator == 'Reliance Jio Infocomm Ltd (RJIL)') {
      return 'Jio';
    } else {
      // If it's not one of the expected values, return a default value.
      return 'Vodafone';
    }
  }
}

Future<void> loadOperatorInfo(String? driverPhoneNum, Function updateUI) async {
  final apiResponse = await validateMobileNumber(
    mobileNumber: driverPhoneNum,
  );

  final selectedOperator =
      OperatorUtils.mapOperatorName(apiResponse['carrier']);

  updateUI(
      selectedOperator); // Call the provided callback function to update the UI.
}
