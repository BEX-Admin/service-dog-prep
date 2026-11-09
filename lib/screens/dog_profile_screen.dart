import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class DogProfileScreen extends StatelessWidget {
  const DogProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dog = context.watch<AppState>().currentDog;
    if (dog == null) {
      return const Scaffold(body: Center(child: Text('No dog selected')));
    }
    return Scaffold(
      appBar: AppBar(title: Text(dog.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(title: const Text('Breed'), subtitle: Text(dog.breed)),
          ListTile(title: const Text('Age'), subtitle: Text('${dog.age} years')),
          ListTile(title: const Text('Size'), subtitle: Text(dog.size)),
          ListTile(title: const Text('Temperament'), subtitle: Text(dog.temperament)),
          ListTile(title: const Text('Fears'), subtitle: Text(dog.fears)),
          ListTile(title: const Text('Goals'), subtitle: Text(dog.goals.join(', '))),
          ListTile(title: const Text('Family'), subtitle: Text(dog.familyName)),
          ListTile(title: const Text('Contact'), subtitle: Text(dog.contact)),
          ListTile(title: const Text('Habits'), subtitle: Text(dog.habits)),
          ListTile(title: const Text('Health'), subtitle: Text(dog.healthNotes)),
        ],
      ),
    );
  }
}
