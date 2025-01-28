import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Addtrips extends StatefulWidget {
  @override
  _AddtripsState createState() => _AddtripsState();
}

class _AddtripsState extends State<Addtrips> {
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _locationArabicController = TextEditingController();
  final TextEditingController _locationEnglishController = TextEditingController();
  final TextEditingController _priceArabicController = TextEditingController();
  final TextEditingController _priceEnglishController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PlatformFile? _pickedFile;
  String? _imageUrl;
  bool _isUploading = false;

  // Function to pick an image
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _pickedFile = result.files.single;
        _isUploading = true;
      });

      try {
        // Upload image to Firebase Storage
        Reference ref = FirebaseStorage.instance.ref().child('trips_images/${_pickedFile!.name}');
        SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg'); // Or 'image/png'
        await ref.putData(_pickedFile!.bytes!, metadata);

        // Get download URL
        String downloadUrl = await ref.getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl;
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image uploaded successfully')));
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
      }
    }
  }

  void _submitData() async {
    if (_nameArabicController.text.isEmpty ||
        _nameEnglishController.text.isEmpty ||
        _locationArabicController.text.isEmpty ||
        _locationEnglishController.text.isEmpty ||
        _priceArabicController.text.isEmpty ||
        _priceEnglishController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields and upload an image')));
      return;
    }

    try {
      await _firestore.collection('experiences').add({
        'nameArabic': _nameArabicController.text,
        'nameEnglish': _nameEnglishController.text,
        'locationArabic': _locationArabicController.text,
        'locationEnglish': _locationEnglishController.text,
        'priceArabic': _priceArabicController.text,
        'priceEnglish': _priceEnglishController.text,
        'time': _timeController.text,
        'image': _imageUrl,
        'date': _dateController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Experience added successfully!')));

      // Clear form
      _nameArabicController.clear();
      _nameEnglishController.clear();
      _locationArabicController.clear();
      _locationEnglishController.clear();
      _priceArabicController.clear();
      _priceEnglishController.clear();
      _timeController.clear();
      _dateController.clear();
      _imageUrl = null;
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Experience')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameArabicController,
                decoration: InputDecoration(labelText: 'Name (Arabic)'),
              ),
              TextField(
                controller: _nameEnglishController,
                decoration: InputDecoration(labelText: 'Name (English)'),
              ),
              TextField(
                controller: _locationArabicController,
                decoration: InputDecoration(labelText: 'Location (Arabic)'),
              ),
              TextField(
                controller: _locationEnglishController,
                decoration: InputDecoration(labelText: 'Location (English)'),
              ),
              TextField(
                controller: _priceArabicController,
                decoration: InputDecoration(labelText: 'Price (Arabic)'),
              ),
              TextField(
                controller: _priceEnglishController,
                decoration: InputDecoration(labelText: 'Price (English)'),
              ),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _pickedFile == null && !_isUploading ? _pickImage : null,
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_imageUrl == null ? 'Pick an Image' : 'Image Selected'),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
