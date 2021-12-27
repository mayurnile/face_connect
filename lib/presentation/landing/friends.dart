import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../../controllers/controllers.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

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
          // Friends List
          _buildFriendsList(size, textTheme),
        ],
      ),
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _buildScreenTitle(TextTheme textTheme) => Padding(
        padding: const EdgeInsets.all(22.0),
        child: Text('Friends', style: textTheme.headline3),
      );

  Widget _buildFriendsList(Size size, TextTheme textTheme) => GetBuilder<FriendsController>(
        initState: initState,
        builder: (FriendsController controller) {
          if (controller.state == FriendsState.LOADING) {
            return _buildFriendssLoading(textTheme);
          } else if (controller.state == FriendsState.LOADED) {
            return _buildFriends(textTheme, controller.friends);
          } else if (controller.state == FriendsState.NO_FRIENDS) {
            return _buildErrorState('', textTheme);
          } else if (controller.state == FriendsState.ERROR) {
            return _buildErrorState(controller.errorMessage, textTheme);
          }
          return const SizedBox.shrink();
        },
      );

  Widget _buildFriendssLoading(TextTheme textTheme) => Expanded(
        child: Center(
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
                'Getting your friends...',
                style: textTheme.bodyText1,
              ),
            ],
          ),
        ),
      );

  Widget _buildFriends(TextTheme textTheme, List<UserModel> friends) => Expanded(
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (BuildContext ctx, int index) => Friend(friend: friends[index]),
        ),
      );

  Widget _buildErrorState(String error, TextTheme textTheme) => Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // error text
              Text(
                error.isEmpty ? 'No freinds found' : error,
                style: textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  /// Member Functions
  ///
  ///
  void initState(_) {
    getFriends(isRefresh: false);
    // if (locator.get<RequestsController>().requests.isEmpty) {}
  }

  Future<void> getFriends({required bool isRefresh}) async {
    final FriendsController controller = Get.find();
    controller.getAllFriends(
      locator.get<AuthController>().token,
      isRefresh: isRefresh,
    );
  }
}
