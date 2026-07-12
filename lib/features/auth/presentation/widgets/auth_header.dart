import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/theme.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String imagePath;
  final double containerSize;
  final double imageSize;

  const AuthHeader({
    super.key,
    this.title = 'Gezi',
    this.imagePath = 'assets/images/GeziBrand.png',
    this.containerSize = 48.0, 
    this.imageSize = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: _buildImage(imagePath),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textColorDark,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Widget _buildImage(String path) {
    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      path,
      width: imageSize,
      height: imageSize,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox();
      },
    );
  }
}
