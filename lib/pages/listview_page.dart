import 'package:flutter/material.dart';
import '../books.dart';
import '../default_books.dart';

class ListViewPage extends StatelessWidget {
  const ListViewPage({super.key});

  void showBookDetailsDialog(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.blue.shade50,
            title: const Text('📖 Book Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "📘 Title: ${book.title}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "✍️ Author: ${book.author}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightBlueTheme = ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.blue.shade50,
      cardColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.black,
        elevation: 2,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
    );

    return Theme(
      data: lightBlueTheme,
      child: Scaffold(
        appBar: AppBar(title: const Text("ListView")),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: localBooks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final book = localBooks[index];
            return InkWell(
              onTap: () => showBookDetailsDialog(context, book),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      book.imagePath ?? 'assets/images/default_book.jpeg',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(book.title ?? ''),
                  subtitle: Text(book.author ?? ''),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
