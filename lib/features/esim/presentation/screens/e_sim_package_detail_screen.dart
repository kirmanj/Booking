import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_bloc.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_event.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_state.dart';
import 'package:aman_booking/features/esim/data/models/e_sim_models.dart';
import 'package:aman_booking/features/esim/presentation/screens/e_sim_checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class ESimPackageDetailScreen extends StatelessWidget {
  const ESimPackageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ESimBloc, ESimState>(
          builder: (context, state) {
            final detailState = state is PackageDetailsLoaded ? state : null;

            if (detailState == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final pkg = detailState.package;
            final country = detailState.country;

            return Stack(
              children: [
                Column(
                  children: [
                    _TopBar(
                      title: pkg.name,
                      subtitle: '${country.name} • ${pkg.validityText}',
                      onBack: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
                        children: [
                          _HeroCard(pkg: pkg, country: country),
                          const SizedBox(height: 12),
                          _Section(
                            title: 'What you get',
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _Pill(text: '${pkg.dataAmount} data'),
                                _Pill(text: pkg.speed),
                                _Pill(text: pkg.validityText),
                                if (pkg.callsMinutes != null)
                                  _Pill(text: '${pkg.callsMinutes} calls'),
                                if (pkg.smsCount != null)
                                  _Pill(text: '${pkg.smsCount} SMS'),
                                _Pill(
                                    text: pkg.isUnlimited
                                        ? 'Unlimited'
                                        : 'Fair use'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _Section(
                            title: 'Features',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: pkg.features
                                  .map((f) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 6.0),
                                        child: Row(
                                          children: [
                                            const Icon(Iconsax.tick_circle,
                                                color: AppColors.primary,
                                                size: 16),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                f,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _Section(
                            title: 'Coverage',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Iconsax.global,
                                        color: AppColors.secondary, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        country.isRegional
                                            ? '${country.coverageCountries.length}+ countries included'
                                            : country.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (country.isRegional)
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: country.coverageCountries
                                        .take(12)
                                        .map((c) => _Pill(text: c))
                                        .toList(),
                                  )
                                else
                                  Text(
                                    'Works instantly on arrival in ${country.name}.',
                                    style: TextStyle(
                                        color: AppColors.textSecondary),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _Section(
                            title: 'Related packages',
                            child: Column(
                              children: detailState.relatedPackages
                                  .map(
                                    (p) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        p.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${p.dataAmount} • ${p.validityText}',
                                      ),
                                      trailing: Text(
                                        '\$${p.finalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      onTap: () => context
                                          .read<ESimBloc>()
                                          .add(SelectPackage(p)),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${pkg.finalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'Per eSIM • ${pkg.pricePerDay}',
                                style:
                                    TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ESimBloc>(),
                                      child: ESimCheckoutScreen(
                                        package: pkg,
                                        country: country,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_checkout,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'Checkout',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final ESimPackage pkg;
  final ESimCountry country;

  const _HeroCard({required this.pkg, required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pkg.dataAmount} • ${pkg.validityText}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Iconsax.security_safe,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Instant activation QR',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Iconsax.simcard, color: Colors.white, size: 36),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const _TopBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.10),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SupportButton(
            category: SupportCategory.eSim,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
