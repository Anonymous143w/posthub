import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posthub/Screen/add_post_text.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final List<Widget> _mediaList = [];
  File? _file;
  int indexx = 0;

  Future<void> _fetchNewMedia() async {
    final imagePicker = ImagePicker();
    final XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
        _mediaList.add(
          Container(
            child: Image.file(
              _file!,
              fit: BoxFit.cover,
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'New Post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddPostTextScreen(_file!),
                  ));
                },
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 375.h,
                child: _mediaList.isNotEmpty
                    ? _mediaList[0]
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              Container(
                width: double.infinity,
                height: 40.h,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(width: 10.w),
                    Text(
                      'Recent',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        indexx = index;
                        _file = null; // You may want to clear the selected file
                      });
                      _fetchNewMedia(); // Call to open image picker
                    },
                    child: _mediaList[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
