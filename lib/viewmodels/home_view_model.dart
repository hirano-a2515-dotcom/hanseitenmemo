import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../repositories/memo_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final MemoRepository repository;

  HomeViewModel(this.repository);

  List<Memo> memoList = [];

  // Hiveからメモを読み込む
  void loadMemos() {
    memoList = repository.getMemos();
    notifyListeners();
  }

  // 新しいメモを追加
  Future<void> addMemo({required String title, required String content}) async {
    final memo = Memo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
    );

    await repository.addMemo(memo);

    loadMemos();
  }

  // 既存メモを編集
  Future<void> updateMemo({
    required String id,
    required String title,
    required String content,
  }) async {
    final oldMemo = memoList.firstWhere((memo) => memo.id == id);

    final updatedMemo = Memo(
      id: oldMemo.id,
      title: title,
      content: content,
      createdAt: oldMemo.createdAt,
    );

    await repository.updateMemo(updatedMemo);

    loadMemos();
  }
}
