class Book {
  final int? id;
  final String? title;
  final String? author;
  final String? description;
  final String? imagePath; // new for local books

  Book({this.id, this.title, this.author, this.description, this.imagePath});

  factory Book.fromMap(Map<String, dynamic> m) => Book(
    id: m['id'] as int?,
    title: m['title'] as String?,
    author: m['author'] as String?,
    description: m['description'] as String?,
    imagePath: m['imagePath'] as String?, // optional
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'author': author,
    'description': description,
    if (imagePath != null) 'imagePath': imagePath,
  };
}
