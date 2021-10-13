import 'package:commuting_app_mobile/dto/new_trip_dto.dart';
import 'package:commuting_app_mobile/dto/trip/create_trip_dto.dart';
import 'package:commuting_app_mobile/dto/trip/create_trip_request_dto.dart';
import 'package:commuting_app_mobile/screens/common/common_header.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/widgets/card_with_icon_header_subheader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTripType extends StatelessWidget {
  Function refresh;

  NewTripType(this.refresh);

  var creationService = locator.get<CreationService>();

  @override
  Widget build(BuildContext context) {
    bool isPassengerType = creationService.createTripRequestDto != null;
    bool isDriverType = creationService.createTripDto != null;
    bool isTypeSelected = isPassengerType || isDriverType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 32,
        ),
        CommonHeader(
          header: AppLocalizations.of(context)!.newTripType,
        ),
        SizedBox(
          height: 16,
        ),
        isPassengerType
            ? SizedBox.shrink()
            : CardWithIconHeaderSubheader(
                Icons.directions_car,
                AppLocalizations.of(context)!.driver,
                AppLocalizations.of(context)!.driverInfo,
                isTypeSelected
                    ? _reset
                    : () {
                        creationService.createTripRequestDto = null;
                        creationService.createTripDto = new CreateTripDto();
                        refresh();
                      },
                isDriverType ? _buildEditButton() : null,
                showFullSubheader: true,
              ),
        isDriverType
            ? SizedBox.shrink()
            : CardWithIconHeaderSubheader(
                Icons.directions_walk,
                AppLocalizations.of(context)!.passenger,
                AppLocalizations.of(context)!.passengerInfo,
                isTypeSelected
                    ? _reset
                    : () {
                        creationService.createTripDto = null;
                        creationService.createTripRequestDto =
                            new CreateTripRequestDto();
                        refresh();
                      },
                isPassengerType ? _buildEditButton() : null,
                showFullSubheader: true,
              ),
      ],
    );
  }

  _buildEditButton() {
    return Icon(Icons.edit_outlined);
  }

  _reset() {
    creationService.createTripDto = null;
    creationService.createTripRequestDto = null;
    refresh();
  }
}
