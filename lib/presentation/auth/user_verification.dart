import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../core/core.dart';
import '../../widgets/widgets.dart';
import '../../controllers/controllers.dart';

class UserVerificationScreen extends StatefulWidget {
  const UserVerificationScreen({Key? key}) : super(key: key);

  @override
  _UserVerificationScreenState createState() => _UserVerificationScreenState();
}

class _UserVerificationScreenState extends State<UserVerificationScreen> {
  // Dependencies
  final ImagePicker _picker = ImagePicker();

  // data variables
  XFile? _selectedPicture;
  File? _userPhoto;

  // controller variables
  bool _isError = false;
  String _errorMessage = '';

  // animation variables
  static const Duration _animDuration = Duration(milliseconds: 500);
  static const Curve _animCurve = Curves.easeInOutCubic;

  // device variables
  late Size size;
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // screen title
              _buildScreenTitle(),
              // image picker
              _buildImagePickerSection(),
              // error message
              _buildErrorMessage(),
              // verify button
              _buildVerifyButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _buildScreenTitle() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // spacing
            SizedBox(height: size.height * 0.04),
            // title
            Text(
              'Verification',
              style: textTheme.headline3,
            ),
            // spacing
            const SizedBox(height: 8.0),
            // subtitle
            Text(
              'You need to provide proof of yourself',
              style: textTheme.subtitle1,
            ),
          ],
        ),
      );

  Widget _buildImagePickerSection() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
        child: Column(
          children: [
            // title
            Text(
              'As our app relies on Face Recognition we need first to teach our system what you look like!',
              style: textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            // spacing
            const SizedBox(height: 24.0),
            // subtitle
            SizedBox(
              width: size.width * 0.6,
              child: Text(
                'Please upload a decent photo of yours so our system might recognize you better',
                style: textTheme.bodyText2!.copyWith(color: AppTheme.fontLightColor),
                textAlign: TextAlign.center,
              ),
            ),
            // image picker
            _buildImagePicker(),
            // subtitle
            Text(
              "This photo is for verificaiton purpose only, for public display you'll be asked to upload another photo on next step",
              style: textTheme.bodyText2!.copyWith(color: AppTheme.fontLightColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _buildImagePicker() => GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: size.width * 0.45,
          width: size.width * 0.45,
          margin: const EdgeInsets.symmetric(vertical: 12.0),
          padding: _userPhoto != null ? const EdgeInsets.all(8.0) : const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: _userPhoto != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    _userPhoto!,
                    fit: BoxFit.cover,
                  ),
                )
              : DottedBorder(
                  borderType: BorderType.RRect,
                  color: AppTheme.fontLightColor,
                  strokeCap: StrokeCap.round,
                  dashPattern: const [5.0],
                  radius: const Radius.circular(12.0),
                  child: Center(child: SvgPicture.asset(IconAssets.profilePicture)),
                ),
        ),
      );

  Widget _buildErrorMessage() => AnimatedContainer(
        duration: _animDuration,
        curve: _animCurve,
        height: _isError ? size.height * 0.05 : 0.0,
        margin: EdgeInsets.only(top: size.height * 0.1),
        padding: const EdgeInsets.only(bottom: 18.0),
        child: AnimatedOpacity(
          duration: _animDuration,
          curve: _animCurve,
          opacity: _isError ? 1.0 : 0.0,
          child: Center(
            child: Text(
              _errorMessage,
              style: textTheme.bodyText2!.copyWith(color: AppTheme.secondaryColor),
            ),
          ),
        ),
      );

  Widget _buildVerifyButton() => GetBuilder<AuthController>(builder: (AuthController controller) {
        return Padding(
          padding: const EdgeInsets.all(22.0),
          child: AppButton(
            title: 'Verify',
            isLoading: controller.state == AuthState.VERIFYING,
            onPressed: _verifyImage,
          ),
        );
      });

  /// Member Functions
  ///
  ///
  void _clearError() => setState(() {
        _isError = false;
        _errorMessage = '';
      });

  void _setError(String error) => setState(() {
        _isError = true;
        _errorMessage = error;
      });

  Future<void> _pickImage() async {
    _clearError();
    _selectedPicture = await _picker.pickImage(source: ImageSource.camera);

    if (_selectedPicture != null) {
      _userPhoto = File.fromUri(Uri.parse(_selectedPicture!.path));
      setState(() {});
    } else {
      _setError("No image was selected...");
    }
  }

  Future<void> _verifyImage() async {
    if (_userPhoto != null) {
      _clearError();
      final result = await locator.get<AuthController>().verifyUserImage(_userPhoto!);

      if (result) {
        locator.get<NavigationService>().pushNamed(AppRoutes.getStartedRoute);
      } else {
        _setError("Verification failed, please try again...");
      }
    } else {
      _setError("Please select an image...");
    }
  }
}
