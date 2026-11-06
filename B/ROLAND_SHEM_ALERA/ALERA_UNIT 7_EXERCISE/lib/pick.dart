class Pick {
  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String id;
  final String title;
  final String kind;
  final String externalId;
  final String note;

  bool get isBook => kind.trim().toLowerCase() == 'book';
}