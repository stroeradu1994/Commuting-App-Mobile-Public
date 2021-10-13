import 'package:commuting_app_mobile/provider/car_provider.dart';
import 'package:commuting_app_mobile/screens/car_creation/car_brand_model_input.dart';
import 'package:commuting_app_mobile/screens/common/common_header.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/widgets/card_with_icon_header_subheader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTripCar extends StatelessWidget {
  Function refresh;

  NewTripCar(this.refresh);

  var creationService = locator.get<CreationService>();

  @override
  Widget build(BuildContext context) {
    var carProvider = Provider.of<CarProvider>(context);

    if (carProvider.state == CarProviderState.IDLE) {
      String? selectedCar = creationService.createTripDto!.carId;

      List<Widget> carWidgets = carProvider.cars
      .where((element) => selectedCar != null ? element.id == selectedCar : true)
          .map((e) => CardWithIconHeaderSubheader(
              Icons.directions_car,
              e.brand! + ' ' + e.model!,
              e.plate! + ' ' + e.color!,
              selectedCar != null
                  ? _reset : () {
                      creationService.createTripDto!.carId = e.id;
                      refresh();
                    },
              selectedCar != null
                  ? _buildEditButton()
                  : null))
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 32,
          ),
          CommonHeader(
            header: AppLocalizations.of(context)!.chooseCar,
          ),
          SizedBox(
            height: 16,
          ),
          ...carWidgets,
          selectedCar != null
              ? SizedBox.shrink()
              : CardWithIconHeaderSubheader(Icons.add, AppLocalizations.of(context)!.addNewCar, null, () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => CarBrandModelInput()),
                  );
                }, null),
        ],
      );
    } else {
      carProvider.getCars();
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
