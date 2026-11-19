import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CounterPersistenceApp());
}

class CounterPersistenceApp extends StatelessWidget {
  const CounterPersistenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Счётчик нажатий',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  static const String _counterKey = 'button_press_count';

  int _counter = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final preferences = await SharedPreferences.getInstance();
    final savedCounter = preferences.getInt(_counterKey) ?? 0;

    if (!mounted) return;

    setState(() {
      _counter = savedCounter;
      _isLoading = false;
    });
  }

  Future<void> _incrementCounter() async {
    final newValue = _counter + 1;

    // Сразу обновляем интерфейс, не заставляя пользователя ждать запись на диск.
    setState(() {
      _counter = newValue;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_counterKey, newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Счётчик нажатий'),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Вы нажали на кнопку:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.add),
                    label: const Text('Нажать'),
                  ),
                ],
              ),
      ),
    );
  }
}
