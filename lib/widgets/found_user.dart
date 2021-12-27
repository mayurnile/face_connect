import 'package:contact_sharing/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './widgets.dart';

import '../core/core.dart';
import '../models/models.dart';

class FoundUser extends StatefulWidget {
  final SearchedUser user;

  const FoundUser({Key? key, required this.user}) : super(key: key);

  @override
  State<FoundUser> createState() => _FoundUserState();
}

class _FoundUserState extends State<FoundUser> {
  // controller variables
  bool isSendingRequest = false;

  // device variables
  late Size size;
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
      child: Row(
        children: [
          // leading
          SizedBox(
            height: size.width * 0.15,
            width: size.width * 0.15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                widget.user.profilePicture,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // spacing
          const SizedBox(width: 18.0),
          // user name
          Text(
            widget.user.name,
            style: textTheme.headline5,
          ),
          // spacing
          const Spacer(),
          // send request
          _buildSendRequestButton(),
        ],
      ),
    );
  }

  Widget _buildSendRequestButton() => GestureDetector(
        onTap: isSendingRequest ? () {} : sendFriendRequest,
        child: isSendingRequest
            ? const LoadingIndicator(
                color: AppTheme.primaryColor,
              )
            : SvgPicture.asset(
                IconAssets.addFriend,
                color: AppTheme.primaryColor,
              ),
      );

  /// Member Functions
  ///
  ///
  Future<void> sendFriendRequest() async {
    setState(() => isSendingRequest = true);
    final String token = locator.get<AuthController>().token;
    await locator.get<HomeController>().sendConnectionRequest(token, widget.user.id);
    Fluttertoast.showToast(
      msg: 'Request Sent!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
    setState(() => isSendingRequest = false);
  }
}
