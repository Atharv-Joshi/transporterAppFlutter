import 'package:liveasy/functions/traccarCalls/createNotificationTraccar.dart';
import 'package:liveasy/functions/traccarCalls/createUserTraccar.dart';
import 'package:liveasy/functions/traccarCalls/linkNotificationAndUserTraccar.dart';
import 'package:liveasy/functions/trasnporterApis/runTransporterApiPost.dart';

void createTraccarUserAndNotifications(String? token, String? mobileNum) async {
  String? traccarId = tidstorage.read("traccarUserId");
  if (traccarId == null) {
    String? userId = await createUserTraccar(token, mobileNum);
    // if (userId != null) {
    //   List<String?>? id = await createNotificationTraccar();
    //   if (id != []) {
    //     linkNotificationAndUserTraccar(userId, id);
    //   }
    // }
  } else {
    //do nothing
  }
}
