import '../../models/common/error_model.dart';
import '/modules/common/error_page.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Common {

  static void showToast({required String msg}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        fontSize: 12.0);
  }

  static void handleErrorResponse(ErrorModel response,
      {bool showErrorPage = true}) {
    if (response.code == 401 ) return;
    var message = "Có lỗi xảy ra";
    switch (response.type) {
      case ErrorType.NO_INTERNET:
        message = "Có lỗi xảy ra trong quá trình kết nối.";
        break;
      case ErrorType.TIME_OUT:
        message = "Kết nối quá thời gian chờ";
        break;
      case ErrorType.CANCELLED:
        message = "Kết nối đã bị hủy";
        break;
      default:
        break;
    }
    showToast(msg: message);
    // response.message = message;
    // Get.to(ErrorPage(error: response));
    if (showErrorPage) {
      response.message = message;
      Get.off(ErrorPage(error: response));
    }
  }

  static openBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
