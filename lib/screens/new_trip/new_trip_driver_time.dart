import 'package:calendar_time/calendar_time.dart';
import 'package:commuting_app_mobile/screens/common/common_header.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/date_time/flutter_datetime_picker.dart';
import 'package:commuting_app_mobile/utils/date_time/i18n_model.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/card_with_icon_header_subheader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTripDriverTime extends StatelessWidget {
  var creationService = locator.get<CreationService>();

  Function refresh;

  NewTripDriverTime(this.refresh);

  @override
  Widget build(BuildContext context) {
    String selectedTime = creationService.createTripDto!.leaveAt != null
        ? creationService.createTripDto!.leaveAt!
        : DateTime.now().add(Duration(minutes: 60)).toString();

    DateTime currentTime = TimeUtils.getDateTime(selectedTime);

    creationService.createTripDto!.leaveAt = currentTime.toIso8601String();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 32,
        ),
        CommonHeader(
          header: AppLocalizations.of(context)!.chooseTimeToLeave,
        ),
        SizedBox(
          height: 16,
        ),
        CardWithIconHeaderSubheader(
            Icons.timelapse,
            TimeUtils.toTimeAgoFromDateTime(currentTime),
            TimeUtils.toCalendarTimeFromDateTime(currentTime), () {
          DatePicker.showDateTimePicker(
            context,
            locale: LocaleType.ro,
            showTitleActions: true,
            currentTime: currentTime,
            maxTime: DateTime.now().add(Duration(days: 2)),
            minTime: DateTime.now().add(Duration(minutes: 30)),
            onChanged: (date) {},
            onConfirm: (date) {
              creationService.createTripDto!.leaveAt = date.toString();
              refresh();
            },
          );
        }, null),
      ],
    );
  }
}
