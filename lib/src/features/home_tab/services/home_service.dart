import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
// Replace 'your_project_name' with your actual package name from pubspec.yaml
import 'package:silviamaharjan_2408228_fyp/src/features/home_tab/models/phase_model.dart';

class HomeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<PhaseContent?> getPhaseData(String phaseId) async {
    try {
      final doc = await _db
          .collection('home_tab')
          .doc(phaseId)
          .collection('content')
          .doc('card')
          .get();

      if (doc.exists && doc.data() != null) {
        return PhaseContent.fromFirestore(doc.data()!);
      }
    } catch (e) {
      debugPrint("Error fetching phase data: $e");
    }
    return null;
  }
}