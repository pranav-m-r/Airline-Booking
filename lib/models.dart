class Flight {
  final int id;
  final String name;
  final String origin;
  final String destination;
  final double price;

  Flight({required this.id, required this.name, required this.origin, required this.destination, required this.price});

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "origin": origin, "destination": destination, "price": price};
  }
}

class Booking {
  final int id;
  final String userId;
  final int flightId;
  final String status;

  Booking({required this.id, required this.userId, required this.flightId, required this.status});

  Map<String, dynamic> toMap() {
    return {"id": id, "userId": userId, "flightId": flightId, "status": status};
  }
}
