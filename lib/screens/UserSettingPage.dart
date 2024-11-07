import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettingsPage extends StatefulWidget {
  final String email; // 사용자의 이메일

  UserSettingsPage({Key? key, required this.email}) : super(key: key);

  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  late DateTime _startDate;
  late int _dailySmoking;
  String _nickname = '';
  double _totalMoneySaved = 0; // 총 절약된 금액

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _dailySmoking = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 설정'),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDatePicker(),
            SizedBox(height: 24),
            _buildDailySmokingInput(),
            SizedBox(height: 24),
            _buildNicknameInput(),
            SizedBox(height: 24),
            _buildTotalMoneySavedInput(),
            SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '금연 시작 날짜',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _startDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null && picked != _startDate) {
              setState(() {
                _startDate = picked;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_startDate.year}-${_startDate.month}-${_startDate.day}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailySmokingInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '하루 평균 흡연량',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '예) 20',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _dailySmoking = int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
              Text(
                '개비',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNicknameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '닉네임',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '닉네임을 입력하세요',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          onChanged: (value) {
            setState(() {
              _nickname = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTotalMoneySavedInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '총 절약된 금액',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '예) 10000',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          onChanged: (value) {
            setState(() {
              _totalMoneySaved = double.tryParse(value) ?? 0; // 사용자 입력에 따라 총 절약된 금액 업데이트
            });
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        _saveUserData();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[600],
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        '저장하기',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  void _saveUserData() async {
    try {
      // Firestore에 사용자 데이터 저장
      await FirebaseFirestore.instance.collection('users').add({
        'email': widget.email, // 로그인 시 사용자의 이메일을 가져옴
        'nickname': _nickname,
        'start_date': Timestamp.fromDate(_startDate), // Timestamp로 변환
        'daily_smoking_amount': _dailySmoking,
        'total_money_saved': _totalMoneySaved, // 입력된 금액
      });
      // 데이터 저장 후 필요한 작업 (예: 홈 페이지로 이동)
      print('사용자 정보가 저장되었습니다.');
    } catch (e) {
      print('데이터 저장 실패: $e');
    }
  }
}
