import 'package:contact_sharing/core/core.dart';
import 'package:flutter/material.dart';

Future<String> showGenderPicker({required BuildContext context}) async {
  // data variables
  String selectedGender = 'Male';

  // gender picker widget
  final Widget genderPickerDialog = GenderPickerDialog(
    onChanged: (String value) => selectedGender = value,
  );

  // modal popup
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
    ),
    builder: (_) => genderPickerDialog,
  );

  return selectedGender;
}

class GenderPickerDialog extends StatefulWidget {
  final Function onChanged;

  const GenderPickerDialog({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<GenderPickerDialog> createState() => _GenderPickerDialogState();
}

class _GenderPickerDialogState extends State<GenderPickerDialog> {
  // data variables
  static const List<String> _genders = [
    'Male',
    'Female',
    'Non-Binary',
    'Prefer not to answer',
  ];

  // device variables
  late Size size;
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // title
          Text(
            'Select Gender',
            style: textTheme.headline3,
          ),
          // spacing
          const SizedBox(height: 22.0),
          // gender picker
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _genders.map((gender) => _tileWidget(gender, textTheme)).toList(),
          ),
        ],
      ),
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _tileWidget(String title, TextTheme textTheme) => GestureDetector(
        onTap: () {
          widget.onChanged(title);
          locator.get<NavigationService>().pop();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Text(
            title,
            style: textTheme.headline4,
            textAlign: TextAlign.left,
          ),
        ),
      );
}
