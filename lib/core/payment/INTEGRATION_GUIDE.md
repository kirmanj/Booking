# Payment Hub Integration Guide

This guide explains how to integrate any service (Flights, Hotels, Car Rental, Bus Tickets, E-SIM, Home Check-in, Airport Taxi, Tours) with the centralized payment hub.

## Quick Start

### 1. Add Dependencies

In your service's screen where you want to initiate payment, import:

```dart
import 'package:aman_booking/core/payment/domain/entities/payment_request.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_item.dart';
import 'package:aman_booking/core/payment/domain/entities/tax_item.dart';
import 'package:aman_booking/core/payment/domain/entities/service_type.dart';
import 'package:aman_booking/core/payment/presentation/screens/checkout_screen.dart';
```

### 2. Create Payment Request

Build your payment request with service-specific data:

```dart
final paymentRequest = PaymentRequest(
  id: 'unique_payment_id',
  serviceType: ServiceType.flight, // or hotel, carRental, etc.
  serviceName: 'Dubai to London',  // Service-specific name
  serviceIcon: ServiceType.flight.icon,
  items: [
    PaymentItem(
      id: 'item_1',
      title: 'Economy Class Ticket',
      description: '1 Adult, Emirates Flight EK001',
      basePrice: 850.00,
      quantity: 1,
      serviceType: ServiceType.flight,
      metadata: {
        'passenger': 'John Doe',
        'seat': '12A',
        // ... other service-specific data
      },
    ),
    // Add more items as needed
  ],
  subtotal: 850.00,
  taxes: [
    TaxItem(
      id: 'tax_1',
      name: 'Airport Tax',
      amount: 42.50,
      percentage: 0.05,
      isInclusive: false,
    ),
    TaxItem(
      id: 'tax_2',
      name: 'Fuel Surcharge',
      amount: 25.00,
      isInclusive: false,
    ),
  ],
  discountAmount: 0.0,
  convenienceFee: 5.00,
  total: 922.50,
  currency: 'AED',
  serviceMetadata: {
    'flight_number': 'EK001',
    'departure': '2024-01-20',
    // ... any other service-specific data
  },
  createdAt: DateTime.now(),
);
```

### 3. Navigate to Checkout

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CheckoutScreen(
      paymentRequest: paymentRequest,
      onPaymentComplete: (invoice) {
        // Handle successful payment
        // Update your service's booking status
        // Navigate to confirmation screen
        print('Payment completed! Invoice: ${invoice.invoiceNumber}');

        // Example: Navigate to service-specific confirmation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FlightBookingConfirmationScreen(
              invoice: invoice,
            ),
          ),
        );
      },
    ),
  ),
);
```

## Service-Specific Examples

### Flight Service Integration

```dart
// In your flight booking screen
void _proceedToPayment() {
  final paymentRequest = PaymentRequest(
    id: 'FL${DateTime.now().millisecondsSinceEpoch}',
    serviceType: ServiceType.flight,
    serviceName: '${selectedFlight.from} to ${selectedFlight.to}',
    serviceIcon: ServiceType.flight.icon,
    items: [
      PaymentItem(
        id: 'ticket_1',
        title: '${selectedFlight.airline} - ${selectedFlight.flightNumber}',
        description: '${passengers.length} Passenger(s), ${selectedClass}',
        basePrice: selectedFlight.price,
        quantity: passengers.length,
        serviceType: ServiceType.flight,
        metadata: {
          'airline': selectedFlight.airline,
          'flight_number': selectedFlight.flightNumber,
          'passengers': passengers,
          'class': selectedClass,
        },
      ),
      if (selectedBaggage != null)
        PaymentItem(
          id: 'baggage_1',
          title: 'Extra Baggage',
          description: '${selectedBaggage.weight}kg',
          basePrice: selectedBaggage.price,
          quantity: 1,
          serviceType: ServiceType.flight,
        ),
      if (selectedSeats.isNotEmpty)
        PaymentItem(
          id: 'seats_1',
          title: 'Seat Selection',
          description: selectedSeats.join(', '),
          basePrice: seatPrice,
          quantity: selectedSeats.length,
          serviceType: ServiceType.flight,
        ),
    ],
    subtotal: calculateSubtotal(),
    taxes: [
      TaxItem(
        id: 'airport_tax',
        name: 'Airport Tax',
        amount: calculateAirportTax(),
        percentage: 0.05,
      ),
      TaxItem(
        id: 'fuel_surcharge',
        name: 'Fuel Surcharge',
        amount: 25.00,
      ),
    ],
    convenienceFee: 5.00,
    total: calculateTotal(),
    currency: 'AED',
    serviceMetadata: {
      'booking_reference': bookingReference,
      'flight_data': selectedFlight.toJson(),
    },
    createdAt: DateTime.now(),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CheckoutScreen(
        paymentRequest: paymentRequest,
        onPaymentComplete: _handlePaymentComplete,
      ),
    ),
  );
}

void _handlePaymentComplete(Invoice invoice) {
  // Update booking status
  bookingService.confirmBooking(
    bookingReference: bookingReference,
    invoiceNumber: invoice.invoiceNumber,
    transactionId: invoice.transactionId,
  );

  // Navigate to confirmation
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => FlightConfirmationScreen(invoice: invoice),
    ),
  );
}
```

### Hotel Service Integration

```dart
void _proceedToPayment() {
  final nights = checkOut.difference(checkIn).inDays;

  final paymentRequest = PaymentRequest(
    id: 'HT${DateTime.now().millisecondsSinceEpoch}',
    serviceType: ServiceType.hotel,
    serviceName: selectedHotel.name,
    serviceIcon: ServiceType.hotel.icon,
    items: [
      PaymentItem(
        id: 'room_1',
        title: selectedRoom.type,
        description: '$nights nights, ${guests} guests',
        basePrice: selectedRoom.pricePerNight,
        quantity: nights,
        serviceType: ServiceType.hotel,
        metadata: {
          'hotel_id': selectedHotel.id,
          'room_type': selectedRoom.type,
          'check_in': checkIn.toIso8601String(),
          'check_out': checkOut.toIso8601String(),
          'guests': guests,
        },
      ),
      if (includeBreakfast)
        PaymentItem(
          id: 'breakfast',
          title: 'Breakfast',
          description: '$nights days, ${guests} guests',
          basePrice: breakfastPricePerPersonPerDay,
          quantity: nights * guests,
          serviceType: ServiceType.hotel,
        ),
    ],
    subtotal: calculateSubtotal(),
    taxes: [
      TaxItem(
        id: 'tourism_tax',
        name: 'Tourism Tax',
        amount: calculateTourismTax(),
        percentage: 0.10,
      ),
      TaxItem(
        id: 'service_charge',
        name: 'Service Charge',
        amount: calculateServiceCharge(),
        percentage: 0.05,
      ),
    ],
    convenienceFee: 3.00,
    total: calculateTotal(),
    currency: 'AED',
    serviceMetadata: {
      'booking_reference': bookingReference,
      'hotel_data': selectedHotel.toJson(),
    },
    createdAt: DateTime.now(),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CheckoutScreen(
        paymentRequest: paymentRequest,
        onPaymentComplete: _handlePaymentComplete,
      ),
    ),
  );
}
```

### E-SIM Service Integration

```dart
void _proceedToPayment() {
  final paymentRequest = PaymentRequest(
    id: 'ES${DateTime.now().millisecondsSinceEpoch}',
    serviceType: ServiceType.eSim,
    serviceName: selectedPlan.country,
    serviceIcon: ServiceType.eSim.icon,
    items: [
      PaymentItem(
        id: 'esim_1',
        title: selectedPlan.name,
        description: '${selectedPlan.data}, ${selectedPlan.validity} days',
        basePrice: selectedPlan.price,
        quantity: selectedQuantity,
        serviceType: ServiceType.eSim,
        metadata: {
          'plan_id': selectedPlan.id,
          'country': selectedPlan.country,
          'data': selectedPlan.data,
          'validity': selectedPlan.validity,
        },
      ),
    ],
    subtotal: selectedPlan.price * selectedQuantity,
    taxes: [], // E-SIM typically has no additional taxes
    convenienceFee: 0.0,
    total: selectedPlan.price * selectedQuantity,
    currency: 'AED',
    serviceMetadata: {
      'plan_data': selectedPlan.toJson(),
    },
    createdAt: DateTime.now(),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CheckoutScreen(
        paymentRequest: paymentRequest,
        onPaymentComplete: _handlePaymentComplete,
      ),
    ),
  );
}
```

## Important Notes

1. **Service Type**: Always use the correct `ServiceType` enum for your service
2. **Metadata**: Store service-specific data in the `metadata` field of `PaymentItem` and `serviceMetadata` field of `PaymentRequest`
3. **Currency**: Always specify the currency (default: 'AED')
4. **Tax Calculation**: Calculate taxes according to your service's business logic
5. **Invoice Callback**: Always implement `onPaymentComplete` to handle the invoice and update your service's state
6. **Navigation**: After payment, navigate to your service-specific confirmation screen

## Payment Hub Features

The payment hub automatically provides:

- ✅ Multiple payment methods (Credit/Debit Card, Apple Pay, Google Pay, PayPal, Bank Transfer, Cash on Delivery)
- ✅ Promo code application (Demo: use "AMAN10" for 10% discount)
- ✅ Tax breakdown display
- ✅ Customer information collection
- ✅ Payment processing with loading states
- ✅ Invoice generation
- ✅ Error handling
- ✅ Consistent AMAN BOOKING branding across all services

## Testing

For testing purposes, the payment repository has a 95% success rate. To test failure scenarios, make multiple payment attempts.

## Need Help?

Check the example implementations in:
- `/lib/features/flights/` (if implemented)
- `/lib/features/hotels/` (if implemented)
- Or refer to the PAYMENT_HUB_PLAN.md for detailed architecture information
