import 'dart:convert';
import 'dart:io';
import 'package:colordetection/admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _profilePictureUrl;
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');

  if (token == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Authentication error. Please log in again.')));
    return;
  }

  final response = await http.get(
    Uri.parse('http://192.168.51.112:5000/protected'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      _nameController.text = data['name'];
      _emailController.text = data['email'];
      _profilePictureUrl = data['profile_picture']; // Ensure this is the correct URL
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data')));
  }
}


  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No image selected')));
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Authentication error. Please log in again.')));
      return;
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.51.112:5000/upload_profile'));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
        await http.MultipartFile.fromPath('profile_picture', _image!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture uploaded successfully')),
      );
      _loadUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                menu_admin()), // Replace with your actual HomePage widget
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile picture')),
      );
    }
  }

  Future<void> saveUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      return;
    }

    final name = _nameController.text;
    final email = _emailController.text;

    final response = await http.put(
      Uri.parse('http://192.168.51.112:5000/edit_profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  Future<void> changePassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');

  if (token == null) {
    return;
  }

  final oldPassword = _oldPasswordController.text;
  final newPassword = _newPasswordController.text;
  final confirmPassword = _confirmPasswordController.text;

  if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All fields are required')),
    );
    return;
  }

  if (newPassword.length < 8) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New password must be at least 8 characters long')),
    );
    return;
  }

  if (newPassword != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New passwords do not match')),
    );
    return;
  }

  final response = await http.post(
    Uri.parse('http://192.168.51.112:5000/change_password'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'current_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password changed successfully')),
    );
  } else {
    final error = json.decode(response.body)['error'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }
}


  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera);
            },
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery);
            },
            child: Text('Gallery'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _showImageSourceDialog();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.15,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : _profilePictureUrl != null
                              ? NetworkImage(_profilePictureUrl!)
                              : AssetImage('assets/default_profile.png')
                                  as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Save Profile Picture'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveUserProfile,
                child: Text('Save Profile'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _oldPasswordController,
                decoration: InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: changePassword,
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
