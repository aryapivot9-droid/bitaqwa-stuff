import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BitaqwaApp());
}

// ==================== THEME ====================

const Color appOrange = Color(0xFFFF8A65);
const Color pageBackground = Color(0xFFF5F7FA);
const Color darkText = Color(0xFF2D3436);

class BitaqwaApp extends StatelessWidget {
  const BitaqwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitaqwa App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: appOrange),
        scaffoldBackgroundColor: pageBackground,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: appOrange,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ==================== GREETING ====================

enum GreetingPeriod { morning, afternoon, evening, night }

GreetingPeriod currentPeriod() {
  final hour = DateTime.now().hour;

  if (hour >= 4 && hour < 11) {
    return GreetingPeriod.morning;
  } else if (hour >= 11 && hour < 15) {
    return GreetingPeriod.afternoon;
  } else if (hour >= 15 && hour < 20) {
    return GreetingPeriod.evening;
  }

  return GreetingPeriod.night;
}

String greetingText() {
  switch (currentPeriod()) {
    case GreetingPeriod.morning:
      return 'Selamat Pagi';
    case GreetingPeriod.afternoon:
      return 'Selamat Siang';
    case GreetingPeriod.evening:
      return 'Selamat Sore';
    case GreetingPeriod.night:
      return 'Selamat Malam';
  }
}

String greetingBackgroundAsset() {
  switch (currentPeriod()) {
    case GreetingPeriod.morning:
    case GreetingPeriod.afternoon:
      return 'assets/Instagram post - 4.png';
    case GreetingPeriod.evening:
      return 'assets/Instagram post - 19.png';
    case GreetingPeriod.night:
      return 'assets/Instagram post - 20.png';
  }
}

void openPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}

// ==================== HOMEPAGE ====================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();

    _clockTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            // FIX: Container dengan clipBehavior wajib punya decoration.
            // Diganti SizedBox + ClipRect supaya tidak error.
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 230,
                child: ClipRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        greetingBackgroundAsset(),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const ColoredBox(color: appOrange),
                      ),
                      ColoredBox(
                        color: Colors.black.withOpacity(0.08),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.94),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                greetingText(),
                                style: const TextStyle(
                                  color: darkText,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Assalamualaikum Fulan',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: darkText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'Menu Utama',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: appOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _MenuButton(
                      icon: Icons.front_hand,
                      label: 'Doa-doa',
                      onTap: () => openPage(context, const DoaPage()),
                    ),
                    _MenuButton(
                      icon: Icons.monetization_on,
                      label: 'Zakat',
                      onTap: () => openPage(context, const ZakatPage()),
                    ),
                    _MenuButton(
                      icon: Icons.mosque,
                      label: 'Jadwal\nSholat',
                      onTap: () =>
                          openPage(context, const JadwalSholatPage()),
                    ),
                    _MenuButton(
                      icon: Icons.play_circle_outline,
                      label: 'Video\nKajian',
                      onTap: () =>
                          openPage(context, const VideoKajianPage()),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'Inspirasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
            ),

            const SizedBox(height: 12),
            const _InspirationCard(),
            const SizedBox(height: 12),
            const _InspirationCard(),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 2,
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InspirationCard extends StatelessWidget {
  const _InspirationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Text(
            'TAHAJUD',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Dan pada sebagian malam hari, bertahajudlah kamu sebagai suatu ibadah tambahan bagimu; mudah-mudahan Tuhanmu mengangkat kamu ke tempat yang terpuji.\n(QS. Al-Isra: 79)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: darkText,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '@diarysafanin',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== DOA-DOA ====================

class DoaItem {
  final String title;
  final IconData icon;
  final Color color;
  final String latin;
  final String meaning;

  const DoaItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.latin,
    required this.meaning,
  });
}

const List<DoaItem> doaItems = [
  DoaItem(
    title: 'Doa Makan',
    icon: Icons.restaurant,
    color: Color(0xFFFF8A65),
    latin: 'Bismillah',
    meaning: 'Dengan nama Allah.',
  ),
  DoaItem(
    title: 'Doa Tidur',
    icon: Icons.bed,
    color: Color(0xFF7E57C2),
    latin: 'Bismika Allahumma ahya wa amuut',
    meaning: 'Dengan nama-Mu ya Allah, aku hidup dan aku mati.',
  ),
  DoaItem(
    title: 'Doa Bepergian',
    icon: Icons.directions_car,
    color: Color(0xFF42A5F5),
    latin:
        'Subhaanalladzii sakhkhara lanaa haadzaa wa maa kunnaa lahu muqriniin',
    meaning: 'Maha Suci Allah yang telah menundukkan kendaraan ini bagi kami.',
  ),
  DoaItem(
    title: 'Doa Masuk Rumah',
    icon: Icons.home,
    color: Color(0xFF66BB6A),
    latin: 'Bismillaahi walajnaa wa bismillaahi kharajnaa',
    meaning: 'Dengan nama Allah kami masuk dan dengan nama Allah kami keluar.',
  ),
  DoaItem(
    title: 'Doa Keluar Rumah',
    icon: Icons.door_front_door,
    color: Color(0xFF26A69A),
    latin: 'Bismillaahi tawakkaltu alallaah',
    meaning: 'Dengan nama Allah, aku bertawakal kepada Allah.',
  ),
  DoaItem(
    title: 'Doa Belajar',
    icon: Icons.menu_book,
    color: Color(0xFFEC407A),
    latin: 'Rabbi zidnii ilma',
    meaning: 'Ya Tuhanku, tambahkanlah ilmu kepadaku.',
  ),
  DoaItem(
    title: 'Doa Wudhu',
    icon: Icons.water_drop,
    color: Color(0xFF29B6F6),
    latin: 'Bismillaah',
    meaning: 'Dengan nama Allah.',
  ),
  DoaItem(
    title: 'Doa Setelah Sholat',
    icon: Icons.mosque,
    color: Color(0xFFAB47BC),
    latin: 'Astaghfirullaah',
    meaning: 'Aku memohon ampun kepada Allah.',
  ),
];

class DoaPage extends StatelessWidget {
  const DoaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doa-doa')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doaItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final item = doaItems[index];

          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => openPage(
                context,
                DoaDetailPage(item: item),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: item.color.withOpacity(0.15),
                    child: Icon(
                      item.icon,
                      color: item.color,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: darkText,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DoaDetailPage extends StatelessWidget {
  final DoaItem item;

  const DoaDetailPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _InfoCard(
            title: 'Bacaan Latin',
            content: item.latin,
          ),
          const SizedBox(height: 14),
          _InfoCard(
            title: 'Artinya',
            content: item.meaning,
          ),
          const SizedBox(height: 20),
          const _BackHomeButton(),
        ],
      ),
    );
  }
}

// ==================== ZAKAT ====================

class ZakatPage extends StatelessWidget {
  const ZakatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zakat')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _NavigationCard(
            title: 'Zakat Fitrah',
            subtitle: 'Pengertian dan ketentuan zakat fitrah',
            icon: Icons.rice_bowl,
            color: Colors.orange,
            onTap: () => openPage(context, const ZakatFitrahPage()),
          ),
          _NavigationCard(
            title: 'Zakat Mal',
            subtitle: 'Pengertian dan ketentuan zakat mal',
            icon: Icons.account_balance_wallet,
            color: Colors.green,
            onTap: () => openPage(context, const ZakatMalPage()),
          ),
          _NavigationCard(
            title: 'Kalkulator Zakat',
            subtitle: 'Hitung zakat dari harta bersih',
            icon: Icons.calculate,
            color: Colors.blue,
            onTap: () => openPage(context, const KalkulatorZakatPage()),
          ),
        ],
      ),
    );
  }
}

class ZakatFitrahPage extends StatelessWidget {
  const ZakatFitrahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zakat Fitrah')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _InfoCard(
            title: 'Pengertian',
            content:
                'Zakat fitrah adalah zakat yang wajib dikeluarkan oleh setiap muslim yang mampu pada bulan Ramadan sebelum sholat Idul Fitri.',
          ),
          SizedBox(height: 14),
          _InfoCard(
            title: 'Besaran Zakat Fitrah',
            content:
                'Besaran yang umum digunakan adalah 2,5 kg atau 3,5 liter makanan pokok per jiwa. Pembayaran dengan uang mengikuti ketentuan lembaga zakat setempat.',
          ),
          SizedBox(height: 14),
          _InfoCard(
            title: 'Penerima Zakat',
            content:
                'Zakat disalurkan kepada golongan yang berhak menerimanya (asnaf) sesuai ketentuan syariat.',
          ),
          SizedBox(height: 20),
          _BackHomeButton(),
        ],
      ),
    );
  }
}

class ZakatMalPage extends StatelessWidget {
  const ZakatMalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zakat Mal')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _InfoCard(
            title: 'Pengertian',
            content:
                'Zakat mal adalah zakat atas harta yang memenuhi syarat wajib zakat, termasuk ketentuan nisab dan haul untuk jenis harta tertentu.',
          ),
          SizedBox(height: 14),
          _InfoCard(
            title: 'Syarat dan Ketentuan',
            content:
                'Harta merupakan milik sendiri, mencapai nisab, dan memenuhi ketentuan haul apabila berlaku. Perhitungan dapat berbeda menurut jenis hartanya.',
          ),
          SizedBox(height: 14),
          _InfoCard(
            title: 'Kadar Zakat',
            content:
                'Untuk banyak jenis harta simpanan dan perdagangan, kadar zakat yang umum adalah 2,5% setelah memenuhi syaratnya.',
          ),
          SizedBox(height: 20),
          _BackHomeButton(),
        ],
      ),
    );
  }
}

// ==================== KALKULATOR ZAKAT ====================

class KalkulatorZakatPage extends StatefulWidget {
  const KalkulatorZakatPage({super.key});

  @override
  State<KalkulatorZakatPage> createState() => _KalkulatorZakatPageState();
}

class _KalkulatorZakatPageState extends State<KalkulatorZakatPage> {
  final uangController = TextEditingController();
  final emasController = TextEditingController();
  final investasiController = TextEditingController();
  final piutangController = TextEditingController();
  final hutangController = TextEditingController();

  double? totalHarta;
  double? hasilZakat;

  double parseAmount(TextEditingController controller) {
    final cleaned = controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  void hitungZakat() {
    final total = parseAmount(uangController) +
        parseAmount(emasController) +
        parseAmount(investasiController) +
        parseAmount(piutangController) -
        parseAmount(hutangController);

    setState(() {
      totalHarta = total < 0 ? 0 : total;
      hasilZakat = totalHarta! * 0.025;
    });
  }

  String rupiah(double value) {
    final digits = value.toStringAsFixed(0);

    return digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  @override
  void dispose() {
    uangController.dispose();
    emasController.dispose();
    investasiController.dispose();
    piutangController.dispose();
    hutangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator Zakat')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Masukkan nilai harta dalam Rupiah',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          _AmountField(
            label: 'Uang tunai / tabungan',
            controller: uangController,
          ),
          _AmountField(
            label: 'Nilai emas / perak',
            controller: emasController,
          ),
          _AmountField(
            label: 'Investasi',
            controller: investasiController,
          ),
          _AmountField(
            label: 'Piutang',
            controller: piutangController,
          ),
          _AmountField(
            label: 'Hutang jatuh tempo',
            controller: hutangController,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: hitungZakat,
            child: const Text('Hitung Zakat'),
          ),
          if (totalHarta != null) ...[
            const SizedBox(height: 20),
            _InfoCard(
              title: 'Total Harta Bersih',
              content: 'Rp ${rupiah(totalHarta!)}',
            ),
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Perkiraan Zakat 2,5%',
              content: 'Rp ${rupiah(hasilZakat!)}',
            ),
            const SizedBox(height: 8),
            const Text(
              'Catatan: hasil ini merupakan simulasi sederhana. Pastikan nisab dan syarat zakat harta sudah terpenuhi.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 20),
          const _BackHomeButton(),
        ],
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _AmountField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ==================== JADWAL SHOLAT ====================

class JadwalSholatPage extends StatelessWidget {
  const JadwalSholatPage({super.key});

  String tanggalHariIni() {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];

    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final now = DateTime.now();

    return '${days[now.weekday - 1]}, '
        '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    const prayerTimes = [
      ('Subuh', '04:28', Icons.nightlight_round),
      ('Dzuhur', '11:36', Icons.wb_sunny),
      ('Ashar', '14:55', Icons.wb_cloudy),
      ('Maghrib', '17:42', Icons.wb_twilight),
      ('Isya', '18:54', Icons.nights_stay),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Sholat')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [appOrange, Color(0xFFFF7043)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Text(
                  'Jadwal Sholat',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Solo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tanggalHariIni(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final prayer in prayerTimes)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 17,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(prayer.$3, color: appOrange),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      prayer.$1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),
                  ),
                  Text(
                    prayer.$2,
                    style: const TextStyle(
                      color: appOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          const Text(
            'Catatan: jadwal di atas adalah contoh. Sesuaikan dengan jadwal resmi wilayah setempat.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== VIDEO KAJIAN ====================

class KajianVideo {
  final String title;
  final String ustadz;
  final String duration;
  final String url;
  final String description;

  const KajianVideo({
    required this.title,
    required this.ustadz,
    required this.duration,
    required this.url,
    required this.description,
  });
}

const List<KajianVideo> kajianVideos = [
  KajianVideo(
    title: 'Keutamaan Sholat Tahajud',
    ustadz: 'Ustadz Abdul Somad',
    duration: '18:27',
    url: 'https://www.youtube.com/watch?v=_whtT3afbK8',
    description:
        'Penjelasan tentang keutamaan dan keistimewaan sholat tahajud.',
  ),
  KajianVideo(
    title: 'Adab Berdoa kepada Allah',
    ustadz: 'Ustadz Adi Hidayat',
    duration: '14:58',
    url: 'https://www.youtube.com/watch?v=aVqqQyNzX0Q',
    description:
        'Pembahasan adab-adab penting ketika berdoa kepada Allah SWT.',
  ),
  KajianVideo(
    title: 'Keajaiban Sedekah dan Istighfar',
    ustadz: 'Ustadz Khalid Basalamah',
    duration: '58:46',
    url: 'https://www.youtube.com/watch?v=OqSi-cquZ7Q',
    description:
        'Pembahasan tentang sedekah, istighfar, dan manfaatnya dalam kehidupan.',
  ),
  KajianVideo(
    title: 'Membersihkan Penyakit Hati',
    ustadz: 'Ustadz Hanan Attaki',
    duration: '15:15',
    url: 'https://www.youtube.com/watch?v=G-Z_IE2ip_o',
    description:
        'Pembahasan tentang menjaga hati dan memperbaiki niat dalam beribadah.',
  ),
];

String youtubeId(String url) {
  final uri = Uri.tryParse(url);

  if (uri == null) return '';

  if (uri.host.contains('youtu.be')) {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
  }

  return uri.queryParameters['v'] ?? '';
}

// VIDEO LIST

class VideoKajianPage extends StatelessWidget {
  const VideoKajianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Kajian')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: kajianVideos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final video = kajianVideos[index];

          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                openPage(
                  context,
                  VideoDetailPage(video: video),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _VideoThumbnail(
                      videoId: youtubeId(video.url),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            video.ustadz,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            video.duration,
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// VIDEO THUMBNAIL

class _VideoThumbnail extends StatelessWidget {
  final String videoId;

  const _VideoThumbnail({
    required this.videoId,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = videoId.isEmpty
        ? ''
        : 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 104,
        height: 72,
        child: thumbnailUrl.isEmpty
            ? const ColoredBox(
                color: Color(0xFFE0E0E0),
                child: Icon(
                  Icons.video_library,
                  color: appOrange,
                ),
              )
            : Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Color(0xFFE0E0E0),
                  child: Icon(
                    Icons.video_library,
                    color: appOrange,
                  ),
                ),
              ),
      ),
    );
  }
}

// VIDEO DETAIL AND PLAYER

class VideoDetailPage extends StatefulWidget {
  final KajianVideo video;

  const VideoDetailPage({
    super.key,
    required this.video,
  });

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  // Player hanya dibuat di Android/iOS. youtube_player_flutter
  // tidak mendukung Flutter Web (penyebab layar error di Chrome).
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _controller = YoutubePlayerController(
        initialVideoId: youtubeId(widget.video.url),
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
        ),
      );
    }
  }

  @override
  void deactivate() {
    // Pause video saat halaman ditutup
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildPlayer() {
    final controller = _controller;

    if (controller == null) {
      // Tampilan pengganti untuk Web
      final id = youtubeId(widget.video.url);

      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://img.youtube.com/vi/$id/hqdefault.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const ColoredBox(color: Color(0xFFE0E0E0)),
            ),
            const ColoredBox(color: Colors.black38),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Pemutar video hanya tersedia di Android / iOS.\n'
                  'Jalankan aplikasi di emulator atau HP untuk memutar video.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: appOrange,
      progressColors: const ProgressBarColors(
        playedColor: appOrange,
        handleColor: appOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Kajian'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _buildPlayer(),
          ),
          const SizedBox(height: 20),
          Text(
            widget.video.title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.video.ustadz}  •  ${widget.video.duration}',
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.video.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: darkText,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Video diputar langsung di dalam aplikasi. '
            'Pastikan perangkat terhubung ke internet.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          const _BackHomeButton(),
        ],
      ),
    );
  }
}

// ==================== SHARED WIDGETS ====================

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const _InfoCard({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: appOrange,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            content,
            style: const TextStyle(
              color: darkText,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _NavigationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackHomeButton extends StatelessWidget {
  const _BackHomeButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.of(context).popUntil(
          (route) => route.isFirst,
        );
      },
      icon: const Icon(Icons.home),
      label: const Text('Kembali ke Homepage'),
      style: OutlinedButton.styleFrom(
        foregroundColor: appOrange,
        side: const BorderSide(color: appOrange),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}