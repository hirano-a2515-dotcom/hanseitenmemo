import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'repositories/memo_repository.dart';
import 'viewmodels/home_view_model.dart';
import 'views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hiveの初期化
  await Hive.initFlutter();

  // メモ保存用Boxを開く
  final memoBox = await Hive.openBox<Map>('memos');

  // Repositoryを作成
  final repository = MemoRepository(memoBox);

  // ViewModelを作成
  final viewModel = HomeViewModel(repository);

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final HomeViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '反省点メモ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: HomePage(viewModel: viewModel),
    );
  }
}
