import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class CustomThumbShapeRangeSlider extends StatefulWidget {
  final Function(int?, int?)? onRangeChanged;
  
  const CustomThumbShapeRangeSlider({super.key, this.onRangeChanged});

  @override
  State<CustomThumbShapeRangeSlider> createState() =>
      _CustomThumbShapeRangeSliderState();
}

class _CustomThumbShapeRangeSliderState extends State<CustomThumbShapeRangeSlider> {
  double _lowerValue = 18;
  double _upperValue = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Exibe os valores selecionados dinamicamente
        FlutterSlider(
          values: [_lowerValue, _upperValue],
          rangeSlider: true,
          max: 100,
          min: 18,
          step: const FlutterSliderStep(step: 1),
          jump: true,
          trackBar: const FlutterSliderTrackBar(
            activeTrackBarHeight: 2,
            activeTrackBar: BoxDecoration(color: Color.fromRGBO(100, 141, 219, 1)),
          ),
          tooltip: FlutterSliderTooltip(alwaysShowTooltip: false),
          handler: FlutterSliderHandler(
            decoration: const BoxDecoration(),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(100, 141, 219, 1),
                  borderRadius: BorderRadius.circular(25)),
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          rightHandler: FlutterSliderHandler(
            decoration: const BoxDecoration(),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(100, 141, 219, 1),
                  borderRadius: BorderRadius.circular(25)),
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
          disabled: false,
          onDragging: (handlerIndex, lowerValue, upperValue) {
            setState(() {
              _lowerValue = lowerValue;
              _upperValue = upperValue;
            });
            // Notify parent of range change
            widget.onRangeChanged?.call(
              lowerValue.toInt(),
              upperValue.toInt(),
            );
          },
        ),
      ],
    );
  }
}
