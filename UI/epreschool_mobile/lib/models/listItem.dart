class ListItem {
  late int id;
  late String label;

  ListItem({required this.id, required this.label});

  ListItem.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    return data;
  }
}