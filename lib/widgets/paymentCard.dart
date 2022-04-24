import 'package:baiti/widgets/dataBase_helper.dart';
import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  PaymentCard({
    Key? key,
    required this.payment,
  }) : super(key: key);

  Payments payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height / 3.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.amber,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("${payment.date} :تاريخ الدفعة"),
          if (payment.description.isNotEmpty)
            Text("${payment.description} :الوصف"),
          Text("${payment.payment} :القيمة"),
        ],
      ),
    );
  }
}
