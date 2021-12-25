import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/core.dart';
import '../../widgets/widgets.dart';
import '../../controllers/controllers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // keys
  final GlobalKey<FormState> _emailLoginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneLoginKey = GlobalKey<FormState>();

  // controllers
  final PageController _pageController = PageController();

  // data variables
  String _email = '';
  String _password = '';
  String _phoneNumber = '';

  // controller variables
  bool _isError = false;
  bool _isEmailLogin = true;
  bool _showPassword = true;
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
                // login type selector
                _buildLoginTypeSelector(),
                // error message
                _buildErrorMessage(),
                // login form
                _buildLoginForm(),
                // social login options
                _buildSocialLoginOptions(),
                // login button
                _buildLoginButton(),
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
              'Login',
              style: textTheme.headline3,
            ),
            // spacing
            const SizedBox(height: 8.0),
            // subtitle
            Text(
              'Hello, Welcome back to your account',
              style: textTheme.subtitle1,
            ),
          ],
        ),
      );

  Widget _buildLoginTypeSelector() => Container(
        height: size.height * 0.07,
        width: size.width,
        margin: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 22.0),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(54.0),
        ),
        child: Stack(
          children: [
            // selector tab
            AnimatedPositioned(
              duration: _animDuration,
              curve: _animCurve,
              left: _isEmailLogin ? 0.0 : size.width * 0.5 - 32.0,
              top: 0.0,
              bottom: 0.0,
              child: Container(
                height: size.height * 0.08,
                width: size.width * 0.5 - 32.0,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(54.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12.0,
                      offset: const Offset(0.0, 4.0),
                    ),
                  ],
                ),
              ),
            ),
            // text
            Positioned.fill(
              child: LayoutBuilder(builder: (context, constraints) {
                return Row(
                  children: [
                    // email text
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _switchLoginType,
                      child: SizedBox(
                        width: constraints.maxWidth * 0.49,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: _animDuration,
                            style: _isEmailLogin ? textTheme.headline5! : textTheme.headline6!.copyWith(color: AppTheme.fontLightColor),
                            child: const Text('Email'),
                          ),
                        ),
                      ),
                    ),
                    // phone number text
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _switchLoginType,
                      child: SizedBox(
                        width: constraints.maxWidth * 0.49,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: _animDuration,
                            style: _isEmailLogin ? textTheme.headline6!.copyWith(color: AppTheme.fontLightColor) : textTheme.headline5!,
                            child: const Text('Phone Number'),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      );

  Widget _buildErrorMessage() => AnimatedContainer(
        duration: _animDuration,
        curve: _animCurve,
        height: _isError ? size.height * 0.05 : 0.0,
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

  Widget _buildLoginForm() => SizedBox(
        height: size.height * 0.32,
        child: PageView(
          controller: _pageController,
          onPageChanged: (int index) {
            setState(() {
              if (index == 0) {
                _isEmailLogin = true;
              } else {
                _isEmailLogin = false;
              }
            });
          },
          children: [
            // email login form
            _buildEmailLoginForm(),
            // phone number logni form
            _buildPhoneNumberLoginForm(),
          ],
        ),
      );

  Widget _buildEmailLoginForm() => Form(
        key: _emailLoginKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              // password input
              TextInputField(
                label: 'Password',
                inputType: TextInputType.visiblePassword,
                inputFormatters: const [],
                obscureText: _showPassword,
                validator: (String? value) => Validators.isFieldEmpty(value),
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
              const SizedBox(height: 12.0),
              // Forget Password button
              Text(
                'Forgot Password?',
                style: textTheme.headline6!.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildPhoneNumberLoginForm() => Form(
        key: _phoneLoginKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
        ),
      );

  Widget _buildSocialLoginOptions() => SizedBox(
        width: size.width,
        child: Column(
          children: [
            // spacing
            SizedBox(height: size.height * 0.05),
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

  Widget _buildLoginButton() => GetBuilder<AuthController>(builder: (AuthController controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: AppButton(
            title: 'Login',
            isLoading: controller.state == AuthState.AUTHENTICATING,
            onPressed: _isEmailLogin ? _loginUsingEmailAndPassword : _loginUsingPhoneNumber,
          ),
        );
      });

  Widget _buildOtherOptions() => Padding(
        padding: const EdgeInsets.only(top: 22.0, bottom: 32.0),
        child: Center(
          child: Text.rich(
            TextSpan(
              text: "Don't have an account? ",
              style: textTheme.bodyText1!.copyWith(color: AppTheme.fontLightColor),
              children: [
                TextSpan(
                  text: "Signup",
                  style: textTheme.headline4!.copyWith(color: AppTheme.secondaryColor),
                  recognizer: _navigateToSignup(),
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

  void _clearError() => setState(() {
        _isError = false;
        _errorMessage = '';
      });

  void _setError(String error) => setState(() {
        _isError = true;
        _errorMessage = error;
      });

  void _switchLoginType() => setState(() {
        _isEmailLogin = !_isEmailLogin;
        if (_isEmailLogin) {
          _clearError();
          _pageController.animateToPage(0, duration: _animDuration, curve: _animCurve);
        } else {
          _clearError();
          _pageController.animateToPage(1, duration: _animDuration, curve: _animCurve);
        }
      });

  TapGestureRecognizer _navigateToSignup() => TapGestureRecognizer()
    ..onTap = () => locator.get<NavigationService>().removeAllAndPush(
          AppRoutes.signupRoute,
        );

  Future<void> _loginUsingEmailAndPassword() async {
    FocusScope.of(context).unfocus();
    final form = _emailLoginKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      final bool result = await locator.get<AuthController>().emailPasswordLogin(
            email: _email,
            password: _password,
          );

      if (result) {
        _clearError();
        locator.get<NavigationService>().removeAllAndPush(AppRoutes.landingRoute);
      } else {
        _setError(locator.get<AuthController>().errorMessage);
      }
    }
  }

  Future<void> _loginUsingPhoneNumber() async {
    FocusScope.of(context).unfocus();
    final form = _phoneLoginKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      locator.get<AuthController>().sendOTP(phoneNumber: "+91 $_phoneNumber");
      locator.get<NavigationService>().pushNamed(AppRoutes.verifyOTPRoute);
    }
  }
}
