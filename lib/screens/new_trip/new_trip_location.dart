import 'package:commuting_app_mobile/provider/location_provider.dart';
import 'package:commuting_app_mobile/screens/common/common_header.dart';
import 'package:commuting_app_mobile/screens/location/edit_location.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/widgets/card_with_icon_header_subheader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTripLocation extends StatelessWidget {
  bool isFrom;
  Function refresh;

  NewTripLocation(this.refresh, this.isFrom);

  var creationService = locator.get<CreationService>();

  @override
  Widget build(BuildContext context) {
    var locationProvider = Provider.of<LocationProvider>(context);

    if (locationProvider.state == LocationProviderState.IDLE) {
      String? selectedFrom;
      String? selectedTo;

      selectedFrom = creationService.createTripDto != null
          ? creationService.createTripDto!.from
          : creationService.createTripRequestDto != null
              ? creationService.createTripRequestDto!.from
              : null;
      selectedTo = creationService.createTripDto != null
          ? creationService.createTripDto!.to
          : creationService.createTripRequestDto != null
              ? creationService.createTripRequestDto!.to
              : null;

      bool isSelected = isFrom ? selectedFrom != null : selectedTo != null;

      String? currentSelected = isSelected
          ? isFrom
              ? selectedFrom!
              : selectedTo!
          : null;

      List<Widget> locations = locationProvider.locations
          .where((e) => isSelected
              ? e.id == currentSelected!
              : isFrom
                  ? true
                  : e.id != selectedFrom!)
          .map((e) =>
              CardWithIconHeaderSubheader(Icons.home, e.label == null ? e.address! : e.label!, e.label == null ? null : e.address!, () {
                if (isSelected) {
                  creationService.createTripDto != null ?
                  isFrom ? creationService.createTripDto!.from = null
                      : creationService.createTripDto!.to = null :
                  isFrom ? creationService.createTripRequestDto!.from = null
                      : creationService.createTripRequestDto!.to = null;
                } else {
                  creationService.createTripDto != null ?
                  isFrom ? creationService.createTripDto!.from = e.id
                      : creationService.createTripDto!.to = e.id :
                  isFrom ? creationService.createTripRequestDto!.from = e.id
                      : creationService.createTripRequestDto!.to = e.id;
                }
                refresh();
              }, isSelected ? _buildEditButton() : null))
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 32,
          ),
          CommonHeader(
            header: isFrom ? AppLocalizations.of(context)!.leaveLocation : AppLocalizations.of(context)!.arriveLocation,
          ),
          SizedBox(
            height: 16,
          ),
          ...locations,
          isSelected
              ? SizedBox.shrink()
              : CardWithIconHeaderSubheader(Icons.add, AppLocalizations.of(context)!.addLocation, null,
                  () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => EditLocation()),
                  );
                }, null),
        ],
      );
    } else {
      locationProvider.getLocations();
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  _buildEditButton() {
    return Icon(Icons.edit_outlined);
  }

  _reset() {
    creationService.createTripDto!.carId = null;
    refresh();
  }
}
