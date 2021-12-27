import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/core.dart';
import '../models/models.dart';

class Friend extends StatelessWidget {
  final UserModel friend;

  const Friend({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        collapsedIconColor: AppTheme.primaryColor,
        iconColor: AppTheme.secondaryColor,
        leading: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              friend.profilePicture!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          friend.name!,
          style: textTheme.headline4,
        ),
        childrenPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 22.0),
        children: [
          // contact details heading
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Contact details',
              style: textTheme.bodyText2,
            ),
          ),
          // spacing
          const SizedBox(height: 8.0),
          // contact details
          Row(
            children: [
              // phone number
              Text(
                "+91 ${friend.phoneNumber}",
                style: textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
              ),
              // spacing
              const Spacer(),
              // call button
              GestureDetector(
                onTap: () {
                  final String url = "tel:91${friend.phoneNumber!}";
                  _launchURL(url);
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: AppTheme.primaryColor,
                    size: 18.0,
                  ),
                ),
              ),
              // spacing
              const SizedBox(width: 12.0),
              // message button
              GestureDetector(
                onTap: () {
                  final String whatsappUrl = "whatsapp://send?phone=+91${friend.phoneNumber}";
                  _launchURL(whatsappUrl);
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.message,
                    color: AppTheme.primaryColor,
                    size: 18.0,
                  ),
                ),
              ),
            ],
          ),
          // spacing
          const SizedBox(height: 8.0),
          // email
          Row(
            children: [
              // phone number
              Text(
                friend.email!,
                style: textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
              ),
              // spacing
              const Spacer(),
              // call button
              GestureDetector(
                onTap: () {
                  final Uri params = Uri(
                    scheme: 'mailto',
                    path: friend.email,
                  );

                  final String url = params.toString();
                  _launchURL(url);
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.email,
                    color: AppTheme.primaryColor,
                    size: 18.0,
                  ),
                ),
              ),
            ],
          ),
          // spacing
          const SizedBox(height: 12.0),
          // contact details heading
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Personal details',
              style: textTheme.bodyText2,
            ),
          ),
          // spacing
          const SizedBox(height: 8.0),
          // location
          Row(
            children: [
              // prefix text
              Text(
                'Lives in ',
                style: textTheme.subtitle1,
              ),
              // city
              Text(
                friend.city!,
                style: textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
              ),
              // spacing
              const Spacer(),
              // call button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.location_city,
                    color: AppTheme.primaryColor,
                    size: 18.0,
                  ),
                ),
              ),
            ],
          ),
          // spacing
          const SizedBox(height: 8.0),
          // dov
          Row(
            children: [
              // prefix text
              Text(
                'Birhtday on ',
                style: textTheme.subtitle1,
              ),
              // city
              Text(
                friend.dob!.dateOfBirthUIFormat,
                style: textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
              ),
              // spacing
              const Spacer(),
              // call button
              GestureDetector(
                onTap: () {
                  final String url = 'https://calendar.google.com/calendar/r/month/${friend.dob!.year}/${friend.dob!.month}/${friend.dob!.day}';
                  _launchURL(url);
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.cake,
                    color: AppTheme.primaryColor,
                    size: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Member Functions
  ///
  ///
  Future<void> _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
