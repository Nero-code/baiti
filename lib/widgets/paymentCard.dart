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
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.pink[400],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(9),
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(5),
                ),
                color: Colors.pink[700],
                child: IconButton(
                  color: Colors.white,
                  onPressed: onPressed,
                  icon: Icon(Icons.change_circle_sharp),
                  splashRadius: 20,
                ),
              )
            ],
          ),
          Text("${payment.date} :تاريخ الدفعة"),
          Text("${payment.payment} :القيمة"),
          if (payment.description.isNotEmpty)
            Text("${payment.description} :الوصف"),
          Align(
            child: Text("alignment!!"),
            alignment: AlignmentGeometry.lerp(
                    Alignment.bottomLeft, Alignment.bottomRight, 0.9)
                as AlignmentGeometry,
          )
        ],
      ),
    );
  }
}
