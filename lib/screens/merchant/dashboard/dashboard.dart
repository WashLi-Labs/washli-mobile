import 'package:flutter/material.dart';
import '../merchant_home/widgets/merchant_nav_bar.dart';
import '../../../widgets/buttons/back_button.dart';
import '../orders/orders.dart';
import '../merchant_activity/activities/activities.dart';
import 'widgets/sales_summery/total_earnings.dart';
import 'widgets/sales_summery/complete_orders.dart';
import 'widgets/sales_summery/earnings.dart';
import 'widgets/sales_summery/customer_review.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Already on Dashboard

    if (index == 0) {
      // Home tab - pop back to MerchantHomeScreen
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == 1) {
      // Orders tab
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrdersScreen()),
      );
    } else if (index == 2) {
      // Activities tab
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ActivitiesScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
      // Handle other navigation (Account) if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  CustomBackButton(onTap: () => Navigator.pop(context)),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Dashboards',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D3A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button space
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Sales Summery',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: const [
                  TotalEarningsCard(),
                  CompletedOrdersCard(),
                  EarningsCard(),
                  CustomerReviewCard(),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Total Earning',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: LineChartPainter(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Mon', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Tue', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Wed', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Thu', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Fri', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Sat', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Sun', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120), // Extra space for navbar
            ],
          ),
        ),
      ),
      bottomNavigationBar: MerchantNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2688EA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (int i = 0; i <= 4; i++) {
        double y = size.height * i / 4;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
        
        // Draw labels
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${400 - (i * 100)}',
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(-25, y - 6));
    }

    final path = Path();
    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.16, size.height * 0.3),
      Offset(size.width * 0.33, size.height * 0.4),
      Offset(size.width * 0.5, size.height * 0.8),
      Offset(size.width * 0.66, size.height * 0.5),
      Offset(size.width * 0.83, size.height * 0.5),
      Offset(size.width, size.height * 0.6),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
