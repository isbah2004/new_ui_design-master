import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataProvider extends ChangeNotifier {
  List<Map<String, dynamic>> audioList = [];
  List<Map<String, dynamic>> docList = [];
  List<Map<String, dynamic>> videoList = [];
  List<Map<String, dynamic>> combinedList = [];

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch data from Firestore
      audioList = await fetchAudioData();
      docList = await fetchDocData();
      videoList = await fetchVideoData();
      
      // Combine and sort lists
      combineAndSortLists();
    } catch (e) {
      // Handle errors
      print("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> fetchAudioData() async {
    CollectionReference audioRef = FirebaseFirestore.instance.collection('audios');
    QuerySnapshot audioSnapshot = await audioRef.orderBy('timestamp', descending: true).get();
    return audioSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> fetchDocData() async {
    CollectionReference docRef = FirebaseFirestore.instance.collection('documents');
    QuerySnapshot docSnapshot = await docRef.orderBy('timestamp', descending: true).get();
    return docSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> fetchVideoData() async {
    CollectionReference videoRef = FirebaseFirestore.instance.collection('videos');
    QuerySnapshot videoSnapshot = await videoRef.orderBy('timestamp', descending: true).get();
    return videoSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  void combineAndSortLists() {
    combinedList = [...audioList, ...docList, ...videoList];
    combinedList.sort((a, b) {
      return b['timestamp'].compareTo(a['timestamp']); 
    });
  }
}
