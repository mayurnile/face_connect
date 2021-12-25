import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../core/core.dart';
import '../../widgets/widgets.dart';
import '../../controllers/controllers.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  // keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Dependencies
  final ImagePicker _picker = ImagePicker();

  // data variables
  XFile? _selectedPicture;
  File? _userPhoto;
  String _profilePhotoURL = '';
  String _name = '';
  String _city = '';
  DateTime? _dob;

  // controller variables
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool _isImageUploading = false;
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // screen title
                _buildScreenTitle(),
                // image picker
                _buildImagePickerSection(),
                // data input form
                _buildDataInputForm(),
                // error message
                _buildErrorMessage(),
                // save button
                _buildSaveButton(),
              ],
            ),
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
              'Get Started',
              style: textTheme.headline3,
            ),
            // spacing
            const SizedBox(height: 8.0),
            // subtitle
            Text(
              'Enter your details and complete your profile',
              style: textTheme.subtitle1,
            ),
          ],
        ),
      );

  Widget _buildImagePickerSection() => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
          child: Column(
            children: [
              // image picker
              GestureDetector(
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
                          child: _isImageUploading
                              ? const LoadingIndicator(color: AppTheme.fontDarkColor)
                              : Center(
                                  child: SvgPicture.asset(IconAssets.profilePicture),
                                ),
                        ),
                ),
              ),
              // subtitle
              Text(
                "This photo will be used for public display",
                style: textTheme.bodyText2!.copyWith(color: AppTheme.fontLightColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  Widget _buildDataInputForm() => Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            children: [
              // name
              TextInputField(
                label: 'Name',
                inputType: TextInputType.name,
                inputFormatters: [InputFormatters().onlyAlphabestInput],
                validator: (String? value) => Validators.isFieldEmpty(value),
                onSaved: (String? value) => value != null ? _name = value.trim() : '',
              ),
              // spacing
              const SizedBox(height: 22.0),
              // city
              TextInputField(
                label: 'City',
                inputType: TextInputType.streetAddress,
                inputFormatters: [InputFormatters().onlyAlphabestInput],
                onSaved: (String? value) => value != null ? _city = value.trim() : '',
              ),
              // spacing
              const SizedBox(height: 22.0),
              // city
              GestureDetector(
                onTap: _pickGender,
                child: TextInputField(
                  controller: _genderController,
                  label: 'Gender',
                  enabled: false,
                  inputType: TextInputType.streetAddress,
                  inputFormatters: const [],
                  suffix: SvgPicture.asset(
                    IconAssets.dropDownArrow,
                    color: AppTheme.fontDarkColor,
                    fit: BoxFit.scaleDown,
                    height: 28.0,
                    width: 28.0,
                  ),
                ),
              ),
              // spacing
              const SizedBox(height: 22.0),
              // date of birth
              GestureDetector(
                onTap: _pickDate,
                child: TextInputField(
                  controller: _dobController,
                  label: 'Date of birth',
                  enabled: false,
                  inputType: TextInputType.streetAddress,
                  inputFormatters: const [],
                  suffix: SvgPicture.asset(
                    IconAssets.date,
                    color: AppTheme.fontDarkColor,
                    fit: BoxFit.scaleDown,
                    height: 28.0,
                    width: 28.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildErrorMessage() => AnimatedContainer(
        duration: _animDuration,
        curve: _animCurve,
        height: _isError ? size.height * 0.05 : 0.0,
        margin: const EdgeInsets.only(top: 22.0),
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

  Widget _buildSaveButton() => GetBuilder<AuthController>(builder: (AuthController controller) {
        return Padding(
          padding: const EdgeInsets.all(22.0),
          child: AppButton(
            title: 'Save',
            isLoading: controller.state == AuthState.AUTHENTICATING,
            onPressed: _save,
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
    FocusScope.of(context).unfocus();
    _clearError();
    _selectedPicture = await _picker.pickImage(source: ImageSource.gallery);

    if (_selectedPicture != null) {
      setState(() => _isImageUploading = true);
      _userPhoto = File.fromUri(Uri.parse(_selectedPicture!.path));
      final String imageURL = await locator.get<AuthController>().uploadImage(_userPhoto!);
      _profilePhotoURL = imageURL;
      setState(() => _isImageUploading = false);
    } else {
      _setError("No image was selected...");
    }
  }

  Future<void> _pickGender() async {
    FocusScope.of(context).unfocus();
    final String selectedGender = await showGenderPicker(context: context);

    if (selectedGender.isNotEmpty) {
      _genderController.text = selectedGender;
      setState(() {});
    }
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final DateTime? pickedTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedTime != null) {
      _dob = pickedTime;
      _dobController.text = _dob.toString();
      setState(() {});
    }
  }

  Future<void> _save() async {
    final form = _formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      if (_userPhoto != null) {
        _clearError();
        final AuthController controller = locator.get<AuthController>();
        controller.userModel.name = _name;
        controller.userModel.profilePicture = _profilePhotoURL;
        controller.userModel.city = _city;
        if (_genderController.text.isNotEmpty) controller.userModel.gender = _genderController.text;
        if (_dob != null) controller.userModel.dob = _dob;
        final result = await locator.get<AuthController>().createUser(controller.userModel);

        if (result) {
          locator.get<NavigationService>().pushNamed(AppRoutes.landingRoute);
        } else {
          _setError(controller.errorMessage.isNotEmpty ? controller.errorMessage : "Unable to signup...");
        }
      } else {
        _setError("Please select an image...");
      }
    }
  }
}
