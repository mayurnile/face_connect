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

    return Column(
      children: [
        // title
        Text(
          'Gender',
          style: textTheme.headline3,
        ),
        // spacing
        const SizedBox(height: 22.0),
        // gender picker
        SizedBox(
          width: size.width,
          height: size.height * 0.3,
          child: Column(
            children: _genders.map((gender) => _tileWidget(gender, textTheme)).toList(),
          ),
        ),
      ],
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _tileWidget(String title, TextTheme textTheme) => GestureDetector(
        onTap: () => widget.onChanged(title),
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(title, style: textTheme.headline3),
        ),
      );
}
