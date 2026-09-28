import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_labor_view.freezed.dart';
part 'customer_labor_view.g.dart';

@freezed
abstract class CustomerLaborView with _$CustomerLaborView {
  const factory CustomerLaborView({
    required String description,
    required double hours,
  }) = _CustomerLaborView;

  factory CustomerLaborView.fromJson(Map<String, dynamic> json) =>
      _$CustomerLaborViewFromJson(json);
}