import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic _webController;

  bool _isVisible = false;

  void onVisibilityChanged(VisibilityInfo info) {
    if (Platform.isIOS) {
      if (!_isVisible && info.visibleFraction > 0) {
        _isVisible = true;
        _webController?.reload();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: VisibilityDetector(
            key: UniqueKey(),
            onVisibilityChanged: onVisibilityChanged,
            child: Stack(
              children: [
                Container(
                  color: Color(0xfffafafa),
                  child: Echarts(
                    extraScript: '''
                    chart.on('click', (params) => {
                      if(params.componentType === 'series') {
                        Messager.postMessage(JSON.stringify({
                          type: 'select',
                          payload: params.dataIndex,
                        }));
                      }
                    });
                  ''',
                    onMessage: (String message) {
                      print(message);
                    },
                    onWebResourceError: (ctrl, e) {
                      print('onWebResourceError');
                    },
                    onLoad: (dynamic controller) {
                      _webController = controller;
                    },
                    option: '''
                        {
                                    dataset: {
                    source: [
                      ['score', 'amount', 'product'],
                      [89.3, 58212, 'Matcha Latte'],
                      [57.1, 78254, 'Milk Tea'],
                      [74.4, 41032, 'Cheese Cocoa'],
                      [50.1, 12755, 'Cheese Brownie'],
                      [89.7, 20145, 'Matcha Cocoa'],
                      [68.1, 79146, 'Tea'],
                      [19.6, 91852, 'Orange Juice'],
                      [10.6, 101852, 'Lemon Juice'],
                      [32.7, 20112, 'Walnut Brownie']
                    ]
                  },
                  grid: { containLabel: true, backgroundColor: '#fafafa' },
                  backgroundColor: '#fafafa',
                  xAxis: { name: 'amount' },
                  yAxis: { type: 'category' },
                  series: [
                    {
                      type: 'bar',
                      encode: {
                        // Map the "amount" column to X axis.
                        x: 'amount',
                        // Map the "product" column to Y axis
                        y: 'product'
                      }
                    }
                  ]
                        }
                  ''',
                  ),
                ),
              ],
            ),
          ),
          width: 300,
          height: 250,
        ),
      ),
    );
  }
}
