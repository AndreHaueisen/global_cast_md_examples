import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staycurrent/util/analytics.dart';
import 'package:staycurrent/util/api.dart';
import 'package:staycurrent/util/data/data_member.dart';
import 'package:staycurrent/util/exceptions.dart';

class DataUser extends Equatable {

  final int id;
  final String username;
  final String displayName;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;
  final String hospitalAffiliation;
  final String practiceFocus;
  final String position;
  final String subspecialty;
  final String traineeLevel;
  final String country;
  final bool admin;
  final bool privateMessage;
  final bool editorsPicks;
  final bool editorsPicksPush;
  final bool tags;
  final bool tagsPush;
  final bool follows;
  final bool followsPush;
  final bool discussionComments;
  final bool discussionCommentsPush;
  final String firebaseId;

  final int discussionsStarted;

  // final List<DataMember>? following;
  final int followers;

  // final ValueNotifier<bool> loadingMoreInfo = ValueNotifier<bool>(true);

  final String joinDate;

  const DataUser._({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.admin,
    required this.firebaseId,
    required this.hospitalAffiliation,
    required this.practiceFocus,
    required this.position,
    required this.subspecialty,
    required this.traineeLevel,
    required this.country,
    required this.privateMessage,
    required this.editorsPicks,
    required this.editorsPicksPush,
    required this.tags,
    required this.tagsPush,
    required this.follows,
    required this.followsPush,
    required this.discussionComments,
    required this.discussionCommentsPush,
    required this.discussionsStarted,
    required this.followers,
    required this.joinDate,
  });

  // static Future<DataUser?> fromFirebase(String firebaseId, Future<String> fbt, String email) async {
  //
  //   String token = await fbt;
  //   Map<String, dynamic>? json = await post<Map<String, dynamic>>(
  //     'verify_token',
  //     withAuth: false,
  //     data: FormData.fromMap({
  //       'token': token,
  //       'firebase_id': firebaseId,
  //       'email': email,
  //     }),
  //   );
  //
  //   if (json == null) return null;
  //
  //   apiLogger.addAttribute("user-id", firebaseId);
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('registered_previously', true);
  //
  //   DataUser user = DataUser._(
  //       json['id'],
  //       json['username'],
  //       json['display_name'],
  //       email,
  //       json['first_name'],
  //       json['last_name'],
  //       json['avatar'],
  //       // json['hospital_affiliation'],
  //       // json['practice_focus'],
  //       // json['position'],
  //       // json['country'],
  //       json['is_admin'] ?? false,
  //       // json['private_message'],
  //       // json['editors_picks'],
  //       // json['editors_picks_push'],
  //       // json['tags'],
  //       // json['tags_push'],
  //       // json['follows'],
  //       // json['follows_push'],
  //       // json['discussion_comments'],
  //       // json['discussion_comments_push'],
  //       firebaseId,
  //   );
  //
  //   get<Map<String, dynamic>>(
  //     'profile/${json['id']}',
  //     withAuth: true,
  //     firebaseId: firebaseId,
  //     userId: json['id'],
  //     timeout: 30,
  //   ).then((data) async {
  //     if (data == null) return;
  //     user.hospitalAffiliation = data['hospital_affiliation'];
  //     user.practiceFocus = data['practice_focus'];
  //     user.position = data['position'];
  //     user.subspecialty = data['subspecialty'];
  //     user.traineeLevel = data['trainee_level'];
  //     user.country = data['country'];
  //     user.privateMessage = data['private_message'] ?? false;
  //     user.editorsPicks = data['editors_picks'] ?? false;
  //     user.editorsPicksPush = data['editors_picks_push'] ?? false;
  //     user.tags = data['tags'] ?? false;
  //     user.tagsPush = data['tags_push'] ?? false;
  //     user.follows = data['follows'] ?? false;
  //     user.followsPush = data['follows_push'] ?? false;
  //     user.discussionComments = data['discussion_comments'] ?? false;
  //     user.discussionCommentsPush = data['discussion_comments_push'] ?? false;
  //
  //     user.discussionsStarted = data['discussion_count'];
  //     user.followers = data['followers'];
  //
  //
  //     List<DataMember> following = [];
  //     for (Map<String, dynamic> member in data['following'])
  //       following.add(DataMember.fromJson(member));
  //
  //     user.following = following;
  //
  //     user.joinDate = data['join_date'];
  //
  //     user.loadingMoreInfo.value = false;
  //
  //     // Firebase Analytics
  //     setupUserProperties(user);
  //
  //   }).catchError((error) {
  //     if (error is ReportableException)
  //       error.report();
  //     else if (error is PlatformException)
  //       ReportableException.fromPlatformException(error).report();
  //     else
  //       print(error);
  //   });
  //
  //   return user;
  //
  // }

  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser._(
        id: json['id'],
        username: json['username'],
        displayName: json['display_name'],
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        avatar: avatar,
        admin: admin,
        firebaseId: firebaseId,
        hospitalAffiliation: hospitalAffiliation,
        practiceFocus: practiceFocus,
        position: position,
        subspecialty: subspecialty,
        traineeLevel: traineeLevel,
        country: country,
        privateMessage: privateMessage,
        editorsPicks: editorsPicks,
        editorsPicksPush: editorsPicksPush,
        tags: tags,
        tagsPush: tagsPush,
        follows: follows,
        followsPush: followsPush,
        discussionComments: discussionComments,
        discussionCommentsPush: discussionCommentsPush,
        discussionsStarted: discussionsStarted,
        followers: followers,
        joinDate: joinDate)
  }

  bool get push =>
      (editorsPicksPush ?? false) && (tagsPush ?? false) &&
          (followsPush ?? false) && (discussionCommentsPush ?? false);

  bool get emailNotifications =>
      (editorsPicks ?? false) && (tags ?? false) &&
          (follows ?? false) && (discussionComments ?? false);

  // bool getNotificationSetting(String field, String method) {
  //   switch (field.toLowerCase()) {
  //     case 'mentions':
  //       return (method.toLowerCase() == 'push' ? tagsPush : tags) ?? false;
  //     case 'follows':
  //       return (method.toLowerCase() == 'push' ? followsPush : follows) ??
  //           false;
  //     case 'comments':
  //       return (method.toLowerCase() == 'push'
  //           ? discussionCommentsPush
  //           : discussionComments) ?? false;
  //
  //     case 'private_message':
  //       return privateMessage ?? false;
  //   }
  //   return false;
  // }
  //
  // Future<bool> toggleNotificationField(String field, String method,
  //     [bool? val]) async {
  //   bool newVal = val ?? !getNotificationSetting(field, method);
  //   switch (field.toLowerCase()) {
  //     case 'mentions':
  //       return await toggleTags(method.toLowerCase(), newVal);
  //     case 'follows':
  //       return await toggleFollows(method.toLowerCase(), newVal);
  //     case 'comments':
  //       return await toggleDiscussionComments(method.toLowerCase(), newVal);
  //
  //     case 'private_message':
  //       return await togglePrivateMessages(newVal);
  //   }
  //   return false;
  // }
  //
  // Future<bool> toggleTags(String method, bool value) async {
  //   method = method.toLowerCase();
  //   try {
  //     await post(
  //       'notification/settings/update',
  //       queryParameters: {
  //         'notification_method': method,
  //         'notification': 'tags',
  //         'value': value,
  //       },
  //     );
  //
  //
  //     if (method == 'push')
  //       this.tagsPush = value;
  //     else
  //       this.tags = value;
  //     return true;
  //   } on ReportableException catch (e) {
  //     e.report();
  //
  //     return false;
  //   }
  // }
  //
  // Future<bool> toggleFollows(String method, bool value) async {
  //   method = method.toLowerCase();
  //   try {
  //     await post(
  //       'notification/settings/update',
  //       queryParameters: {
  //         'notification_method': method,
  //         'notification': 'follows',
  //         'value': value,
  //       },
  //     );
  //
  //     if (method == 'push')
  //       this.followsPush = value;
  //     else
  //       this.follows = value;
  //     return true;
  //   } on ReportableException catch (e) {
  //     e.report();
  //
  //     return false;
  //   }
  // }
  //
  // Future<bool> toggleDiscussionComments(String method, bool value) async {
  //   method = method.toLowerCase();
  //   try {
  //     await post(
  //       'notification/settings/update',
  //       queryParameters: {
  //         'notification_method': method,
  //         'notification': 'discussion_comments',
  //         'value': value,
  //       },
  //     );
  //
  //     if (method == 'push')
  //       this.discussionCommentsPush = value;
  //     else
  //       this.discussionComments = value;
  //     return true;
  //   } on ReportableException catch (e) {
  //     e.report();
  //
  //     return false;
  //   }
  // }
  //
  // Future<bool> togglePrivateMessages(bool value) async {
  //   try {
  //     await post(
  //       'notification/settings/update',
  //       queryParameters: {
  //         'notification_method': 'email',
  //         'notification': 'private_message',
  //         'value': value
  //       },
  //     );
  //
  //     this.privateMessage = value;
  //     return true;
  //   } on ReportableException catch (e) {
  //     e.report();
  //
  //     return false;
  //   }
  // }

  @override
  List<Object?> get props => [id];

}