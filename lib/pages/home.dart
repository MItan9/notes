import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notes/pages/category_notes.dart';
import 'package:notes/pages/all_notes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Note {
  String title;
  String text;
  DateTime date;

  Note({
    required this.title,
    required this.text,
    required this.date,
  });
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _CategoryName;
  List<Map<String, dynamic>> categoryList = [];
  Color _selectedColor = Colors.amber;
  String _categorySearchText = '';

  @override
  void initState() {
    super.initState();
    _loadCategoryList();
  }

  _loadCategoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categoryListJson = prefs.getString('categoryList');

    if (categoryListJson != null) {
      List<Map<String, dynamic>> savedCategoryList = (jsonDecode(categoryListJson) as List)
          .map((categoryJson) => categoryJson as Map<String, dynamic>)
          .toList();
      setState(() {
        categoryList = savedCategoryList;
      });
    }
  }

  _saveCategoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String categoryListJson = jsonEncode(categoryList);
    prefs.setString('categoryList', categoryListJson);
  }

  void _addCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color pickerColor = _selectedColor; // Хранит выбранный цвет

        return AlertDialog(
          title: const Text('Add a Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  onChanged: (String value) {
                    setState(() {
                      _CategoryName = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Category name',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Pick a Color'),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: pickerColor,
                                onColorChanged: (Color color) {
                                  setState(() {
                                    pickerColor = color;
                                  });
                                },
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedColor = pickerColor;
                                  });
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                                child: Text('Select'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: Text('Change'),
                  ),
                  SizedBox(width: 20), // Добавляем расстояние между кнопкой и квадратиком
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  categoryList.add({
                    'name': _CategoryName,
                    'notes': <Note>[],
                    'color': pickerColor.value,
                  });
                  _saveCategoryList();
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
              ),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }


  _openCategoryNotes(BuildContext context, int categoryIndex) {
    Map<String, dynamic> categoryData = categoryList[categoryIndex];
    Color categoryColor = Color(categoryData['color']);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CategoryNotes(
        categoryData: categoryData,
        categoryIndex: categoryIndex,
        updateCategory: _updateCategory,
        categoryColor: categoryColor,
      ),
    ));
  }


  _deleteCategory(int categoryIndex) {
    setState(() {
      categoryList.removeAt(categoryIndex);
      _saveCategoryList();
    });
  }

  _updateCategory(int categoryIndex, Map<String, dynamic> updatedData) {
    setState(() {
      categoryList[categoryIndex] = updatedData;
      _saveCategoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredCategoryList = categoryList.where((category) {
      return category['name'].toLowerCase().contains(_categorySearchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String value) {
                setState(() {
                  _categorySearchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Categories',
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.search, color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: filteredCategoryList.length,
              itemBuilder: (BuildContext context, int categoryIndex) {
                Color? categoryColor;
                if (filteredCategoryList[categoryIndex]['color'] != null) {
                  categoryColor = Color(filteredCategoryList[categoryIndex]['color']);
                } else {
                  // Handle the case when 'color' is null (e.g., provide a default color).
                  categoryColor = Colors.amber; // You can use any default color you prefer.
                }
                // Отрисовка квадрата с выбранным цветом
                Widget categoryTile = Container(
                  color: categoryColor,
                  child: Center(
                    child: Text(
                      filteredCategoryList[categoryIndex]['name'],
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );

                return GestureDetector(
                  onTap: () {
                    _openCategoryNotes(context, categoryIndex);
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Stack(
                      children: [
                        categoryTile,
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteCategory(categoryIndex);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          _addCategoryDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'All Notes',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber,
        onTap: (int index) {
          if (index == 0) {
            // Navigate to the category screen
          } else if (index == 1) {
            // Navigate to the all notes screen
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AllNotes(categoryList),
            ));
          }
        },
      ),
    );
  }
}
