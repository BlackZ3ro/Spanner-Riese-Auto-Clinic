import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_part_view.freezed.dart';
part 'customer_part_view.g.dart';

@freezed
abstract class CustomerPartView with _$CustomerPartView {
  const factory CustomerPartView({
    required String name,
    required int quantity,
  }) = _CustomerPartView;

  factory CustomerPartView.fromJson(Map<String, dynamic> json) =>
      _$CustomerPartViewFromJson(json);
}