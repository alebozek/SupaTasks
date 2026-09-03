import 'package:flutter/material.dart';
import 'package:notes_app/themes/app_theme.dart';
import 'package:notes_app/widgets/theme-picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const SUPABASE_URL = String.fromEnvironment('SUPABASE_URL');
  const SUPABASE_KEY = String.fromEnvironment('SUPABASE_KEY');
  
  await Supabase.initialize(
    url: SUPABASE_URL,
    publishableKey: SUPABASE_KEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tasks',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: MyHomePage(
        title: 'My Tasks',
        selectedTheme: _themeMode,
        onThemeChanged: (themeMode) {
          setState(() {
            _themeMode = themeMode;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  final String title;
  final ThemeMode selectedTheme;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _notesStream = Supabase.instance.client.from('notes').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            ThemePicker(
              selectedTheme: widget.selectedTheme,
              onThemeChanged: widget.onThemeChanged,
            ),
            const SizedBox(width: 16),
            Center(
              child: Text(widget.title, style: const TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }else {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Dismissible(
                  key: ValueKey(note['id']),
                  direction: DismissDirection.endToStart,
                  background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.symmetric(horizontal: 20), child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (direction) async {
                    try {
                      await Supabase.instance.client.from('notes').delete().eq('id', note['id']);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(backgroundColor: Colors.green, content: Text('Task deleted successfully!')),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete task.')),
                      );
                    }
                  },
                  child: ListTile(
                    title: Text(note['body']),
                  ),
                );
              },
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final taskController = TextEditingController();

              Future<void> addTask(String value) async {
                final trimmedValue = value.trim();
                if (trimmedValue.isEmpty) {
                  return;
                }

                try {
                  await Supabase.instance.client.from('notes').insert({'body': trimmedValue});
                  if (!mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(backgroundColor: Colors.green, content: Text('Task added successfully!')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(backgroundColor: Colors.red, content: Text('Failed to add task.')),
                  );
                }
              }

              return SimpleDialog(
                title: const Text('Add Task'),
                contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                children: [
                  TextFormField(
                    controller: taskController,
                    autofocus: true,
                    minLines: 2,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onFieldSubmitted: (value) async {
                      await addTask(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'What do you want to get done?',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        await addTask(taskController.text);
                      },
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Add'),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
