import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/widgets/small_space_widget.dart';
import 'package:flutter/material.dart';

class LinearStepperWidget extends StatelessWidget {
  List<LinearStepperStep> steps;

  LinearStepperWidget({required this.steps});

  @override
  Widget build(BuildContext context) {
    List<Widget> leftIcons = [];

    for (int i = 0; i < steps.length; i++) {
      leftIcons.add(_buildPointIcon(steps[i]));
      if (i != steps.length - 1) {
        leftIcons.add(_buildInterPointsIcon(steps[i]));
      }
    }

    List<Widget> stepWidgets = [];

    for (int i = 0; i < steps.length; i++) {
      stepWidgets.add(_buildStep(steps[i]));
      if (i != steps.length - 1) {
        stepWidgets.add(SmallSpaceWidget());
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        children: [
          Column(
            children: leftIcons,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: stepWidgets,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStep(LinearStepperStep step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(step.header,
            style: TextStyle(
                fontSize: 15,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
                color: textColor)),
        if (step.subheader1 != null)
          SizedBox(
            height: 2,
          ),
        if (step.subheader1 != null)
          Text(step.subheader1!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w300,
                  color: textColor)),
        if (step.subheader2 != null)
          SizedBox(
            height: 2,
          ),
        if (step.subheader2 != null)
          Text(step.subheader2!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w300,
                  color: textColor)),
        if (step.action != null) step.action!,
      ],
    );
  }

  Widget _buildPointIcon(LinearStepperStep step) {
    return Icon(
      step.isOk ? Icons.check_circle_outline : Icons.adjust,
      color: primaryColor,
      size: 20,
    );
  }

  Widget _buildInterPointsIcon(LinearStepperStep step) {
    return Container(
      width: 2,
      height: step.action == null ? 58 : 128,
      color: primaryColor,
    );
  }
}

class LinearStepperStep {
  String header;
  String? subheader1;
  String? subheader2;
  bool isOk = false;
  Widget? action;

  LinearStepperStep(
      this.header, this.subheader1, this.subheader2, this.isOk, this.action);
}
