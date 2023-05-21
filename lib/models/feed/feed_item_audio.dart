class FeedItemAudio {
  String? url;
  double? duration;
  FeedItemAudio({this.url, this.duration});
  FeedItemAudio.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    duration = json['duration'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['url'] = url;
    data['duration'] = duration;
    return data;
  }
}
