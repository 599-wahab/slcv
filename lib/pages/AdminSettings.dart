import 'package:flutter/material.dart';

class AdminSettings extends StatelessWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        backgroundColor: Colors.blue[500],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildCard(
              title: 'Change Password',
              child: const ChangePasswordForm(),
            ),
            buildCard(
              title: 'Notification Settings',
              child: NotificationSettings(),
            ),
            buildCard(
              title: 'Theme',
              child: ThemeSettings(),
            ),
            buildCard(
              title: 'Admin Access',
              child: AdminAccessList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 4,
        shadowColor: Colors.blue.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Current Password'),
          obscureText: true,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'New Password'),
          obscureText: true,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Retype New Password'),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Implement password change logic here
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

class NotificationSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Mute Notification'),
          value: true, // Example value, replace with actual state
          onChanged: (bool value) {
            // Implement mute notification logic here
          },
        ),
        SwitchListTile(
          title: const Text('Unauthorized Alert'),
          value: true, // Example value, replace with actual state
          onChanged: (bool value) {
            // Implement unauthorized alert logic here
          },
        ),
        SwitchListTile(
          title: const Text('Searched Person Alert'),
          value: true, // Example value, replace with actual state
          onChanged: (bool value) {
            // Implement searched person alert logic here
          },
        ),
      ],
    );
  }
}

class ThemeSettings extends StatefulWidget {
  @override
  _ThemeSettingsState createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return selectedIndex == 0
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.5);
                    },
                  ),
                ),
                child: const Text('Dark Mode'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return selectedIndex == 1
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.5);
                    },
                  ),
                ),
                child: const Text('Light Mode'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return selectedIndex == 2
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.5);
                    },
                  ),
                ),
                child: const Text('Auto Mode'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AdminAccessList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example list of admins, replace with actual data
    final List<String> admins = ['Admin 1', 'Admin 2', 'Admin 3'];

    return Column(
      children: [
        for (final admin in admins)
          ListTile(
            title: Text(admin),
            // Add admin access logic here
          ),
      ],
    );
  }
}
