import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ui_design/utils/utils.dart';

class CrudProvider extends ChangeNotifier {
  final FirebaseFirestore addDoc = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  bool _pickerLoading = false, _uploadLoading = false;
  bool get pickerLoading => _pickerLoading;
  bool get uploadLoading => _uploadLoading;

  String? _url, _publicId, _signature;
  String? get url => _url;
  String? get signature => _signature;
  String? get publicId => _publicId;
  File? _file;
  File? get file => _file;

  setPickerLoading(bool value) {
    _pickerLoading = value;
    notifyListeners();
  }

  setUploadLoading(bool value) {
    _uploadLoading = value;
    notifyListeners();
  }

  Future<void> pickFile({required List<String> allowedExtentions}) async {
    setPickerLoading(true);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtentions,
    );
    if (result != null) {
      _file = File(result.files.single.path!);
    } else {
      _file = null;
    }
    setPickerLoading(false); // Ensure to reset picker loading state
  }

  Future<void> uploadFile(
      {required String collectionPath,
      required String title,
      required BuildContext context}) async {
    if (_file == null) return;

    setUploadLoading(true);
    try {
      String fileName = 'uploads/${_file!.path.split('/').last}';
      Reference ref = storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(_file!);

      TaskSnapshot taskSnapshot = await uploadTask;
      _url = await taskSnapshot.ref.getDownloadURL();

      await addDoc.collection(collectionPath).add({
        'title': title,
        'url': _url,
        'fileName': _file!.path.split('/').last,
        'timestamp':DateTime.now().millisecondsSinceEpoch.toString(),
      });
      Navigator.pop(context);
      _file = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error uploading file: $e');
    } finally {
      setUploadLoading(false);
      _file = null;
    }
  }

  Future<void> uploadQoute(
      {required String collectionPath,
      required String title,
      required String quote,
      required BuildContext context}) async {
    if (_file == null) return;

    setUploadLoading(true);
    try {
      String fileName = 'uploads/${_file!.path.split('/').last}';
      Reference ref = storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(_file!);

      TaskSnapshot taskSnapshot = await uploadTask;
      _url = await taskSnapshot.ref.getDownloadURL();

      await addDoc.collection(collectionPath).add({
        'title': title,
        'quote':quote,
        'url': _url,
        'fileName': _file!.path.split('/').last,
        'timestamp':DateTime.now().millisecondsSinceEpoch.toString(),
      });
      Navigator.pop(context);
      _file = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error uploading file: $e');
    } finally {
      setUploadLoading(false);
      _file = null;
    }
  }

  Future<void> updateFileAndData(
      {required String docId,
      required String collectionPath,
      required String title,
      required BuildContext context}) async {
    if (_file == null) return;

    setUploadLoading(true);
    try {
      // First, delete the existing file if any
      DocumentSnapshot docSnapshot =
          await addDoc.collection(collectionPath).doc(docId).get();
      if (docSnapshot.exists) {
        String existingUrl = docSnapshot['url'];
        Reference existingRef = storage.refFromURL(existingUrl);
        await existingRef.delete();
      }

      // Now upload the new file
      String fileName = 'uploads/${_file!.path.split('/').last}';
      Reference ref = storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(_file!);

      TaskSnapshot taskSnapshot = await uploadTask;
      _url = await taskSnapshot.ref.getDownloadURL();

      await addDoc
          .collection(collectionPath)
          .doc(docId)
          .update({'title': title, 'url': _url,
           'fileName': _file!.path.split('/').last,
        'timestamp':DateTime.now().millisecondsSinceEpoch.toString(),
          }).then((value) {
        Navigator.pop(context);
      });

  
      notifyListeners();
    } catch (e) {
      Utils.toastMessage(message: e.toString());
    } finally {
      setUploadLoading(false);    _file = null;
    }
  }
  Future<void> updateFileAndQuote(
      {required String docId,
      required String collectionPath,
      required String title,
      required String quote,
      required BuildContext context}) async {
    if (_file == null) return;

    setUploadLoading(true);
    try {
      // First, delete the existing file if any
      DocumentSnapshot docSnapshot =
          await addDoc.collection(collectionPath).doc(docId).get();
      if (docSnapshot.exists) {
        String existingUrl = docSnapshot['url'];
        Reference existingRef = storage.refFromURL(existingUrl);
        await existingRef.delete();
      }

      // Now upload the new file
      String fileName = 'uploads/${_file!.path.split('/').last}';
      Reference ref = storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(_file!);

      TaskSnapshot taskSnapshot = await uploadTask;
      _url = await taskSnapshot.ref.getDownloadURL();

      await addDoc
          .collection(collectionPath)
          .doc(docId)
          .update({'title': title, 'url': _url,'quote':quote,
           'fileName': _file!.path.split('/').last,
        'timestamp':DateTime.now().millisecondsSinceEpoch.toString(),
          }).then((value) {
        Navigator.pop(context);
      });

  
      notifyListeners();
    } catch (e) {
      Utils.toastMessage(message: e.toString());
    } finally {
      setUploadLoading(false);    _file = null;
    }
  }

  Future<void> deleteFileAndData(
      {required String docId,
      required String collection,
      required String url}) async {
    setUploadLoading(true);
    try {
      await storage.refFromURL(url).delete();

      await addDoc.collection(collection).doc(docId).delete();

      notifyListeners();
    } catch (e) {
      Utils.toastMessage(message: e.toString());
    } finally {
      setUploadLoading(false);
    }
  }
}
