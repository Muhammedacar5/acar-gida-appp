import 'package:flutter/material.dart';

void main() => runApp(const AcarGidaApp());

const brandGold = Color(0xFFB58A3B);
const brandBlack = Color(0xFF171717);

class AcarGidaApp extends StatelessWidget {
  const AcarGidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACAR GIDA TOPTAN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandGold,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAF8),
        appBarTheme: const AppBarTheme(
          backgroundColor: brandBlack,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const RoleGate(),
    );
  }
}

enum AppRole { customer, salesperson, admin }

class RoleGate extends StatelessWidget {
  const RoleGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACAR GIDA TOPTAN',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: .5)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          const Text('Hoş geldiniz',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Devam etmek için hesap türünüzü seçin.',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 28),
          _RoleTile(
            icon: Icons.storefront_outlined,
            title: 'Müşteri girişi',
            subtitle: 'Ürünleri inceleyin ve sipariş verin',
            onTap: () => _open(context, AppRole.customer),
          ),
          _RoleTile(
            icon: Icons.assignment_ind_outlined,
            title: 'Plasiyer girişi',
            subtitle: 'Size yönlendirilen siparişleri yönetin',
            onTap: () => _open(context, AppRole.salesperson),
          ),
          _RoleTile(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Yönetici girişi',
            subtitle: 'Ürünleri, müşterileri ve tüm siparişleri yönetin',
            onTap: () => _open(context, AppRole.admin),
          ),
          const SizedBox(height: 24),
          const Text(
            'Geliştirme sürümü: Giriş ve veritabanı bağlantısı henüz yapılandırılmadı.',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, AppRole role) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RolePlaceholder(role: role),
    ));
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF3EAD8),
          foregroundColor: brandBlack,
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class RolePlaceholder extends StatelessWidget {
  const RolePlaceholder({super.key, required this.role});
  final AppRole role;

  String get heading => switch (role) {
        AppRole.customer => 'Müşteri paneli',
        AppRole.salesperson => 'Plasiyer paneli',
        AppRole.admin => 'Yönetici paneli',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(heading)),
      body: switch (role) {
        AppRole.customer => const CustomerHome(),
        AppRole.salesperson => const _ComingSoon(
            icon: Icons.notifications_active_outlined,
            title: 'Plasiyer siparişleri',
            description:
                'Giriş ve yetkilendirme bağlandığında yalnızca size atanmış siparişler burada listelenecek.'),
        AppRole.admin => const _ComingSoon(
            icon: Icons.inventory_2_outlined,
            title: 'Yönetici paneli',
            description:
                'Ürün ekleme, fotoğraf yükleme, fiyat/stok yönetimi, plasiyer ve sipariş yönetimi burada olacak.'),
      },
    );
  }
}

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  String selectedCategory = 'Tümü';
  final Map<String, int> cart = {};

  final categories = const [
    'Tümü',
    'Gazlı içecekler',
    'Su ve maden suyu',
    'Meyve suları',
    'Turşu',
    'Kahve',
    'Şeker',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: brandBlack,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ACAR GIDA',
                  style: TextStyle(
                    color: Color(0xFFE5C47D),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  )),
              SizedBox(height: 3),
              Text('TOPTAN & PERAKENDE',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
              SizedBox(height: 18),
              Text('Alışverişe başlayın',
                  style: TextStyle(color: Colors.white, fontSize: 19,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Expanded(
                child: Text('Ürün kategorileri',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Badge(
                label: Text('${cart.values.fold<int>(0, (a, b) => a + b)}'),
                child: const Icon(Icons.shopping_basket_outlined, size: 26),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = categories[index];
              final active = selectedCategory == item;
              return ChoiceChip(
                label: Text(item),
                selected: active,
                onSelected: (_) => setState(() => selectedCategory = item),
              );
            },
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      size: 52, color: brandGold),
                  const SizedBox(height: 12),
                  const Text('Ürün kataloğu hazırlanıyor',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    selectedCategory == 'Tümü'
                        ? 'Yönetici panelinden ürünler eklendiğinde burada fotoğrafları ve fiyatlarıyla görünecek.'
                        : '$selectedCategory kategorisine ürünler eklendiğinde burada listelenecek.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _showCart(context),
                    icon: const Icon(Icons.shopping_basket_outlined),
                    label: const Text('Sepeti görüntüle'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sepetim',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(cart.isEmpty
                  ? 'Sepetiniz henüz boş.'
                  : '${cart.values.fold<int>(0, (a, b) => a + b)} adet ürün sepette.'),
              const SizedBox(height: 18),
              const Text(
                'Sipariş oluşturma ve plasiyer seçimi, müşteri hesabı ve sunucu bağlantısı tamamlandığında etkinleştirilecek.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: brandGold),
            const SizedBox(height: 14),
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
