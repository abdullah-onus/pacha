class FeedItemText {
  String? text;
  FeedItemText({this.text});
  FeedItemText.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['text'] = text;
    return data;
  }
}
