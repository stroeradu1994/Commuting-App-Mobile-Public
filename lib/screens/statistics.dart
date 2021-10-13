import 'package:commuting_app_mobile/screens/widgets_with_header.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/widgets/loading_widget.dart';
import 'package:commuting_app_mobile/widgets/small_space_widget.dart';
import 'package:flutter/material.dart';
import 'package:commuting_app_mobile/services/statistics_service.dart';
import 'package:commuting_app_mobile/dto/statistics/statistics_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'common/main_screen_with_drawer.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  var statisticsService = locator.get<StatisticsService>();

  StatisticsResponse? statisticsResponse;

  @override
  Widget build(BuildContext context) {
    return MainScreenWithDrawer(
      position: 3,
      onRefresh: () async {
        statisticsResponse = await statisticsService.get();
        setState(() {

        });
        return Future.value(true);
      },
      child: _buildWrapper(),
    );
  }

  Widget _buildWrapper() {
    if (statisticsResponse == null) {
      return FutureBuilder(
        future: statisticsService.get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            statisticsResponse = snapshot.data;
            return _buildContent(statisticsResponse!);
          }
          return LoadingWidget();
        },
      );
    }
    return _buildContent(statisticsResponse!);
  }

  Widget _buildContent(StatisticsResponse statisticsResponse) {
    return Column(
      children: [
        WidgetsWithHeader(
            header: AppLocalizations.of(context)!.statistics,
            widgets: [
              Column(
                children: [
                  SmallSpaceWidget(),
                  _buildStatistic(AppLocalizations.of(context)!.numberOfTripsAsDriver, statisticsResponse.numberOfTripsAsDriver!.round().toString()),
                  SmallSpaceWidget(),
                  Divider(),
                  SmallSpaceWidget(),
                  _buildStatistic(AppLocalizations.of(context)!.numberOfTripsAsPassenger, statisticsResponse.numberOfTripsAsPassenger!.round().toString()),
                  SmallSpaceWidget(),
                  Divider(),
                  SmallSpaceWidget(),
                  _buildStatistic(AppLocalizations.of(context)!.kmAsDriver + '(km)', statisticsResponse.kmAsDriver!.toStringAsFixed(1)),
                  SmallSpaceWidget(),
                  Divider(),
                  SmallSpaceWidget(),
                  _buildStatistic(AppLocalizations.of(context)!.kmAsPassenger + '(km)', statisticsResponse.kmAsPassenger!.toStringAsFixed(1)),
                  SmallSpaceWidget(),
                  Divider(),
                  SmallSpaceWidget(),
                  _buildStatistic(AppLocalizations.of(context)!.numberOfPassengers, statisticsResponse.numberOfPassengers!.round().toString()),
                ],
              )
            ])
      ],
    );
  }

  _buildStatistic(String text, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 26, right: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(text, style: TextStyle(
            fontSize: 13,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
            color: textColor
        ),), Text(value)],
      ),
    );
  }
}
