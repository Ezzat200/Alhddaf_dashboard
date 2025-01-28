import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddAcademy extends StatefulWidget {
  @override
  _AddAcademyState createState() => _AddAcademyState();
}

class _AddAcademyState extends State<AddAcademy> {
  final TextEditingController _cityArabicController = TextEditingController();
  final TextEditingController _cityEnglishController = TextEditingController();
  final TextEditingController _locationArabicController = TextEditingController();
  final TextEditingController _locationEnglishController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _priceArabicController = TextEditingController();
  final TextEditingController _priceEnglishController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();

  String? _mainImageUrl;
  List<String> _imagesUrls = [];
  bool _isUploading = false;

  // Function to upload the main image using FilePicker
  Future<void> _uploadMainImage() async {
    try {
      // فتح مربع حوار لاختيار ملف صورة
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        // إذا تم اختيار صورة، احصل على الملف
        PlatformFile file = result.files.first;

        // رفع الصورة إلى Firebase Storage
        setState(() {
          _isUploading = true;
        });

        // تحديد مسار الصورة في Firebase Storage
        Reference storageRef = FirebaseStorage.instance.ref().child('academy_images').child(file.name);

        // رفع الملف إلى Firebase Storage
        UploadTask uploadTask = storageRef.putData(file.bytes!);

        // الانتظار حتى يتم رفع الصورة
        TaskSnapshot snapshot = await uploadTask;

        // الحصول على رابط الصورة
        String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _mainImageUrl = downloadUrl;
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully!')));
      } else {
        // إذا تم إلغاء اختيار الصورة
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    }
  }

  void _submitData() async {
    if (_cityArabicController.text.isEmpty ||
        _cityEnglishController.text.isEmpty ||
        _locationArabicController.text.isEmpty ||
        _locationEnglishController.text.isEmpty ||
        _nameArabicController.text.isEmpty ||
        _nameEnglishController.text.isEmpty ||
        _priceArabicController.text.isEmpty ||
        _priceEnglishController.text.isEmpty ||
        _mainImageUrl == null ||
        _uidController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and upload the main image')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('acadmy').add({
        'cityArabic': _cityArabicController.text,
        'cityEnglish': _cityEnglishController.text,
        'locationArabic': _locationArabicController.text,
        'locationEnglish': _locationEnglishController.text,
        'nameArabic': _nameArabicController.text,
        'nameEnglish': _nameEnglishController.text,
        'priceArabic': _priceArabicController.text,
        'priceEnglish': _priceEnglishController.text,
        'image': _mainImageUrl,
        'images': _imagesUrls,
        'uid': _uidController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Academy data added successfully!')),
      );

      // Clear form
      _cityArabicController.clear();
      _cityEnglishController.clear();
      _locationArabicController.clear();
      _locationEnglishController.clear();
      _nameArabicController.clear();
      _nameEnglishController.clear();
      _priceArabicController.clear();
      _priceEnglishController.clear();
      _uidController.clear();
      setState(() {
        _mainImageUrl = null;
        _imagesUrls = [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Academy Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _cityArabicController,
                decoration: InputDecoration(labelText: 'City (Arabic)'),
              ),
              TextField(
                controller: _cityEnglishController,
                decoration: InputDecoration(labelText: 'City (English)'),
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
                controller: _nameArabicController,
                decoration: InputDecoration(labelText: 'Name (Arabic)'),
              ),
              TextField(
                controller: _nameEnglishController,
                decoration: InputDecoration(labelText: 'Name (English)'),
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
                controller: _uidController,
                decoration: InputDecoration(labelText: 'UID'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadMainImage,
                child: Text(_mainImageUrl == null ? 'Upload Main Image' : 'Main Image Uploaded'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
