import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/core.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../../controllers/controllers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screen Title
          _buildScreenTitle(textTheme),
          // Snap Section
          _buildSnapSection(size, textTheme),
        ],
      ),
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _buildScreenTitle(TextTheme textTheme) => Padding(
        padding: const EdgeInsets.all(22.0),
        child: Text('Home', style: textTheme.headline3),
      );

  Widget _buildSnapSection(Size size, TextTheme textTheme) => Expanded(
        child: GetBuilder<HomeController>(
          builder: (HomeController controller) {
            if (controller.state == HomeState.INITIAL) {
              return _buildHomeInitialState(size, textTheme);
            } else {
              return _buildHomeSearchState(size, textTheme);
            }
          },
        ),
      );

  Widget _buildHomeInitialState(Size size, TextTheme textTheme) => SizedBox(
        width: size.width,
        child: Column(
          children: [
            // illustration
            SvgPicture.asset(
              IllustrationAssets.snapIllustration,
              height: size.height * 0.5,
            ),
            // snap title
            Text(
              'Snap to\nGet Started',
              style: textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            // snap button
            _buildSnapButton(textTheme),
            // subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Text(
                "Take a picture, we'll analyze and list you the contact details of the detected person",
                style: textTheme.bodyText2!.copyWith(
                  color: AppTheme.fontLightColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );

  Widget _buildSnapButton(TextTheme textTheme, {bool isRetry = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 22.0),
        child: ElevatedButton(
          onPressed: _snap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // snap icon
              SvgPicture.asset(
                IconAssets.snap,
                // color: Colors.white,
                height: 22.0,
                width: 22.0,
                fit: BoxFit.scaleDown,
              ),
              // spacing
              const SizedBox(width: 22.0),
              // title
              Text(
                isRetry ? 'Snap Again' : 'Snap',
                style: textTheme.button,
              ),
            ],
          ),
        ),
      );

  Widget _buildHomeSearchState(Size size, TextTheme textTheme) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // display snapped image
          Container(
            height: size.height * 0.4,
            width: size.width,
            margin: const EdgeInsets.symmetric(horizontal: 22.0),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.file(
                locator.get<HomeController>().userPhoto,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // found connections list
          _buildConnectionsList(size, textTheme),
        ],
      );

  Widget _buildConnectionsList(Size size, TextTheme textTheme) => Expanded(
        child: GetBuilder<HomeController>(
          builder: (HomeController controller) {
            if (controller.state == HomeState.SEARCHING_CONNECTIONS) {
              return _buildSearchingConnections(textTheme);
            } else if (controller.state == HomeState.CONNECTIONS_FOUND) {
              return _buildFoundUsersList(textTheme, controller.foundUsers);
            } else if (controller.state == HomeState.NO_CONNECTIONS_FOUND) {
              return _buildErrorState('', textTheme);
            } else if (controller.state == HomeState.ERROR) {
              return _buildErrorState(controller.errorMessage, textTheme);
            }
            return const SizedBox.shrink();
          },
        ),
      );

  Widget _buildSearchingConnections(TextTheme textTheme) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // loading icon
            const LoadingIndicator(
              color: AppTheme.primaryColor,
            ),
            // spacing
            const SizedBox(height: 8.0),
            // text
            Text(
              'Analyzing your image...',
              style: textTheme.bodyText1,
            ),
          ],
        ),
      );

  Widget _buildFoundUsersList(TextTheme textTheme, List<SearchedUser> foundUsers) => Container();

  Widget _buildErrorState(String error, TextTheme textTheme) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // error text
            Text(
              error.isEmpty ? 'No connections found' : error,
              style: textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            // spacing
            const SizedBox(height: 8.0),
            // retry button
            _buildSnapButton(textTheme, isRetry: true),
          ],
        ),
      );

  /// Member Functions
  ///
  ///
  void _snap() {
    final String token = locator.get<AuthController>().token;
    locator.get<HomeController>().pickImage(token);
  }
}
