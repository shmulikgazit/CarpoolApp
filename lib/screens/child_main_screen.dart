import 'package:flutter/material.dart';
import '../widgets/ride_card.dart';
import 'child_settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildMainScreen extends StatelessWidget {
  const ChildMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('שלום, דני!'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final lastChildId = prefs.getString('lastChildId');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChildSettingsScreen(childId: lastChildId),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'יום שלישי, 15 במאי',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                const Text(
                  'הסעות צהריים:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const RideCard(
                  time: '13:00',
                  driverName: 'אבא של רותי',
                  availableSeats: 2,
                  passengers: ['רותי', 'יעל'],
                ),
                const RideCard(
                  time: '14:00',
                  driverName: 'אמא של יוסי',
                  availableSeats: 1,
                  passengers: ['יוסי', 'אתה'],
                  isSelected: true,
                ),
                const RideCard(
                  time: '15:00',
                  driverName: 'שירות מונית',
                  availableSeats: 3,
                  passengers: ['מיכל'],
                  isTaxi: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Open dialog to change ride selection
                  },
                  child: const Text('שנה בחירת הסעה'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'הודעות:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('- אמא של דן ביטלה את ההסעה של 14:00. נא לבחור הסעה אחרת.'),
                const Text('- רמי מחפש הסעה ל-15:00.'),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'בית'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'לוח זמנים'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'הודעות'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'פרופיל'),
          ],
          currentIndex: 0,
          onTap: (index) {
            // Navigate to other screens
          },
        ),
      ),
    );
  }
}
