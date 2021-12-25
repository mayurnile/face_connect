import 'dart:io';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../core/core.dart';
import '../models/models.dart';

class AuthController extends GetxController {
  // Instances
  late FirebaseAuth firebaseAuth;

  // data variables
  late String _token;
  late String countryCode;
  late String phoneNumber;
  late String _imageVerificationKey;
  late UserModel userModel;
  late String otp;
  late String phoneVerificationID;

  // controller vairables
  late String errorMessage;
  late AuthState state;

  @override
  void onInit() {
    super.onInit();

    // initializing instances
    firebaseAuth = FirebaseAuth.instance;

    // initializing data variables
    _token = '';
    countryCode = '';
    phoneNumber = '';
    _imageVerificationKey = '';
    userModel = UserModel();
    otp = '';
    phoneVerificationID = '';

    // initializing controller variables
    errorMessage = '';
    state = AuthState.UNAUTHENTICATED;
  }

  // Method for email and password login
  Future<bool> emailPasswordLogin({required String email, required String password}) async {
    try {
      state = AuthState.AUTHENTICATING;
      update();

      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        state = AuthState.AUTHENTICATED;
        errorMessage = '';
        _token = await userCredential.user!.getIdToken();
        update();
        return true;
      } else {
        state = AuthState.UNAUTHENTICATED;
        errorMessage = 'Email or Password incorrect. Please try again';
        _token = '';
        update();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      state = AuthState.UNAUTHENTICATED;
      if (e.code == 'user-not-found') {
        errorMessage = 'Please signup first!';
      } else {
        errorMessage = 'Email or Password incorrect. Please try again';
      }
      _token = '';
      update();
      return false;
    } catch (e) {
      state = AuthState.UNAUTHENTICATED;
      errorMessage = 'Email or Password incorrect. Please try again';
      _token = '';
      update();
      return false;
    }
  }

  // Method for sending OTP
  Future<void> sendOTP({required String phoneNumber}) async {
    try {
      Future<void> _verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
        if (phoneAuthCredential.smsCode != null) {
          otp = phoneAuthCredential.smsCode!;
          update();
        }
      }

      Future<void> _verificationFailed(FirebaseAuthException authException) async {
        throw authException;
      }

      Future<void> _codeSent(String verificationId, [int? forceResendingToken]) async {
        phoneVerificationID = verificationId;
        update();
      }

      Future<void> _codeAutoRetrievalTimeout(String verificationId) async {
        phoneVerificationID = verificationId;
        update();
      }

      final PhoneVerificationCompleted verificationCompleted = _verificationCompleted;
      final PhoneVerificationFailed verificationFailed = _verificationFailed;
      final PhoneCodeSent codeSent = _codeSent;
      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = _codeAutoRetrievalTimeout;

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: '${countryCode.trim()} ${phoneNumber.trim()}',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        // autoRetrievedSmsCodeForTesting: '123456',
        // timeout: const Duration(seconds: 1),
      );
    } catch (e) {
      state = AuthState.UNAUTHENTICATED;
      errorMessage = 'Unable to send OTP...';
      update();
    }
  }

  // Method for email password signup
  Future<bool> emailPasswordSignup({required String email, required String password}) async {
    try {
      state = AuthState.AUTHENTICATING;
      update();

      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        state = AuthState.AUTHENTICATED;
        errorMessage = '';
        _token = await userCredential.user!.getIdToken();
        update();
        return true;
      } else {
        state = AuthState.UNAUTHENTICATED;
        errorMessage = 'Email or Password incorrect. Please try again';
        _token = '';
        update();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      state = AuthState.UNAUTHENTICATED;
      if (e.code == 'account-exists-with-different-credentail' || e.code == 'email-already-in-use') {
        errorMessage = 'Account already exists, Please login!';
      } else {
        errorMessage = 'Email or Password incorrect. Please try again';
      }
      _token = '';
      update();
      return false;
    } catch (e) {
      state = AuthState.UNAUTHENTICATED;
      errorMessage = 'Email or Password incorrect. Please try again';
      _token = '';
      update();
      return false;
    }
  }

  // Method for verifying image
  Future<bool> verifyUserImage(File image) async {
    try {
      state = AuthState.VERIFYING;
      update();

      final String imageURL = await uploadImage(image);
      // final String imageURL = "https://faceconnect.s3.ap-south-1.amazonaws.com/user/51cf7e05-ab1b-4351-8a0e-bd8d040e3470.png";

      final Uri uri = Uri.parse("$BASE_URL/user/verifyimage");

      final response = await http.post(
        uri,
        body: json.encode({"imageURL": imageURL}),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> parsedJSON = json.decode(response.body) as Map<String, dynamic>;

        if (parsedJSON["status"] == "success") {
          _imageVerificationKey = parsedJSON["key"] as String;
          state = AuthState.AUTHENTICATED;
          update();
          return true;
        }
      }
      state = AuthState.AUTHENTICATED;
      update();
      return false;
    } catch (e) {
      state = AuthState.AUTHENTICATED;
      update();
      return false;
    }
  }

  // Method for creating user in database
  Future<bool> createUser(UserModel user) async {
    try {
      state = AuthState.AUTHENTICATING;
      update();

      final Uri uri = Uri.parse("$BASE_URL/user/create");
      final String body = json.encode({
        "name": user.name,
        "city": user.city,
        "gander": user.gender,
        if (user.dob != null) "dob": user.dob!.millisecondsSinceEpoch,
        "mobileNumber": user.phoneNumber,
        "email": user.email,
        "profileImageURL": user.profilePicture,
        "key": _imageVerificationKey,
      });

      final response = await http.post(
        uri,
        body: body,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> parsedJSON = json.decode(response.body) as Map<String, dynamic>;

        if (parsedJSON["status"] == "success") {
          state = AuthState.AUTHENTICATED;
          update();
          _imageVerificationKey = '';
          return true;
        } else {
          errorMessage = parsedJSON["message"] as String;
        }
      }
      state = AuthState.AUTHENTICATED;
      update();
      return false;
    } catch (e) {
      state = AuthState.AUTHENTICATED;
      update();
      return false;
    }
  }

  // Method for getting upload url
  Future<String> uploadImage(File image) async {
    try {
      final Uri url = Uri.parse("$BASE_URL/s3/getS3UploadURL?type=user&extention=png&mimetype=image%2Fpng");
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> parsedJSON = json.decode(response.body) as Map<String, dynamic>;

        if (parsedJSON["uploadURL"] != null) {
          final String uploadURL = parsedJSON["uploadURL"] as String;
          final String objectURL = parsedJSON["objectURL"] as String;

          final uploadURI = Uri.parse(uploadURL);
          final uploadResponse = await http.put(
            uploadURI,
            body: image.readAsBytesSync(),
          );

          if (uploadResponse.statusCode == 200) {
            return objectURL;
          } else {
            throw Exception('Unable to upload image...');
          }
        } else {
          throw Exception('Unable to get upload url...');
        }
      } else {
        throw Exception('Unable to get upload url...');
      }
    } catch (e) {
      rethrow;
    }
  }

  // getters
  String get token => _token;
}

enum AuthState {
  UNAUTHENTICATED,
  AUTHENTICATED,
  AUTHENTICATING,
  ERROR,
  VERIFYING,
}
