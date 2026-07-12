import 'package:equatable/equatable.dart';

class OnboardingStepEntity extends Equatable {
  final String title;
  final String subtitle;
  final String imageUrl;

  const OnboardingStepEntity({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [title, subtitle, imageUrl];
}
