import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../../controllers/controllers.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key? key}) : super(key: key);

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
          // Requests List
          _buildRequestsList(size, textTheme),
        ],
      ),
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _buildScreenTitle(TextTheme textTheme) => Padding(
        padding: const EdgeInsets.all(22.0),
        child: Text('Requests', style: textTheme.headline3),
      );

  Widget _buildRequestsList(Size size, TextTheme textTheme) => GetBuilder<RequestsController>(
        initState: initState,
        builder: (RequestsController controller) {
          if (controller.state == RequestsState.LOADING) {
            return _buildRequestsLoading(textTheme);
          } else if (controller.state == RequestsState.LOADED) {
            return _buildRequests(textTheme, controller.requests);
          } else if (controller.state == RequestsState.NO_REQUESTS) {
            return _buildErrorState('', textTheme);
          } else if (controller.state == RequestsState.ERROR) {
            return _buildErrorState(controller.errorMessage, textTheme);
          }
          return const SizedBox.shrink();
        },
      );

  Widget _buildRequestsLoading(TextTheme textTheme) => Expanded(
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
                'Loading your requests...',
                style: textTheme.bodyText1,
              ),
            ],
          ),
        ),
      );

  Widget _buildRequests(TextTheme textTheme, List<RequestModel> requests) => Expanded(
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (BuildContext ctx, int index) => FoundRequest(request: requests[index]),
        ),
      );

  Widget _buildErrorState(String error, TextTheme textTheme) => Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // error text
              Text(
                error.isEmpty ? 'No connections found' : error,
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
    getConnectionRequests(isRefresh: false);
    // if (locator.get<RequestsController>().requests.isEmpty) {}
  }

  Future<void> getConnectionRequests({required bool isRefresh}) async {
    final RequestsController controller = Get.find();
    controller.getAllConnectionRequests(
      locator.get<AuthController>().token,
      isRefresh: isRefresh,
    );
  }
}
