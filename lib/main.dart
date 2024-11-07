import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/LoginPage.dart';
import 'firebase_options.dart';  // 자동 생성된 firebase_options 파일 import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedMetric = 'daysSmokeFree';
  String selectedTab = 'dailyGoal';

  void selectMetric(String metric) {
    setState(() {
      selectedMetric = metric;
    });
  }

  void selectTab(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  Widget buildSelectedMetricContent() {
    switch (selectedMetric) {
      case 'daysSmokeFree':
        return _buildAchievementCard(
          title: '금연 진행',
          value: '7일',
          icon: Icons.timer,
          iconColor: Colors.blue,
        );
      case 'moneySaved':
        return _buildAchievementCard(
          title: '절약 금액',
          value: '100,000원',
          icon: Icons.attach_money,
          iconColor: Colors.green,
        );
      case 'dailyGoal':
        return _buildAchievementCard(
          title: '오늘의 목표',
          value: '하루 2개비 줄이기',
          icon: Icons.psychology,
          iconColor: Colors.purple,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildAchievementSelection(),
                const SizedBox(height: 24),
                buildSelectedMetricContent(),
                const SizedBox(height: 40),
                _buildTabbedGuideAndDonationSection(),
                const SizedBox(height: 40),
                _buildQuickActions(),
                const SizedBox(height: 100),
              ],
            ),
            _buildEmergencyButton(),
            _buildLogoutLink() // 로그아웃 버튼을 항상 하단에 고정
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          '환영합니다.',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '김태린님의 금연 여정',
          style: TextStyle(
            fontSize: 32,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetricButton('금연 진행', 'daysSmokeFree'),
        _buildMetricButton('절약 금액', 'moneySaved'),
        _buildMetricButton('오늘의 목표', 'dailyGoal'),
      ],
    );
  }

  Widget _buildMetricButton(String title, String metric) {
    return Expanded(
      child: GestureDetector(
        onTap: () => selectMetric(metric),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selectedMetric == metric ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectedMetric == metric ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selectedMetric == metric ? Colors.blue : Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(
            icon,
            size: 32,
            color: iconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTabbedGuideAndDonationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTabButton('오늘의 목표', 'dailyGoal'),
            _buildTabButton('후원 목표', 'donationGoal'),
          ],
        ),
        const SizedBox(height: 16),
        selectedTab == 'dailyGoal' ? _buildAIGuideSection() : _buildDonationSection(),
      ],
    );
  }

  Widget _buildTabButton(String title, String tab) {
    return Expanded(
      child: GestureDetector(
        onTap: () => selectTab(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selectedTab == tab ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectedTab == tab ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selectedTab == tab ? Colors.blue : Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIGuideSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          const Icon(
            Icons.psychology,
            size: 32,
            color: Colors.purple,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '오늘의 목표',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '하루 2개비 줄이기',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonationSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.volunteer_activism,
                size: 32,
                color: Colors.redAccent,
              ),
              const SizedBox(width: 16),
              const Text(
                '이번 달 절약 금액: 100,000원',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '후원 가능한 금액: 10,000원',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '후원 대상: 지역 내 결식아동 또는 해외 빈민 지원',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // 후원 기능 연결 (예: 서버에 후원 요청)
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              '10,000원 후원하기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '빠른 실행',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildQuickActionButton(
          title: '실시간 상담',
          description: 'AI 상담사와 대화하기',
          icon: Icons.psychology,
        ),
        const SizedBox(height: 12),
        _buildQuickActionButton(
          title: '환경 기여도',
          description: '내가 줄인 탄소 배출량',
          icon: Icons.eco,
        ),
        const SizedBox(height: 12),
        _buildQuickActionButton(
          title: '도전 과제',
          description: '다음 목표까지 3일 남음',
          icon: Icons.emoji_events,
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey[600]),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
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

  Widget _buildEmergencyButton() {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          '긴급 흡연 욕구 지원',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 로그아웃 링크를 화면 하단에 고정
  Widget _buildLogoutLink() {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: Text(
            '로그아웃',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
