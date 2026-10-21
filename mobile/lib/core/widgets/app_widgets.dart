import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Top bar for every screen: surface colour, hairline bottom border and a
/// chevron back button (shown only when there is a screen to go back to).
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
    this.showBack = true,
  });

  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool showBack;

  static const double _barHeight = 56;

  @override
  Size get preferredSize => Size.fromHeight(_barHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final canGoBack = showBack && Navigator.of(context).canPop();

    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: canGoBack ? 52 : 0,
      leading: canGoBack
          ? IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.chevron_left, size: 28),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      titleSpacing: canGoBack ? 0 : 20,
      toolbarHeight: _barHeight,
      centerTitle: false,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      shape: const Border(bottom: BorderSide(color: AppColors.border)),
      systemOverlayStyle: AppTheme.overlayStyle,
      title: Text(title, style: AppText.heading(18)),
      actions: actions,
      bottom: bottom,
    );
  }
}

/// Bordered surface card. Tappable when [onTap] is given.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 14,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Rounded square with a tinted background and a matching icon.
class IconChip extends StatelessWidget {
  const IconChip({
    super.key,
    required this.icon,
    required this.tone,
    this.size = 44,
    this.iconSize = 22,
    this.radius = 12,
  });

  final IconData icon;
  final AppTone tone;
  final double size;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tone.chipBg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: iconSize, color: tone.chipText),
    );
  }
}

/// Small pill used for statuses and phases.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.tone,
    this.large = false,
  });

  final String label;
  final AppTone tone;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: large ? 12 : 9, vertical: large ? 5 : 3),
      decoration: BoxDecoration(
        color: tone.chipBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppText.body(large ? 12 : 11, weight: FontWeight.w600, color: tone.chipText),
      ),
    );
  }
}

/// Small uppercase section label, e.g. "WORKSPACE".
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: AppText.label);
}

/// Vehicle photo, or the green "Vehicle photo" placeholder when there isn't one.
class VehiclePhoto extends StatelessWidget {
  const VehiclePhoto({super.key, this.imageUrl, this.height = 120});

  final String? imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppTone.green.chipBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_outlined, size: 32, color: AppTone.green.chipText),
          const SizedBox(height: 6),
          Text(
            'Vehicle photo',
            style: AppText.body(12, weight: FontWeight.w500, color: AppTone.green.chipText),
          ),
        ],
      ),
    );

    final url = imageUrl;
    if (url == null || url.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}

/// Hairline divider with the vertical spacing used between sections.
class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Divider(height: 1),
      );
}
