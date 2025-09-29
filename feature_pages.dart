import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart'; // CLOUD_FUNCTION_URL

Widget _genericPage(String title, Widget body) {
  return Scaffold(appBar: AppBar(title: Text(title)), body: body);
}

class PersonalizedLearningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return _genericPage('Personalized Learning Paths', StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        var data = snapshot.data!.data() as Map<String,dynamic>?;
        var paths = data?['learningPaths'] ?? [];
        return ListView.builder(
          itemCount: paths.length,
          itemBuilder: (_, i) => ListTile(title: Text(paths[i].toString())),
        );
      },
    ));
  }
})

class GamificationPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('Gamification', Center(child: Text('Gamification content'))); }
class InteractiveContentPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('Interactive Content', Center(child: Text('Interactive content'))); }
class ProgressTrackingPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('Progress Tracking', Center(child: Text('Progress Tracking'))); }
class CommunityForumPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('Community Forum', Center(child: Text('Community Forum'))); }
class AIMentorPage extends StatefulWidget { @override _AIMentorPageState createState() => _AIMentorPageState(); }
class _AIMentorPageState extends State<AIMentorPage> {
  final promptController = TextEditingController();
  String responseText = '';
  Future<void> sendPrompt() async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final res = await http.post(Uri.parse(CLOUD_FUNCTION_URL),
        headers: {'Authorization': 'Bearer $idToken','Content-Type':'application/json'},
        body: jsonEncode({'prompt': promptController.text,'provider':'openai'}));
    if (res.statusCode == 200) {
      setState(() { responseText = jsonDecode(res.body)['response']; });
    } else { setState(() { responseText = 'Error contacting mentor'; }); }
  }
  @override Widget build(BuildContext context) => _genericPage('AI Mentor',
    Padding(
      padding: EdgeInsets.all(12),
      child: Column(children:[
        TextField(controller: promptController, decoration: InputDecoration(labelText:'Enter your question')),
        SizedBox(height:12),
        ElevatedButton(onPressed: sendPrompt, child: Text('Ask Mentor')),
        SizedBox(height:20),
        Expanded(child: SingleChildScrollView(child: Text(responseText)))
      ])
    )
  );
}
class SkillMatchPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('Skill-based Matchmaking', Center(child: Text('Skill Match content'))); }
class RealProjectsPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('Real-world Projects', Center(child: Text('Real-world projects'))); }
class CertificationPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('Certification & Badging', Center(child: Text('Badges'))); }
class CareerResourcesPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('Career Resources', Center(child: Text('Career Resources'))); }
class CoachingPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('One-on-One Coaching', Center(child: Text('Coaching content'))); }
class CustomPlanPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('Customized Learning Plans', Center(child: Text('Custom Plans'))); }
class ExclusiveContentPage extends StatelessWidget { @override Widget build(BuildContext context) => _genericPage('Exclusive Content', Center(child: Text('Exclusive Content'))); }
