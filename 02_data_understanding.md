# Data Understanding

## Data source
The dataset represents booking and customer data from an online tourism platform.
The data was obtained from a publicly available dataset and adapted to simulate a real business environment.

## Tables overview
The analysis is based on the following tables:
- customers
- bookings
- payments (or revenue)
- channels

## Key columns
### customers
- customer_id
- country
- customer_segment
- signup_date

### bookings
- booking_id
- customer_id
- booking_date
- channel
- booking_value

## Data assumptions
- Each booking represents one transaction
- Revenue equals booking_value
- One customer can have multiple bookings

## Data quality notes
- No missing customer_id values
- Booking dates span 12 months
- Some customers appear multiple times due to repeat bookings
