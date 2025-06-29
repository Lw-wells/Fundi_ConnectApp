import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fullName;
  bool isLoading = true;
  bool hasProfile = false;

  @override
  void initState() {
    super.initState();
    fetchFundiName();
  }

  Future<void> fetchFundiName() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      setState(() {
        fullName = 'Not logged in';
        isLoading = false;
        hasProfile = false;
      });
      return;
    }

    final response = await Supabase.instance.client
        .from('fundis')
        .select('full_name')
        .eq('user_id', user.id)
        .maybeSingle();

    setState(() {
      if (response != null && response['full_name'] != null) {
        fullName = response['full_name'];
        hasProfile = true;
      } else {
        fullName = null;
        hasProfile = false;
      }
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('FundiConnect'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : hasProfile
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome back!',
                    style: TextStyle(fontSize: 22, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    fullName!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 60,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Profile not found',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please complete your fundi profile.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    label: const Text('Complete Profile'),
                  ),
                ],
              ),
      ),
    );
  }
}
