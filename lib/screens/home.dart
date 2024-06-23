import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/colors/colors.dart';
import 'package:todo/services/firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _todocontroller = TextEditingController();
  final FocusNode _textfieldfocusNode = FocusNode();
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TodoService todoService = TodoService();

  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: tdBGColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // IconButton(onPressed: () {}, icon: Icon(Icons.dark_mode)),
            GestureDetector(
              onTap: () {
                _showUserDialog(context);
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(user?.photoURL ?? '1.png'),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                search_bar(onQueryChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                }),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "All ToDos",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('users')
                        .doc(user?.uid)
                        .collection('todos')
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> docs = snapshot.data!.docs;

                        if (_searchQuery.isNotEmpty) {
                          docs = docs.where((doc) {
                            String task = doc.get('task').toLowerCase();
                            return task.contains(_searchQuery.toLowerCase());
                          }).toList();
                        }

                        if (docs.isEmpty) {
                          return Center(child: Text("No ToDo tasks"));
                        }

                        return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            String task = docs[index].get('task');
                            bool isDone = docs[index].get('isDone');

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.grey),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: isDone,
                                  onChanged: (bool? value) {
                                    _firestore
                                        .collection('users')
                                        .doc(user?.uid)
                                        .collection('todos')
                                        .doc(docs[index].id)
                                        .update({'isDone': value});
                                  },
                                ),
                                title: Text(
                                  task,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: tdBlack,
                                    decoration: isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    _firestore
                                        .collection('users')
                                        .doc(user?.uid)
                                        .collection('todos')
                                        .doc(docs[index].id)
                                        .delete();
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todocontroller,
                      focusNode: _textfieldfocusNode,
                      decoration: InputDecoration(
                        hintText: "Add a new todo item",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  child: FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.white, size: 50),
                    onPressed: () {
                      if (_todocontroller.text.isNotEmpty) {
                        todoService.addTodoTask(_todocontroller.text, false);
                        _todocontroller.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user?.photoURL ?? 'assets/images/1.png'),
              ),
              SizedBox(height: 10),
              Text('Name: ${user?.displayName ?? 'Anonymous'}'),
              SizedBox(height: 10),
              Text('Email: ${user?.email ?? 'No email'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // Close the dialog
                await GoogleSignIn().signOut();
                Navigator.pushReplacementNamed(context, '/');
                // Optionally, navigate to the login screen or do other actions
              },
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}

class search_bar extends StatefulWidget {
  final ValueChanged<String> onQueryChanged;
  const search_bar({
    super.key,
    required this.onQueryChanged,
  });

  @override
  State<search_bar> createState() => _search_barState();
}

class _search_barState extends State<search_bar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => widget.onQueryChanged(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 30,
          ),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }
}
