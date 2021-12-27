import 'dart:convert';

import 'package:contact_sharing/models/models.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../core/core.dart';

class FriendsController extends GetxController {
  // data variables
  late List<UserModel> friends;

  // controller variables
  late String errorMessage;
  late FriendsState state;

  @override
  void onInit() {
    super.onInit();

    // initialize data variables
    friends = [];

    // initialize controller variables
    errorMessage = '';
    state = FriendsState.LOADING;
  }

  // Method for getting list of all friends
  Future<void> getAllFriends(String token, {bool isRefresh = false}) async {
    state = FriendsState.LOADING;
    if (isRefresh) update();

    final Uri url = Uri.parse("$BASE_URL/user/myFriends");
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> parsedJSON = json.decode(response.body) as Map<String, dynamic>;

      if (parsedJSON["status"] == "success") {
        final List<dynamic> connectionFriends = parsedJSON["friends"] as List<dynamic>;

        if (connectionFriends.isNotEmpty) {
          friends = [];
          for (final foundUser in connectionFriends) {
            final UserModel userModel = UserModel.fromJSON(foundUser as Map<String, dynamic>);
            friends.add(userModel);
          }
          state = FriendsState.LOADED;
          errorMessage = '';
          update();
        } else {
          state = FriendsState.NO_FRIENDS;
          errorMessage = '';
          update();
        }
      }
    } else {
      final Map<String, dynamic> parsedJSON = json.decode(response.body) as Map<String, dynamic>;
      if (parsedJSON["success"] == false) {
        errorMessage = parsedJSON["message"] as String;
      } else {
        errorMessage = 'Something went wrong...';
      }
      throw Exception();
    }
  }
}

enum FriendsState {
  LOADING,
  LOADED,
  NO_FRIENDS,
  ERROR,
}
