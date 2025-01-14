import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String searchQuery = '';

  // Function to update the access value in Firebase
  Future<void> updateAccess(String docId, bool newValue) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(docId)
          .update({'access': newValue});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating access: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
      ),
      body: Column(
        children: [
          // Styled Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').snapshots(),
              builder: (context, snapshot) {
                // Check if the snapshot has data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No users found'));
                }

                // Extract the list of documents
                final userDocs = snapshot.data!.docs;

                // Filter the documents based on the search query
                final filteredDocs = userDocs.where((doc) {
                  final userData = doc.data() as Map<String, dynamic>;
                  final email = userData['email']?.toLowerCase() ?? '';
                  return email.contains(searchQuery);
                }).toList();

                // Build the filtered list of emails with a toggle for access
                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    // Get the data from each document
                    final userDoc = filteredDocs[index];
                    final userData = userDoc.data() as Map<String, dynamic>;
                    final email = userData['email'] ?? 'No email';
                    final access = userData['access'] ?? false;

                    return ListTile(
                      title: Text(email),
                      trailing: CupertinoSwitch(
                        value: access,
                        onChanged: (newValue) {
                          updateAccess(userDoc.id, newValue); // Update Firebase
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
