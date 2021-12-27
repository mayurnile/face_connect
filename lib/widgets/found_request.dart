import 'package:contact_sharing/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class FoundRequest extends StatefulWidget {
  final RequestModel request;

  const FoundRequest({Key? key, required this.request}) : super(key: key);

  @override
  _FoundRequestState createState() => _FoundRequestState();
}

class _FoundRequestState extends State<FoundRequest> {
  // controller variables
  bool isAcceptingRequest = false;
  bool isRejectingRequest = false;

  // device variables
  late Size size;
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
      child: Row(
        children: [
          // leading
          SizedBox(
            height: size.width * 0.15,
            width: size.width * 0.15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                widget.request.senderProfilePicture,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // spacing
          const SizedBox(width: 18.0),
          // user name
          Text(
            widget.request.senderName,
            style: textTheme.headline5,
          ),
          // spacing
          const Spacer(),
          // accept request
          _buildAcceptRequestButton(),
          // spacing
          const SizedBox(width: 12.0),
          // reject request
          _buildRejectRequestButton(),
        ],
      ),
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _buildAcceptRequestButton() => GestureDetector(
        onTap: isAcceptingRequest ? () {} : acceptRequest,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryColor.withOpacity(0.2),
          ),
          child: isAcceptingRequest
              ? const LoadingIndicator(color: AppTheme.primaryColor)
              : const Icon(
                  Icons.done,
                  color: AppTheme.primaryColor,
                  size: 28.0,
                ),
        ),
      );

  Widget _buildRejectRequestButton() => GestureDetector(
        onTap: isRejectingRequest ? () {} : rejectRequest,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.secondaryColor.withOpacity(0.2),
          ),
          child: isRejectingRequest
              ? const LoadingIndicator(color: AppTheme.secondaryColor)
              : const Icon(
                  Icons.close,
                  color: AppTheme.secondaryColor,
                  size: 28.0,
                ),
        ),
      );

  /// Member Functions
  ///
  ///
  Future<void> acceptRequest() async {
    setState(() => isAcceptingRequest = true);

    final String token = locator.get<AuthController>().token;
    final bool result = await locator.get<RequestsController>().acceptConnectionRequest(token, widget.request.requestID);

    if (result) {
      Fluttertoast.showToast(
        msg: 'Request Accepted!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: locator.get<RequestsController>().errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
    setState(() => isAcceptingRequest = false);
  }

  Future<void> rejectRequest() async {
    setState(() => isRejectingRequest = true);

    final String token = locator.get<AuthController>().token;
    final bool result = await locator.get<RequestsController>().rejectingConnectionRequest(token, widget.request.requestID);

    if (result) {
      Fluttertoast.showToast(
        msg: 'Request Rejected!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: locator.get<RequestsController>().errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
    setState(() => isRejectingRequest = false);
  }
}
