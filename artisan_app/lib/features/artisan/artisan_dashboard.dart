import 'package:flutter/material.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/services/firestore_service.dart';
import 'package:backend/models/artisan_model.dart';
import 'package:backend/models/product_model.dart';
import 'package:backend/models/order_model.dart';
import '../../core/colors.dart';
import '../common/profile_screen.dart';
import 'widgets/dashboard_components.dart';


class ArtisanDashboard extends StatefulWidget {
  const ArtisanDashboard({super.key});

  @override
  State<ArtisanDashboard> createState() => _ArtisanDashboardState();
}

class _ArtisanDashboardState extends State<ArtisanDashboard> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  int _currentIndex = 0;

  final List<String> _titles = [
    'Dashboard',
    'Products',
    'Orders',
    'Earnings',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Set background color for the entire dashboard
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DashboardOverview(),
          ProductListView(),
          OrderManagementView(),
          EarningsAnalyticsView(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2_rounded),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics_rounded),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}




class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final user = authService.currentUser;

    if (user == null) {
      return const Center(child: Text('Please login to view dashboard'));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, user, firestoreService),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildEarningsHero(user, firestoreService),
                  const SizedBox(height: 24),
                  _buildMetricsGrid(user, firestoreService),
                  const SizedBox(height: 32),
                  const DashboardSectionTitle(title: 'Quick Actions'),
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                  DashboardSectionTitle(
                    title: 'Recent Activity',
                    onActionTap: () {},
                  ),
                  _buildActivityList(user, firestoreService),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, dynamic user, FirestoreService firestoreService) {
    return StreamBuilder<Artisan?>(
      stream: firestoreService.artisanStream(user.uid),
      builder: (context, snapshot) {
        final artisan = snapshot.data;
        return SliverAppBar(
          expandedHeight: 140.0,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: AppColors.background,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  artisan?.shopName ?? 'My Shop',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 20),
              ),
            ),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }

  Widget _buildEarningsHero(dynamic user, FirestoreService firestoreService) {
    return StreamBuilder<double>(
      stream: firestoreService.getArtisanSalesStream(user.uid),
      builder: (context, snapshot) {
        final earnings = snapshot.data ?? 0.0;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8D6E63), Color(0xFFA1887F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8D6E63).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text(
                    'Total Earnings',
                    style: TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'This Month',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '₹ ${earnings.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '+12% from last week',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildMetricsGrid(dynamic user, FirestoreService firestoreService) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<List<Product>>(
            stream: firestoreService.artisanProductsStream(user.uid),
            builder: (context, snapshot) {
              return PremiumStatCard(
                title: 'Live Products',
                value: '${snapshot.data?.length ?? 0}',
                icon: Icons.inventory_2_outlined,
                baseColor: Colors.orange[700]!,
              );
            }
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StreamBuilder<int>(
            stream: firestoreService.getActiveOrdersCountStream(user.uid),
            builder: (context, snapshot) {
              return PremiumStatCard(
                title: 'Pending Orders',
                value: '${snapshot.data ?? 0}',
                icon: Icons.local_shipping_outlined,
                baseColor: Colors.blue[600]!,
              );
            }
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QuickActionItem(
            label: 'Add Item',
            icon: Icons.add_rounded,
            color: const Color(0xFF66BB6A),
            onTap: () => Navigator.pushNamed(context, '/add-product'),
          ),
          QuickActionItem(
            label: 'Store',
            icon: Icons.storefront_rounded,
            color: const Color(0xFF5C6BC0),
            onTap: () {},
          ),
          QuickActionItem(
            label: 'Offer',
            icon: Icons.local_offer_rounded,
            color: const Color(0xFFEF5350),
            onTap: () {},
          ),
          QuickActionItem(
            label: 'Reports',
            icon: Icons.analytics_rounded,
            color: const Color(0xFFFFA726),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(dynamic user, FirestoreService firestoreService) {
    return StreamBuilder<List<OrderModel>>(
      stream: firestoreService.artisanOrdersStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Error loading activity');
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final orders = snapshot.data!;
        if (orders.isEmpty) {
          return _buildEmptyActivity();
        }
        
        return Column(
          children: orders.take(3).map((order) {
            return ActivityItem(
              title: 'New Order Received',
              subtitle: 'Order #${order.id.substring(0, 4)} - ${order.productName}',
              time: 'Just now',
              icon: Icons.shopping_bag_outlined,
              iconColor: const Color(0xFF8D6E63),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyActivity() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome_outlined, size: 48, color: Colors.grey[200]),
          const SizedBox(height: 16),
          Text(
            'Your story begins here',
            style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first product to reach customers.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[350], fontSize: 13),
          ),
        ],
      ),
    );
  }
}


// ActivityItem is still used in the Recent Activity list
class ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;

  const ActivityItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }
}


// Placeholder views for testing navigation
class EarningsAnalyticsView extends StatelessWidget {
  const EarningsAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final user = authService.currentUser;

    if (user == null) return const Center(child: Text('Please login'));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<double>(
        stream: firestoreService.getArtisanSalesStream(user.uid),
        builder: (context, snapshot) {
          final totalEarnings = snapshot.data ?? 0.0;
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                  onPressed: () {
                    // Navigate back to Role Selection
                    Navigator.pushReplacementNamed(context, '/role-selection');
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Earnings Analytics',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(color: AppColors.background),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, Color(0xFF8D6E63)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Earnings',
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹ ${totalEarnings.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _BalanceInfo(label: 'Net Balance', value: '₹ ${totalEarnings.toStringAsFixed(0)}'),
                                  _BalanceInfo(label: 'Pending', value: '₹ 0'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text('Recent Performance', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      if (totalEarnings == 0) 
                        _buildEmptyAnalytics()
                      else
                        Column(
                          children: [
                            Container(
                              height: 200,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(7, (index) {
                                  final heights = [0.1, 0.2, 0.15, 0.3, 0.25, 0.4, 0.3];
                                  return Container(
                                    width: 30,
                                    height: 150 * heights[index],
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyAnalytics() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.analytics_outlined, color: Colors.grey[200], size: 48),
          const SizedBox(height: 16),
          Text(
            'No sales data yet',
            style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep sharing your products to start earning!',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _BalanceInfo extends StatelessWidget {
  final String label;
  final String value;
  const _BalanceInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

class _TopProductItem extends StatelessWidget {
  final String name;
  final String sales;
  final String revenue;

  const _TopProductItem({required this.name, required this.sales, required this.revenue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$sales units sold', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Text(revenue, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final user = authService.currentUser;

    if (user == null) return const Center(child: Text('Please login'));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<List<Product>>(
        stream: firestoreService.artisanProductsStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final products = snapshot.data!;
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/role-selection');
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'My Products',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(color: AppColors.background),
                ),
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded, color: AppColors.textPrimary)),
                ],
              ),
              if (products.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: Text('No products listed yet')),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withOpacity(0.05),
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                                  ),
                                  child: product.imageUrl != null 
                                    ? ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                                        child: Image.network(product.imageUrl!, fit: BoxFit.cover),
                                      )
                                    : Icon(Icons.image_outlined, color: theme.primaryColor.withOpacity(0.2), size: 48),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.category.toUpperCase(),
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '₹ ${product.price}',
                                          style: TextStyle(
                                            color: theme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Icon(Icons.more_vert_rounded, size: 20, color: Colors.grey),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-product'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class OrderManagementView extends StatelessWidget {
  const OrderManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Orders', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
            onPressed: () {
              // Navigate back to Role Selection
              Navigator.pushReplacementNamed(context, '/role-selection');
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorPadding: const EdgeInsets.all(4),
                tabs: const [
                  Tab(text: 'Pending'),
                  Tab(text: 'Accepted'),
                  Tab(text: 'Completed'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            OrderList(status: 'Pending'),
            OrderList(status: 'Accepted'),
            OrderList(status: 'Completed'),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final String status;
  const OrderList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final user = authService.currentUser;

    if (user == null) return const Center(child: Text('Please login'));

    return StreamBuilder<List<OrderModel>>(
      stream: firestoreService.artisanOrdersStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final allOrders = snapshot.data!;
        // Simple mapping for demo: Pending -> pending, Accepted -> processing, Completed -> delivered
        final filteredOrders = allOrders.where((o) {
          if (status == 'Pending') return o.status == OrderStatus.pending;
          if (status == 'Accepted') return o.status == OrderStatus.processing;
          if (status == 'Completed') return o.status == OrderStatus.delivered;
          return false;
        }).toList();

        if (filteredOrders.isEmpty) {
          return Center(child: Text('No $status orders'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            final order = filteredOrders[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.shopping_bag_outlined, color: theme.primaryColor, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Order #${order.id.substring(0, 4)}', 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('${order.createdAt.day} ${_getMonth(order.createdAt.month)}', 
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(order.productName, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                            Text('Customer ID: ${order.customerId.substring(0, 6)}', 
                                style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Amount', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          Text('₹ ${order.totalAmount}', 
                              style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getStatusColor(status).withOpacity(0.1),
                          foregroundColor: _getStatusColor(status),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          status == 'Pending' ? 'Accept Order' : (status == 'Accepted' ? 'Ship Order' : 'Details'),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending': return Colors.orange;
      case 'Accepted': return Colors.blue;
      case 'Completed': return Colors.green;
      default: return Colors.grey;
    }
  }
}

