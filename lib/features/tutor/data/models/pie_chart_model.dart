class PieChartDataModel {
  final String name;
  final double percentage;

  PieChartDataModel({required this.name, required this.percentage});

  factory PieChartDataModel.fromJson(Map<String, dynamic> json) {
    return PieChartDataModel(
      name: json['name'],
      percentage: json['percentage'],
    );
  }
}