class Memo {
  final String id;
  final String title;
  final String content;
  final String createdAt;

  Memo({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  // Map形式に変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
    };
  }

  // Map形式からMemoに変換
  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}
