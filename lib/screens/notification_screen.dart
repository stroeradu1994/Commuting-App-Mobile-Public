import 'package:calendar_time/calendar_time.dart';
import 'package:commuting_app_mobile/dto/notification/notification_type.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/notification_service.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/loading_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:commuting_app_mobile/provider/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:commuting_app_mobile/dto/notification/notification_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'common/main_screen.dart';

class NotificationScreen extends StatelessWidget {
  var _notificationService = locator.get<NotificationService>();

  @override
  Widget build(BuildContext context) {
    var notificationProvider = Provider.of<NotificationProvider>(context);

    return MainScreen(
        header: AppLocalizations.of(context)!.notifications,
        hasBack: true,
        isList: true,
        onRefresh: () async {
          await notificationProvider.fetch();
          return Future.value(true);
        },
        child: _buildWrapper(context, notificationProvider));
  }

  Widget _buildWrapper(context, notificationProvider) {
    if (notificationProvider.state == NotificationProviderState.NOT_FETCHED) {
      notificationProvider.fetch();
      return LoadingWidget();
    }
    if (notificationProvider.state == NotificationProviderState.BUSY) {
      return LoadingWidget();
    }
    if (notificationProvider.state == NotificationProviderState.IDLE) {
      return _buildContent(context, notificationProvider.notifications);
    }
    return LoadingWidget();
  }

  Widget _buildContent(context, List<NotificationResponse> notifications) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: notifications
            .map((e) => ListTile(
                  title: Text(e.text!),
                  subtitle: Text(
                    TimeUtils.toCalendarTimeFromString(e.createdAt!.toString()),
                  ),
                  onTap: () {
                    _notificationService.openScreen(
                        context,
                        EnumToString.fromString(
                            NotificationType.values, e.type!),
                        e.entityId!);
                  },
                ))
            .toList(),
      ),
    );
  }
}
