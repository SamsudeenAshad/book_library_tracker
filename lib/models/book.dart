class Book {
  final String title;
  final String author;
  final String details;
  final int? publishYear;
  final String? category;

  Book({
    required this.title,
    required this.author,
    required this.details,
    this.publishYear,
    this.category,
  });

  // Create a copy of the book with potentially updated fields
  Book copyWith({
    String? title,
    String? author,
    String? details,
    int? publishYear,
    String? category,
  }) {
    return Book(
      title: title ?? this.title,
      author: author ?? this.author,
      details: details ?? this.details,
      publishYear: publishYear ?? this.publishYear,
      category: category ?? this.category,
    );
  }

  // For debugging and logging purposes
  @override
  String toString() {
    return 'Book(title: $title, author: $author, details: $details, publishYear: $publishYear, category: $category)';
  }
}
