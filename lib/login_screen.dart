import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final String apiUrl = 'http://123.231.9.43:3999';

    final response = await http.post(Uri.parse('$apiUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}));

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['res_code'] == 0) {
      // Login successful
      final userData = jsonResponse['user_data'];

     if (jsonResponse != null && jsonResponse['res_code'] == 0) {
      // Login successful
      final userData = jsonResponse['user_data'];

      // Save user data in SQLite database
      await _saveUserDataInDatabase(userData);

      Navigator.pushReplacementNamed(context, '/home');
      return;
    }
    } else {
      // Login failed
      setState(() {
        _errorMessage = jsonResponse['res_desc'];
      });

      showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Login Error'),
        content: Text(_errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
    }
  }

  Future<void> _saveUserDataInDatabase(Map<String, dynamic> userData) async {
    final String dbName = 'user.db';
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final String path = '${appDocumentDir.path}/$dbName';
    print('Database path: $path');

    // Delete any existing database
    await deleteDatabase(path);

    // Create the database
    final Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE User (
          id TEXT PRIMARY KEY,
          email TEXT,
          name TEXT,
          dob TEXT,
          gender TEXT,
          company TEXT,
          position TEXT
        )
      ''');
    });

    // Insert user data into the database
    await database.insert('User', userData);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),

          ],
        ),
      ),
    );
  }
}