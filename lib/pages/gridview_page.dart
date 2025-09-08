import 'package:flutter/material.dart';
import '../books.dart';
import '../default_books.dart';

class GridViewPage extends StatelessWidget {
  const GridViewPage({super.key});

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
                  "📘 Title: ${book.title ?? 'Unknown'}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "✍️ Author: ${book.author ?? 'Unknown'}",
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
        appBar: AppBar(title: const Text("GridView")),
        body: GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: localBooks.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final book = localBooks[index];
            return InkWell(
              onTap: () => showBookDetailsDialog(context, book),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          book.imagePath ?? 'assets/images/default_book.jpeg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        book.title ?? 'Untitled',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        book.author ?? 'Unknown',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
