import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendAndRetrieveMessage(
    {required String msg,
      required String tokin,
      required String username}) async {
  // Go to Firebase console -> Project settings -> Cloud Messaging -> copy Server key
  // the Server key will start "AAAAMEjC64Y..."

  final yourServerKey =
      "AAAAiEQEjSA:APA91bFDvIMx5s6vnK5YwqQgH8D5_PaA0EMslHsEniaGDyDJcFcqfomhb9OKhJxsxWmx6CMQCzWCQKG9eltqe43ezWD79gA9M4YtOuPChqduNe5JVM80cLFAFMHZhC-ifGOs9b2riUJt";
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$yourServerKey',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': "${msg}",
          'title': "${username}",
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        // FCM Token lists.
        // 'registration_ids': ["Your_FCM_Token_One", "Your_FCM_Token_Two"],
        'to': tokin
      },
    ),
  );
}