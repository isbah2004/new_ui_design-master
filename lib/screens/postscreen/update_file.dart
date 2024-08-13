import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ui_design/provider/crud_provider.dart';
import 'package:ui_design/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:ui_design/reusablewidgets/reusable_button.dart';
import 'package:ui_design/reusablewidgets/reusable_text_field.dart';
import 'package:ui_design/utils/utils.dart';

class UpdateFile extends StatefulWidget {
  final String appBarTitle, collection, docId, fileName, title;
  final List<String> allowedExtentions;
  const UpdateFile(
      {super.key,
      required this.appBarTitle,
      required this.collection,
      required this.docId,
      required this.fileName,
      required this.title, required this.allowedExtentions});

  @override
  State<UpdateFile> createState() => _UpdateFileState();
}

class _UpdateFileState extends State<UpdateFile> {
  TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<CrudProvider>(
            builder: (BuildContext context, CrudProvider value, Widget? child) {
              return GestureDetector(
                onTap: () {
                  if (titleController.text.isEmpty) {
                    Utils.toastMessage(message: 'Please enter title');
                  } else if (value.file == null) {
                    Utils.toastMessage(message: 'Please pick file');
                  } else {
                    value.updateFileAndData(
                        collectionPath: widget.collection,
                        title: titleController.text,
                        context: context,
                        docId: widget.docId);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: value.uploadLoading
                      ? const MulticolorProgressIndicator()
                      : const Icon(Icons.done),
                ),
              );
            },
          )
        ],
        title: Text(
          widget.appBarTitle,
          style: GoogleFonts.ubuntu(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableTextField(
              hintText: 'Title',
              controller: titleController,
              keyboardType: TextInputType.text,
              prefix: const Icon(Icons.title_rounded),
            ),
            const SizedBox(
              height: 00000,
            ),
            Consumer<CrudProvider>(
              builder:
                  (BuildContext context, CrudProvider value, Widget? child) {
                return Column(
                  children: [
                    value.file == null
                        ? const SizedBox()
                        : const SizedBox(
                            height: 15,
                          ),
                    value.file == null
                        ? const SizedBox()
                        : Text(
                            textAlign: TextAlign.center,
                            value.file!.path.split('/').last,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    ReusableButton(
                        title: 'Pick File',
                        onTap: () {
                          value.pickFile(allowedExtentions: widget.allowedExtentions);
                        },
                        loading: value.pickerLoading),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
