import 'package:flutter/material.dart';

import '../viewmodels/home_view_model.dart';
import 'memo_detail_page.dart';

class HomePage extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomePage({super.key, required this.viewModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.loadMemos();
  }

  // 新規メモ追加

  Future<void> addMemo() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const MemoDetailPage()),
    );

    if (!mounted || result == null) return;

    try {
      await viewModel.addMemo(
        title: result['title']!,
        content: result['content']!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('メモを保存しました！'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('メモの保存に失敗しました'),
          backgroundColor: Colors.red,
        ),
      );

      debugPrint('保存エラー：$e');
    }
  }

  // 既存メモの編集

  Future<void> editMemo(int index) async {
    final memo = viewModel.memoList[index];

    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MemoDetailPage(title: memo.title, content: memo.content),
      ),
    );

    if (!mounted || result == null) return;

    try {
      await viewModel.updateMemo(
        id: memo.id,
        title: result['title']!,
        content: result['content']!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('メモを更新しました！'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('メモの更新に失敗しました'),
          backgroundColor: Colors.red,
        ),
      );

      debugPrint('更新エラー：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '反省点メモ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, child) {
          final memos = viewModel.memoList;

          if (memos.isEmpty) {
            return const Center(
              child: Text('まだメモがありません', style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: memos.length,
            itemBuilder: (context, index) {
              final memo = memos[index];

              return Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    memo.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          memo.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          memo.createdAt.substring(0, 10),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.blue),
                  onTap: () => editMemo(index),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: addMemo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
