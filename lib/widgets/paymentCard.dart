import 'package:baiti/widgets/dataBase_helper.dart';
import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  PaymentCard({
    Key? key,
    required this.payment,
    required this.onPressed,
  }) : super(key: key);

  Payments payment;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.pink[400],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.pink[700],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(9),
                    bottomRight: Radius.circular(9),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      color: Colors.white,
                      onPressed: onPressed,
                      icon: Icon(Icons.change_circle_sharp),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "تاريخ الدفعة: ${payment.date}",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "القيمة: ${payment.payment} ",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                if (payment.description.isNotEmpty)
                  Text(
                    "الوصف: ${payment.description} ",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
