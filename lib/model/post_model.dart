import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'post_model.g.dart';

part 'post_model.freezed.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
