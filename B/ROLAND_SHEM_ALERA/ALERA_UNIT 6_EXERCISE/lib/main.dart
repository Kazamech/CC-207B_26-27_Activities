import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const String myName = 'Roland Shem Alera';
const String myTagline = '3rd-year BSIT student';
const String myBiography =
    "My nickname is Pepsi and I'm from Sipalay City, Negros Occidental. "
    "I'm currently studying Bachelor of Science in Information Technology. "
    "My hobbies are basketball, badminton, and fixing things that I can't fix. "
    "My goal is to be a millionaire while being lazy.";

const String myPhotoPath = 'assets/images/me.jpg';
const String petPhotoPath = 'assets/images/pet.jpg';
const String petSoundPath = 'sounds/bark.mp3';

const String petName = 'Sky';
const String petAction = 'barked';

const List<String> hobbies = [
  'Basketball',
  'Badminton',
  'Fixing things',
  'Coding',
  'Sleeping',
];

class ClassSlot {
  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });

  final String day;
  final String time;
  final String subject;
}

const List<ClassSlot> schedule = [
 ClassSlot(day: 'Mon', time: '9:00 AM-12:00 PM', subject: 'CIT 246 IT Project Management'),
  ClassSlot(day: 'Mon', time: '1:00-3:00 PM', subject: 'CIT 212 Networking 2'),
  ClassSlot(day: 'Mon', time: '3:00-6:00 PM', subject: 'CC 207B Applications Development'),
  ClassSlot(day: 'Tue', time: '7:00-9:00 AM', subject: 'CIT 210 Web Systems and Technologies'),
  ClassSlot(day: 'Tue', time: '11:30 AM-1:00 PM', subject: 'BA 234 Technopreneurship'),
  ClassSlot(day: 'Tue', time: '1:00-2:30 PM', subject: 'CC 208 Methods of Research'),
  ClassSlot(day: 'Tue', time: '3:00-6:00 PM', subject: 'CIT 213 Human Computer Interaction 2'),
  ClassSlot(day: 'Wed', time: '10:00 AM-12:00 PM', subject: 'CIT 246 IT Project Management'),
  ClassSlot(day: 'Wed', time: '1:00-4:00 PM', subject: 'CIT 212 Networking 2'),
  ClassSlot(day: 'Wed', time: '4:00-6:00 PM', subject: 'CC 207B Applications Development'),
  ClassSlot(day: 'Thu', time: '7:00-10:00 AM', subject: 'CIT 210 Web Systems and Technologies'),
  ClassSlot(day: 'Thu', time: '11:30 AM-1:00 PM', subject: 'BA 234 Technopreneurship'),
  ClassSlot(day: 'Thu', time: '1:00-2:30 PM', subject: 'CC 208 Methods of Research'),
  ClassSlot(day: 'Thu', time: '4:00-6:00 PM', subject: 'CIT 213 Human Computer Interaction 2'),
];

class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'My Friends in Iloilo'),
  Photo(asset: 'assets/images/gallery/photo2.jpg', caption: 'My Future Teacher GF'),
  Photo(asset: 'assets/images/gallery/photo3.jpg', caption: 'Once a young kid'),
  Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'My Friends in Sipalay'),
  Photo(asset: 'assets/images/gallery/photo5.jpg', caption: 'Me'),
  Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'Us Together'),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 6 Exercise',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          ProfileScreen(),
          PetScreen(),
          GalleryScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int newIndex) {
          setState(() {
            selectedIndex = newIndex;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'My Pet'),
          NavigationDestination(icon: Icon(Icons.photo_library), label: 'Gallery'),
        ],
      ),
    );
  }
}

class ProfileInfo {
  const ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(info.icon, color: theme.colorScheme.primary),
      title: Text(info.label, style: theme.textTheme.labelLarge),
      subtitle: Text(info.value, style: theme.textTheme.bodyMedium),
    );
  }
}

class TableCellText extends StatelessWidget {
  const TableCellText(this.text, {super.key, this.bold = false});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: bold ? style?.copyWith(fontWeight: FontWeight.bold) : style,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<ProfileInfo> infos = [
      const ProfileInfo(icon: Icons.badge, label: 'Nickname', value: 'Pepsi'),
      const ProfileInfo(icon: Icons.cake, label: 'Birthday', value: 'December 27, 2004'),
      const ProfileInfo(icon: Icons.home, label: 'Address', value: 'Sipalay City, Negros Occidental'),
      const ProfileInfo(icon: Icons.school, label: 'School', value: 'West Visayas State University'),
      const ProfileInfo(icon: Icons.computer, label: 'Course', value: 'BS Information Technology'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(myName),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    myPhotoPath,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of $myName',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(myName, style: theme.textTheme.headlineSmall),
                      Text(myTagline, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  for (final info in infos) InfoTile(info: info),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Hobbies', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in hobbies) Chip(label: Text(hobby)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(myBiography, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Class Schedule', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(color: theme.colorScheme.outline),
                      columnWidths: const {
                        0: FixedColumnWidth(56),
                        1: FixedColumnWidth(150),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: const [
                            TableCellText('Day', bold: true),
                            TableCellText('Time', bold: true),
                            TableCellText('Subject', bold: true),
                          ],
                        ),
                        for (final slot in schedule)
                          TableRow(
                            children: [
                              TableCellText(slot.day),
                              TableCellText(slot.time),
                              TableCellText(slot.subject),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  bool isPlaying = false;
  bool isLiked = false;
  int playCount = 0;

  late final AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> playSound() async {
    setState(() {
      isPlaying = true;
      playCount = playCount + 1;
    });

    try {
      await player.play(AssetSource(petSoundPath));
    } catch (error) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future<void> resetCount() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset the count?'),
          content: Text(
            '$petName has $petAction $playCount times. Start again from zero?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (answer == true) {
      setState(() {
        playCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  isLiked = !isLiked;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          petPhotoPath,
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of $petName, my pet',
                        ),
                      ),
                    ),
                  ),
                  if (isLiked)
                    Icon(
                      Icons.favorite,
                      size: 96,
                      color: theme.colorScheme.error,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Double-tap the photo to give $petName a heart',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: isPlaying ? null : playSound,
              icon: Icon(isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(isPlaying ? 'Playing...' : 'Play sound'),
            ),
            const SizedBox(height: 16),
            Text(
              '$petName has $petAction $playCount times.',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: playCount == 0 ? null : resetCount,
              child: const Text('Reset count'),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );

    if (makeFavorite == true) {
      setState(() {
        favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        photo.asset,
                        fit: BoxFit.cover,
                        semanticLabel: photo.caption,
                      ),
                    ),
                  ),
                  if (favoriteAsset == photo.asset)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: const Icon(
                        Icons.star,
                        size: 32,
                        color: Colors.amber,
                        shadows:  [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      photo.asset,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.star),
                    label: const Text('Make favorite'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}