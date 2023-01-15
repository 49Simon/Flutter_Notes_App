import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<dynamic, List> _notes = {};
  final _textController = TextEditingController();
  bool _isHidden = true;

  // user credentials
  final _credentials = {};

  // track the current page
  var _currentPage = 'login';

  // login form fields
  late String _username;
  late String _password;

  // registration form fields
  late String _regUsername;
  late String _regPassword;
  late String _regConfirmPassword;

  @override
  Widget build(BuildContext context) {
    Icon myicon = _currentPage == 'noteList'
        ? const Icon(Icons.logout)
        : const Icon(null);
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Notes App'),
        backgroundColor: const Color.fromARGB(255, 83, 59, 78),
        actions: [
          IconButton(onPressed: _showLoginForm, icon: myicon),
        ],
      ),
      body: _currentPage == 'login'
          ? _buildLoginForm()
          : _currentPage == 'register'
              ? _buildRegistrationForm()
              : _buildNoteList(),
    );
  }

  // Builds the login form
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Username', prefixIcon: Icon(Icons.person)),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
              onSaved: (value) => _username = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      icon: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      })),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              onSaved: (value) => _password = value!,
              obscureText: _isHidden,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: _showRegistrationForm,
              child: const Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the registration form
  Widget _buildRegistrationForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              onSaved: (value) => _regUsername = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      icon: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      })),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              onSaved: (value) => _regPassword = value!,
              obscureText: _isHidden,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              obscureText: _isHidden,
              onSaved: ((newValue) => _regConfirmPassword = newValue!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleRegistration,
              child: const Text('Create account'),
            ),
            TextButton(
              onPressed: _showLoginForm,
              child: const Text('Have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteList() {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _notes[_username]!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notes[_username]![index]),
                  onTap: () {
                    _editNote(index);
                  },
                  onLongPress: () {
                    _deleteNote(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNote() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextField(
              autofocus: true,
              controller: _textController,
              decoration: const InputDecoration(hintText: "New Note"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                  _textController.clear();
                },
              ),
              TextButton(
                child: const Text("Save"),
                onPressed: () {
                  setState(() {
                    _notes[_username]!.add(_textController.text);
                  });
                  Navigator.pop(context);
                  _textController.clear();
                },
              )
            ],
          );
        });
  }

  void _editNote(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextField(
              controller: _textController,
              decoration: const InputDecoration(hintText: "Edit Note"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                  _textController.clear();
                },
              ),
              TextButton(
                child: const Text("Save"),
                onPressed: () {
                  setState(() {
                    _notes[_username]![index] = _textController.text;
                  });
                  Navigator.pop(context);
                  _textController.clear();
                },
              )
            ],
          );
        });
    _textController.text = _notes[_username]![index];
  }

  void _deleteNote(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Note"),
            content: const Text("Are you sure you want to delete this note?"),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("Delete"),
                onPressed: () {
                  setState(() {
                    _notes[_username]!.removeAt(index);
                  });
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // Handles the login form submission
  void _handleLogin() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // check if the provided credentials are valid
      if (_credentials[_username] == _password) {
        setState(() {
          _currentPage = 'noteList';
        });
      } else {
        _errorMessage("Invalid username/password");
      }
    }
  }

// Handles the registration form submission
  void _handleRegistration() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      if (_regPassword != _regConfirmPassword) {
        _errorMessage("Passwords do not match");
      } else if (_credentials.containsKey(_regUsername)) {
        _errorMessage("User already exists");
      } else {
        setState(() {
          // save the user's credentials
          _credentials[_regUsername] = _regPassword;
          _username = _regUsername; // Set the current username
          _notes[_regUsername] = <String>[];
          _currentPage = 'noteList';
        });
      }
    }
  }

  void _showRegistrationForm() {
    setState(() {
      _currentPage = 'register';
    });
  }

  void _showLoginForm() {
    setState(() {
      _currentPage = 'login';
    });
  }

  void _errorMessage(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Color.fromARGB(255, 255, 3, 3),
      ),
    )));
  }
}
