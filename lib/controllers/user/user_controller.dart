import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usersapp/globals/app_globals.dart';
import 'package:usersapp/models/user/user_model.dart';
import 'package:usersapp/services/network_service.dart';

class UserModel extends ChangeNotifier {
  List<User>? users;
  var userPage = 1;

  Future getUsers({page = 1}) async {
    var response = await NetworkService.instance
        .getMethod('${AppGlobals.apiUrl}?page=$page&limit=15');
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

  Future createUser(data) async {
    var response =
        await NetworkService.instance.postMethod(AppGlobals.apiUrl, data);

    notifyListeners();
    return response;
  }

  Future updateUser(data) async {
    var response = await NetworkService.instance
        .putMethod(AppGlobals.updateUrl(data['id']), data);
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

  Future deleteUser(data) async {
    var response =
        await NetworkService.instance.deleteMethod(AppGlobals.deleteUrl(data));
    users?.removeWhere((element) => element.id == data);
    notifyListeners();
    return response is Map ? true : false;
  }
}
