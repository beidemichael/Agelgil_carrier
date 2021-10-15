
import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:provider/provider.dart';
import 'package:time_formatter/time_formatter.dart';

import 'complete_order_list_dialog.dart';


class CompleteMyOrdersCard extends StatefulWidget {
  Orders orders;
  CompleteMyOrdersCard({this.orders});
  @override
  _CompleteMyOrdersCardState createState() => _CompleteMyOrdersCardState();
}

class _CompleteMyOrdersCardState extends State<CompleteMyOrdersCard> {
  List food = [];
  List price = [];
  List quantity = [];
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      food = widget.orders.food;
      price = widget.orders.price;
      quantity = widget.orders.quantity;
    });
  }

  _orderList(BuildContext context) {
    CompleteOrderListBlurryDialog alert = CompleteOrderListBlurryDialog(widget.orders);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

 

  @override
  Widget build(BuildContext context) {
   
    return InkWell(
      onTap: () {
        _orderList(context);
      },
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: Stack(
                      children: <Widget>[
                        RedContainerBackShadow(),
                        GreyContainerFront(),
                        TextsAndContent(),
                        HyphenDevider(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  HyphenDevider() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11.0),
        child: Column(
          children: [
            Container(
              height: 145,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              height: 22,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Flex(
                          children: List.generate(
                            (MediaQuery.of(context).size.width / 10).floor(),
                            (index) => Container(
                              height: 1,
                              width: 5,
                              color: Colors.grey[500],
                            ),
                          ),
                          direction: Axis.horizontal,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween);
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextsAndContent() {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300)),
                          Marquee(
                            backDuration: Duration(milliseconds: 400),
                            directionMarguee: DirectionMarguee.oneDirection,
                            child: Text(widget.orders.userName,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Phone',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300)),
                          Text(widget.orders.userPhone,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 55,
                        // color: Colors.yellow[50],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Orderd items',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w300)),
                            Text(widget.orders.quantity.length.toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 55,
                        // color: Colors.blue[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w300)),
                            Text(widget.orders.subTotal.toString() + '0 Birr',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              SizedBox(height: 3.0),
              
              SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                    convertTimeStamp(
                            widget.orders.created.millisecondsSinceEpoch)
                        .toString(),
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String convertTimeStamp(timeStamp) {
//Pass the epoch server time and the it will format it for you
    String formatted = formatTime(timeStamp).toString();
    return formatted;
  }

  GreyContainerFront() {
    return Column(
      children: <Widget>[
        Container(
          height: 145,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
            color: Colors.grey[50],
          ),
         
        ),
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.grey[50], BlendMode.srcOut),
          child: Stack(
            children: <Widget>[
              Container(
                height: 22,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.dstOut,
                  color: Colors.grey[100],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 22,
                  width: 11,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 22,
                  width: 11,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }

  RedContainerBackShadow() {
    return Column(
      children: <Widget>[
        Container(
          height: 145,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500],
                blurRadius: 5.0, //effect of softening the shadow
                spreadRadius: 0.1, //effecet of extending the shadow
                offset: Offset(
                    0.0, //horizontal
                    3.0 //vertical
                    ),
              ),
            ],
            // color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0),
          child: Container(
            height: 22,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500],
                  blurRadius: 5.0, //effect of softening the shadow
                  spreadRadius: 0.1, //effecet of extending the shadow
                  offset: Offset(
                      0.0, //horizontal
                      3.0 //vertical
                      ),
                ),
              ],
              // color: Colors.grey[400],
            ),
          ),
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500],
                blurRadius: 5.0, //effect of softening the shadow
                spreadRadius: 0.1, //effecet of extending the shadow
                offset: Offset(
                    0.0, //horizontal
                    3.0 //vertical
                    ),
              ),
            ],
            // color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }
}
