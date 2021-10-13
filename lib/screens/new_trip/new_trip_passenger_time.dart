import 'package:commuting_app_mobile/screens/common/common_header.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/date_time/flutter_datetime_picker.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/card_with_icon_header_subheader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTripPassengerTime extends StatefulWidget {
  Function refresh;

  NewTripPassengerTime(this.refresh);

  @override
  _NewTripPassengerTimeState createState() => _NewTripPassengerTimeState();
}

class _NewTripPassengerTimeState extends State<NewTripPassengerTime> {
  var creationService = locator.get<CreationService>();

  bool isAsap = true;

  @override
  void initState() {
    super.initState();
    creationService.createTripRequestDto!.asap = true;
  }

  @override
  Widget build(BuildContext context) {
    String selectedTime = creationService.createTripRequestDto!.arriveBy != null
        ? creationService.createTripRequestDto!.arriveBy!
        : DateTime.now().add(Duration(minutes: 60)).toString();

    DateTime currentTime = TimeUtils.getDateTime(selectedTime);

    creationService.createTripRequestDto!.arriveBy = isAsap ? DateTime.now().toIso8601String() : currentTime.toIso8601String();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 32,
        ),
        CommonHeader(
          header: AppLocalizations.of(context)!.chooseTimeToArrive,
        ),
        SizedBox(
          height: 16,
        ),
        RadioListTile(
            title: Text(AppLocalizations.of(context)!.asap),
            value: 0,
            groupValue: isAsap ? 0 : 1,
            onChanged: (val) {
              setState(() {
                isAsap = val == 0;
              });
            }),
        RadioListTile(
            title: Text(AppLocalizations.of(context)!.arriveBy),
            value: 1,
            groupValue: isAsap ? 0 : 1,
            onChanged: (val) {
              setState(() {
                isAsap = val == 0;
                creationService.createTripRequestDto!.asap = isAsap;
                creationService.createTripRequestDto!.arriveBy = null;
              });
            }),
        isAsap
            ? SizedBox.shrink()
            : CardWithIconHeaderSubheader(
                Icons.timelapse,
                TimeUtils.toTimeAgoFromDateTime(currentTime),
                TimeUtils.getFormattedDateTime(currentTime), () {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  currentTime: currentTime,
                  maxTime: DateTime.now().add(Duration(days: 2)),
                  minTime: DateTime.now().add(Duration(minutes: 30)),
                  onChanged: (date) {},
                  onConfirm: (date) {
                    creationService.createTripRequestDto!.arriveBy = date.toString();
                    creationService.createTripRequestDto!.asap = false;
                    widget.refresh();
                  },
                );
              }, null),
      ],
    );
  }
}
