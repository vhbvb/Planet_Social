// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:test/test.dart';

void main() {
  test("registUser",()async{

    String _body = null;

    User user = User();
    ApiService.shared.regist(user,"123456",(status,body){

      // _body = body;
      // print(status);
      // print(body);
    });


  var value = await Future.delayed(Duration(seconds: 10),(){
      return _body !=null;
    });
  expect(value, equals(true));
  },timeout: Timeout(Duration(seconds: 20)));
}
