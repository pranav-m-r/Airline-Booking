// ignore_for_file: unused_element, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_import, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' show File;

late Database db;
String? currentUserID;
List<Map<String, dynamic>> users = [];
List<Map<String, dynamic>> bookings = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initDatabase();
  await fetchUsers();
  await fetchBookings();
  runApp(SkyLinerApp());
}

Future<void> initDatabase() async {
  try {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "database.db");

    // Check if the database already exists
    bool databaseExists = await File(path).exists();

    if (!databaseExists) {
      // Copy the database from assets if it doesn't exist
      ByteData data = await rootBundle.load("assets/database.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      print("✅ Database copied from assets.");
    } else {
      print("✅ Database already exists. Skipping copy.");
    }

    // Open the database in read-write mode
    db = await openDatabase(path);
    print("✅ Database initialized successfully.");

    // Debugging: Check available tables
    List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table';");
    print("📋 Tables in database: $tables");
  } catch (e) {
    print('❌ Error initializing database: $e');
  }
}

Future<void> fetchUsers() async {
    try {
      // Query the database to fetch all users
      List<Map<String, dynamic>> queryResult = await db.rawQuery('''
        SELECT 
          userID, 
          email, 
          password, 
          name, 
          phone, 
          isAdmin 
        FROM users
      ''');

      // Map the query result to the dummyUsers format
      users = queryResult;
      print("👥 Fetched users: $users");
    } catch (e) {
      print('❌ Error fetching users: $e');
    }
  }

  Future<void> fetchBookings() async {
    try {
      // Query the database to fetch all bookings
      List<Map<String, dynamic>> queryResult = await db.rawQuery('''
        SELECT 
          bookingID, 
          userID, 
          flightID, 
          bookingDate, 
          status 
        FROM bookings
      ''');

      // Map the query result to the dummyBookings format
      bookings = queryResult;
      print("📋 Fetched bookings: $bookings");
    } catch (e) {
      print('❌ Error fetching bookings: $e');
    }
  }

class SkyLinerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/flight_search': (context) => FlightSearchPage(),
        '/admin_dashboard': (context) => AdminDashboardPage(),
        '/flight_results': (context) => FlightResultsPage(),
        '/flight_details': (context) => FlightDetailsPage(),
        '/payment': (context) => PaymentPage(),
        '/booking_history': (context) => BookingHistoryPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

// final dummyFlights = [
//   {'id': 'A1B2', 'origin': 'New York', 'destination': 'Los Angeles', 'price': 200.0, 'date': '2025-03-20', 'departure': '08:00', 'arrival': '11:30', 'airline': 'Delta Airlines'},
//   {'id': 'C3D4', 'origin': 'New York', 'destination': 'Los Angeles', 'price': 220.0, 'date': '2025-03-20', 'departure': '12:00', 'arrival': '15:30', 'airline': 'American Airlines'},
//   {'id': 'E5F6', 'origin': 'New York', 'destination': 'Los Angeles', 'price': 210.0, 'date': '2025-03-21', 'departure': '14:00', 'arrival': '17:30', 'airline': 'United Airlines'},
//   {'id': 'G7H8', 'origin': 'Chicago', 'destination': 'Houston', 'price': 150.0, 'date': '2025-03-20', 'departure': '09:00', 'arrival': '11:00', 'airline': 'Southwest Airlines'},
//   {'id': 'I9J0', 'origin': 'Chicago', 'destination': 'Houston', 'price': 180.0, 'date': '2025-03-21', 'departure': '13:00', 'arrival': '15:00', 'airline': 'Spirit Airlines'},
//   {'id': 'K1L2', 'origin': 'San Francisco', 'destination': 'Seattle', 'price': 100.0, 'date': '2025-03-20', 'departure': '10:00', 'arrival': '12:00', 'airline': 'Alaska Airlines'},
//   {'id': 'M3N4', 'origin': 'San Francisco', 'destination': 'Seattle', 'price': 120.0, 'date': '2025-03-21', 'departure': '16:00', 'arrival': '18:00', 'airline': 'JetBlue'},
//   {'id': 'O5P6', 'origin': 'New York', 'destination': 'Chicago', 'price': 170.0, 'date': '2025-03-20', 'departure': '07:00', 'arrival': '09:30', 'airline': 'Delta Airlines'},
//   {'id': 'Q7R8', 'origin': 'Houston', 'destination': 'San Francisco', 'price': 190.0, 'date': '2025-03-20', 'departure': '11:00', 'arrival': '14:30', 'airline': 'United Airlines'},
//   {'id': 'S9T0', 'origin': 'New York', 'destination': 'Los Angeles', 'price': 230.0, 'date': '2025-03-21', 'departure': '18:00', 'arrival': '21:30', 'airline': 'American Airlines'},
//   {'id': 'U1V2', 'origin': 'Chicago', 'destination': 'New York', 'price': 175.0, 'date': '2025-03-20', 'departure': '08:30', 'arrival': '11:00', 'airline': 'Spirit Airlines'},
//   {'id': 'W3X4', 'origin': 'Seattle', 'destination': 'San Francisco', 'price': 110.0, 'date': '2025-03-21', 'departure': '12:30', 'arrival': '14:30', 'airline': 'Alaska Airlines'},
//   {'id': 'Y5Z6', 'origin': 'Houston', 'destination': 'Chicago', 'price': 160.0, 'date': '2025-03-20', 'departure': '10:30', 'arrival': '13:00', 'airline': 'Southwest Airlines'},
//   {'id': 'A7B8', 'origin': 'Los Angeles', 'destination': 'New York', 'price': 240.0, 'date': '2025-03-21', 'departure': '20:00', 'arrival': '23:30', 'airline': 'JetBlue'},
// ];

void showPopup(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

class SkyLinerTopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  SkyLinerTopNavBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// final List<Map<String, dynamic>> dummyUsers = [
//   {
//     'userID': 'USER001',
//     'email': 'user1@example.com',
//     'password': 'password123',
//     'name': 'John Doe',
//     'phone': '123-456-7890',
//     'isAdmin': false,
//   },
//   {
//     'userID': 'USER002',
//     'email': 'user2@example.com',
//     'password': 'securepass',
//     'name': 'Jane Smith',
//     'phone': '987-654-3210',
//     'isAdmin': false,
//   },
//   {
//     'userID': 'ADMIN001',
//     'email': 'admin@example.com',
//     'password': 'admin123',
//     'name': 'Admin User',
//     'phone': '111-222-3333',
//     'isAdmin': true,
//   },
// ];

// final List<Map<String, dynamic>> dummyBookings = [
//   {
//     'bookingID': 'B001',
//     'userID': 'USER001',
//     'flightID': 'A1B2',
//     'bookingDate': '2025-03-19',
//     'status': 'Confirmed',
//   },
//   {
//     'bookingID': 'B002',
//     'userID': 'USER002',
//     'flightID': 'C3D4',
//     'bookingDate': '2025-03-18',
//     'status': 'Confirmed',
//   },
// ];


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void authenticateUser(BuildContext context) {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    // Check if user exists in the dummy user list
    final user = users.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      currentUserID = user['userID'];
      print("IS ADMIN? ${user['isAdmin']}");
      // Check if the user is an admin
      if (user['isAdmin'] == 1) {
        // Redirect to Admin Dashboard
        Navigator.pushNamed(context, '/admin_dashboard');
      } else {
        // Redirect to Flight Search page
        Navigator.pushNamed(context, '/flight_search', arguments: {'isGuest': false});
      }
    } else {
      // Show error message for invalid credentials
      showPopup(context, 'Login Failed', 'Invalid email or password. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'SkyLiner',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Fill out the details to access your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => authenticateUser(context),
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: Text('Forgot Password?'),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don’t have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  void addUser(BuildContext context) async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String phone = phoneController.text.trim();

    // Validate input fields
    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      showPopup(context, 'Error', 'All fields are required.');
      return;
    }

    // Check if the user already exists
    final existingUser = users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {}, // Return an empty map with matching type
    );

    if (existingUser.isNotEmpty) {
      showPopup(context, 'Error', 'User with this email already exists.');
      return;
    }

    // Generate a unique userID
    final String userID = DateTime.now().millisecondsSinceEpoch.toString();

    // Add the new user to the list
    users = List.from(users)
    ..add({
      'userID': userID,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'isAdmin': false, // Default to false
    });

    try {
      // Insert the new user into the database
      await db.insert(
        'users',
        {
          'userID': userID,
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'isAdmin': 0, // Default to false (0 for SQLite)
        },
      );

      // Show success message
      if (context.mounted) showPopup(context, 'Success', 'Account created successfully!');

      // Redirect to login page
      if (context.mounted) Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      // Handle database errors
      if (context.mounted) showPopup(context, 'Error', 'Failed to create account. Please try again.');
      print('❌ Error adding user to database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'SkyLiner',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Let’s get started by filling out the form below.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => addUser(context),
                child: Text('Sign Up'),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlightManagementPage()),
                );
              },
              child: Text('Flight Management'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementPage()),
                );
              },
              child: Text('User Management'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingInsightsPage()),
                );
              },
              child: Text('Booking Insights'),
            ),
          ],
        ),
      ),
    );
  }
}

class FlightManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Management'),
      ),
      body: Center(
        child: Text(
          'Flight Management Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class UserManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Center(
        child: Text(
          'User Management Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class BookingInsightsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Insights'),
      ),
      body: Center(
        child: Text(
          'Booking Insights Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}



Widget _buildTextField(String label, {bool obscureText = false}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: label,
      ),
    ),
  );
}

Widget _buildButton(BuildContext context, String text, String route) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
    ),
    onPressed: () {
      Navigator.pushNamed(context, route);
    },
    child: Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    ),
  );
}

Widget _buildBottomNav(BuildContext context, String text, String route) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    ),
  );
}


// Other pages (FlightSearchPage, etc.) remain unchanged.


class FlightSearchPage extends StatefulWidget {
  @override
  _FlightSearchPageState createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  final TextEditingController departureController = TextEditingController();
  final TextEditingController arrivalController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final bool isGuest = args?['isGuest'] ?? false;

    return Scaffold(
      appBar: SkyLinerTopNavBar(title: 'SkyLiner - Flight Search'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: departureController,
              decoration: InputDecoration(labelText: 'Departure City'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: arrivalController,
              decoration: InputDecoration(labelText: 'Arrival City'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (departureController.text.isEmpty ||
                    arrivalController.text.isEmpty ||
                    dateController.text.isEmpty) {
                  showPopup(context, 'Error', 'Please fill all fields.');
                  return;
                }
                Navigator.pushNamed(
                  context,
                  '/flight_results',
                  arguments: {
                    'departureCity': departureController.text,
                    'arrivalCity': arrivalController.text,
                    'date': dateController.text,
                  },
                );
              },
              child: Text('Search Flights'),
            ),
            if (!isGuest) ...[
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/booking_history');
                },
                child: Text('View Booking History'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: Text('View Profile'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


// Other pages and widgets remain the same but should use the SkyLinerTopNavBar for consistency


class FlightResultsPage extends StatefulWidget {
  @override
  State<FlightResultsPage> createState() => _FlightResultsPageState();
}

class _FlightResultsPageState extends State<FlightResultsPage> {
  List<Map<String, dynamic>> flights = [];

  Future<void> fetchFlights() async {
    try {
      // Debugging: Check available tables before querying
      List<Map<String, dynamic>> tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table';");
      print("📋 Available tables: $tables");

      List<Map<String, dynamic>> queryResult = await db.rawQuery('''
        SELECT 
          flights.flight_id AS id,
          flights.flight_number AS flightNumber,
          airlines.name AS airline,
          departure_airport.city AS origin,
          arrival_airport.city AS destination,
          flights.departure_time AS departure,
          flights.arrival_time AS arrival,
          flights.status AS status,
          DATE(flights.departure_time) AS date
        FROM flights
        INNER JOIN airlines ON flights.airline_id = airlines.airline_id
        INNER JOIN airports AS departure_airport ON flights.departure_airport_id = departure_airport.airport_id
        INNER JOIN airports AS arrival_airport ON flights.arrival_airport_id = arrival_airport.airport_id
      ''');

      setState(() {
        flights = queryResult;
      });
    } catch (e) {
      print('❌ Error fetching flight data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    initDatabase().then((_) {
      fetchFlights();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String departureCity =
        (args?['departureCity'] ?? '').trim().toLowerCase();
    final String arrivalCity =
        (args?['arrivalCity'] ?? '').trim().toLowerCase();
    final String date = (args?['date'] ?? '').trim();

    final filteredFlights = flights
        .where((flight) =>
            flight['origin'].toString().trim().toLowerCase() == departureCity &&
            flight['destination']
                .toString()
                .trim()
                .toLowerCase() ==
                arrivalCity &&
            flight['date'].toString().trim() == date)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Flight Results')),
      body: flights.isEmpty
          ? Center(child: SpinKitCircle(color: Colors.blue))
          : filteredFlights.isEmpty
              ? Center(
                  child: Text('No flights available for selected criteria'))
              : ListView.builder(
                  itemCount: filteredFlights.length,
                  itemBuilder: (context, index) {
                    final flight = filteredFlights[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('Airline: ${flight['airline']}'),
                        subtitle: Text('${flight['origin']} → ${flight['destination']}\n'
                            'Date: ${flight['date']}\n'
                            'Price: \$${flight['price']}'),
                        onTap: () {
                          Navigator.pushNamed(context, '/flight_details',
                              arguments: flight);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}



class FlightDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flight = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: SkyLinerTopNavBar(title: 'Flight Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flight ID: ${flight['id']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Airline: ${flight['airline']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Origin: ${flight['origin']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Destination: ${flight['destination']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Price: \$${flight['price']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Date: ${flight['date']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Departure: ${flight['departure']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Arrival: ${flight['arrival']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
                      final bookingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

                      Navigator.pushNamed(
                        context, 
                        '/payment', 
                        arguments: {
                          'id': flight['id'],
                          'price': flight['price'],
                          'airline': flight['airline'],
                          'uniqueId': uniqueId,
                          'bookingDate': bookingDate,
                        },
                      );
                    },
                    child: Text('Book Flight'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethod;
  String paymentStatus = "Pending";

  void _confirmPayment(BuildContext context, Map<String, dynamic> paymentDetails) async {
    try {
      await db.delete(
        'bookings',
        where: 'flightID = ? AND userID = ?',
        whereArgs: [paymentDetails['id'], paymentDetails['userID']],
      );
      print("✅ Existing booking removed from database (if any).");
    } catch (e) {
      print("❌ Error removing existing booking from database: $e");
    }

    // Update the payment status
    setState(() {
      paymentStatus = "Confirmed";
    });

    // Create a new booking
    Map<String, dynamic> newBooking = {
      'bookingID': DateTime.now().millisecondsSinceEpoch.toString(),
      'userID': currentUserID,
      'flightID': paymentDetails['id'],
      'bookingDate': paymentDetails['bookingDate'],
      'status': 'Confirmed',
    };

    try {
      // Insert the new booking into the database
      await db.insert('bookings', newBooking);
      print("✅ New booking added to database: $newBooking");

      // Add the new booking to the in-memory list
      setState(() {
        bookings = List.from(bookings)..add(newBooking); // Create a new list and add the booking
      });
    } catch (e) {
      print("❌ Error adding new booking to database: $e");
    }

    print("✅ Booking confirmed and added: $newBooking");
    print("📋 Updated bookings list: $bookings");

    // Close PaymentPage and return to the previous screen
    if (context.mounted) Navigator.pop(context);
  }



  void _showConfirmationDialog(BuildContext parentContext, Map<String, dynamic> paymentDetails) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Confirm Payment"),
          content: Text("Do you want to confirm the payment now or pay later?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  paymentStatus = "Pending";
                });
                Navigator.pop(dialogContext);
              },
              child: Text("Pay Later"),
            ),
            ElevatedButton(
  onPressed: () {
    _confirmPayment(parentContext, paymentDetails); // Pass the correct BuildContext
    Navigator.pop(dialogContext); // Close the dialog
  },
  child: Text("Confirm"),
),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentDetails = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (paymentDetails == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Payment')),
        body: Center(child: Text("No payment details available.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment ID: PAY-${paymentDetails['id']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Flight ID: ${paymentDetails['id']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Amount: \$${paymentDetails['price']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              items: [
                DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
                DropdownMenuItem(value: 'Debit Card', child: Text('Debit Card')),
                DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                DropdownMenuItem(value: 'Net Banking', child: Text('Net Banking')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
              value: selectedPaymentMethod,
              hint: Text('Select Method'),
            ),
            SizedBox(height: 16),
            Text(
              'Payment Method: ${selectedPaymentMethod ?? "Not Selected"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Payment Status: $paymentStatus',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: paymentStatus == "Confirmed" ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedPaymentMethod == null) {
                  print("❌ Please select a payment method before confirming.");
                  return;
                }
                _showConfirmationDialog(context, paymentDetails); // ✅ Pass context properly
              },
              child: Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}


class BookingHistoryPage extends StatefulWidget {

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  List<Map<String, dynamic>> userBookings = [];

  @override
  void initState() {
    super.initState();
    _updateBookings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateBookings(); // Refresh bookings every time the page is revisited
  }

  void _updateBookings() {
    setState(() {
      userBookings = bookings.where((booking) => booking['userID'] == currentUserID).toList();
    });
  }

  void cancelBooking(String bookingID) async {
    try {
      // Remove the booking from the database
      await db.delete(
        'bookings',
        where: 'bookingID = ?',
        whereArgs: [bookingID],
      );
      print("✅ Booking removed from database: $bookingID");

      // Remove the booking from the in-memory list
      setState(() {
        bookings.removeWhere((booking) => booking['bookingID'] == bookingID);
        _updateBookings(); // Refresh the userBookings list
      });
    } catch (e) {
      print("❌ Error canceling booking: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking History')),
      body: userBookings.isEmpty
          ? Center(child: Text('No bookings found.'))
          : ListView.builder(
              itemCount: userBookings.length,
              itemBuilder: (context, index) {
                final booking = userBookings[index];
                return Card(
                  child: ListTile(
                    title: Text('Flight ID: ${booking['flightID']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Booking ID: ${booking['bookingID']}'),
                        Text('Status: ${booking['status']}'),
                        Text('Booking Date: ${booking['bookingDate']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        cancelBooking(booking['bookingID']);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}


class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> currentUser;

  @override
  void initState() {
    super.initState();
    // Load the user's data initially
    print("🔍 Current User ID: $currentUserID");
    print(users);
    currentUser = users.firstWhere((user) => user['userID'] == currentUserID);
  }

  void refreshUserData() {
    setState(() {
      currentUser = users.firstWhere((user) => user['userID'] == currentUserID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: ${currentUser['userID']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Name: ${currentUser['name']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: ${currentUser['email']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Phone: ${currentUser['phone']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Navigate to ProfileEditPage and wait for the result
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEditPage(),
                  ),
                );

                // If the result is not null, refresh the user data
                if (result != null) {
                  refreshUserData();
                }
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}



class ProfileEditPage extends StatefulWidget {

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late Map<String, dynamic> currentUser;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    // Initialize currentUser from dummyUsers
    currentUser = users.firstWhere((user) => user['userID'] == currentUserID);
    nameController = TextEditingController(text: currentUser['name']);
    emailController = TextEditingController(text: currentUser['email']);
    phoneController = TextEditingController(text: currentUser['phone']);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void saveChanges(BuildContext context, Map<String, dynamic> updatedData) async {
    // Find the user in the users list based on userID
    final index = users.indexWhere((user) => user['userID'] == updatedData['userID']);

    if (index != -1) {
      // Update the user's data in the users list
      setState(() {
        users = List.from(users)..[index] = updatedData; // Create a new list and update it
      });

      try {
        // Update the user's data in the database
        await db.update(
          'users',
          {
            'name': updatedData['name'],
            'email': updatedData['email'],
            'phone': updatedData['phone'],
            'isAdmin': updatedData['isAdmin'],
          },
          where: 'userID = ?',
          whereArgs: [updatedData['userID']],
        );

        print("✅ User data updated successfully in the database.");
      } catch (e) {
        print("❌ Error updating user data in the database: $e");
      }
    }

    // Navigate back to the ProfilePage with updated data
    if (context.mounted) Navigator.pop(context, updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: ${currentUser['userID']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Create the updated data map
                final updatedData = {
                  'userID': currentUser['userID'],
                  'email': emailController.text,
                  'password': currentUser['password'], // Keep the password unchanged
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'isAdmin': currentUser['isAdmin'], // Keep admin status unchanged
                };

                // Save changes to the dummy data
                saveChanges(context, updatedData);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}



