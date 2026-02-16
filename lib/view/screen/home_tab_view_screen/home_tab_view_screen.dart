// ignore_for_file: deprecated_member_use

import 'package:boimteric_app_getx/controller/home_tab_view_screen_controller/home_tab_view_screen_controller.dart';
import 'package:boimteric_app_getx/core/theme/app_colors.dart';
import 'package:boimteric_app_getx/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Home Tab View Screen with location tracking and safe zone detection
class HomeTabViewScreen extends StatelessWidget {
  const HomeTabViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeTabViewScreenControllerImp>(
      init: HomeTabViewScreenControllerImp(),
      builder: (controller) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.refreshLocation,
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Section
                    _buildHeader(context, controller),
                    const SizedBox(height: 24),

                    // Location Status Card
                    _buildLocationStatusCard(context, controller),
                    const SizedBox(height: 16),

                    // Safe Zone Info Card
                    _buildSafeZoneInfoCard(context, controller),
                    const SizedBox(height: 16),

                    // Location Details Card
                    _buildLocationDetailsCard(context, controller),
                    const SizedBox(height: 24),

                    // Check-in/Check-out Button
                    _buildActionButton(context, controller),
                    const SizedBox(height: 16),

                    // Status Indicator
                    _buildStatusIndicator(context, controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build header section with title
  Widget _buildHeader(
    BuildContext context,
    HomeTabViewScreenController controller,
  ) {
    return Center(
      child: Text(
        'attendance'.tr,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }

  /// Build location status card with dynamic theming
  Widget _buildLocationStatusCard(
    BuildContext context,
    HomeTabViewScreenController controller,
  ) {
    final statusConfig = _getStatusConfig(controller.locationStatus, context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: statusConfig.gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: statusConfig.shadowColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(statusConfig.icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusConfig.title,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        statusConfig.subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white.withOpacity(0.9),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      controller.locationStatusMessage,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build safe zone information card
  Widget _buildSafeZoneInfoCard(
    BuildContext context,
    HomeTabViewScreenController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.place_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'safe_zone_information'.tr,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.business,
              label: 'nearest_location'.tr,
              value: controller.nearestLocation?.name ?? 'Unknown',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              icon: Icons.social_distance,
              label: 'distance'.tr,
              value: controller.isInSafeZone
                  ? 'within_range'.tr
                  : '${controller.distanceToSafeZone.toStringAsFixed(0)}m away',
              valueColor: controller.isInSafeZone
                  ? AppColors.success
                  : AppColors.warning,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              icon: Icons.radio_button_checked,
              label: 'zone_radius'.tr,
              value: '${controller.nearestLocation?.radius ?? 0}m',
            ),
          ],
        ),
      ),
    );
  }

  /// Build location details card
  Widget _buildLocationDetailsCard(
    BuildContext context,
    HomeTabViewScreenController controller,
  ) {
    final position = controller.currentPosition;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.my_location, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'current_coordinates'.tr,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCoordinateBox(
                    context,
                    label: 'latitude'.tr,
                    value: position != null
                        ? position.latitude.toStringAsFixed(6)
                        : '--',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCoordinateBox(
                    context,
                    label: 'longitude'.tr,
                    value: position != null
                        ? position.longitude.toStringAsFixed(6)
                        : '--',
                  ),
                ),
              ],
            ),
            if (position != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildCoordinateBox(
                      context,
                      label: 'accuracy'.tr,
                      value: '${position.accuracy.toStringAsFixed(1)}m',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCoordinateBox(
                      context,
                      label: 'altitude'.tr,
                      value: '${position.altitude.toStringAsFixed(1)}m',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build coordinate info box
  Widget _buildCoordinateBox(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build info row widget
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textHint, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: valueColor ?? Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Build check-in/check-out action button
  Widget _buildActionButton(
    BuildContext context,
    HomeTabViewScreenController controller,
  ) {
    final isCheckIn = !controller.isCheckedIn;
    final isEnabled = isCheckIn ? controller.canCheckIn : true;

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading
            ? null
            : isEnabled
            ? (isCheckIn ? controller.checkIn : controller.checkOut)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isCheckIn ? AppColors.success : AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.textDisabled,
          disabledForegroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isEnabled ? 2 : 0,
        ),
        child: controller.isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'processing'.tr,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isCheckIn ? Icons.login : Icons.logout, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    isCheckIn ? 'check_in'.tr : 'check_out'.tr,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Build status indicator at bottom
  Widget _buildStatusIndicator(
    BuildContext context,
    HomeTabViewScreenController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: controller.isCheckedIn
            ? AppColors.success.withOpacity(0.1)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: controller.isCheckedIn
              ? AppColors.success.withOpacity(0.3)
              : AppColors.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: controller.isCheckedIn
                  ? AppColors.success
                  : AppColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            controller.isCheckedIn
                ? 'you_are_currently_checked_in'.tr
                : 'you_are_not_check_in'.tr,
            style: AppTextStyles.bodySmall.copyWith(
              color: controller.isCheckedIn
                  ? AppColors.success
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Get status configuration based on location status
  _StatusConfig _getStatusConfig(LocationStatus status, BuildContext context) {
    switch (status) {
      case LocationStatus.inSafeZone:
        return _StatusConfig(
          title: 'in_safe_zone'.tr,
          subtitle: 'you_can_check_in_now'.tr,
          icon: Icons.check_circle,
          gradientColors: [AppColors.success, const Color(0xFF4CAF50)],
          shadowColor: AppColors.success,
        );
      case LocationStatus.outsideSafeZone:
        return _StatusConfig(
          title: 'outside_safe_zone'.tr,
          subtitle: 'move_closer_to_check_in'.tr,
          icon: Icons.warning,
          gradientColors: [AppColors.warning, const Color(0xFFFFB74D)],
          shadowColor: AppColors.warning,
        );
      case LocationStatus.permissionDenied:
        return _StatusConfig(
          title: 'permission_denied'.tr,
          subtitle: 'enable_location_permission'.tr,
          icon: Icons.block,
          gradientColors: [AppColors.textDisabled, const Color(0xFF9E9E9E)],
          shadowColor: Colors.grey,
        );
      case LocationStatus.searching:
        return _StatusConfig(
          title: 'locating'.tr,
          subtitle: 'getting_your_location'.tr,
          icon: Icons.location_searching,
          gradientColors: [AppColors.primary, AppColors.primaryLight],
          shadowColor: AppColors.primary,
        );
      case LocationStatus.error:
        return _StatusConfig(
          title: 'location_error'.tr,
          subtitle: 'try_refreshing'.tr,
          icon: Icons.error_outline,
          gradientColors: [AppColors.error, const Color(0xFFE57373)],
          shadowColor: AppColors.error,
        );
      default:
        return _StatusConfig(
          title: 'initializing'.tr,
          subtitle: 'starting_location_services'.tr,
          icon: Icons.location_on,
          gradientColors: [AppColors.primary, AppColors.primaryLight],
          shadowColor: AppColors.primary,
        );
    }
  }
}

/// Status configuration helper class
class _StatusConfig {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final Color shadowColor;

  _StatusConfig({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.shadowColor,
  });
}
