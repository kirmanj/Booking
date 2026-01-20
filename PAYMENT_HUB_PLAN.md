# Centralized Payment Hub - Implementation Plan

## Overview
Create a unified payment, checkout, and invoice system that all services (Flights, Hotels, Car Rental, Bus Tickets, E-SIM, Home Check-in, Airport Taxi, Tours) can use instead of having separate payment screens.

## Architecture

### Core Structure
```
lib/core/payment/
├── domain/
│   ├── entities/
│   │   ├── payment_item.dart          # Individual line items
│   │   ├── payment_request.dart       # Complete payment request
│   │   ├── invoice.dart                # Invoice data model
│   │   └── payment_result.dart        # Payment completion result
│   └── repositories/
│       └── payment_repository.dart     # Abstract payment repository
├── data/
│   ├── models/
│   │   └── payment_models.dart        # Data models
│   └── repositories/
│       └── payment_repository_impl.dart
├── presentation/
│   ├── bloc/
│   │   ├── payment_bloc.dart
│   │   ├── payment_event.dart
│   │   └── payment_state.dart
│   └── screens/
│       ├── checkout_screen.dart        # Main checkout screen
│       ├── payment_method_screen.dart  # Payment method selection
│       └── invoice_screen.dart         # Final invoice/receipt
└── widgets/
    ├── payment_summary_card.dart
    ├── payment_item_row.dart
    ├── tax_breakdown_widget.dart
    └── payment_method_tile.dart
```

## Data Models

### 1. PaymentItem
Represents a single line item in the payment
```dart
class PaymentItem {
  final String id;
  final String title;
  final String description;
  final double basePrice;
  final int quantity;
  final ServiceType serviceType;
  final Map<String, dynamic> metadata; // Service-specific data

  double get total => basePrice * quantity;
}
```

### 2. PaymentRequest
Complete payment request from any service
```dart
class PaymentRequest {
  final String id;
  final ServiceType serviceType;
  final String serviceName;          // "AMAN BOOKING Flight Service"
  final String serviceIcon;          // Icon for the service
  final List<PaymentItem> items;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double convenienceFee;
  final double total;
  final String currency;
  final Map<String, dynamic> serviceMetadata;
  final DateTime createdAt;
}
```

### 3. ServiceType (Enum)
```dart
enum ServiceType {
  flight,
  hotel,
  carRental,
  busTic ket,
  eSim,
  homeCheckin,
  airportTaxi,
  tour
}
```

### 4. Invoice
Final invoice after payment
```dart
class Invoice {
  final String invoiceNumber;
  final DateTime issueDate;
  final PaymentRequest paymentRequest;
  final PaymentMethod paymentMethod;
  final String transactionId;
  final PaymentStatus status;
  final String customerName;
  final String customerEmail;
}
```

## Service-Specific Integration

### Each Service Needs To:

1. **Create PaymentRequest**
   - Build PaymentItem list with service-specific data
   - Calculate subtotal, taxes, fees
   - Package metadata for invoice generation

2. **Navigate to Checkout**
   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (_) => CheckoutScreen(
         paymentRequest: paymentRequest,
         onPaymentComplete: (invoice) {
           // Handle success - navigate to service-specific confirmation
         },
       ),
     ),
   );
   ```

3. **Handle Payment Result**
   - Receive invoice with transaction details
   - Update service-specific booking status
   - Navigate to service-specific success screen

## Checkout Screen Features

### 1. Service Header
- Display service name with icon
- Show "AMAN BOOKING [Service Name]"
- Service-specific accent color

### 2. Items Breakdown
- List all payment items
- Show quantity × unit price
- Display descriptions

### 3. Price Summary
- Subtotal
- Taxes (broken down by type if needed)
- Convenience fee
- Discounts (if applicable)
- **Total** (prominent)

### 4. Payment Methods
- Credit/Debit Card
- Apple Pay
- Google Pay
- PayPal
- Bank Transfer
- Cash on Delivery (for applicable services)

### 5. Additional Fields (Service-Specific)
- Customer contact information
- Special instructions
- Promo code input

## Tax Calculation Strategy

### By Service Type:
- **Flight**: Airport tax, fuel surcharge, service fee
- **Hotel**: Tourism tax (varies by location), service charge
- **Car Rental**: VAT, insurance fee
- **Bus**: Standard VAT
- **E-SIM**: No additional taxes (included in price)
- **Home Check-in**: Service fee only
- **Airport Taxi**: Standard VAT
- **Tour**: Tourism tax, guide fee

### Configurable Tax System:
```dart
class TaxConfiguration {
  final ServiceType serviceType;
  final List<TaxRule> rules;

  double calculateTax(double subtotal, Map<String, dynamic> context);
}

class TaxRule {
  final String name;           // "VAT", "Tourism Tax"
  final double percentage;     // 0.05 for 5%
  final double? fixedAmount;   // Optional fixed amount
  final bool isInclusive;      // Already included in price
}
```

## Invoice Screen Features

### 1. Header
- "AMAN BOOKING" branding
- Invoice number
- Date & time
- Service type badge

### 2. Service Details
- Service-specific information
- Booking reference
- Customer information

### 3. Itemized Billing
- All line items
- Tax breakdown
- Payment method used
- Transaction ID

### 4. Actions
- Download PDF
- Email invoice
- Print
- Share

### 5. Footer
- Company information
- Support contact
- Terms & conditions link

## Implementation Steps

### Phase 1: Core Payment System (Week 1)
1. Create directory structure
2. Implement data models
3. Create payment repository
4. Build payment BLoC
5. Create base checkout screen UI

### Phase 2: Service Integration (Week 2)
1. Update Flights to use payment hub
2. Update Hotels to use payment hub
3. Update Car Rental to use payment hub
4. Update Bus Tickets to use payment hub

### Phase 3: Remaining Services (Week 3)
1. Update E-SIM to use payment hub
2. Update Home Check-in to use payment hub
3. Update Airport Taxi to use payment hub
4. Update Tours to use payment hub

### Phase 4: Polish & Testing (Week 4)
1. Add animations and transitions
2. Implement PDF generation
3. Add payment method integrations
4. Test all service flows
5. Handle edge cases

## Service-Specific Adaptations

### Flights
- Display passenger names
- Show flight details (route, time, airline)
- Include baggage fees as separate items
- Seat selection fees

### Hotels
- Show room type and dates
- Number of guests
- Meal plan charges
- Extra services (spa, parking)

### Car Rental
- Vehicle details
- Rental period
- Insurance options
- Additional driver fees
- Fuel policy charges

### Bus Tickets
- Route information
- Seat numbers
- Passenger details
- Luggage fees (if applicable)

### E-SIM
- Country/region
- Data plan details
- Validity period
- Multiple SIM discounts

### Home Check-in
- Flight information
- Number of bags
- Service address
- Special handling fees

### Airport Taxi
- Pickup/dropoff locations
- Vehicle type
- Distance/time estimate
- Toll charges

### Tours
- Tour name and duration
- Number of participants
- Date and time
- Optional add-ons (meals, photos)

## Benefits of Centralized System

1. **Consistency**: Same UX across all services
2. **Maintainability**: Update payment logic in one place
3. **Compliance**: Easier to manage payment regulations
4. **Analytics**: Centralized payment tracking
5. **Features**: Add new payment methods once, available everywhere
6. **Testing**: Test payment flows once
7. **Branding**: Consistent AMAN BOOKING experience

## Next Steps

1. Review and approve this plan
2. Create base payment hub structure
3. Implement one service integration as pilot
4. Gather feedback
5. Roll out to remaining services

## Notes

- Keep service-specific logic minimal in payment hub
- Use metadata extensively for flexibility
- Ensure backward compatibility during migration
- Consider A/B testing new checkout flow
- Plan for internationalization (multiple currencies, languages)
