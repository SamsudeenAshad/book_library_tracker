import '../models/book.dart';

class BookService {
  // Singleton pattern for the service
  static final BookService _instance = BookService._internal();
  
  factory BookService() {
    return _instance;
  }
  
  BookService._internal();

  // In-memory storage for books
  final List<Book> _books = [];

  // Get all books
  List<Book> getAllBooks() {
    return List.unmodifiable(_books);
  }

  // Add a new book and return the updated list
  List<Book> addBook(Book book) {
    _books.add(book);
    return getAllBooks();
  }

  // Check if book exists by comparing title and author
  bool bookExists(String title, String author) {
    return _books.any((book) => 
      book.title.toLowerCase() == title.toLowerCase() && 
      book.author.toLowerCase() == author.toLowerCase()
    );
  }

  // Update an existing book
  void updateBook(Book oldBook, Book updatedBook) {
    final index = _books.indexOf(oldBook);
    if (index != -1) {
      _books[index] = updatedBook;
    }
  }

  // Delete a book
  void deleteBook(Book book) {
    _books.remove(book);
  }
}
