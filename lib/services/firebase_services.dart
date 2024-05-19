import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStoreSerivce {
// get colllection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('note');

// create note
  Future<void> addNote(String note) {
    return notes.add(
      {
        'note': note,
        'timestamp': Timestamp.now(),
      },
    );
  }

// read note
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        //descending trure which means the newset note will be on the top
        notes.orderBy('timeStamp', descending: true).snapshots();
    return notesStream;
  }

// update note

// delete note
}
