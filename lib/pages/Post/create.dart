import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      // Process the data (e.g., send it to a server or save it locally)
      String title = _titleController.text;
      String description = _descriptionController.text;
      String content = _contentController.text;
      print('Title: $title');
      print('Description: $description');
      print('Content: $content');

      // Clear the form
      _titleController.clear();
      _descriptionController.clear();
      _contentController.clear();

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Create Blog Post',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    filled: false,
                    fillColor: Colors.black12,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    filled: false,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                    filled: false,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                  maxLines: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the content';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitPost,
                    child: Text('Submit Post'),
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.lightBlueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
