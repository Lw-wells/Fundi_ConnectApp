import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FundiProfileScreen extends StatefulWidget {
  const FundiProfileScreen({super.key});

  @override
  _FundiProfileScreenState createState() => _FundiProfileScreenState();
}

class _FundiProfileScreenState extends State<FundiProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _service = TextEditingController();
  final _location = TextEditingController();
  final _bio = TextEditingController();
  final _phone = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveProfile() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    print('Current user: $user');

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await supabase.from('fundis').insert({
        'user_id': user.id,
        'full_name': _fullName.text.trim(),
        'service': _service.text.trim(),
        'location': _location.text.trim(),
        'bio': _bio.text.trim(),
        'phone': _phone.text.trim(),
      }).execute();

      print('Response status: ${response.status}');
      print('Response data: ${response.data}');

      if (response.status == 201 || response.status == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile saved!')));

        _fullName.clear();
        _service.clear();
        _location.clear();
        _bio.clear();
        _phone.clear();

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile.')),
        );
      }
    } catch (error) {
      print('Exception: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _service.dispose();
    _location.dispose();
    _bio.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fundi Profile Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullName,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter full name' : null,
              ),
              TextFormField(
                controller: _service,
                decoration: const InputDecoration(
                  labelText: 'Service (e.g. Electrician)',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your service'
                    : null,
              ),
              TextFormField(
                controller: _location,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              TextFormField(
                controller: _bio,
                decoration: const InputDecoration(labelText: 'Short Bio'),
                maxLines: 2,
              ),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _saveProfile();
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
