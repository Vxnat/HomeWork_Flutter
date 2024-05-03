class SampleItem {
  SampleItem({
    required this.date,
    required this.id,
    required this.description,
    required this.imgItem,
    required this.name,
  });
  late final String date;
  late final String id;
  late final String description;
  late final String imgItem;
  late final String name;

  SampleItem.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    id = json['id'];
    description = json['description'];
    imgItem = json['img_item'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date;
    data['id'] = id;
    data['description'] = description;
    data['img_item'] = imgItem;
    data['name'] = name;
    return data;
  }
}
