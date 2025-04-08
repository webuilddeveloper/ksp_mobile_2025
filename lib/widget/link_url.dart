import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  bool _validURL = Uri.parse(url).isAbsolute;
  if (!_validURL) url = 'http://' + url;
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

launchInWebViewWithJavaScript(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
