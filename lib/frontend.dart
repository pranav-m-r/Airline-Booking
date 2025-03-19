// ignore_for_file: unused_element, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_import, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' show File;

late Database db;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initDatabase();
  runApp(SkyLinerApp());
}

Future<void> initDatabase() async {
  String databasesPath = await getDatabasesPath();
  String path = "${databasesPath}database.db";
  await deleteDatabase(path);
  ByteData data = await rootBundle.load("assets/database.db");
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(path).writeAsBytes(bytes, flush: true);
  db = await openDatabase(path, readOnly: true);
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
        '/flight_results': (context) => FlightResultsPage(),
        '/flight_details': (context) => FlightDetailsPage(),
        '/payment': (context) => PaymentPage(), // Add this route
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

List<Map> flights = [];

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

class LoginPage extends StatelessWidget {
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
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/flight_search', arguments: {'isGuest': false});
                },
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

class SignUpPage extends StatelessWidget {
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
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/flight_search', arguments: {'isGuest': false});
                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/flight_search', arguments: {'isGuest': true});
                },
                child: Text('Continue as Guest'),
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
  void initList() async {
    // Query the database to fetch all flight details
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

    // Populate the flights list with the query result
    setState(() {
      flights = queryResult.map((flight) {
        return {
          'id': flight['id'],
          'flightNumber': flight['flightNumber'],
          'airline': flight['airline'],
          'origin': flight['origin'],
          'destination': flight['destination'],
          'departure': flight['departure'],
          'arrival': flight['arrival'],
          'status': flight['status'],
          'date': flight['date'],
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    if (flights.isEmpty) {
      initList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String departureCity = (args?['departureCity'] ?? '').trim().toLowerCase();
    final String arrivalCity = (args?['arrivalCity'] ?? '').trim().toLowerCase();
    final String date = (args?['date'] ?? '').trim();

    final filteredFlights = flights.where((flight) =>
      flight['origin'].toString().trim().toLowerCase() == departureCity &&
      flight['destination'].toString().trim().toLowerCase() == arrivalCity &&
      flight['date'].toString().trim() == date
    ).toList();

     return Scaffold(
      appBar: AppBar(title: Text('Flight Results')),
      body: filteredFlights.isEmpty
          ? Center(child: Text('No flights available for selected criteria'))
          : ListView.builder(
              itemCount: filteredFlights.length,
              itemBuilder: (context, index) {
                final flight = filteredFlights[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Airline: ${flight['airline']}'),
                    subtitle: Text('${flight['origin']} → ${flight['destination']}\nDate: ${flight['date']}\nPrice: \$${flight['price']}'),
                    onTap: () {
                      Navigator.pushNamed(context, '/flight_details', arguments: flight);
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

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Payment'),
          content: Text('Do you want to confirm the payment or pay later?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  paymentStatus = "Confirmed";
                });
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  paymentStatus = "Pending";
                });
                Navigator.of(context).pop();
              },
              child: Text('Pay Later'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentDetails = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

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
              'Airline: ${paymentDetails['airline']}',
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: paymentStatus == "Confirmed" ? Colors.green : Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showConfirmationDialog,
              child: Text('Pay Now'),
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
  List<Map<String, dynamic>> dummyBookings = [
    {'id': '1A2B', 'airline': 'Airline A', 'status': 'Confirmed', 'date': '2025-03-15'},
    {'id': '3C4D', 'airline': 'Airline B', 'status': 'Cancelled', 'date': '2025-03-14'},
  ];

  void cancelBooking(int index) {
    setState(() {
      dummyBookings[index]['status'] = 'Cancelled';
    });
  }

  void showPopup(BuildContext context, String title, String message, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                cancelBooking(index);
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SkyLiner - Booking History')),
      body: dummyBookings.isEmpty
          ? Center(child: Text('No bookings yet!'))
          : ListView.builder(
              itemCount: dummyBookings.length,
              itemBuilder: (context, index) {
                final booking = dummyBookings[index];
                return Card(
                  child: ListTile(
                    title: Text('Airline: ${booking['airline']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Booking ID: ${booking['id']}'),
                        Text('Status: ${booking['status']}'),
                        Text('Booking Date: ${booking['date']}'),
                      ],
                    ),
                    trailing: booking['status'] == 'Confirmed'
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showPopup(
                                context,
                                'Booking Cancelled',
                                'You have cancelled booking for ${booking['airline']}',
                                index,
                              );
                            },
                          )
                        : null, // No delete button if already cancelled
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
  Map<String, String> userProfile = {
    'userID': 'USER12345',
    'name': 'John Doe',
    'email': 'johndoe@example.com',
    'phoneNo': '1234567890',
    'passportNo': 'A1234567',
  };

  void updateProfile(Map<String, String> updatedProfile) {
    setState(() {
      userProfile = updatedProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditPage(
                    userProfile: userProfile,
                    onSave: updateProfile,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: ${userProfile['userID']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Name: ${userProfile['name']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: ${userProfile['email']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Phone Number: ${userProfile['phoneNo']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Passport Number: ${userProfile['passportNo']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class ProfileEditPage extends StatefulWidget {
  final Map<String, String> userProfile;
  final Function(Map<String, String>) onSave;

  ProfileEditPage({required this.userProfile, required this.onSave});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneNoController;
  late TextEditingController passportNoController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userProfile['name']);
    emailController = TextEditingController(text: widget.userProfile['email']);
    phoneNoController = TextEditingController(text: widget.userProfile['phoneNo']);
    passportNoController = TextEditingController(text: widget.userProfile['passportNo']);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    passportNoController.dispose();
    super.dispose();
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
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneNoController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: passportNoController,
              decoration: InputDecoration(labelText: 'Passport Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Map<String, String> updatedProfile = {
                  'userID': widget.userProfile['userID']!,
                  'name': nameController.text,
                  'email': emailController.text,
                  'phoneNo': phoneNoController.text,
                  'passportNo': passportNoController.text,
                };
                widget.onSave(updatedProfile);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}


