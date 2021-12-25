import 'dart:io';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import './controllers.dart';

import '../core/core.dart';
import '../models/models.dart';

class HomeController extends GetxController {
  // Dependencies
  final ImagePicker _picker = ImagePicker();

  // data variables
  late List<SearchedUser> foundUsers;
  late String requestKey;
  XFile? _selectedPicture;
  File? _userPhoto;

  // controller vairables
  late String errorMessage;
  late HomeState state;

  @override
  void onInit() {
    super.onInit();

    // data variables
    foundUsers = [];
    requestKey = '';

    // initializing controller variables
    errorMessage = '';
    state = HomeState.INITIAL;
  }

  Future<void> pickImage(String token) async {
    _selectedPicture = await _picker.pickImage(source: ImageSource.camera);

    if (_selectedPicture != null) {
      _userPhoto = File.fromUri(Uri.parse(_selectedPicture!.path));
      scanImageForFriends(token, _userPhoto!);
    }
  }

  // Method for searching users from photo
  Future<void> scanImageForFriends(String token, File image) async {
    try {
      state = HomeState.SEARCHING_CONNECTIONS;
      update();

      // final String imageURL = await locator.get<AuthController>().uploadImage(image);
      const String imageURL = "https://faceconnect.s3.ap-south-1.amazonaws.com/user/9189d1d7-b08a-4fec-a417-173f998737df.png";

      final Uri uri = Uri.parse("$BASE_URL/user/findUser");

      final response = await http.post(
        uri,
        body: json.encode({"imageURL": imageURL}),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> parsedJSON = json.decode(response.body) as Map<String, dynamic>;

        if (parsedJSON["status"] == "success") {
          final List<dynamic> foundUsersList = parsedJSON["data"]["foundUsers"] as List<dynamic>;

          if (foundUsersList.isNotEmpty) {
            for (final foundUser in foundUsersList) {
              foundUsers.add(SearchedUser.fromJSON(foundUser as Map<String, dynamic>));
            }
            requestKey = parsedJSON["data"]["key"] as String;
            state = HomeState.CONNECTIONS_FOUND;
            errorMessage = '';
            update();
          } else {
            state = HomeState.NO_CONNECTIONS_FOUND;
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
    } catch (e) {
      state = HomeState.ERROR;
      update();
    }
  }

  // getters
  File get userPhoto => _userPhoto!;
}

enum HomeState {
  INITIAL,
  SEARCHING_CONNECTIONS,
  CONNECTIONS_FOUND,
  NO_CONNECTIONS_FOUND,
  ERROR,
}
