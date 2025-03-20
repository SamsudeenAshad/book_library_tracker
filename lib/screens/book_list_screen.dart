import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'add_book_screen.dart';
import 'edit_book_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookService _bookService = BookService();
  late List<Book> _books;

  @override
  void initState() {
    super.initState();
    _books = _bookService.getAllBooks();
  }

  void _refreshBookList() {
    setState(() {
      _books = _bookService.getAllBooks();
    });
  }

  void _deleteBook(Book book) {
    _bookService.deleteBook(book);
    _refreshBookList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        title: const Text(
          'Book Manager',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blue[700],
      ),
      body: _books.isEmpty
          ? _buildEmptyState()
          : _buildBookList(),
floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookScreen()),
          );
          if (result == true) {
            _refreshBookList();
          }
        },
        tooltip: 'Add Book',
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.library_books,
            size: 80,
            color: Colors.blueGrey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your book collection is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to add your first book',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            tileColor: Colors.blue[50],
            title: Text(
              book.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'By: ${book.author}',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  book.details,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueGrey),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBookScreen(book: book),
                      ),
                    );
                    if (result == true) {
                      _refreshBookList();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    _deleteBook(book);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
