import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usersapp/globals/app_globals.dart';
import 'package:usersapp/models/user/user_model.dart';
import 'package:usersapp/services/network_service.dart';

class UserController extends ChangeNotifier {
  List<User>? users;
  var userPage = 1;

  Future getUsers(BuildContext context, {page = 1}) async {
    var response = await NetworkService.instance
        .getMethod('${AppGlobals.apiUrl}?page=$page&limit=15', context);
    if (response['data'] != null) {
      print(response['data']);
      if (page == 1) {
        users = List.generate(response['data'].length,
            (index) => User.fromJson(response['data'][index]));
        notifyListeners();
      } else {
        userPage = page;
        if (response['data'].length > 0) {
          List<User>? tempUserList = List.generate(response['data'].length,
              (index) => User.fromJson(response['data'][index]));
          users?.addAll(tempUserList);
          notifyListeners();
        }
      }
    }
    return response;
  }

  Future createUser(data, BuildContext context) async {
    var response = await NetworkService.instance
        .postMethod(AppGlobals.apiUrl, data, context);

    notifyListeners();
    return response;
  }

  bool checkIdentity(value) {
    String valueAsString = value.toString();
    var digits = valueAsString.split('');
    var digit10 = int.parse(digits[9]);
    var digit11 = int.parse(digits[10]);
    var total10 = 0;
    var evens = 0;
    var odds = 0;
    for (var i = 0; i < digits.length; i++) {
      var num = int.parse(digits[i]);
      if (i < 10) total10 += num;
      if (i < 9) {
        if ((i + 1) % 2 == 0) {
          evens += num;
        } else {
          odds += num;
        }
      }
    }
    if (total10 % 10 != digit11) return false;
    if (((odds * 7) + (evens * 9)) % 10 != digit10) return false;
    if ((odds * 8) % 10 != digit11) return false;
    return true;
  }

  Future updateUser(data, BuildContext context) async {
    var response = await NetworkService.instance
        .putMethod(AppGlobals.updateUrl(data['id']), data, context);
    if (response is Map) {
      User? userData =
          users?.where((element) => element.id.toString() == data['id']).first;
      userData?.name = data['name'];
      userData?.surname = data['surname'];
      userData?.birthDate = DateFormat("yyyy-MM-dd").parse(data['birthdate']);
      userData?.identity = data['identity'];
      userData?.phoneNumber = data['phone_number'];
    }
    notifyListeners();
    return response is Map ? true : false;
  }

  Future deleteUser(data, BuildContext context) async {
    var response = await NetworkService.instance
        .deleteMethod(AppGlobals.deleteUrl(data), context);
    users?.removeWhere((element) => element.id == data);
    notifyListeners();
    return response is Map ? true : false;
  }
}
