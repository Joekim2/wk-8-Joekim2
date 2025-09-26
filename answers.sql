-- Tours and Travel Booking System Database
CREATE DATABASE IF NOT EXISTS travel_booking_system;

USE travel_booking_system;

-- 1.Customers Table
CREATE TABLE
    customers (
        customer_id INT AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        phone VARCHAR(20),
        date_of_birth DATE,
        passport_number VARCHAR(20) UNIQUE,
        address TEXT,
        city VARCHAR(50),
        country VARCHAR(50),
        registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT chk_email_format CHECK (email LIKE '%@%.%')
    );

-- 1.Destinations Table
CREATE TABLE
    destinations (
        destination_id INT AUTO_INCREMENT PRIMARY KEY,
        destination_name VARCHAR(100) NOT NULL,
        country VARCHAR(50) NOT NULL,
        city VARCHAR(50),
        best_time_to_visit VARCHAR(100),
        is_active BOOLEAN DEFAULT TRUE,
        created_date DATETIME DEFAULT CURRENT_TIMESTAMP
    );

-- 3. Tour Packages Table
CREATE TABLE
    tour_packages (
        package_id INT AUTO_INCREMENT PRIMARY KEY,
        package_name VARCHAR(100) NOT NULL,
        destination_id INT NOT NULL,
        duration_days INT NOT NULL,
        price_per_person DECIMAL(10, 2) NOT NULL,
        description TEXT,
        package_type ENUM (
            'Adventure',
            'Cultural',
            'Beach',
            'City Tour',
            'Wildlife',
            'Honeymoon'
        ) NOT NULL,
        max_group_size INT DEFAULT 20,
        is_available BOOLEAN DEFAULT TRUE,
        created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_package_destination FOREIGN KEY (destination_id) REFERENCES destinations (destination_id) ON DELETE RESTRICT,
        CONSTRAINT chk_positive_price CHECK (price_per_person > 0),
        CONSTRAINT chk_positive_duration CHECK (duration_days > 0)
    );

-- 4. Accommodations Table
CREATE TABLE
    accommodations (
        accommodation_id INT AUTO_INCREMENT PRIMARY KEY,
        accommodation_name VARCHAR(100) NOT NULL,
        destination_id INT NOT NULL,
        accommodation_type ENUM ('Hotel', 'Resort', 'Hostel', 'Villa', 'Apartment') NOT NULL,
        star_rating INT CHECK (star_rating BETWEEN 1 AND 5),
        address TEXT,
        contact_email VARCHAR(100),
        contact_phone VARCHAR(20),
        price_per_night DECIMAL(10, 2) NOT NULL,
        is_available BOOLEAN DEFAULT TRUE,
        CONSTRAINT fk_accommodation_destination FOREIGN KEY (destination_id) REFERENCES destinations (destination_id) ON DELETE RESTRICT,
        CONSTRAINT chk_positive_accommodation_price CHECK (price_per_night > 0)
    );

-- 5. Transportation Table
CREATE TABLE
    transportation (
        transport_id INT AUTO_INCREMENT PRIMARY KEY,
        transport_type ENUM ('Flight', 'Bus', 'Train', 'Cruise', 'Car Rental') NOT NULL,
        company_name VARCHAR(100) NOT NULL,
        departure_location VARCHAR(100) NOT NULL,
        arrival_location VARCHAR(100) NOT NULL,
        departure_time DATETIME,
        arrival_time DATETIME,
        price DECIMAL(10, 2) NOT NULL,
        capacity INT NOT NULL,
        is_available BOOLEAN DEFAULT TRUE,
        CONSTRAINT chk_positive_transport_price CHECK (price >= 0),
        CONSTRAINT chk_positive_capacity CHECK (capacity > 0)
    );

-- 5. Create bookings table
CREATE TABLE
    bookings (
        booking_id INT AUTO_INCREMENT PRIMARY KEY,
        customer_id INT NOT NULL,
        package_id INT NOT NULL,
        booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        travel_date DATE NOT NULL,
        number_of_travelers INT NOT NULL DEFAULT 1,
        total_amount DECIMAL(10, 2) NOT NULL,
        booking_status ENUM ('Pending', 'Confirmed', 'Cancelled', 'Completed') DEFAULT 'Pending',
        special_requirements TEXT,
        CONSTRAINT fk_booking_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON DELETE CASCADE,
        CONSTRAINT fk_booking_package FOREIGN KEY (package_id) REFERENCES tour_packages (package_id) ON DELETE RESTRICT,
        CONSTRAINT chk_positive_travelers CHECK (number_of_travelers > 0),
        CONSTRAINT chk_positive_total_amount CHECK (total_amount > 0)
    );

-- 6. Create booking_accommodations table
CREATE TABLE
    booking_accommodations (
        booking_accommodation_id INT AUTO_INCREMENT PRIMARY KEY,
        booking_id INT NOT NULL,
        accommodation_id INT NOT NULL,
        check_in_date DATE NOT NULL,
        check_out_date DATE NOT NULL,
        number_of_rooms INT DEFAULT 1,
        total_accommodation_cost DECIMAL(10, 2) NOT NULL,
        CONSTRAINT fk_ba_booking FOREIGN KEY (booking_id) REFERENCES bookings (booking_id) ON DELETE CASCADE,
        CONSTRAINT fk_ba_accommodation FOREIGN KEY (accommodation_id) REFERENCES accommodations (accommodation_id) ON DELETE RESTRICT,
        CONSTRAINT chk_valid_stay_dates CHECK (check_out_date > check_in_date),
        CONSTRAINT chk_positive_rooms CHECK (number_of_rooms > 0)
    );

-- 7. Create booking_transportation table
CREATE TABLE
    booking_transportation (
        booking_transport_id INT AUTO_INCREMENT PRIMARY KEY,
        booking_id INT NOT NULL,
        transport_id INT NOT NULL,
        departure_date DATE NOT NULL,
        number_of_passengers INT NOT NULL,
        total_transport_cost DECIMAL(10, 2) NOT NULL,
        CONSTRAINT fk_bt_booking FOREIGN KEY (booking_id) REFERENCES bookings (booking_id) ON DELETE CASCADE,
        CONSTRAINT fk_bt_transport FOREIGN KEY (transport_id) REFERENCES transportation (transport_id) ON DELETE RESTRICT,
        CONSTRAINT chk_positive_passengers CHECK (number_of_passengers > 0)
    );

-- 9. Payments Table (One-to-One relationship with Bookings)
CREATE TABLE
    payments (
        payment_id INT AUTO_INCREMENT PRIMARY KEY,
        booking_id INT NOT NULL UNIQUE,
        payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        payment_amount DECIMAL(10, 2) NOT NULL,
        payment_method ENUM (
            'Credit Card',
            'Debit Card',
            'Bank Transfer',
            'PayPal',
            'Cash'
        ) NOT NULL,
        payment_status ENUM ('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
        transaction_id VARCHAR(100) UNIQUE,
        CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES bookings (booking_id) ON DELETE CASCADE,
        CONSTRAINT chk_positive_payment_amount CHECK (payment_amount > 0)
    );

-- 10. Reviews Table
CREATE TABLE
    reviews (
        review_id INT AUTO_INCREMENT PRIMARY KEY,
        customer_id INT NOT NULL,
        package_id INT NOT NULL,
        booking_id INT NOT NULL,
        rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
        review_text TEXT,
        review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        is_approved BOOLEAN DEFAULT FALSE,
        CONSTRAINT fk_review_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON DELETE CASCADE,
        CONSTRAINT fk_review_package FOREIGN KEY (package_id) REFERENCES tour_packages (package_id) ON DELETE CASCADE,
        CONSTRAINT fk_review_booking FOREIGN KEY (booking_id) REFERENCES bookings (booking_id) ON DELETE CASCADE,
        CONSTRAINT uc_review_per_booking UNIQUE (customer_id, booking_id)
    );

-- 11. Tour Guides Table
CREATE TABLE
    tour_guides (
        guide_id INT AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        phone VARCHAR(20),
        specialization VARCHAR(100),
        languages VARCHAR(200),
        hourly_rate DECIMAL(8, 2) NOT NULL,
        is_available BOOLEAN DEFAULT TRUE,
        hire_date DATE,
        CONSTRAINT chk_positive_hourly_rate CHECK (hourly_rate > 0)
    );

-- 12. Package Guides Table (Many-to-Many relationship between Packages and Guides)
CREATE TABLE
    package_guides (
        package_guide_id INT AUTO_INCREMENT PRIMARY KEY,
        package_id INT NOT NULL,
        guide_id INT NOT NULL,
        assignment_date DATE NOT NULL,
        CONSTRAINT fk_pg_package FOREIGN KEY (package_id) REFERENCES tour_packages (package_id) ON DELETE CASCADE,
        CONSTRAINT fk_pg_guide FOREIGN KEY (guide_id) REFERENCES tour_guides (guide_id) ON DELETE CASCADE,
        CONSTRAINT uc_package_guide_assignment UNIQUE (package_id, guide_id, assignment_date)
    );

-- 13. Activities Table
CREATE TABLE
    activities (
        activity_id INT AUTO_INCREMENT PRIMARY KEY,
        activity_name VARCHAR(100) NOT NULL,
        destination_id INT NOT NULL,
        description TEXT,
        duration_hours DECIMAL(4, 2),
        price DECIMAL(8, 2) NOT NULL,
        activity_type ENUM (
            'Sightseeing',
            'Adventure',
            'Cultural',
            'Relaxation'
        ) NOT NULL,
        minimum_age INT DEFAULT 0,
        is_available BOOLEAN DEFAULT TRUE,
        CONSTRAINT fk_activity_destination FOREIGN KEY (destination_id) REFERENCES destinations (destination_id) ON DELETE RESTRICT,
        CONSTRAINT chk_positive_activity_price CHECK (price >= 0),
        CONSTRAINT chk_positive_activity_duration CHECK (duration_hours > 0)
    );

-- 14. Package Activities Table (Many-to-Many relationship)
CREATE TABLE
    package_activities (
        package_activity_id INT AUTO_INCREMENT PRIMARY KEY,
        package_id INT NOT NULL,
        activity_id INT NOT NULL,
        day_number INT NOT NULL,
        start_time TIME,
        included_in_package BOOLEAN DEFAULT TRUE,
        additional_cost DECIMAL(8, 2) DEFAULT 0,
        CONSTRAINT fk_pa_package FOREIGN KEY (package_id) REFERENCES tour_packages (package_id) ON DELETE CASCADE,
        CONSTRAINT fk_pa_activity FOREIGN KEY (activity_id) REFERENCES activities (activity_id) ON DELETE CASCADE,
        CONSTRAINT chk_positive_day_number CHECK (day_number > 0),
        CONSTRAINT uc_activity_schedule UNIQUE (package_id, activity_id, day_number)
    );

-- 15. Emergency Contacts Table (One-to-One relationship with Customers)
CREATE TABLE
    emergency_contacts (
        contact_id INT AUTO_INCREMENT PRIMARY KEY,
        customer_id INT NOT NULL UNIQUE,
        full_name VARCHAR(100) NOT NULL,
        relationship VARCHAR(50) NOT NULL,
        phone VARCHAR(20) NOT NULL,
        email VARCHAR(100),
        address TEXT,
        CONSTRAINT fk_emergency_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON DELETE CASCADE
    );

-- Create Indexes for better performance
CREATE INDEX idx_customers_email ON customers (email);

CREATE INDEX idx_bookings_travel_date ON bookings (travel_date);

CREATE INDEX idx_bookings_status ON bookings (booking_status);

CREATE INDEX idx_packages_destination ON tour_packages (destination_id);

CREATE INDEX idx_payments_status ON payments (payment_status);

CREATE INDEX idx_transport_dates ON transportation (departure_time, arrival_time);

CREATE INDEX idx_accommodations_destination ON accommodations (destination_id);

-- Insert Sample Data (Optional - for testing purposes)
INSERT INTO
    customers (
        first_name,
        last_name,
        email,
        phone,
        passport_number,
        city,
        country
    )
VALUES
    (
        'Joel',
        'Mwangi',
        'joel.mwangi@email.com',
        '+254-111-407-579',
        'P12345678',
        'Nairobi',
        'Kenya'
    ),
    (
        'Stacey',
        'Hensley',
        'stacey.Hensley@email.com',
        '+34-444-0102',
        'P87654321',
        'Madrid',
        'Spain'
    ),
    (
        'Ching',
        'Wei',
        'ching.wei@email.com',
        '+86-555-0103',
        'P11223344',
        'Beijing',
        'China'
    );

INSERT INTO
    destinations (
        destination_name,
        country,
        city,
        best_time_to_visit
    )
VALUES
    (
        'Bali Paradise',
        'Indonesia',
        'Denpasar',
        'April-October'
    ),
    (
        'Swiss Alps',
        'Switzerland',
        'Interlaken',
        'June-September'
    ),
    (
        'Santorini Getaway',
        'Greece',
        'Santorini',
        'May-October'
    );

INSERT INTO
    tour_packages (
        package_name,
        destination_id,
        duration_days,
        price_per_person,
        package_type,
        max_group_size
    )
VALUES
    (
        'Bali Cultural Experience',
        1,
        7,
        1200.00,
        'Cultural',
        15
    ),
    (
        'Alpine Adventure',
        2,
        5,
        1500.00,
        'Adventure',
        10
    ),
    (
        'Greek Island Hopping',
        3,
        10,
        2000.00,
        'Beach',
        20
    );

-- Display table creation confirmation
SELECT
    'Travel Booking System Database created successfully!' AS message;

SELECT
    COUNT(*) AS tables_created
FROM
    information_schema.tables
WHERE
    table_schema = 'travel_booking_system';

SELECT
    *
FROM
    customers;

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    city
FROM
    customers;

-- Sample Query to retrieve Booking Details with Accommodation and Transportation
SELECT
    b.booking_id,
    c.first_name,
    c.last_name,
    p.package_name,
    a.accommodation_name,
    ba.check_in_date,
    ba.check_out_date,
    t.transport_type,
    t.company_name,
    bt.departure_date
FROM
    bookings b
    JOIN customers c ON b.customer_id = c.customer_id
    JOIN tour_packages p ON b.package_id = p.package_id
    LEFT JOIN booking_accommodations ba ON b.booking_id = ba.booking_id
    LEFT JOIN accommodations a ON ba.accommodation_id = a.accommodation_id
    LEFT JOIN booking_transportation bt ON b.booking_id = bt.booking_id
    LEFT JOIN transportation t ON bt.transport_id = t.transport_id
WHERE
    b.booking_status = 'Confirmed'
