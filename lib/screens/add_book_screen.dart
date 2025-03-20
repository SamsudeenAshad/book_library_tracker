import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final BookService _bookService = BookService();

  // Text editing controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _detailsController = TextEditingController();
  final _publishYearController = TextEditingController();
  final _categoryController = TextEditingController();

  // Focus nodes for form fields
  final _titleFocus = FocusNode();
  final _authorFocus = FocusNode();

  final _detailsFocus = FocusNode();
  final _publishYearFocus = FocusNode();
  final _categoryFocus = FocusNode();

  bool _processingAddBook = false;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _titleController.dispose();
    _authorController.dispose();
    _detailsController.dispose();
    _publishYearController.dispose();
    _categoryController.dispose();

    // Clean up focus nodes
    _titleFocus.dispose();
    _authorFocus.dispose();
    _detailsFocus.dispose();
    _publishYearFocus.dispose();
    _categoryFocus.dispose();

    super.dispose();
  }

  // Method to move focus to the next field
  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _addBook() {
    // Validate form
    if (_formKey.currentState!.validate()) {
      setState(() {
        _processingAddBook = true;
      });

      final String title = _titleController.text.trim();
      final String author = _authorController.text.trim();
      final String details = _detailsController.text.trim();
      final int? publishYear = int.tryParse(_publishYearController.text.trim());
      final String category = _categoryController.text.trim();

      // Create new book
      final newBook = Book(
        title: title,
        author: author,
        details: details,
        publishYear: publishYear,
        category: category.isNotEmpty ? category : null,
      );

      // Add book to service
      _bookService.addBook(newBook);

      setState(() {
        _processingAddBook = false;
      });

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Return to book list screen with refresh flag
      Navigator.pop(context, true);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        title: const Text(
          'Add New Book',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Book title field
TextFormField(
                controller: _titleController,
                focusNode: _titleFocus,
                decoration: InputDecoration(
                  labelText: 'Book Title',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.book, color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400]!),
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Author Name',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person, color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400]!),
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Book Details',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.description, color: Colors.blueGrey),
                  hintText: 'Genre, publication year, synopsis, etc.',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400]!),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some details about the book';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Publish year field
TextFormField(
                controller: _publishYearController,
                focusNode: _publishYearFocus,
                decoration: InputDecoration(
                  labelText: 'Publish Year',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400]!),
                  ),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final year = int.tryParse(value.trim());
                    if (year == null || year < 0 || year > DateTime.now().year) {
                      return 'Please enter a valid publish year';
                    }
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  _fieldFocusChange(context, _publishYearFocus, _categoryFocus);
                },
              ),

              const SizedBox(height: 16),

              // Category field
TextFormField(
                controller: _categoryController,
                focusNode: _categoryFocus,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.category, color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400]!),
                  ),
                ),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value != null && value.trim().length > 50) {
                    return 'Category cannot be more than 50 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Submit button
ElevatedButton(
                onPressed: _processingAddBook ? null : _addBook,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.blue[700],
                ),
                child: _processingAddBook
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Add Book',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
