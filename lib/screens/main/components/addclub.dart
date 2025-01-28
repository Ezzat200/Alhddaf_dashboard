import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:haddaf_ashboard/screens/dashboard/components/my_clubs.dart';
import 'package:haddaf_ashboard/screens/main/components/club.dart';


class AddClubScreen extends StatefulWidget {
  @override
  _AddClubScreenState createState() => _AddClubScreenState();
}

class _AddClubScreenState extends State<AddClubScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  String? _selectedCollection = 'clup';
  String? _imageUrl;
  bool _isUploading = false;
  PlatformFile? _pickedFile;

  // Function to pick an image file
  Future<void> _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _pickedFile = result.files.single;
        _isUploading = true;
      });

      try {
        // رفع الصورة إلى Firebase Storage
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('clubs_images/${_pickedFile!.name}');
        SettableMetadata metadata =
            SettableMetadata(contentType: 'image/jpeg');
        await ref.putData(_pickedFile!.bytes!, metadata);

        // الحصول على الرابط المباشر للصورة
        String downloadUrl = await ref.getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl;
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully')));
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: $e')));
      }
    }
  }

  // Function to send data to Firestore
  Future<void> _sendDataToFirestore() async {
    if (_titleController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _textController.text.isEmpty ||
        _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all fields and upload an image')));
      return;
    }

    try {
      // القيم التي سيتم إرسالها
      final String location = _locationController.text;
      final String price = _priceController.text;
      final String text = _textController.text;
      final String uid = DateTime.now().toIso8601String(); // معرف فريد

      // إرسال البيانات إلى الكولكشن
      await FirebaseFirestore.instance.collection('clup').add({
        'img': _imageUrl,
        'location': location,
        'price': price,
        'text': text,
        'uid': uid,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'status': 'active',
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data added successfully')));

      // الانتقال إلى صفحة عرض النوادي
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyClubs()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Club Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField for Title
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),

              // TextField for Location
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 16),

              // TextField for Price
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // TextField for Text
              TextField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Text'),
              ),
              const SizedBox(height: 16),

              // Button to pick an image
              ElevatedButton(
                onPressed: _pickedFile == null && !_isUploading ? _pickImage : null,
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_imageUrl == null ? 'Pick an Image' : 'Image Selected'),
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _sendDataToFirestore,
                child: const Text('Add Club'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
