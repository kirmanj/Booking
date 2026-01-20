#!/bin/bash

# Feature 8: Home Check-in (Pages 73-78)
touch lib/features/8_home_checkin/presentation/screens/home_checkin_info_screen.dart
touch lib/features/8_home_checkin/presentation/screens/home_checkin_booking_screen.dart
touch lib/features/8_home_checkin/presentation/screens/checkin_checklist_screen.dart
touch lib/features/8_home_checkin/presentation/screens/home_checkin_tracking_screen.dart
touch lib/features/8_home_checkin/presentation/screens/checkin_agent_chat_screen.dart
touch lib/features/8_home_checkin/presentation/screens/checkin_complete_screen.dart

touch lib/features/8_home_checkin/presentation/widgets/checkin_timeline.dart
touch lib/features/8_home_checkin/presentation/widgets/document_upload.dart
touch lib/features/8_home_checkin/presentation/widgets/tracking_map_widget.dart
touch lib/features/8_home_checkin/presentation/widgets/agent_info_card.dart

touch lib/features/8_home_checkin/presentation/bloc/home_checkin_bloc.dart
touch lib/features/8_home_checkin/presentation/bloc/home_checkin_event.dart
touch lib/features/8_home_checkin/presentation/bloc/home_checkin_state.dart
touch lib/features/8_home_checkin/presentation/bloc/tracking_bloc.dart
touch lib/features/8_home_checkin/presentation/bloc/tracking_event.dart
touch lib/features/8_home_checkin/presentation/bloc/tracking_state.dart

touch lib/features/8_home_checkin/data/models/checkin_booking_model.dart
touch lib/features/8_home_checkin/data/models/agent_model.dart
touch lib/features/8_home_checkin/data/repositories/home_checkin_repository.dart
touch lib/features/8_home_checkin/domain/entities/checkin_entity.dart

# Feature 9: E-SIM (Pages 79-84)
touch lib/features/9_esim/presentation/screens/esim_country_select_screen.dart
touch lib/features/9_esim/presentation/screens/esim_plans_screen.dart
touch lib/features/9_esim/presentation/screens/esim_plan_details_screen.dart
touch lib/features/9_esim/presentation/screens/esim_checkout_screen.dart
touch lib/features/9_esim/presentation/screens/esim_qr_guide_screen.dart
touch lib/features/9_esim/presentation/screens/my_esims_screen.dart

touch lib/features/9_esim/presentation/widgets/country_tile.dart
touch lib/features/9_esim/presentation/widgets/esim_plan_card.dart
touch lib/features/9_esim/presentation/widgets/qr_code_widget.dart
touch lib/features/9_esim/presentation/widgets/install_guide_widget.dart

touch lib/features/9_esim/presentation/bloc/esim_bloc.dart
touch lib/features/9_esim/presentation/bloc/esim_event.dart
touch lib/features/9_esim/presentation/bloc/esim_state.dart

touch lib/features/9_esim/data/models/esim_plan_model.dart
touch lib/features/9_esim/data/models/esim_purchase_model.dart
touch lib/features/9_esim/data/models/country_model.dart
touch lib/features/9_esim/data/repositories/esim_repository.dart
touch lib/features/9_esim/domain/entities/esim_plan_entity.dart

# Feature 10: Airport Taxi (Pages 85-92)
touch lib/features/10_airport_taxi/presentation/screens/taxi_search_screen.dart
touch lib/features/10_airport_taxi/presentation/screens/vehicle_selection_screen.dart
touch lib/features/10_airport_taxi/presentation/screens/pickup_details_screen.dart
touch lib/features/10_airport_taxi/presentation/screens/driver_tracking_screen.dart
touch lib/features/10_airport_taxi/presentation/screens/taxi_payment_screen.dart
touch lib/features/10_airport_taxi/presentation/screens/taxi_trip_details_screen.dart
touch lib/features/10_airport_taxi/presentation/screens/rate_driver_screen.dart
touch lib/features/10_airport_taxi/presentation/screens/cancel_ride_screen.dart

touch lib/features/10_airport_taxi/presentation/widgets/taxi_search_form.dart
touch lib/features/10_airport_taxi/presentation/widgets/vehicle_card.dart
touch lib/features/10_airport_taxi/presentation/widgets/driver_card.dart
touch lib/features/10_airport_taxi/presentation/widgets/tracking_map.dart
touch lib/features/10_airport_taxi/presentation/widgets/trip_timeline.dart

touch lib/features/10_airport_taxi/presentation/bloc/taxi_booking_bloc.dart
touch lib/features/10_airport_taxi/presentation/bloc/taxi_booking_event.dart
touch lib/features/10_airport_taxi/presentation/bloc/taxi_booking_state.dart
touch lib/features/10_airport_taxi/presentation/bloc/taxi_tracking_bloc.dart
touch lib/features/10_airport_taxi/presentation/bloc/taxi_tracking_event.dart
touch lib/features/10_airport_taxi/presentation/bloc/taxi_tracking_state.dart

touch lib/features/10_airport_taxi/data/models/taxi_model.dart
touch lib/features/10_airport_taxi/data/models/driver_model.dart
touch lib/features/10_airport_taxi/data/models/ride_model.dart
touch lib/features/10_airport_taxi/data/repositories/taxi_repository.dart
touch lib/features/10_airport_taxi/domain/entities/taxi_entity.dart

# Feature 11: Support (Pages 93-100)
touch lib/features/11_support/presentation/screens/help_center_screen.dart
touch lib/features/11_support/presentation/screens/faq_article_screen.dart
touch lib/features/11_support/presentation/screens/create_ticket_screen.dart
touch lib/features/11_support/presentation/screens/my_tickets_screen.dart
touch lib/features/11_support/presentation/screens/ticket_detail_screen.dart
touch lib/features/11_support/presentation/screens/live_chat_screen.dart
touch lib/features/11_support/presentation/screens/voice_call_screen.dart
touch lib/features/11_support/presentation/screens/refund_request_screen.dart

touch lib/features/11_support/presentation/widgets/faq_category_card.dart
touch lib/features/11_support/presentation/widgets/ticket_card.dart
touch lib/features/11_support/presentation/widgets/chat_bubble.dart
touch lib/features/11_support/presentation/widgets/message_input.dart
touch lib/features/11_support/presentation/widgets/timeline_item.dart

touch lib/features/11_support/presentation/bloc/support_bloc.dart
touch lib/features/11_support/presentation/bloc/support_event.dart
touch lib/features/11_support/presentation/bloc/support_state.dart
touch lib/features/11_support/presentation/bloc/chat_bloc.dart
touch lib/features/11_support/presentation/bloc/chat_event.dart
touch lib/features/11_support/presentation/bloc/chat_state.dart

touch lib/features/11_support/data/models/ticket_model.dart
touch lib/features/11_support/data/models/message_model.dart
touch lib/features/11_support/data/models/faq_model.dart
touch lib/features/11_support/data/repositories/support_repository.dart
touch lib/features/11_support/domain/entities/ticket_entity.dart

# Feature 12: Payments (Pages 101-110)
touch lib/features/12_payments/presentation/screens/payment_methods_screen.dart
touch lib/features/12_payments/presentation/screens/add_card_screen.dart
touch lib/features/12_payments/presentation/screens/secure_auth_screen.dart
touch lib/features/12_payments/presentation/screens/payment_success_screen.dart
touch lib/features/12_payments/presentation/screens/payment_failed_screen.dart
touch lib/features/12_payments/presentation/screens/transaction_history_screen.dart
touch lib/features/12_payments/presentation/screens/invoices_list_screen.dart
touch lib/features/12_payments/presentation/screens/invoice_detail_screen.dart
touch lib/features/12_payments/presentation/screens/notification_preferences_screen.dart
touch lib/features/12_payments/presentation/screens/privacy_security_screen.dart

touch lib/features/12_payments/presentation/widgets/payment_card_widget.dart
touch lib/features/12_payments/presentation/widgets/transaction_item.dart
touch lib/features/12_payments/presentation/widgets/invoice_card.dart
touch lib/features/12_payments/presentation/widgets/preference_toggle.dart

touch lib/features/12_payments/presentation/bloc/payment_bloc.dart
touch lib/features/12_payments/presentation/bloc/payment_event.dart
touch lib/features/12_payments/presentation/bloc/payment_state.dart
touch lib/features/12_payments/presentation/bloc/invoice_bloc.dart
touch lib/features/12_payments/presentation/bloc/invoice_event.dart
touch lib/features/12_payments/presentation/bloc/invoice_state.dart

touch lib/features/12_payments/data/models/payment_method_model.dart
touch lib/features/12_payments/data/models/transaction_model.dart
touch lib/features/12_payments/data/models/invoice_model.dart
touch lib/features/12_payments/data/repositories/payment_repository.dart
touch lib/features/12_payments/domain/entities/payment_entity.dart

echo "Features 8-12 created!"
