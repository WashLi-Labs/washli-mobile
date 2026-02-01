import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({super.key});

  final List<Map<String, String>> promotions = const [
    {
      'title': 'Promotions',
      'value': '20% Off',
      'detail': 'More Detail',
      'icon': 'offer'
    },
    {
      'title': 'New User',
      'value': 'Free Wash',
      'detail': 'Claim Now',
      'icon': 'gift'
    },
    {
      'title': 'Deal',
      'value': 'Buy 1 Get 1',
      'detail': 'Expire Soon',
      'icon': 'deal'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 100, // Fixed height for carousel stability
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Promotions Carousel
          Expanded(
            child: CarouselSlider(
               options: CarouselOptions(
                height: 100,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.vertical, // Vertical swipe for a "ticker" feel, or horizontal? Standard is horizontal.
                // Let's use horizontal for "Swipe"
               ),
               items: promotions.map((promo) {
                 return Builder(
                   builder: (BuildContext context) {
                     return Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                       child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              promo['icon'] == 'offer' ? Icons.local_offer_rounded : 
                              promo['icon'] == 'gift' ? Icons.card_giftcard_rounded : Icons.star_rounded,
                              color: const Color(0xFF007BFF), 
                              size: 24
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  promo['title']!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  promo['value']!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  promo['detail']!,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                     );
                   },
                 );
               }).toList(),
            ),
          ),
          
          // Divider
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 0), // Reduce margin as padding is inside carousel
          ),
          
          // Coins
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.monetization_on_rounded, color: Color(0xFF007BFF), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Coins',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          '100',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         Text(
                          'Available',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
