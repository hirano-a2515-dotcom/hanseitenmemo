import 'package:hive/hive.dart';
import '../models/memo.dart';

class MemoRepository {
  final Box<Map> box;

  MemoRepository(this.box);

  // メモ一覧を取得
  List<Memo> getMemos() {
    final memos = box.values.map((value) {
      return Memo.fromMap(Map<String, dynamic>.from(value));
    }).toList();

    // 新しい順に並べる
    memos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    print('読み込み結果:${memos.length}件');
    return memos;
  }

  // メモを追加
  Future<void> addMemo(Memo memo) async {
    await box.put(memo.id, memo.toMap());

    // 保存されたデータを確認
    print('保存完了！');
    print('保存件数：${box.length}');
    print('保存データ：${box.get(memo.id)}');
  }

  // メモを更新
  Future<void> updateMemo(Memo memo) async {
    await box.put(memo.id, memo.toMap());
  }
}
