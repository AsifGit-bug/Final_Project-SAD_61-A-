import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CrudPage extends StatefulWidget {
  final bool showNewlyAddedOnly;

  const CrudPage({this.showNewlyAddedOnly = false, super.key});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController();
  bool _loading = false;
  String? bookId;

  late Future<List<Map<String, dynamic>>> _supabaseBooks;

  @override
  void initState() {
    super.initState();
    if (widget.showNewlyAddedOnly) {
      _supabaseBooks = _fetchBooks();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Map) {
      bookId = args['id']?.toString();
      _title.text = args['title'] ?? '';
      _author.text = args['author'] ?? '';
    }
  }

  Future<List<Map<String, dynamic>>> _fetchBooks() async {
    final response = await Supabase.instance.client.from('book').select();
    return (response as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      if (bookId == null) {
        await Supabase.instance.client.from('book').insert({
          'title': _title.text.trim(),
          'author': _author.text.trim(),
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Book added!")));
          _title.clear();
          _author.clear();
          if (widget.showNewlyAddedOnly) {
            setState(() {
              _supabaseBooks = _fetchBooks();
            });
          }
        }
      } else {
        await Supabase.instance.client
            .from('book')
            .update({
              'title': _title.text.trim(),
              'author': _author.text.trim(),
            })
            .eq('id', bookId!);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Book updated!")));
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteBook({String? id}) async {
    if (id == null) return;
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.from('book').delete().eq('id', id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Book deleted")));
        if (widget.showNewlyAddedOnly) {
          setState(() {
            _supabaseBooks = _fetchBooks();
          });
        } else {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error deleting: $e")));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lightBlueTheme = ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.blue.shade50,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.black87,
        elevation: 2,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade400,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue.shade700),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );

    return Theme(
      data: lightBlueTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.showNewlyAddedOnly
                ? "Newly Added Books"
                : bookId == null
                ? "Add Book"
                : "Edit Book",
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (!widget.showNewlyAddedOnly)
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _title,
                        decoration: const InputDecoration(labelText: "Title"),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? "Enter book title"
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _author,
                        decoration: const InputDecoration(labelText: "Author"),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? "Enter author" : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _saveBook,
                          child: Text(_loading ? "Saving..." : "Save"),
                        ),
                      ),
                      if (bookId != null) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed:
                                _loading ? null : () => _deleteBook(id: bookId),
                            child: const Text("Delete"),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              if (widget.showNewlyAddedOnly)
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _supabaseBooks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("No books found.");
                    }

                    final books = snapshot.data!;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: books.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/default_book.jpeg',
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    book['title'] ?? 'Untitled',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    book['author'] ?? 'Unknown',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed:
                                        _loading
                                            ? null
                                            : () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) => const CrudPage(),
                                                  settings: RouteSettings(
                                                    arguments: {
                                                      'id': book['id'],
                                                      'title': book['title'],
                                                      'author': book['author'],
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                    child: const Text("Edit"),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed:
                                        _loading
                                            ? null
                                            : () => _deleteBook(
                                              id: book['id'].toString(),
                                            ),
                                    child: const Text("Delete"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
