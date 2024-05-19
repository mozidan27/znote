import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:znote/services/firebase_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseStoreSerivce firebaseStoreSerivce = FirebaseStoreSerivce();

  // textController
  final TextEditingController textController = TextEditingController();
  // add note to our home page
  void openNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // add new nete
              firebaseStoreSerivce.addNote(textController.text);
              // clear text controller
              textController.clear();
              // close dialog
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: openNewNote,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseStoreSerivce.getNotesStream(),
        builder: (context, snapshot) {
          // if we have data , get all the docs
          if (snapshot.hasData) {
            List noteslist = snapshot.data!.docs;
            //display as alist
            return ListView.builder(
              itemCount: noteslist.length,
              itemBuilder: (context, index) {
                // get each individual doc
                DocumentSnapshot document = noteslist[index];
                String docID = document.id;

                // get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                // display as a list tile
                return ListTile(
                  textColor: Colors.black,
                  title: Text(noteText),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.delete)),
                );
              },
            );
            // if there is no data return nothing
          } else {
            return const Text('No notes..');
          }
        },
      ),
    );
  }
}
