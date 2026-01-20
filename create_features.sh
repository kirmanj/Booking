#!/bin/bash

# Feature 1: Auth (Pages 1-10)
touch lib/features/1_auth/presentation/screens/splash_screen.dart
touch lib/features/1_auth/presentation/screens/onboarding_page.dart
touch lib/features/1_auth/presentation/screens/language_picker_screen.dart
touch lib/features/1_auth/presentation/screens/currency_picker_screen.dart
touch lib/features/1_auth/presentation/screens/login_screen.dart
touch lib/features/1_auth/presentation/screens/otp_verification_screen.dart
touch lib/features/1_auth/presentation/screens/register_screen.dart
touch lib/features/1_auth/presentation/screens/permissions_screen.dart

touch lib/features/1_auth/presentation/widgets/onboarding_page_widget.dart
touch lib/features/1_auth/presentation/widgets/language_tile.dart
touch lib/features/1_auth/presentation/widgets/currency_tile.dart
touch lib/features/1_auth/presentation/widgets/otp_input_field.dart
touch lib/features/1_auth/presentation/widgets/social_login_button.dart

touch lib/features/1_auth/presentation/bloc/auth_bloc.dart
touch lib/features/1_auth/presentation/bloc/auth_event.dart
touch lib/features/1_auth/presentation/bloc/auth_state.dart
touch lib/features/1_auth/presentation/bloc/language_bloc.dart
touch lib/features/1_auth/presentation/bloc/language_event.dart
touch lib/features/1_auth/presentation/bloc/language_state.dart

touch lib/features/1_auth/data/models/user_model.dart
touch lib/features/1_auth/data/models/auth_response_model.dart
touch lib/features/1_auth/data/repositories/auth_repository.dart
touch lib/features/1_auth/domain/entities/user_entity.dart

# Feature 2: Home (Pages 11-20)
touch lib/features/2_home/presentation/screens/main_home_screen.dart
touch lib/features/2_home/presentation/screens/global_search_screen.dart
touch lib/features/2_home/presentation/screens/offers_screen.dart
touch lib/features/2_home/presentation/screens/favorites_screen.dart
touch lib/features/2_home/presentation/screens/notifications_inbox_screen.dart
touch lib/features/2_home/presentation/screens/notification_detail_screen.dart
touch lib/features/2_home/presentation/screens/profile_screen.dart
touch lib/features/2_home/presentation/screens/settings_screen.dart
touch lib/features/2_home/presentation/screens/wallet_screen.dart
touch lib/features/2_home/presentation/screens/booking_history_screen.dart

touch lib/features/2_home/presentation/widgets/service_card.dart
touch lib/features/2_home/presentation/widgets/promo_carousel.dart
touch lib/features/2_home/presentation/widgets/recent_bookings_card.dart
touch lib/features/2_home/presentation/widgets/notification_card.dart
touch lib/features/2_home/presentation/widgets/booking_card.dart

touch lib/features/2_home/presentation/bloc/home_bloc.dart
touch lib/features/2_home/presentation/bloc/home_event.dart
touch lib/features/2_home/presentation/bloc/home_state.dart
touch lib/features/2_home/presentation/bloc/notifications_bloc.dart
touch lib/features/2_home/presentation/bloc/notifications_event.dart
touch lib/features/2_home/presentation/bloc/notifications_state.dart

touch lib/features/2_home/data/models/service_model.dart
touch lib/features/2_home/data/models/promo_model.dart
touch lib/features/2_home/data/models/notification_model.dart
touch lib/features/2_home/data/repositories/home_repository.dart
touch lib/features/2_home/data/repositories/notifications_repository.dart
touch lib/features/2_home/domain/entities/service_entity.dart

# Feature 3: Flights (Pages 21-32)
touch lib/features/3_flights/presentation/screens/flight_search_screen.dart
touch lib/features/3_flights/presentation/screens/flight_results_screen.dart
touch lib/features/3_flights/presentation/screens/flight_filters_screen.dart
touch lib/features/3_flights/presentation/screens/flight_compare_screen.dart
touch lib/features/3_flights/presentation/screens/flight_details_screen.dart
touch lib/features/3_flights/presentation/screens/passenger_details_screen.dart
touch lib/features/3_flights/presentation/screens/flight_addons_screen.dart
touch lib/features/3_flights/presentation/screens/flight_review_screen.dart
touch lib/features/3_flights/presentation/screens/flight_payment_screen.dart
touch lib/features/3_flights/presentation/screens/flight_confirmation_screen.dart
touch lib/features/3_flights/presentation/screens/manage_flight_booking_screen.dart
touch lib/features/3_flights/presentation/screens/flight_status_tracker_screen.dart

touch lib/features/3_flights/presentation/widgets/flight_search_form.dart
touch lib/features/3_flights/presentation/widgets/flight_card.dart
touch lib/features/3_flights/presentation/widgets/flight_filter_widget.dart
touch lib/features/3_flights/presentation/widgets/passenger_form.dart
touch lib/features/3_flights/presentation/widgets/seat_selection_widget.dart
touch lib/features/3_flights/presentation/widgets/flight_timeline.dart

touch lib/features/3_flights/presentation/bloc/flight_search_bloc.dart
touch lib/features/3_flights/presentation/bloc/flight_search_event.dart
touch lib/features/3_flights/presentation/bloc/flight_search_state.dart
touch lib/features/3_flights/presentation/bloc/flight_booking_bloc.dart
touch lib/features/3_flights/presentation/bloc/flight_booking_event.dart
touch lib/features/3_flights/presentation/bloc/flight_booking_state.dart

touch lib/features/3_flights/data/models/flight_model.dart
touch lib/features/3_flights/data/models/passenger_model.dart
touch lib/features/3_flights/data/models/flight_search_params_model.dart
touch lib/features/3_flights/data/models/flight_booking_model.dart
touch lib/features/3_flights/data/repositories/flights_repository.dart
touch lib/features/3_flights/domain/entities/flight_entity.dart
touch lib/features/3_flights/domain/entities/passenger_entity.dart

# Feature 4: Hotels (Pages 33-44)
touch lib/features/4_hotels/presentation/screens/hotel_search_screen.dart
touch lib/features/4_hotels/presentation/screens/hotel_results_screen.dart
touch lib/features/4_hotels/presentation/screens/hotel_map_view_screen.dart
touch lib/features/4_hotels/presentation/screens/hotel_filters_screen.dart
touch lib/features/4_hotels/presentation/screens/hotel_details_screen.dart
touch lib/features/4_hotels/presentation/screens/room_selection_screen.dart
touch lib/features/4_hotels/presentation/screens/guest_details_screen.dart
touch lib/features/4_hotels/presentation/screens/hotel_review_payment_screen.dart
touch lib/features/4_hotels/presentation/screens/hotel_confirmation_screen.dart
touch lib/features/4_hotels/presentation/screens/manage_hotel_booking_screen.dart
touch lib/features/4_hotels/presentation/screens/hotel_reviews_list_screen.dart
touch lib/features/4_hotels/presentation/screens/saved_hotels_screen.dart

touch lib/features/4_hotels/presentation/widgets/hotel_search_form.dart
touch lib/features/4_hotels/presentation/widgets/hotel_card.dart
touch lib/features/4_hotels/presentation/widgets/hotel_map_widget.dart
touch lib/features/4_hotels/presentation/widgets/room_card.dart
touch lib/features/4_hotels/presentation/widgets/amenity_icon.dart
touch lib/features/4_hotels/presentation/widgets/review_card.dart

touch lib/features/4_hotels/presentation/bloc/hotel_search_bloc.dart
touch lib/features/4_hotels/presentation/bloc/hotel_search_event.dart
touch lib/features/4_hotels/presentation/bloc/hotel_search_state.dart
touch lib/features/4_hotels/presentation/bloc/hotel_booking_bloc.dart
touch lib/features/4_hotels/presentation/bloc/hotel_booking_event.dart
touch lib/features/4_hotels/presentation/bloc/hotel_booking_state.dart

touch lib/features/4_hotels/data/models/hotel_model.dart
touch lib/features/4_hotels/data/models/room_model.dart
touch lib/features/4_hotels/data/models/hotel_search_params_model.dart
touch lib/features/4_hotels/data/models/hotel_booking_model.dart
touch lib/features/4_hotels/data/repositories/hotels_repository.dart
touch lib/features/4_hotels/domain/entities/hotel_entity.dart
touch lib/features/4_hotels/domain/entities/room_entity.dart

# Feature 5: Cars (Pages 45-55)
touch lib/features/5_cars/presentation/screens/car_search_screen.dart
touch lib/features/5_cars/presentation/screens/car_results_screen.dart
touch lib/features/5_cars/presentation/screens/car_filters_screen.dart
touch lib/features/5_cars/presentation/screens/car_details_screen.dart
touch lib/features/5_cars/presentation/screens/car_extras_insurance_screen.dart
touch lib/features/5_cars/presentation/screens/driver_documents_screen.dart
touch lib/features/5_cars/presentation/screens/car_review_payment_screen.dart
touch lib/features/5_cars/presentation/screens/car_confirmation_screen.dart
touch lib/features/5_cars/presentation/screens/manage_car_booking_screen.dart
touch lib/features/5_cars/presentation/screens/damage_report_screen.dart
touch lib/features/5_cars/presentation/screens/car_invoice_screen.dart

touch lib/features/5_cars/presentation/widgets/car_search_form.dart
touch lib/features/5_cars/presentation/widgets/car_card.dart
touch lib/features/5_cars/presentation/widgets/car_specs_widget.dart
touch lib/features/5_cars/presentation/widgets/extra_item_toggle.dart
touch lib/features/5_cars/presentation/widgets/document_upload_widget.dart

touch lib/features/5_cars/presentation/bloc/car_search_bloc.dart
touch lib/features/5_cars/presentation/bloc/car_search_event.dart
touch lib/features/5_cars/presentation/bloc/car_search_state.dart
touch lib/features/5_cars/presentation/bloc/car_booking_bloc.dart
touch lib/features/5_cars/presentation/bloc/car_booking_event.dart
touch lib/features/5_cars/presentation/bloc/car_booking_state.dart

touch lib/features/5_cars/data/models/car_model.dart
touch lib/features/5_cars/data/models/car_search_params_model.dart
touch lib/features/5_cars/data/models/car_booking_model.dart
touch lib/features/5_cars/data/repositories/cars_repository.dart
touch lib/features/5_cars/domain/entities/car_entity.dart

# Feature 6: Buses (Pages 56-63)
touch lib/features/6_buses/presentation/screens/bus_search_screen.dart
touch lib/features/6_buses/presentation/screens/bus_results_screen.dart
touch lib/features/6_buses/presentation/screens/bus_seat_selection_screen.dart
touch lib/features/6_buses/presentation/screens/bus_passenger_details_screen.dart
touch lib/features/6_buses/presentation/screens/bus_review_payment_screen.dart
touch lib/features/6_buses/presentation/screens/bus_ticket_screen.dart
touch lib/features/6_buses/presentation/screens/manage_bus_booking_screen.dart
touch lib/features/6_buses/presentation/screens/bus_route_details_screen.dart

touch lib/features/6_buses/presentation/widgets/bus_search_form.dart
touch lib/features/6_buses/presentation/widgets/bus_card.dart
touch lib/features/6_buses/presentation/widgets/seat_map_widget.dart
touch lib/features/6_buses/presentation/widgets/bus_ticket_qr_widget.dart

touch lib/features/6_buses/presentation/bloc/bus_search_bloc.dart
touch lib/features/6_buses/presentation/bloc/bus_search_event.dart
touch lib/features/6_buses/presentation/bloc/bus_search_state.dart
touch lib/features/6_buses/presentation/bloc/bus_booking_bloc.dart
touch lib/features/6_buses/presentation/bloc/bus_booking_event.dart
touch lib/features/6_buses/presentation/bloc/bus_booking_state.dart

touch lib/features/6_buses/data/models/bus_model.dart
touch lib/features/6_buses/data/models/bus_seat_model.dart
touch lib/features/6_buses/data/models/bus_booking_model.dart
touch lib/features/6_buses/data/repositories/buses_repository.dart
touch lib/features/6_buses/domain/entities/bus_entity.dart

# Feature 7: Tours (Pages 64-72)
touch lib/features/7_tours/presentation/screens/tours_browse_screen.dart
touch lib/features/7_tours/presentation/screens/tour_results_screen.dart
touch lib/features/7_tours/presentation/screens/tour_filters_screen.dart
touch lib/features/7_tours/presentation/screens/tour_details_screen.dart
touch lib/features/7_tours/presentation/screens/tour_availability_screen.dart
touch lib/features/7_tours/presentation/screens/tour_participants_screen.dart
touch lib/features/7_tours/presentation/screens/tour_addons_screen.dart
touch lib/features/7_tours/presentation/screens/tour_review_payment_screen.dart
touch lib/features/7_tours/presentation/screens/tour_confirmation_screen.dart

touch lib/features/7_tours/presentation/widgets/tour_card.dart
touch lib/features/7_tours/presentation/widgets/tour_itinerary_widget.dart
touch lib/features/7_tours/presentation/widgets/availability_calendar.dart
touch lib/features/7_tours/presentation/widgets/tour_category_chip.dart

touch lib/features/7_tours/presentation/bloc/tours_bloc.dart
touch lib/features/7_tours/presentation/bloc/tours_event.dart
touch lib/features/7_tours/presentation/bloc/tours_state.dart
touch lib/features/7_tours/presentation/bloc/tour_booking_bloc.dart
touch lib/features/7_tours/presentation/bloc/tour_booking_event.dart
touch lib/features/7_tours/presentation/bloc/tour_booking_state.dart

touch lib/features/7_tours/data/models/tour_model.dart
touch lib/features/7_tours/data/models/tour_itinerary_model.dart
touch lib/features/7_tours/data/models/tour_booking_model.dart
touch lib/features/7_tours/data/repositories/tours_repository.dart
touch lib/features/7_tours/domain/entities/tour_entity.dart

echo "Features 1-7 created!"
