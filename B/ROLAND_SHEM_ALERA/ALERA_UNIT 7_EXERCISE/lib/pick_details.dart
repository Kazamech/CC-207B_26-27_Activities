class PickDetails {
  const PickDetails({
    required this.title,
    required this.summary,
    this.imageUrl,
  });

  final String title;
  final String summary;
  final String? imageUrl;
}