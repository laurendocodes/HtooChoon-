import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Constants/plan_colors.dart';
import 'package:htoochoon_flutter/Constants/text_constants.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/org_core_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/free_user_home.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:flutter/material.dart';

class PlanSelectionScreen extends StatelessWidget {
  final String role;

  const PlanSelectionScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final planColors = Theme.of(context).extension<PlanColors>()!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: (role == "org")
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    const double spacing = 16;
                    const int cardCount = 3;

                    final totalSpacing = spacing * (cardCount - 1);

                    final double cardWidth =
                        (constraints.maxWidth - totalSpacing) / cardCount;

                    final cards = [
                      PlanCard(
                        width: cardWidth,
                        title: "Core",
                        price: "\$0",
                        cardColor: planColors.basic,
                        bulletColor: Theme.of(context).colorScheme.primary,
                      ),
                      PlanCard(
                        width: cardWidth,
                        title: "Super",
                        price: "\$29",
                        cardColor: planColors.pro,
                        bulletColor: Theme.of(context).colorScheme.primary,
                      ),
                      PlanCard(
                        width: cardWidth,
                        title: "Plus",
                        price: "\$61",
                        cardColor: planColors.premium,
                        bulletColor: Colors.white,
                        textColor: Colors.white,
                      ),
                    ];

                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              if (role == 'org') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OrgDashboardScreen(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: cards,
                        ),
                      ],
                    );
                  },
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    const double spacing = 16;
                    const int cardCount = 3;

                    final totalSpacing = spacing * (cardCount - 1);

                    final double cardWidth =
                        (constraints.maxWidth - totalSpacing) / cardCount;

                    final cards = [
                      PlanCard(
                        width: cardWidth,
                        title: "Basic",
                        price: "\$0",
                        cardColor: planColors.basic,
                        bulletColor: Theme.of(context).colorScheme.primary,
                      ),
                      PlanCard(
                        width: cardWidth,
                        title: "Pro",
                        price: "\$29",
                        cardColor: planColors.pro,
                        bulletColor: Theme.of(context).colorScheme.primary,
                      ),
                      PlanCard(
                        width: cardWidth,
                        title: "Premium",
                        price: "\$61",
                        cardColor: planColors.premium,
                        bulletColor: Colors.white,
                        textColor: Colors.white,
                      ),
                    ];

                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FreeUserHome(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: cards,
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final double width;
  final String title;
  final String price;
  final Color cardColor;
  final Color bulletColor;
  final Color? textColor;

  const PlanCard({
    super.key,
    required this.width,
    required this.title,
    required this.price,
    required this.cardColor,
    required this.bulletColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveTextColor =
        textColor ?? Theme.of(context).colorScheme.onSurface;

    return SizedBox(
      width: width,
      child: Card(
        color: cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: effectiveTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                price,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: effectiveTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _feature("Unlimited access", effectiveTextColor),
              _feature("Priority support", effectiveTextColor),
              _feature("Advanced tools", effectiveTextColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feature(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: bulletColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }
}
