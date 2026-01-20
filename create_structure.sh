#!/bin/bash

# Create main lib directory
mkdir -p lib

# Create core directories
mkdir -p lib/core/{constants,theme,utils,widgets,extensions}
mkdir -p lib/data/{models,mock}
mkdir -p lib/config/routes
mkdir -p lib/services
mkdir -p lib/blocs/global/{theme_bloc,language_bloc,connectivity_bloc}

# Create all feature directories
mkdir -p lib/features/1_auth/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/2_home/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/3_flights/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/4_hotels/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/5_cars/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/6_buses/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/7_tours/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/8_home_checkin/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/9_esim/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/10_airport_taxi/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/11_support/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/12_payments/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/13_partner_auth/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/14_partner_hotel/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/15_partner_car/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/16_partner_tour/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/17_partner_taxi/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/18_admin_auth/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}
mkdir -p lib/features/19_admin/{presentation/{screens,widgets,bloc},data/{models,repositories},domain/entities}

# Core files
touch lib/main.dart
touch lib/app.dart

# Core constants
touch lib/core/constants/app_colors.dart
touch lib/core/constants/app_strings.dart
touch lib/core/constants/app_text_styles.dart
touch lib/core/constants/app_routes.dart

# Core theme
touch lib/core/theme/light_theme.dart
touch lib/core/theme/dark_theme.dart
touch lib/core/theme/theme_bloc.dart

# Core utils
touch lib/core/utils/date_formatter.dart
touch lib/core/utils/currency_formatter.dart
touch lib/core/utils/validators.dart
touch lib/core/utils/helpers.dart

# Core widgets
touch lib/core/widgets/custom_button.dart
touch lib/core/widgets/custom_text_field.dart
touch lib/core/widgets/loading_indicator.dart
touch lib/core/widgets/error_widget.dart
touch lib/core/widgets/empty_state.dart

# Core extensions
touch lib/core/extensions/string_extensions.dart
touch lib/core/extensions/date_extensions.dart
touch lib/core/extensions/context_extensions.dart

# Data models
touch lib/data/models/user_model.dart
touch lib/data/models/booking_model.dart
touch lib/data/models/payment_model.dart
touch lib/data/models/notification_model.dart

# Mock data
touch lib/data/mock/mock_users.dart
touch lib/data/mock/mock_flights.dart
touch lib/data/mock/mock_hotels.dart
touch lib/data/mock/mock_cars.dart
touch lib/data/mock/mock_buses.dart
touch lib/data/mock/mock_tours.dart
touch lib/data/mock/mock_esims.dart
touch lib/data/mock/mock_taxis.dart

# Config
touch lib/config/routes/app_router.dart
touch lib/config/routes/customer_routes.dart
touch lib/config/routes/partner_routes.dart
touch lib/config/routes/admin_routes.dart
touch lib/config/app_config.dart

# Services
touch lib/services/navigation_service.dart
touch lib/services/storage_service.dart
touch lib/services/logger_service.dart
touch lib/services/mock_data_service.dart

# Global BLoCs
touch lib/blocs/global/theme_bloc/theme_bloc.dart
touch lib/blocs/global/theme_bloc/theme_event.dart
touch lib/blocs/global/theme_bloc/theme_state.dart
touch lib/blocs/global/language_bloc/language_bloc.dart
touch lib/blocs/global/language_bloc/language_event.dart
touch lib/blocs/global/language_bloc/language_state.dart
touch lib/blocs/global/connectivity_bloc/connectivity_bloc.dart
touch lib/blocs/global/connectivity_bloc/connectivity_event.dart
touch lib/blocs/global/connectivity_bloc/connectivity_state.dart

echo "Core structure created!"
