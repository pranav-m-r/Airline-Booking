PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE airports (
    airport_id   INTEGER PRIMARY KEY,
    name         TEXT NOT NULL,
    city         TEXT NOT NULL,
    country      TEXT NOT NULL,
    iata_code    TEXT UNIQUE,   -- e.g., JFK
    icao_code    TEXT UNIQUE    -- e.g., KJFK
);
INSERT INTO airports VALUES(1,'John F. Kennedy International Airport','New York','USA','JFK','KJFK');
INSERT INTO airports VALUES(2,'Los Angeles International Airport','Los Angeles','USA','LAX','KLAX');
INSERT INTO airports VALUES(3,'Heathrow Airport','London','UK','LHR','EGLL');
INSERT INTO airports VALUES(4,'Charles de Gaulle Airport','Paris','France','CDG','LFPG');
INSERT INTO airports VALUES(5,'Tokyo International Airport','Tokyo','Japan','HND','RJTT');
INSERT INTO airports VALUES(6,'Frankfurt Airport','Frankfurt','Germany','FRA','EDDF');
INSERT INTO airports VALUES(7,'Dubai International Airport','Dubai','UAE','DXB','OMDB');
INSERT INTO airports VALUES(8,'Singapore Changi Airport','Singapore','Singapore','SIN','WSSS');
INSERT INTO airports VALUES(9,'Sydney Airport','Sydney','Australia','SYD','YSSY');
INSERT INTO airports VALUES(10,'Beijing Capital International Airport','Beijing','China','PEK','ZBAA');
CREATE TABLE airlines (
    airline_id   INTEGER PRIMARY KEY,
    name         TEXT NOT NULL,
    iata_code    TEXT UNIQUE,   -- e.g., AA
    icao_code    TEXT UNIQUE    -- e.g., AAL
);
INSERT INTO airlines VALUES(1,'American Airlines','AA','AAL');
INSERT INTO airlines VALUES(2,'British Airways','BA','BAW');
INSERT INTO airlines VALUES(3,'Air France','AF','AFR');
INSERT INTO airlines VALUES(4,'Japan Airlines','JL','JAL');
INSERT INTO airlines VALUES(5,'Emirates','EK','UAE');
CREATE TABLE flights (
    flight_id              INTEGER PRIMARY KEY,
    flight_number          TEXT NOT NULL,
    airline_id             INTEGER NOT NULL,
    departure_airport_id   INTEGER NOT NULL,
    arrival_airport_id     INTEGER NOT NULL,
    departure_time         TEXT NOT NULL,  -- ISO 8601 format: YYYY-MM-DD HH:MM:SS
    arrival_time           TEXT NOT NULL,  -- ISO 8601 format
    status                 TEXT,           -- e.g., 'On Time', 'Delayed', 'Cancelled'
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id),
    FOREIGN KEY (departure_airport_id) REFERENCES airports(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES airports(airport_id)
);
INSERT INTO flights VALUES(1,'AA100',1,1,2,'2025-04-01 08:00:00','2025-04-01 11:00:00','On Time');
INSERT INTO flights VALUES(2,'BA150',2,3,4,'2025-04-02 09:00:00','2025-04-02 10:30:00','Delayed');
INSERT INTO flights VALUES(3,'AF200',3,4,6,'2025-04-03 07:30:00','2025-04-03 09:30:00','On Time');
INSERT INTO flights VALUES(4,'JL300',4,5,10,'2025-04-04 12:00:00','2025-04-04 15:00:00','Cancelled');
INSERT INTO flights VALUES(5,'EK400',5,7,8,'2025-04-05 14:00:00','2025-04-05 18:00:00','On Time');
INSERT INTO flights VALUES(6,'AA110',1,2,1,'2025-04-06 16:00:00','2025-04-06 23:00:00','On Time');
INSERT INTO flights VALUES(7,'BA160',2,3,7,'2025-04-07 10:00:00','2025-04-07 14:00:00','Delayed');
INSERT INTO flights VALUES(8,'AF210',3,6,4,'2025-04-08 06:45:00','2025-04-08 08:45:00','On Time');
INSERT INTO flights VALUES(9,'JL310',4,10,5,'2025-04-09 11:30:00','2025-04-09 14:30:00','On Time');
INSERT INTO flights VALUES(10,'EK410',5,8,7,'2025-04-10 13:00:00','2025-04-10 17:00:00','Cancelled');
INSERT INTO flights VALUES(11,'AA120',1,1,3,'2025-04-11 07:15:00','2025-04-11 19:00:00','On Time');
INSERT INTO flights VALUES(12,'BA170',2,4,3,'2025-04-12 08:00:00','2025-04-12 09:45:00','On Time');
INSERT INTO flights VALUES(13,'AF220',3,6,7,'2025-04-13 15:30:00','2025-04-13 18:00:00','Delayed');
INSERT INTO flights VALUES(14,'JL320',4,5,8,'2025-04-14 10:30:00','2025-04-14 13:30:00','On Time');
INSERT INTO flights VALUES(15,'EK420',5,7,9,'2025-04-15 20:00:00','2025-04-16 06:00:00','On Time');
INSERT INTO flights VALUES(16,'AA130',1,2,5,'2025-04-16 11:00:00','2025-04-16 19:00:00','Delayed');
INSERT INTO flights VALUES(17,'BA180',2,3,1,'2025-04-17 14:00:00','2025-04-17 22:00:00','On Time');
INSERT INTO flights VALUES(18,'AF230',3,4,10,'2025-04-18 09:15:00','2025-04-18 12:15:00','On Time');
INSERT INTO flights VALUES(19,'JL330',4,5,9,'2025-04-19 07:00:00','2025-04-19 16:00:00','Cancelled');
INSERT INTO flights VALUES(20,'EK430',5,8,10,'2025-04-20 13:30:00','2025-04-20 17:30:00','On Time');
CREATE TABLE users (
    userID TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    isAdmin BOOLEAN NOT NULL
);
INSERT INTO users VALUES('USER001','user1@example.com','password123','John Doe','123-456-7890',0);
INSERT INTO users VALUES('USER002','user2@example.com','securepass','Jane Smith','987-654-3210',0);
INSERT INTO users VALUES('ADMIN001','admin@example.com','admin123','Admin User','111-222-3333',1);
CREATE TABLE bookings (
    bookingID TEXT PRIMARY KEY,
    userID TEXT NOT NULL,     
    flightID TEXT NOT NULL,
    bookingDate TEXT NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (userID) REFERENCES users (userID),
    FOREIGN KEY (flightID) REFERENCES flights (flight_id)
);
INSERT INTO bookings VALUES('B001','USER001','A1B2','2025-03-19','Confirmed');
INSERT INTO bookings VALUES('B002','USER002','C3D4','2025-03-18','Confirmed');
COMMIT;
