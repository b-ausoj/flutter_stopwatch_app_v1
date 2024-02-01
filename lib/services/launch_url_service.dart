import 'package:url_launcher/url_launcher.dart';

final Uri contactUri = Uri(
  scheme: "mailto",
  path: "josua.bu@gmail.com",
  query: encodeQueryParameters(<String, String>{
    "subject": "Stopwatch App Feedback",
  }),
);

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

Future<void> launchMailApp() async {
  if (await canLaunchUrl(contactUri)) {
    try {
      launchUrl(contactUri);
    } catch (e) {
      // catch?
    }
  } else {
    // what to do else
  }
}
