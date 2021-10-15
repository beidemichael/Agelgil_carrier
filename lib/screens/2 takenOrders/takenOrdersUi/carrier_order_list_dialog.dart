import 'dart:ui';


import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:agelgil_carrier_end/shared/concave_decoration.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:marquee_widget/marquee_widget.dart';

class CarrierOrderListBlurryDialog extends StatelessWidget {
  OrdersCarrier orders;

  CarrierOrderListBlurryDialog(this.orders);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0), color: Colors.white),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Items List",
                            style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.grey[900],
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 4.0,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            // color: Colors.white,
                            //  height: 400,
                            child: ListView.builder(
                              itemCount: orders.price.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: ListView.builder(
                                    itemCount: orders.quantity.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        child: ListView.builder(
                                          itemCount: orders.food.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 13,
                                                  right: 13),
                                              child: Container(
                                                height: 50,
                                                //color: Colors.red,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    13.0),
                                                        child: Container(
                                                          height: 32,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey[500],
                                                                blurRadius:
                                                                    10.0, //effect of softening the shadow
                                                                spreadRadius:
                                                                    0.1, //effecet of extending the shadow
                                                                offset: Offset(
                                                                    0.0, //horizontal
                                                                    3.0 //vertical
                                                                    ),
                                                              ),
                                                            ],
                                                            color: Colors
                                                                .orange[100],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        2.0),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  'Price: ' +
                                                                      orders
                                                                          .price[
                                                                              index]
                                                                          .toString() +
                                                                      '0 Birr',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        13.0,
                                                                    // fontWeight: FontWeight.w700,
                                                                    // fontStyle: FontStyle.italic,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Qty: ' +
                                                                      orders
                                                                          .quantity[
                                                                              index]
                                                                          .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        13.0,
                                                                    // fontWeight: FontWeight.w700,
                                                                    // fontStyle: FontStyle.italic,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 8.0, 0.0),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Container(
                                                          height: 28,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey[400],
                                                                blurRadius:
                                                                    2.0, //effect of softening the shadow
                                                                spreadRadius:
                                                                    0.1, //effecet of extending the shadow
                                                                offset: Offset(
                                                                    0.0, //horizontal
                                                                    3.0 //vertical
                                                                    ),
                                                              ),
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey[400],
                                                                blurRadius:
                                                                    1.0, //effect of softening the shadow
                                                                spreadRadius:
                                                                    0.1, //effecet of extending the shadow
                                                                offset: Offset(
                                                                    0.0, //horizontal
                                                                    -1.0 //vertical
                                                                    ),
                                                              ),
                                                            ],
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Center(
                                                            child: Marquee(
                                                              backDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          500),
                                                              directionMarguee:
                                                                  DirectionMarguee
                                                                      .oneDirection,
                                                              child: Text(
                                                                orders
                                                                    .food[index]
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                            .grey[
                                                                        600]),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  /////////////////////////////// close button
                  top: 0.0,
                  right: 0.0,
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      )),
                ),
                Positioned(
                  ///////////////////////////////convex effect for close button
                  top: 0.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(
                        FontAwesomeIcons.times,
                        size: 18.0,
                        color: Colors.grey,
                      ),
                      decoration: ConcaveDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          colors: [
                            Colors.white,
                            Colors.grey[700],
                          ],
                          depression: 4.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
