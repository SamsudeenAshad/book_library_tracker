import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;

  EditBookScreen({required this.book});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final BookService _bookService = BookService();

  // Text editing controllers
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _detailsController;

  // Focus nodes for form fields
  final _titleFocus = FocusNode();
  final _authorFocus = FocusNode();
  final _detailsFocus = FocusNode();

  bool _processingEditBook = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _detailsController = TextEditingController(text: widget.book.details);
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _titleController.dispose();
    _authorController.dispose();
    _detailsController.dispose();

    // Clean up focus nodes
    _titleFocus.dispose();
    _authorFocus.dispose();
    _detailsFocus.dispose();

    super.dispose();
  }

  // Method to move focus to the next field
  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _editBook() {
    // Validate form
    if (_formKey.currentState!.validate()) {
      setState(() {
        _processingEditBook = true;
      });

      final String title = _titleController.text.trim();
      final String author = _authorController.text.trim();
      final String details = _detailsController.text.trim();

      // Create updated book
      final updatedBook = Book(
        title: title,
        author: author,
        details: details,
      );

      // Update book in service
      _bookService.updateBook(widget.book, updatedBook);

      setState(() {
        _processingEditBook = false;
      });

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Return to book list screen with refresh flag
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        title: const Text(
          'Edit Book',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Book title field
                TextFormField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  decoration: const InputDecoration(
                    labelText: 'Book Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.book),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the book title';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    _fieldFocusChange(context, _titleFocus, _authorFocus);
                  },
                ),

                const SizedBox(height: 16),

                // Author field
                TextFormField(
                  controller: _authorController,
                  focusNode: _authorFocus,
                  decoration: const InputDecoration(
                    labelText: 'Author Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the author name';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    _fieldFocusChange(context, _authorFocus, _detailsFocus);
                  },
                ),

                const SizedBox(height: 16),

                // Book details field
                TextFormField(
                  controller: _detailsController,
                  focusNode: _detailsFocus,
                  decoration: const InputDecoration(
                    labelText: 'Book Details',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Genre, publication year, synopsis, etc.',
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter some details about the book';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Submit button
                ElevatedButton(
                  onPressed: _processingEditBook ? null : _editBook,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: _processingEditBook
                      ? const CircularProgressIndicator()
                      : const Text('Update Book'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
