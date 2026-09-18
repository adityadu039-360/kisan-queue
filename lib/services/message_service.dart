import 'package:url_launcher/url_launcher.dart';

class MessageService {
  static Future<bool> openSmsComposer({
    required String mobile,
    required String message,
  }) async {
    final uri = Uri(
      scheme: 'sms',
      path: mobile,
      queryParameters: {'body': message},
    );

    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri);
  }
}
