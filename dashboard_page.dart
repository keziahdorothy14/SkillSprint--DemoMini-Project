import 'package:flutter/material.dart';
import 'feature_pages.dart';

class DashboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {'title': 'Personalized Learning Paths', 'widget': PersonalizedLearningPage()},
    {'title': 'Gamification', 'widget': GamificationPage()},
    {'title': 'Interactive Content', 'widget': InteractiveContentPage()},
    {'title': 'Progress Tracking', 'widget': ProgressTrackingPage()},
    {'title': 'Community Forum', 'widget': CommunityForumPage()},
    {'title': 'AI Mentor', 'widget': AIMentorPage()},
    {'title': 'Skill-based Matchmaking', 'widget': SkillMatchPage()},
    {'title': 'Real-world Projects', 'widget': RealProjectsPage()},
    {'title': 'Certification & Badging', 'widget': CertificationPage()},
    {'title': 'Career Resources', 'widget': CareerResourcesPage()},
    {'title': 'One-on-One Coaching', 'widget': CoachingPage()},
    {'title': 'Customized Learning Plans', 'widget': CustomPlanPage()},
    {'title': 'Exclusive Content', 'widget': ExclusiveContentPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search features...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: features.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(features[index]['title']),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => features[index]['widget']));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
