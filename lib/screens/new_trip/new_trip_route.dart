import 'package:commuting_app_mobile/screens/common/common_header.dart';
import 'package:commuting_app_mobile/screens/new_trip/choose_route.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/widgets/card_with_icon_header_subheader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTripRoute extends StatefulWidget {
  Function refresh;

  NewTripRoute(this.refresh);

  @override
  _NewTripRouteState createState() => _NewTripRouteState();
}

class _NewTripRouteState extends State<NewTripRoute> {
  var creationService = locator.get<CreationService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 32,
        ),
        CommonHeader(
          header: AppLocalizations.of(context)!.chooseRoute,
        ),
        SizedBox(
          height: 16,
        ),
        CardWithIconHeaderSubheader(
            Icons.add_road_outlined, creationService.createTripDto!.routeId == null ? AppLocalizations.of(context)!.noRouteSelected : AppLocalizations.of(context)!.routeSelected, null, () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => ChooseRoute(creationService.createTripDto!.leaveAt!)),
          );
          widget.refresh();
        }, null)
      ],
    );
  }

}
