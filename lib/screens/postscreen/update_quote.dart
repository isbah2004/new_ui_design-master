
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ui_design/provider/crud_provider.dart';
import 'package:ui_design/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:ui_design/reusablewidgets/reusable_button.dart';
import 'package:ui_design/reusablewidgets/reusable_text_field.dart';
import 'package:ui_design/utils/utils.dart';

class UpdateQuote extends StatefulWidget {
  final String appBartitle, collection,docId;
  final List<String> allowedExtentions;
  const UpdateQuote(
      {super.key,
      required this.appBartitle,
      required this.collection,
  required this.allowedExtentions, required this.docId});

  @override
  State<UpdateQuote> createState() => _UpdateQuoteState();
}

class _UpdateQuoteState extends State<UpdateQuote> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController quoteController = TextEditingController();
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
                    value.updateFileAndQuote(
                        collectionPath: widget.collection,
                        title: titleController.text,
                        context: context, quote: quoteController.text, docId: '');
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
          widget.appBartitle,
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
              height: 15,
            ),
            ReusableTextField(maxLines: null,
              hintText: 'Quote',
              controller: quoteController,
              keyboardType: TextInputType.text,
              prefix: const Icon(Icons.message_outlined),
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