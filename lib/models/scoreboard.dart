class Scoreboard {
  List<Results>? results;
  Scoreboard({this.results});
  Scoreboard.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? fullname;
  String? avatar;
  int? category;
  int? score;
  int? rank;
  Results({this.id, this.fullname, this.avatar, this.category, this.score, this.rank});
  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    avatar = json['avatar'];
    category = json['category'];
    score = json['score'];
    rank = json['rank'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['fullname'] = fullname;
    data['avatar'] = avatar;
    data['category'] = category;
    data['score'] = score;
    data['rank'] = rank;
    return data;
  }
}
