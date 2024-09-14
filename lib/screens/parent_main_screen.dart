import 'package:flutter/material.dart';
import 'parent_settings_screen.dart';
import '../widgets/ride_card.dart';

class ParentMainScreen extends StatelessWidget {
  const ParentMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('שלום, הורה!'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ParentSettingsScreen()),
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
                  'הסעות קרובות:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const RideCard(
                  time: '14:00',
                  driverName: 'אתה',
                  availableSeats: 3,
                  passengers: ['יוסי', 'רותי', 'מיכל'],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Implement ride management logic
                  },
                  child: const Text('נהל הסעות'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'הודעות:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('- דן זקוק להסעה ב-15:00 היום.'),
                const Text('- יש שינוי בלוח הזמנים של בית הספר ביום חמישי.'),
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
            // Implement navigation logic
          },
        ),
      ),
    );
  }
}
