
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ui_design/provider/crud_provider.dart';
import 'package:ui_design/screens/postscreen/update_file.dart';
import 'package:ui_design/theme/theme.dart';
 
 void updateDeleteDialog(
      {required String title,
      required String appBarTitle,
      required String collection,required List<String> allowedExtensions,
      required String docId,
      required String fileName,
      required String url,
      required BuildContext context}) {
    final crudProvider = Provider.of<CrudProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Manage Document',
            style: GoogleFonts.ubuntu(),
          ),
          content: Text(
            'Would you like to update or delete this document?',
            style: GoogleFonts.ubuntu(),
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateFile(
                                appBarTitle: appBarTitle,
                                collection: collection,allowedExtentions: allowedExtensions,
                                docId: docId,
                                fileName: fileName,
                                title: title)));
                
                  },
                  child: Container(padding:EdgeInsets.symmetric(horizontal:10,vertical:10),
                    decoration: BoxDecoration(
                        color: AppTheme.greenColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Update',
                      style: GoogleFonts.ubuntu(
                          color: AppTheme.whiteColor), // Customize color
                    ),
                  ),
                ),
                     GestureDetector(
              onTap: () {
                crudProvider.deleteFileAndData(
                    docId: docId, collection: collection, url: url);
                Navigator.of(context).pop(); // Close the dialog
              },
               child: Container(padding:EdgeInsets.symmetric(horizontal:10,vertical:10),
                decoration: BoxDecoration(
                    color: AppTheme.redColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Delete',
                  style: GoogleFonts.ubuntu(
                      color: AppTheme.whiteColor), // Customize color
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog without action
              },
            child: Container(padding:EdgeInsets.symmetric(horizontal:10,vertical:10),
                decoration: BoxDecoration(
                    color: AppTheme.blueColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.ubuntu(
                      color: AppTheme.whiteColor), // Customize color
                ),
              ),
            ),
       ],
            ),
        ],
        );
      },
    );
  }
