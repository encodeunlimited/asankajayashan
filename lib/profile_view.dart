import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ProfileViewScreen extends StatefulWidget {
  @override
  _ProfileViewScreenState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  Future<Map<String, dynamic>> _getUserDataFromDatabase() async {
    final String dbName = 'user.db';
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final String path = '${appDocumentDir.path}/$dbName';
    print('Database path: $path');

    final Database database = await openDatabase(path);

    final List<Map<String, dynamic>> results = await database.query('User');

    await database.close();

    return results.isNotEmpty ? results.first : {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile View'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              //logout functionality
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserDataFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileItem('ID', userData!['id']),
                _buildProfileItem('Email', userData['email']),
                _buildProfileItem('Name', userData['name']),
                _buildProfileItem('Date of Birth', userData['dob']),
                _buildProfileItem('Gender', userData['gender']),
                _buildProfileItem('Company', userData['company']),
                _buildProfileItem('Position', userData['position']),
              ],
            ),
          );
        },
      ),

    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120.0,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
