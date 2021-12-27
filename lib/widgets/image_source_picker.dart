import 'package:contact_sharing/core/core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource> showImageSourcePicker({required BuildContext context}) async {
  // data variables
  ImageSource selectedSource = ImageSource.camera;

  // gender picker widget
  final Widget sourcePickerDialog = SourcePickerDialog(
    onChanged: (ImageSource value) => selectedSource = value,
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
    builder: (_) => sourcePickerDialog,
  );

  return selectedSource;
}

class SourcePickerDialog extends StatefulWidget {
  final Function onChanged;

  const SourcePickerDialog({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SourcePickerDialog> createState() => _SourcePickerDialogState();
}

class _SourcePickerDialogState extends State<SourcePickerDialog> {
  // data variables
  static const List<ImageSource> _sources = [
    ImageSource.camera,
    ImageSource.gallery,
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
            'Select Source',
            style: textTheme.headline3,
          ),
          // spacing
          const SizedBox(height: 22.0),
          // gender picker
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _sources.map((source) => _tileWidget(source, textTheme)).toList(),
          ),
        ],
      ),
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _tileWidget(ImageSource source, TextTheme textTheme) => GestureDetector(
        onTap: () {
          widget.onChanged(source);
          locator.get<NavigationService>().pop();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Text(
            source == ImageSource.camera ? 'Camera' : 'Gallery',
            style: textTheme.headline4,
            textAlign: TextAlign.left,
          ),
        ),
      );
}
