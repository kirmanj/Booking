# Quick Start Guide - Aman Booking

## Get Started in 3 Minutes! 🚀

### Step 1: Create Flutter Project (30 seconds)
```bash
flutter create aman_booking
cd aman_booking
```

### Step 2: Copy Files (30 seconds)
1. Delete the default `lib` folder in your project
2. Copy the entire `lib` folder from this starter code
3. Copy `pubspec.yaml` to your project root

### Step 3: Get Dependencies (30 seconds)
```bash
flutter pub get
```

### Step 4: Run the App (30 seconds)
```bash
flutter run
```

That's it! Your app is running! 🎉

---

## What You'll See

### Home Screen
✅ Beautiful AMAN BOOKING logo  
✅ Search bar  
✅ 6 Service cards (Flights, Hotels, Cars, Tours, Bus, E-SIM)  
✅ 3 Special offer cards with gradients  
✅ 4 Popular destination cards  
✅ 2 Quick action buttons  

### Bottom Navigation
✅ Home - Main screen (working)  
✅ Favorites - Placeholder screen  
✅ Bookings - Placeholder screen  
✅ Profile - Menu items screen  
✅ Support - FAQ and contact screen  

---

## File Structure

```
lib/
├── main.dart                    # App starts here
├── app.dart                     # Theme and routing
├── core/
│   ├── constants/
│   │   └── app_colors.dart     # Brand colors
│   └── navigation/
│       └── main_navigation.dart # Bottom nav
└── features/
    ├── home/                    # ✨ Main home screen
    ├── favorites/               # Placeholder
    ├── bookings/                # Placeholder
    ├── profile/                 # Menu screen
    └── support/                 # FAQ screen
```

---

## Key Features

### 🎨 Design
- Yellow primary color (#FFB800) from your logo
- White background with grey accents
- Modern card designs with shadows
- Smooth gradients
- Material 3 design

### 🧭 Navigation
- 5-tab bottom navigation
- State preservation
- Smooth transitions

### 📱 Home Screen
- Scrollable content
- Service cards grid
- Offers carousel
- Destination cards
- Search functionality (UI only)

---

## Customize It!

### Change Colors
Edit: `lib/core/constants/app_colors.dart`

```dart
static const Color primary = Color(0xFFFFB800); // Your color
```

### Add More Services
Edit: `lib/features/home/presentation/screens/home_screen.dart`

Find `GridView.count` section and add more `_buildServiceCard()` calls.

### Change Offers
Edit the `offers` list in `_buildOfferCard()` method.

### Add Destinations
Edit the `destinations` list in `_buildDestinationCard()` method.

---

## Next Steps

### Immediate (1-2 hours)
1. ✅ App is running
2. 🔲 Add real images (replace emojis)
3. 🔲 Connect service cards to navigation
4. 🔲 Implement search function

### Short Term (1-2 days)
1. 🔲 Add authentication screens
2. 🔲 Create flight search screen
3. 🔲 Create hotel search screen
4. 🔲 Add booking flow

### Long Term (1-2 weeks)
1. 🔲 Implement all 160 screens
2. 🔲 Add state management (BLoC)
3. 🔲 Integrate Firebase
4. 🔲 Add payment gateway
5. 🔲 Add notifications
6. 🔲 Multi-language support

---

## Troubleshooting

### Error: "Cannot find main.dart"
**Solution**: Make sure you copied all files to the `lib` folder.

### Error: "Target of URI doesn't exist"
**Solution**: Check that all import paths are correct. Run `flutter clean` then `flutter pub get`.

### Colors not showing correctly
**Solution**: Hot restart the app (press R R in terminal) instead of hot reload.

### Bottom nav not working
**Solution**: Make sure you copied `main_navigation.dart` to `lib/core/navigation/`.

---

## Tips

💡 **Hot Reload**: Press `r` to hot reload after UI changes  
💡 **Hot Restart**: Press `R` to restart app after adding new files  
💡 **Clear Cache**: Run `flutter clean` if you have issues  
💡 **Check Imports**: Make sure all import paths start with correct path  

---

## Resources

📚 **Flutter Docs**: https://flutter.dev/docs  
🎨 **Material Design**: https://m3.material.io  
💬 **Flutter Community**: https://flutter.dev/community  

---

## Need Help?

1. Check the README.md for detailed documentation
2. Review the code comments in each file
3. Flutter Doctor: `flutter doctor` to check setup
4. Clean build: `flutter clean && flutter pub get`

---

**Happy Coding! 🚀**

Built with ❤️ using Flutter
