# Quick Reference: Add Support Buttons to Remaining Screens

This document provides the exact code to add support buttons to the remaining feature screens.

---

## Tours Feature

### File: `lib/features/tours/presentation/screens/tour_booking_screen.dart`

**1. Add imports at the top:**
```dart
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';
```

**2. Find the AppBar and add actions:**
```dart
appBar: AppBar(
  // ... existing properties ...
  actions: const [
    SupportButton(
      category: SupportCategory.tours,
      color: AppColors.textPrimary, // Adjust color based on your AppBar background
    ),
    SizedBox(width: 8),
  ],
),
```

---

## Bus Tickets Feature

### File: `lib/features/bus_tickets/presentation/screens/bus_seat_selection_screen.dart`

**1. Add imports:**
```dart
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';
```

**2. Add to AppBar:**
```dart
appBar: AppBar(
  // ... existing properties ...
  actions: const [
    SupportButton(
      category: SupportCategory.busTickets,
      color: AppColors.textPrimary,
    ),
    SizedBox(width: 8),
  ],
),
```

### File: `lib/features/bus_tickets/presentation/screens/bus_trip_details_screen.dart`

Same as above - add imports and actions to AppBar.

---

## E-SIM Feature

### File: `lib/features/esim/presentation/screens/e_sim_checkout_screen.dart`

**1. Add imports:**
```dart
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';
```

**2. Add to AppBar:**
```dart
appBar: AppBar(
  // ... existing properties ...
  actions: const [
    SupportButton(
      category: SupportCategory.eSim,
      color: AppColors.textPrimary,
    ),
    SizedBox(width: 8),
  ],
),
```

### File: `lib/features/esim/presentation/screens/e_sim_package_detail_screen.dart`

Same pattern - add imports and actions.

---

## Airport Taxi Feature

### File: `lib/features/airport_taxi/presentation/screens/booking_confirmation_screen.dart`

**1. Add imports:**
```dart
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';
```

**2. Add to AppBar:**
```dart
appBar: AppBar(
  // ... existing properties ...
  actions: const [
    SupportButton(
      category: SupportCategory.airportTaxi,
      color: AppColors.textPrimary,
    ),
    SizedBox(width: 8),
  ],
),
```

### File: `lib/features/airport_taxi/presentation/screens/taxi_tracking_screen.dart`

Same pattern - add imports and actions.

---

## Home Check-In Feature

### File: `lib/features/home_checkin/presentation/screens/booking_form_screen.dart`

**1. Add imports:**
```dart
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';
```

**2. Add to AppBar:**
```dart
appBar: AppBar(
  // ... existing properties ...
  actions: const [
    SupportButton(
      category: SupportCategory.homeCheckin,
      color: AppColors.textPrimary,
    ),
    SizedBox(width: 8),
  ],
),
```

### File: `lib/features/home_checkin/presentation/screens/boarding_pass_screen.dart`

Same pattern - add imports and actions.

---

## General Pattern for SliverAppBar

If the screen uses `SliverAppBar` instead of `AppBar`:

```dart
SliverAppBar(
  // ... existing properties ...
  actions: const [
    SupportButton(
      category: SupportCategory.yourCategory,
      color: AppColors.textPrimary, // or Colors.white
    ),
    SizedBox(width: 8),
  ],
)
```

---

## Support Categories Reference

Use the appropriate category for each feature:

- `SupportCategory.flights` - Flight bookings
- `SupportCategory.hotels` - Hotel reservations
- `SupportCategory.carRental` - Car rental services
- `SupportCategory.tours` - Tour packages
- `SupportCategory.busTickets` - Bus tickets
- `SupportCategory.eSim` - E-SIM services
- `SupportCategory.airportTaxi` - Airport taxi
- `SupportCategory.homeCheckin` - Home check-in
- `SupportCategory.payment` - Payment issues
- `SupportCategory.general` - General inquiries

---

## Color Options

Adjust the button color based on your AppBar background:

- **White/Light AppBar:** `color: AppColors.textPrimary`
- **Dark/Colored AppBar:** `color: Colors.white`
- **Transparent/Gradient AppBar:** Test both and choose

---

## Testing After Adding

After adding the support button, test:
1. Button appears in AppBar ✓
2. Clicking opens Create Ticket screen ✓
3. Category is pre-selected correctly ✓
4. Ticket creation works ✓
5. Navigation back works ✓

---

## Complete Example

Here's a complete example for a typical screen:

```dart
import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
// ... other imports ...

// ADD THESE IMPORTS:
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class MyFeatureScreen extends StatelessWidget {
  const MyFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Feature',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        // ADD THESE ACTIONS:
        actions: const [
          SupportButton(
            category: SupportCategory.tours, // Change to your category
            color: AppColors.textPrimary,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: YourScreenContent(),
    );
  }
}
```

---

That's it! Copy the pattern and apply it to each remaining screen. The support button will automatically:
- Open the Create Ticket screen
- Pre-select the correct category
- Allow users to create support tickets specific to that feature
