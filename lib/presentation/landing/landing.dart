import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screens.dart';

import '../../core/core.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  // controller
  int _currentPage = 0;
  final PageController _pageController = PageController();

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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // pages
            _buildPages(),
            // tab bar
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _buildPages() => Expanded(
        child: PageView(
          controller: _pageController,
          onPageChanged: (int index) => setState(() => _currentPage = index),
          children: const [
            HomeScreen(),
            FriendsScreen(),
            RequestsScreen(),
            ProfileScreen(),
          ],
        ),
      );

  Widget _buildBottomNavBar() => Container(
        height: size.height * 0.08,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12.0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavBarTab(0, IconAssets.home, 'Home'),
            _buildNavBarTab(1, IconAssets.friends, 'Friends'),
            _buildNavBarTab(2, IconAssets.requests, 'Requests'),
            _buildNavBarTab(3, IconAssets.profile, 'Profile'),
          ],
        ),
      );

  Widget _buildNavBarTab(int myIndex, String icon, String title) {
    final bool isSelected = myIndex == _currentPage;
    final Widget displayWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // icon
        SvgPicture.asset(
          icon,
          height: 22.0,
          width: 22.0,
          fit: BoxFit.scaleDown,
          color: isSelected ? AppTheme.secondaryColor : AppTheme.fontLightColor,
        ),
        // spacing
        if (isSelected) const SizedBox(width: 8.0),
        // Title
        AnimatedDefaultTextStyle(
          duration: _animDuration,
          curve: _animCurve,
          style: isSelected
              ? textTheme.headline6!.copyWith(
                  color: AppTheme.secondaryColor,
                )
              : textTheme.headline6!.copyWith(
                  fontSize: 0.0,
                ),
          child: Text(title),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => setState(() {
        _currentPage = myIndex;
        _pageController.animateToPage(_currentPage, duration: _animDuration, curve: _animCurve);
      }),
      child: AnimatedContainer(
        duration: _animDuration,
        curve: _animCurve,
        height: size.height * 0.08,
        width: isSelected ? size.width * 0.35 : size.height * 0.08,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.secondaryColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(54.0),
        ),
        child: displayWidget,
      ),
    );
  }
}
