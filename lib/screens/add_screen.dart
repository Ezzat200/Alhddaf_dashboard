import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:haddaf_ashboard/screens/dashboard/dashboard_screen.dart';
import 'package:file_picker/file_picker.dart';

class AddAdScreen extends StatefulWidget {
  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  final TextEditingController _titleController = TextEditingController();
  String? _selectedCollection;
  String? _imageUrl;
  bool _isUploading = false;
  PlatformFile? _pickedFile;

  final List<String> _collections = [
    'academyAds',
    'testReservationBannerAds',
    'testReservationSliderAds',
    'playerMarketAds',
    'coachBannerAds',
    'coachSliderAds',
    'clubAds',
    'tripAds',
    'homeFirstSlider',
    'homeSecondSlider',
    'homeThirdSlider',
    'playerMarketAdsBanner',
  ];

  // Function to pick an image file
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _pickedFile = result.files.single;
        _isUploading = true;
      });

      try {
        // رفع الصورة إلى Firebase Storage مع تحديد نوع المحتوى
        Reference ref = FirebaseStorage.instance.ref().child('ads_images/${_pickedFile!.name}');
        SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg'); // أو 'image/png' حسب نوع الصورة
        await ref.putData(_pickedFile!.bytes!, metadata);

        // الحصول على الرابط المباشر للصورة
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

  // Function to send data to selected collection
  Future<void> _sendDataToFirestore() async {
    if (_selectedCollection == null || _titleController.text.isEmpty || _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields and upload an image')));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection(_selectedCollection!).add({
        'title': _titleController.text,
        'imageUrl': _imageUrl,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'status': 'active',
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data added to $_selectedCollection')));

      // Navigate to Dashboard screen after successful data submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Advertisement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown to select collection
            DropdownButton<String>(
              hint: const Text('Select Collection'),
              value: _selectedCollection,
              onChanged: (newValue) {
                setState(() {
                  _selectedCollection = newValue;
                });
              },
              items: _collections.map((String collection) {
                return DropdownMenuItem<String>(
                  value: collection,
                  child: Text(collection),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // TextField for Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
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
              child: const Text('Add Advertisement'),
            ),
          ],
        ),
      ),
    );
  }
}
