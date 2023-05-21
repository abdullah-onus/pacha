class FeedItemMedia {
  String? url;
  int? height;
  int? width;
  FeedItemMedia({this.url, this.height, this.width});
  FeedItemMedia.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    height = json['height'];
    width = json['width'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['url'] = url;
    data['height'] = height;
    data['width'] = width;
    return data;
  }
}
