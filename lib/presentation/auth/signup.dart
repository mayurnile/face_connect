import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/core.dart';
import '../../widgets/widgets.dart';
import '../../controllers/controllers.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // data variables
  String _email = '';
  String _phoneNumber = '';
  String _password = '';
  String _confirmPassword = '';

  // controller variables
  bool _isError = false;
  bool _showPassword = true;
  bool _showConfirmPassword = true;
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
                // error message
                _buildErrorMessage(),
                // login form
                _buildSignupForm(),
                // social login options
                _buildSocialLoginOptions(),
                // signup button
                _buildSignupButton(),
                // signup options
                _buildOtherOptions(),
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
              'Signup',
              style: textTheme.headline3,
            ),
            // spacing
            const SizedBox(height: 8.0),
            // subtitle
            Text(
              'Hey, fill in your details to get started',
              style: textTheme.subtitle1,
            ),
          ],
        ),
      );

  Widget _buildErrorMessage() => AnimatedContainer(
        duration: _animDuration,
        curve: _animCurve,
        height: _isError ? size.height * 0.05 : 0.0,
        padding: const EdgeInsets.only(bottom: 18.0),
        margin: const EdgeInsets.only(top: 32.0),
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

  Widget _buildSignupForm() => Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
          child: Column(
            children: [
              // email input
              TextInputField(
                label: 'Email',
                inputType: TextInputType.emailAddress,
                inputFormatters: [InputFormatters().onlyEmailInput],
                validator: (String? value) => Validators.isValidEmail(value),
                onSaved: (String? value) => value != null ? _email = value.trim() : '',
              ),
              // spacing
              const SizedBox(height: 22.0),
              // phone number input
              TextInputField(
                label: 'Phone Number',
                inputType: TextInputType.number,
                inputFormatters: [InputFormatters().onlyNumbersInput],
                validator: (String? value) => Validators.isFieldEmpty(value),
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // spacing
                    const SizedBox(width: 18.0),
                    // text
                    Text(
                      '+91',
                      style: textTheme.bodyText1,
                    ),
                    // spacing
                    const SizedBox(width: 8.0),
                    // divider
                    const SizedBox(
                      height: 32.0,
                      child: VerticalDivider(
                        color: AppTheme.fontLightColor,
                      ),
                    ),
                    // spacing
                    const SizedBox(width: 8.0),
                  ],
                ),
                onSaved: (String? value) => value != null ? _phoneNumber = value.trim() : '',
              ),
              // spacing
              const SizedBox(height: 22.0),
              // password input
              TextInputField(
                label: 'Password',
                inputType: TextInputType.visiblePassword,
                inputFormatters: const [],
                obscureText: _showPassword,
                validator: (String? value) => Validators.isFieldEmpty(value),
                onChanged: (String? value) => value != null ? _password = value.trim() : '',
                onSaved: (String? value) => value != null ? _password = value.trim() : '',
                suffix: IconButton(
                  onPressed: _toggleShowPassword,
                  icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                    color: AppTheme.fontLightColor,
                  ),
                ),
              ),
              // spacing
              const SizedBox(height: 22.0),
              // confirm password input
              TextInputField(
                label: 'Confirm Password',
                inputType: TextInputType.visiblePassword,
                inputFormatters: const [],
                obscureText: _showConfirmPassword,
                validator: (String? value) {
                  if (value != null && value.trim().isEmpty) {
                    return 'This field cannot be empty!';
                  }
                  if (value != null && value.trim() != _password) {
                    return 'Password and confirm password did not matched!';
                  }
                },
                onChanged: (String? value) => value != null ? _confirmPassword = value.trim() : '',
                onSaved: (String? value) => value != null ? _confirmPassword = value.trim() : '',
                suffix: IconButton(
                  onPressed: _toggleShowConfirmPassword,
                  icon: Icon(
                    _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: AppTheme.fontLightColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSocialLoginOptions() => SizedBox(
        width: size.width,
        child: Column(
          children: [
            // spacing
            const SizedBox(height: 22.0),
            // title text
            Text(
              'or continue with',
              style: textTheme.bodyText2!.copyWith(color: AppTheme.fontLightColor),
            ),
            // google login button
            GestureDetector(
              child: Container(
                width: size.width * 0.15,
                height: size.height * 0.15,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      blurRadius: 12.0,
                      offset: const Offset(0.0, 8.0),
                    ),
                  ],
                ),
                child: SvgPicture.asset(IconAssets.googleAuth),
              ),
            ),
          ],
        ),
      );

  Widget _buildSignupButton() => GetBuilder<AuthController>(builder: (AuthController controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: AppButton(
            title: 'Signup',
            isLoading: controller.state == AuthState.AUTHENTICATING,
            onPressed: _signup,
          ),
        );
      });

  Widget _buildOtherOptions() => Padding(
        padding: const EdgeInsets.only(top: 22.0, bottom: 32.0),
        child: Center(
          child: Text.rich(
            TextSpan(
              text: "Already have an account? ",
              style: textTheme.bodyText1!.copyWith(color: AppTheme.fontLightColor),
              children: [
                TextSpan(
                  text: "Login",
                  style: textTheme.headline4!.copyWith(color: AppTheme.secondaryColor),
                  recognizer: _navigateToLogin(),
                ),
              ],
            ),
          ),
        ),
      );

  /// Member Functions
  ///
  ///
  void _toggleShowPassword() => setState(() => _showPassword = !_showPassword);

  void _toggleShowConfirmPassword() => setState(() => _showConfirmPassword = !_showConfirmPassword);

  void _clearError() => setState(() {
        _isError = false;
        _errorMessage = '';
      });

  void _setError(String error) => setState(() {
        _isError = true;
        _errorMessage = error;
      });

  TapGestureRecognizer _navigateToLogin() => TapGestureRecognizer()
    ..onTap = () => locator.get<NavigationService>().removeAllAndPush(
          AppRoutes.loginRoute,
        );

  Future<void> _signup() async {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      if (_password == _confirmPassword) {
        final bool result = await locator.get<AuthController>().emailPasswordSignup(
              email: _email,
              password: _password,
            );

        if (result) {
          _clearError();
          locator.get<AuthController>().userModel.email = _email;
          locator.get<AuthController>().userModel.phoneNumber = _phoneNumber;
          locator.get<NavigationService>().removeAllAndPush(AppRoutes.userVerificationRoute);
        } else {
          _setError(locator.get<AuthController>().errorMessage);
        }
      } else {
        _setError("Password and confirm password did not matched...");
      }
    }
  }
}
