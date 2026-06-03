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
  Map<String, TextEditingController> emailControllers = {};
  Map<String, TextEditingController> nameControllers = {};
  Map<String, bool> editingStates = {};
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();
  bool _newUserMapAccess = true;

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in emailControllers.values) {
      controller.dispose();
    }
    for (var controller in nameControllers.values) {
      controller.dispose();
    }
    newEmailController.dispose();
    newNameController.dispose();
    super.dispose();
  }

  // Function to update any field in Firebase
  Future<void> updateUserField(
      String docId, String field, dynamic value) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(docId)
          .update({field: value});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$field updated successfully'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating $field: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Function to save all changes for a user
  Future<void> saveUserChanges(String docId, String email, String name) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(docId).update({
        'email': email.trim().toLowerCase(),
        'name': name,
      });

      setState(() {
        editingStates[docId] = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User information updated successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating user: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Function to update access field specifically
  Future<void> updateAccess(String docId, bool newValue) async {
    await updateUserField(docId, 'access', newValue);
  }

  Future<void> updateMapAccess(String docId, bool newValue) async {
    await updateUserField(docId, 'mapAccess', newValue);
  }

  // Function to add a new user
  Future<void> addNewUser() async {
    final email = newEmailController.text.trim().toLowerCase();
    final name = newNameController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email is required'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check if email already exists
    try {
      final existingUsers = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User with this email already exists'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Add new user to Firebase
      await FirebaseFirestore.instance.collection('user').add({
        'email': email,
        'name': name.isEmpty ? 'New User' : name,
        'access': false,
        'mapAccess': _newUserMapAccess,
      });

      // Clear the input fields
      newEmailController.clear();
      newNameController.clear();
      setState(() {
        _newUserMapAccess = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User added successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding user: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Function to delete a user
  Future<void> deleteUser(String docId, String email) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete user: $email?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance.collection('user').doc(docId).delete();

        // Clean up controllers for deleted user
        emailControllers.remove(docId);
        nameControllers.remove(docId);
        editingStates.remove(docId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting user: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
          // Add New User Section
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New User',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: newNameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: newEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email *',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: addNewUser,
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Add User'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Enable Apple Map Access',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      CupertinoSwitch(
                        value: _newUserMapAccess,
                        onChanged: (value) {
                          setState(() {
                            _newUserMapAccess = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

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

                // Build the filtered list with editable user information
                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    // Get the data from each document
                    final userDoc = filteredDocs[index];
                    final userData = userDoc.data() as Map<String, dynamic>;
                    final docId = userDoc.id;
                    final email = userData['email'] ?? 'No email';
                    final name = userData['name'] ?? 'No name';
                    final access = userData['access'] ?? false;
                    final mapAccess = userData['mapAccess'] is bool
                        ? userData['mapAccess'] as bool
                        : true;

                    // Initialize controllers if they don't exist
                    if (!emailControllers.containsKey(docId)) {
                      emailControllers[docId] =
                          TextEditingController(text: email);
                    }
                    if (!nameControllers.containsKey(docId)) {
                      nameControllers[docId] =
                          TextEditingController(text: name);
                    }
                    if (!editingStates.containsKey(docId)) {
                      editingStates[docId] = false;
                    }

                    final isEditing = editingStates[docId] ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name field
                            Row(
                              children: [
                                const SizedBox(
                                  width: 60,
                                  child: Text('Name:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  child: isEditing
                                      ? TextField(
                                          controller: nameControllers[docId],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                          ),
                                        )
                                      : Text(name),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Email field
                            Row(
                              children: [
                                const SizedBox(
                                  width: 60,
                                  child: Text('Email:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  child: isEditing
                                      ? TextField(
                                          controller: emailControllers[docId],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                          ),
                                        )
                                      : Text(email),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Access toggle
                            Row(
                              children: [
                                const SizedBox(
                                  width: 60,
                                  child: Text('Access:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                CupertinoSwitch(
                                  value: access,
                                  onChanged: (newValue) {
                                    updateAccess(docId, newValue);
                                  },
                                ),
                                const Spacer(),

                                // Action buttons
                                if (isEditing) ...[
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await saveUserChanges(
                                        docId,
                                        emailControllers[docId]!.text,
                                        nameControllers[docId]!.text,
                                      );
                                    },
                                    icon: const Icon(Icons.save, size: 16),
                                    label: const Text('Save'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        editingStates[docId] = false;
                                        // Reset controllers to original values
                                        emailControllers[docId]!.text = email;
                                        nameControllers[docId]!.text = name;
                                      });
                                    },
                                    icon: const Icon(Icons.cancel, size: 16),
                                    label: const Text('Cancel'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ] else ...[
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        editingStates[docId] = true;
                                      });
                                    },
                                    icon: const Icon(Icons.edit, size: 16),
                                    label: const Text('Edit'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      deleteUser(docId, email);
                                    },
                                    icon: const Icon(Icons.delete, size: 16),
                                    label: const Text('Delete'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 60,
                                  child: Text('Map:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                CupertinoSwitch(
                                  value: mapAccess,
                                  onChanged: (newValue) {
                                    updateMapAccess(docId, newValue);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
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
