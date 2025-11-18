import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Tifnova/l10n/app_localizations.dart';
import 'package:Tifnova/screens/home_screen.dart';
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, String>> get mess => [];
  List<Map<String, String>> get allMesses => [];

  // Localized Help Categories
  List<Map<String, dynamic>> get helpCategories {
    final loc = AppLocalizations.of(context)!;

    return [
      {
        'title': loc.helpCategoryGettingStarted,
        'icon': Icons.play_circle_outline,
        'faqs': [
          {
            'question': loc.faqRegisterTitle,
            'answer': loc.faqRegisterDesc,
          },
          {
            'question': loc.faqSearchMessTitle,
            'answer': loc.faqSearchMessDesc,
          },
          {
            'question': loc.faqSelectMessTitle,
            'answer': loc.faqSelectMessDesc,
          },
        ],
      },
      {
        'title': loc.helpCategoryAccountProfile,
        'icon': Icons.person_outline,
        'faqs': [
          {
            'question': loc.faqUpdateProfileTitle,
            'answer': loc.faqUpdateProfileDesc,
          },
          {
            'question': loc.faqChangeMobileTitle,
            'answer': loc.faqChangeMobileDesc,
          },
          {
            'question': loc.faqResetPasswordTitle,
            'answer': loc.faqResetPasswordDesc,
          },
        ],
      },
      {
        'title': loc.helpCategorySubscriptionOrders,
        'icon': Icons.shopping_bag_outlined,
        'faqs': [
          {
            'question': loc.faqSubscribeTitle,
            'answer': loc.faqSubscribeDesc,
          },
          {
            'question': loc.faqPauseSubscriptionTitle,
            'answer': loc.faqPauseSubscriptionDesc,
          },
          {
            'question': loc.faqCancelSubscriptionTitle,
            'answer': loc.faqCancelSubscriptionDesc,
          },
          {
            'question': loc.faqOrderHistoryTitle,
            'answer': loc.faqOrderHistoryDesc,
          },
        ],
      },
      {
        'title': loc.helpCategoryPaymentRefunds,
        'icon': Icons.payment_outlined,
        'faqs': [
          {
            'question': loc.faqPaymentMethodsTitle,
            'answer': loc.faqPaymentMethodsDesc,
          },
          {
            'question': loc.faqPaymentSecurityTitle,
            'answer': loc.faqPaymentSecurityDesc,
          },
          {
            'question': loc.faqRefundTitle,
            'answer': loc.faqRefundDesc,
          },
          {
            'question': loc.faqDoubleChargeTitle,
            'answer': loc.faqDoubleChargeDesc,
          },
        ],
      },
      {
        'title': loc.helpCategoryFoodMenu,
        'icon': Icons.restaurant_menu_outlined,
        'faqs': [
          {
            'question': loc.faqCustomizeMealsTitle,
            'answer': loc.faqCustomizeMealsDesc,
          },
          {
            'question': loc.faqVegVeganTitle,
            'answer': loc.faqVegVeganDesc,
          },
          {
            'question': loc.faqReportQualityTitle,
            'answer': loc.faqReportQualityDesc,
          },
        ],
      },
    ];
  }

  List<Map<String, dynamic>> get filteredCategories {
    if (_searchQuery.isEmpty) return helpCategories;

    return helpCategories
        .map((category) {
          final filteredFaqs = (category['faqs'] as List)
              .where(
                (faq) =>
                    faq['question']
                        .toString()
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    faq['answer']
                        .toString()
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()),
              )
              .toList();

          return {...category, 'faqs': filteredFaqs};
        })
        .where((category) => (category['faqs'] as List).isNotEmpty)
        .toList();
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+911234567890');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@tifnova.com',
      query: 'subject=Help Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/1234567890');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Stack(
              children: [
                CustomPaint(
                  painter: CurvePainter(),
                  child: Container(
                    height: 225,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        Text(
                          loc.helpTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          loc.helpSubtitle,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),

                        const SizedBox(height: 28),

                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: loc.helpSearchHint,
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF870474),
                                ),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                            _searchQuery = '';
                                          });
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 5,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/icons/back.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MessListScreen(mess: mess, allMesses: allMesses),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),

            // FAQ Categories
            Expanded(
              child: filteredCategories.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          loc.helpNoResults,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loc.helpNoResultsSubtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];
                        return _buildCategoryCard(category);
                      },
                    ),
            ),

            // Contact Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    loc.helpStillNeedHelp,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF870474),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContactButton(
                        icon: 'assets/icons/call.png',
                        label: loc.helpCall,
                        onTap: _launchPhone,
                      ),
                      _buildContactButton(
                        icon: 'assets/icons/gmail.png',
                        label: loc.helpEmail,
                        onTap: _launchEmail,
                      ),
                      _buildContactButton(
                        icon: 'assets/icons/whatsapp.png',
                        label: loc.helpWhatsapp,
                        onTap: _launchWhatsApp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF870474).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            category['icon'],
            color: const Color(0xFF870474),
            size: 24,
          ),
        ),
        title: Text(
          category['title'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF870474),
          ),
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (category['faqs'] as List).length,
            itemBuilder: (context, index) {
              final faq = category['faqs'][index];
              return _buildFAQItem(faq);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(Map<String, String> faq) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text(
          faq['question']!,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              faq['answer']!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF870474)),
        ),
        child: Column(
          children: [
            icon is String
                ? Image.asset(
                    icon,
                    width: 28,
                    height: 28,
                  )
                : Icon(
                    icon,
                    color: const Color(0xFF870474),
                    size: 28,
                  ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF870474),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = const Color(0xFF870474);
    final Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
