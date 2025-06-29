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
      });
      return;
    }

    final response = await Supabase.instance.client
        .from('fundis')
        .select('full_name')
        .eq('user_id', user.id)
        .maybeSingle(); // fetch only one row

    setState(() {
      if (response != null && response['full_name'] != null) {
        fullName = response['full_name'];
      } else {
        fullName = 'Profile not found';
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
      appBar: AppBar(
        title: const Text('FundiConnect Home'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Welcome,', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text(
                    fullName ?? 'No name available',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
