# 🧳 Travel Booking System Database Documentation

## 📋 Overview
The **Travel Booking System** is a comprehensive relational database designed for tours and travel companies to manage their entire booking operations. This system handles customer information, tour packages, accommodations, transportation, payments, and reviews in an integrated manner.

---

## 🗃️ Database Schema

**Database Name:** `travel_booking_system`

### 📊 Tables Structure (15 Tables)

#### 1. `customers` — Customer Information
- Stores all customer details including personal information and contact details.
- **Primary Key:** `customer_id` (Auto-increment)
- **Unique Constraints:** `email`, `passport_number`
- **Relationships:** One-to-Many with `bookings`, One-to-One with `emergency_contacts`

#### 2. `destinations` — Travel Destinations
- Contains information about available travel destinations worldwide.
- **Primary Key:** `destination_id`
- **Fields:** destination name, country, city, best visiting time, active status

#### 3. `tour_packages` — Tour Package Details
- Stores various tour packages offered by the company.
- **Primary Key:** `package_id`
- **Foreign Key:** `destination_id` → `destinations(destination_id)`
- **Package Types:** Adventure, Cultural, Beach, City Tour, Wildlife, Honeymoon

#### 4. `accommodations` — Hotel/Stay Information
- Manages accommodation options available at different destinations.
- **Primary Key:** `accommodation_id`
- **Types:** Hotel, Resort, Hostel, Villa, Apartment
- **Star Rating:** 1-5 stars

#### 5. `transportation` — Travel Transport Options
- Stores transportation details like flights, buses, trains, etc.
- **Primary Key:** `transport_id`
- **Types:** Flight, Bus, Train, Cruise, Car Rental

#### 6. `bookings` — Main Booking Records
- Core table that tracks all customer bookings.
- **Primary Key:** `booking_id`
- **Foreign Keys:** `customer_id`, `package_id`
- **Status:** Pending, Confirmed, Cancelled, Completed

#### 7. `booking_accommodations` — Booking-Accommodation Junction
- Manages many-to-many relationship between bookings and accommodations.
- **Primary Key:** `booking_accommodation_id`
- **Foreign Keys:** `booking_id`, `accommodation_id`

#### 8. `booking_transportation` — Booking-Transportation Junction
- Manages many-to-many relationship between bookings and transportation.
- **Primary Key:** `booking_transport_id`
- **Foreign Keys:** `booking_id`, `transport_id`

#### 9. `payments` — Payment Information
- Stores payment details for each booking.
- **Primary Key:** `payment_id`
- **Foreign Key:** `booking_id` (One-to-One relationship)
- **Payment Methods:** Credit Card, Debit Card, Bank Transfer, PayPal, Cash

#### 10. `reviews` — Customer Reviews and Ratings
- Tracks customer feedback for packages and services.
- **Primary Key:** `review_id`
- **Rating System:** 1-5 stars
- **Unique Constraint:** One review per booking per customer

#### 11. `tour_guides` — Tour Guide Information
- Manages tour guide details and availability.
- **Primary Key:** `guide_id`
- **Fields:** Specialization, languages spoken, hourly rate

#### 12. `package_guides` — Package-Guide Assignment
- Junction table for many-to-many relationship between packages and guides.
- **Primary Key:** `package_guide_id`
- **Foreign Keys:** `package_id`, `guide_id`

#### 13. `activities` — Tour Activities
- Stores individual activities available at destinations.
- **Primary Key:** `activity_id`
- **Activity Types:** Sightseeing, Adventure, Cultural, Relaxation

#### 14. `package_activities` — Package-Activity Schedule
- Manages activities included in each package with scheduling information.
- **Primary Key:** `package_activity_id`
- **Foreign Keys:** `package_id`, `activity_id`

#### 15. `emergency_contacts` — Customer Emergency Contacts
- Stores emergency contact information for customers.
- **Primary Key:** `contact_id`
- **Foreign Key:** `customer_id` (One-to-One relationship)

---

## 🔗 Relationships Summary

### One-to-Many Relationships
- `customers` → `bookings` (One customer, many bookings)
- `destinations` → `tour_packages` (One destination, many packages)
- `tour_packages` → `bookings` (One package, many bookings)
- `destinations` → `accommodations` (One destination, many accommodations)
- `destinations` → `activities` (One destination, many activities)

### Many-to-Many Relationships (via junction tables)
- `bookings` ↔ `accommodations` (via `booking_accommodations`)
- `bookings` ↔ `transportation` (via `booking_transportation`)
- `tour_packages` ↔ `activities` (via `package_activities`)
- `tour_packages` ↔ `tour_guides` (via `package_guides`)

### One-to-One Relationships
- `bookings` ↔ `payments` (One booking, one payment)
- `customers` ↔ `emergency_contacts` (One customer, one emergency contact)

---

## ✅ Constraints Implemented

- **Primary Key Constraints:** Unique identifier for each table; auto-increment on ID columns
- **Foreign Key Constraints:** Maintains referential integrity between related tables; uses `ON DELETE CASCADE/RESTRICT` for data protection
- **Check Constraints:**
  - Email format validation (`email LIKE '%@%.%'`)
  - Positive price and duration checks
  - Valid date ranges (check-out after check-in)
  - Rating range validation (1-5 stars)
  - Star rating validation (1-5)
  - Positive capacity and traveler counts
- **Unique Constraints:** Email addresses, passport numbers, transaction IDs, one review per booking, unique package-guide assignments
- **Not Null Constraints:** Essential fields like names, emails, prices, dates

---

## 🚀 Key Features

### Data Integrity
- Prevents invalid data entry through comprehensive constraints
- Maintains relational consistency across all tables
- Ensures business logic compliance

### Business Logic Enforcement
- Prevents future travel date violations
- Ensures valid accommodation stay dates
- Maintains package availability status
- Tracks booking and payment statuses

### Scalability
- Supports multiple destinations and package types
- Handles complex booking scenarios
- Accommodates business growth

### Performance
- Strategic indexing on frequently queried columns
- Optimized for common search operations
- Efficient relationship management