import 'package:flutter/material.dart';
import 'package:usersapp/globals/app_globals.dart';
import 'package:usersapp/models/user/user_model.dart';
import 'package:usersapp/services/network_service.dart';

class UserModel extends ChangeNotifier {
  List<User>? users;

  Future getUsers() async {
    var response = await NetworkService.instance.getMethod(AppGlobals.apiUrl);
    if (response['data'] != null) {
      users = List.generate(response['data'].length,
          (index) => User.fromJson(response['data'][index]));
    }
    notifyListeners();
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
        .putMethod(AppGlobals.updateUrl(data), data);
    print(response);
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
