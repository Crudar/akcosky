import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class EventsListShimmer extends StatefulWidget {
  const EventsListShimmer({Key? key}) : super(key: key);

  @override
  State<EventsListShimmer> createState() => EventsListShimmerState();
}

class EventsListShimmerState extends State<EventsListShimmer> {

  @override
  Widget build(context) {

    return SafeArea(
      child: Shimmer.fromColors(
        baseColor: Colors.black,
        highlightColor: Colors.white,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(left: 5),
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                SizedBox(height: 5),
                Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 130,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(mainAxisSize: MainAxisSize.max,
                        children: [
                      Container(
                        width: 40,
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(child: Column(
                          children:[
                            Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                      ]
                      ),
                      ),
                      SizedBox(width: 10),
                    ]
                    ),
                  ],
                ),
                    SizedBox(height: 10),
                    Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Row(mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 40,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(child: Column(
                                  children:[
                                    Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    )
                                  ]
                              ),
                              ),
                              SizedBox(width: 10),
                            ]
                        ),
                      ],
                    )
              ])
          ),
        ],
        ),
      )
      );
    }
  }

const _shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);