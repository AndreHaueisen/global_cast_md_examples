import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staycurrent/util/analytics.dart';
import 'package:staycurrent/util/api.dart';
import 'package:staycurrent/util/data/data_member.dart';
import 'package:staycurrent/util/exceptions.dart';

class DataUser {

  int id;
  String username;
  String displayName;
  String email;
  String? firstName;
  String? lastName;
  String? avatar;
  String? hospitalAffiliation;
  String? practiceFocus;
  String? position;
  String? subspecialty;
  String? traineeLevel;
  String? country;
  bool? admin;
  bool? privateMessage;
  bool? editorsPicks;
  bool? editorsPicksPush;
  bool? tags;
  bool? tagsPush;
  bool? follows;
  bool? followsPush;
  bool? discussionComments;
  bool? discussionCommentsPush;
  String? firebaseId;

  int? discussionsStarted;
  List<DataMember>? following;
  int? followers;

  ValueNotifier<bool> loadingMoreInfo = ValueNotifier<bool>(true);

  String? joinDate;

  static Future<DataUser?> fromFirebase(String firebaseId, Future<String> fbt, String email) async {

    String token = await fbt;
    Map<String, dynamic>? json = await post<Map<String, dynamic>>(
      'verify_token',
      withAuth: false,
      data: FormData.fromMap({
        'token': token,
        'firebase_id': firebaseId,
        'email': email,
      }),
    );

    if (json == null) return null;

    apiLogger.addAttribute("user-id", firebaseId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('registered_previously', true);

    DataUser user = DataUser._(
        json['id'],
        json['username'],
        json['display_name'],
        email,
        json['first_name'],
        json['last_name'],
        json['avatar'],
        // json['hospital_affiliation'],
        // json['practice_focus'],
        // json['position'],
        // json['country'],
        json['is_admin'] ?? false,
        // json['private_message'],
        // json['editors_picks'],
        // json['editors_picks_push'],
        // json['tags'],
        // json['tags_push'],
        // json['follows'],
        // json['follows_push'],
        // json['discussion_comments'],
        // json['discussion_comments_push'],
        firebaseId,
    );

    get<Map<String, dynamic>>(
      'profile/${json['id']}',
      withAuth: true,
      firebaseId: firebaseId,
      userId: json['id'],
      timeout: 30,
    ).then((data) async {
      if (data == null) return;
      user.hospitalAffiliation = data['hospital_affiliation'];
      user.practiceFocus = data['practice_focus'];
      user.position = data['position'];
      user.subspecialty = data['subspecialty'];
      user.traineeLevel = data['trainee_level'];
      user.country = data['country'];
      user.privateMessage = data['private_message'] ?? false;
      user.editorsPicks = data['editors_picks'] ?? false;
      user.editorsPicksPush = data['editors_picks_push'] ?? false;
      user.tags = data['tags'] ?? false;
      user.tagsPush = data['tags_push'] ?? false;
      user.follows = data['follows'] ?? false;
      user.followsPush = data['follows_push'] ?? false;
      user.discussionComments = data['discussion_comments'] ?? false;
      user.discussionCommentsPush = data['discussion_comments_push'] ?? false;

      user.discussionsStarted = data['discussion_count'];
      user.followers = data['followers'];


      List<DataMember> following = [];
      for (Map<String, dynamic> member in data['following'])
        following.add(DataMember.fromJson(member));

      user.following = following;

      user.joinDate = data['join_date'];

      user.loadingMoreInfo.value = false;

      // Firebase Analytics
      setupUserProperties(user);

    }).catchError((error) {
      if (error is ReportableException)
        error.report();
      else if (error is PlatformException)
        ReportableException.fromPlatformException(error).report();
      else
        print(error);
    });

    return user;

  }

  DataUser._(
    this.id,
    this.username,
    this.displayName,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    // this.hospitalAffiliation,
    // this.practiceFocus,
    // this.position,
    // this.country,
    this.admin,
    // this.privateMessage,
    // this.editorsPicks,
    // this.editorsPicksPush,
    // this.tags,
    // this.tagsPush,
    // this.follows,
    // this.followsPush,
    // this.discussionComments,
    // this.discussionCommentsPush,
    this.firebaseId,
  );

  DataUser._other(this.id, this.username, this.displayName, this.email);

  factory DataUser.fromJson(Map<dynamic, dynamic> json) =>
      DataUser._other(json['id'], json['profile_name'], json['display_name'], json['email']);


  @override
  bool operator ==(Object? other) {
    return other != null &&
      other is DataUser &&
      other.id == id &&
      other.username == username &&
      other.displayName == displayName &&
      other.email == email &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.avatar == avatar &&
      other.hospitalAffiliation == hospitalAffiliation &&
      other.practiceFocus == practiceFocus &&
      other.position == position &&
      other.subspecialty == subspecialty &&
      other.country == country &&
      other.admin == admin &&
      other.privateMessage == privateMessage &&
      other.editorsPicks == editorsPicks &&
      other.editorsPicksPush == editorsPicksPush &&
      other.tags == tags &&
      other.tagsPush == tagsPush &&
      other.follows == follows &&
      other.followsPush == followsPush &&
      other.discussionComments == discussionComments &&
      other.discussionCommentsPush == discussionCommentsPush &&
      other.firebaseId == firebaseId;
  }

  @override
  int get hashCode => hashValues(hashValues(id, username, displayName, email),
      firstName, lastName, avatar, hospitalAffiliation, practiceFocus, position,
      subspecialty, country, admin, privateMessage, editorsPicks,
      editorsPicksPush, tags, tagsPush, follows, followsPush,
      discussionComments, discussionCommentsPush, firebaseId);

  bool get push => (editorsPicksPush ?? false) && (tagsPush ?? false) &&
      (followsPush ?? false) && (discussionCommentsPush ?? false);

  bool get emailNotifications => (editorsPicks ?? false) && (tags ?? false) &&
      (follows ?? false) && (discussionComments ?? false);

  bool getNotificationSetting(String field, String method) {
    switch (field.toLowerCase()) {
      case 'mentions': return (method.toLowerCase() == 'push' ? tagsPush : tags) ?? false;
      case 'follows': return (method.toLowerCase() == 'push' ? followsPush : follows) ?? false;
      case 'comments': return (method.toLowerCase() == 'push' ? discussionCommentsPush : discussionComments) ?? false;

      case 'private_message': return privateMessage ?? false;
    }
    return false;
  }

  Future<bool> toggleNotificationField(String field, String method, [bool? val]) async {
    bool newVal = val ?? !getNotificationSetting(field, method);
    switch (field.toLowerCase()) {
      case 'mentions': return await toggleTags(method.toLowerCase(), newVal);
      case 'follows': return await toggleFollows(method.toLowerCase(), newVal);
      case 'comments': return await toggleDiscussionComments(method.toLowerCase(), newVal);

      case 'private_message': return await togglePrivateMessages(newVal);
    }
    return false;
  }

  Future<bool> toggleTags(String method, bool value) async {
    method = method.toLowerCase();
    try {
      await post(
        'notification/settings/update',
        queryParameters: {
          'notification_method': method,
          'notification': 'tags',
          'value': value,
        },
      );


      if (method == 'push')
        this.tagsPush = value;
      else
        this.tags = value;
      return true;
    } on ReportableException catch (e) {
      e.report();

      return false;
    }
  }

  Future<bool> toggleFollows(String method, bool value) async {
    method = method.toLowerCase();
    try {
      await post(
        'notification/settings/update',
        queryParameters: {
          'notification_method': method,
          'notification': 'follows',
          'value': value,
        },
      );

      if (method == 'push')
        this.followsPush = value;
      else
        this.follows = value;
      return true;
    } on ReportableException catch (e) {
      e.report();

      return false;
    }
  }

  Future<bool> toggleDiscussionComments(String method, bool value) async {
    method = method.toLowerCase();
    try {
      await post(
        'notification/settings/update',
        queryParameters: {
          'notification_method': method,
          'notification': 'discussion_comments',
          'value': value,
        },
      );

      if (method == 'push')
        this.discussionCommentsPush = value;
      else
        this.discussionComments = value;
      return true;
    } on ReportableException catch (e) {
      e.report();

      return false;
    }
  }

  Future<bool> togglePrivateMessages(bool value) async {
    try {
      await post(
        'notification/settings/update',
        queryParameters: {
          'notification_method': 'email',
          'notification': 'private_message',
          'value': value
        },
      );

      this.privateMessage = value;
      return true;
    } on ReportableException catch (e) {
      e.report();

      return false;
    }
  }

}