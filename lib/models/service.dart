class Service {
  final String title;
  final String? description;
  final double? price;
  final String? duration;
  final List<String> features;
  final bool isDone;

  Service({
    required this.title,
    this.description,
    this.price,
    this.duration,
    required this.features,
    required this.isDone,
  });
}