import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../core/core.dart';
import '../models/models.dart';

class RequestsController extends GetxController {
  // data variables
  late List<RequestModel> requests;

  // controller vairables
  late String errorMessage;
  late RequestsState state;

  @override
  void onInit() {
    super.onInit();

    // data variables
    requests = [];

    // initializing controller variables
    errorMessage = '';
    state = RequestsState.LOADING;
  }

  // Method for getting all requests list
  Future<void> getAllConnectionRequests(String token, {bool isRefresh = false}) async {
    state = RequestsState.LOADING;
    if (isRefresh) update();

    final Uri url = Uri.parse("$BASE_URL/user/connectionRequests");
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
        final List<dynamic> connectionRequests = parsedJSON["requests"] as List<dynamic>;

        if (connectionRequests.isNotEmpty) {
          for (final foundUser in connectionRequests) {
            final RequestModel requestModel = RequestModel.fromJSON(foundUser as Map<String, dynamic>);
            requests.add(requestModel);
          }
          state = RequestsState.LOADED;
          errorMessage = '';
          update();
        } else {
          state = RequestsState.NO_REQUESTS;
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

  // Method for accepting the request
  Future<bool> acceptConnectionRequest(String token, String requestID) async {
    try {
      final Uri url = Uri.parse("$BASE_URL/user/acceptConnectionRequest?requestId=$requestID");
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> parsedJSON = json.decode(response.body) as Map<String, dynamic>;
        if (parsedJSON["status"] == "success") {
          requests.removeWhere((request) => request.requestID == requestID);
          update();
          return true;
        }
      } else {
        final Map<String, dynamic> parsedJSON = json.decode(response.body) as Map<String, dynamic>;
        if (parsedJSON["success"] == false) {
          errorMessage = parsedJSON["message"] as String;
        } else {
          errorMessage = 'Something went wrong...';
        }
        update();
        throw Exception();
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Method for rejecting the request
  Future<bool> rejectingConnectionRequest(String token, String requestID) async {
    try {
      final Uri url = Uri.parse("$BASE_URL/user/rejectConnectionRequest?requestId=$requestID");
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> parsedJSON = json.decode(response.body) as Map<String, dynamic>;
        if (parsedJSON["status"] == "success") {
          requests.removeWhere((request) => request.requestID == requestID);
          update();
          return true;
        }
      } else {
        final Map<String, dynamic> parsedJSON = json.decode(response.body) as Map<String, dynamic>;
        if (parsedJSON["success"] == false) {
          errorMessage = parsedJSON["message"] as String;
        } else {
          errorMessage = 'Something went wrong...';
        }
        update();
        throw Exception();
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}

enum RequestsState {
  LOADING,
  LOADED,
  NO_REQUESTS,
  ERROR,
}
