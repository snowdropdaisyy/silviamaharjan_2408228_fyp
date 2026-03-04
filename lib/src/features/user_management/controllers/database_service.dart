import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

Map<String, String> dynamicFeelingIcons = {};

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Save onboarding data inside a nested map
  Future<void> saveOnboardingData(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'onboarding': data,
      'onboardingComplete': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Fetch full user data (including onboarding metadata)
  Future<Map<String, dynamic>?> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  /// Toggles a feeling in the daily_logs sub-collection using _firestore.
  Future<void> toggleFeelingLog(String feelingLabel, String dateKey) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('daily_logs')
        .doc(dateKey);

    final doc = await docRef.get();
    List<String> currentLogs = [];

    if (doc.exists && doc.data() != null) {
      currentLogs = List<String>.from(doc.data()!['feelings'] ?? []);
    }

    // TOGGLE LOGIC:
    if (currentLogs.contains(feelingLabel)) {
      currentLogs.remove(feelingLabel);
    } else {
      currentLogs.add(feelingLabel);
    }

    // Update Firestore with the NEW list
    await docRef.set({
      'feelings': currentLogs,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<List<String>> getFeelingsForDate(String dateKey) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      // This looks for the daily_logs sub-collection under the specific user
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('daily_logs') // This will be created once you log a mood
          .doc(dateKey)
          .get();

      if (doc.exists && doc.data() != null) {
        return List<String>.from(doc.data()!['feelings'] ?? []);
      }
    } catch (e) {
      debugPrint("Error fetching logs: $e");
    }
    return [];
  }

  /// Fetches the list of logged feelings for a specific date.
  Future<List<String>> getDailyLogs(String dateKey) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('daily_logs')
        .doc(dateKey)
        .get();

    if (doc.exists && doc.data() != null) {
      return List<String>.from(doc.data()!['feelings'] ?? []);
    }
    return [];
  }
}