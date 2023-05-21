import 'dart:convert';
import 'package:pacha/models/feed/feed_item_audio.dart';
import 'package:pacha/models/feed/feed_item_media.dart';
import 'feed_item_text.dart';

class FeedItems {
  List<Feed>? feed;
  FeedItems({this.feed});
  FeedItems.fromJson(Map<String, dynamic> json) {
    if (json['feed'] != null) {
      feed = <Feed>[];
      json['feed'].forEach((v) {
        feed!.add(Feed.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (feed != null) {
      data['feed'] = feed!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feed {
  int? id;
  String? type;
  bool? showUser;
  int? userId;
  String? userFullname;
  int? userCategory;
  String? userAvatar;
  bool? showAvatar;
  String? avatar;
  bool? showTitle;
  String? title;
  bool? showSubtitle;
  String? subtitle;
  bool? showBody;
  dynamic body;
  bool? showDescription;
  String? description;
  bool? showCreatedAt;
  String? createdAt;
  Feed(
      {this.id,
      this.type,
      this.showUser,
      this.userId,
      this.userFullname,
      this.userCategory,
      this.userAvatar,
      this.showAvatar,
      this.avatar,
      this.showTitle,
      this.title,
      this.showSubtitle,
      this.subtitle,
      this.showBody,
      this.body,
      this.showDescription,
      this.description,
      this.showCreatedAt,
      this.createdAt});
  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    showUser = json['show_user'];
    userId = json['user_id'];
    userFullname = json['user_fullname'];
    userCategory = json['user_category'];
    userAvatar = json['user_avatar'];
    showAvatar = json['show_avatar'];
    avatar = json['avatar'];
    showTitle = json['show_title'];
    title = json['title'];
    showSubtitle = json['show_subtitle'];
    subtitle = json['subtitle'];
    showBody = json['show_body'];
    // --- ENUM('album', 'audio', 'event', 'photo', 'score', 'text', 'video')
    if (type == "album") {
      body = [];
      jsonDecode(json['body']).forEach((v) {
        body.add(FeedItemMedia.fromJson(v));
      });
    } else if (type == "audio") {
      body = FeedItemAudio.fromJson(jsonDecode(json['body']));
    } else if (type == "event") {
      // body = FeedItemMedia.fromJson(jsonDecode(json['body']));
    } else if (type == "photo") {
      body = FeedItemMedia.fromJson(jsonDecode(json['body']));
    } else if (type == "score") {
      // body = FeedItemMedia.fromJson(jsonDecode(json['body']));
    } else if (type == "text") {
      body = FeedItemText.fromJson(jsonDecode(json['body']));
    } else if (type == "video") {
      body = FeedItemMedia.fromJson(jsonDecode(json['body']));
    }
    showDescription = json['show_description'];
    description = json['description'];
    showCreatedAt = json['show_created_at'];
    createdAt = json['created_at'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['type'] = type;
    data['show_user'] = showUser;
    data['user_id'] = userId;
    data['user_fullname'] = userFullname;
    data['user_category'] = userCategory;
    data['user_avatar'] = userAvatar;
    data['show_avatar'] = showAvatar;
    data['avatar'] = avatar;
    data['show_title'] = showTitle;
    data['title'] = title;
    data['show_subtitle'] = showSubtitle;
    data['subtitle'] = subtitle;
    data['show_body'] = showBody;
    data['body'] = body;
    data['show_description'] = showDescription;
    data['description'] = description;
    data['show_created_at'] = showCreatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
