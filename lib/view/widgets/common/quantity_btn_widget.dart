import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class QuantityBtnWidget extends StatefulWidget {
  QuantityBtnWidget(
      {super.key,

      required this.quantity,
      required this.onQuantityChange,
      required this.onAddTap,
        this.allowLocalIncrement
      });

  int quantity;
  Function(int quantity, QtyChangeType changeType)? onQuantityChange;
  VoidCallback? onAddTap;
  bool? allowLocalIncrement;

  @override
  State<QuantityBtnWidget> createState() => _QuantityBtnWidgetState();
}

class _QuantityBtnWidgetState extends State<QuantityBtnWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.quantity == 0
        ? CommonButton(
            height: 30,
            width: 90,
            margin: EdgeInsets.zero,
            text: 'add'.tr.toUpperCase(),
            clickAction: widget.onAddTap ?? () {},
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        widget.quantity = widget.quantity - 1;
                      });

                      if (widget.onQuantityChange != null) {
                        widget.onQuantityChange!(
                            widget.quantity, QtyChangeType.decrease);
                      }
                    },
                    child: const Icon(
                      Icons.remove_circle_outline_rounded,
                      size: 18,
                      color: Colors.white,
                    )),
                Text(
                  widget.quantity.toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14.fontMultiplier,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                InkWell(
                    onTap: () {


                     if(widget.allowLocalIncrement??false){
                       setState(() {
                         widget.quantity = widget.quantity + 1;
                       });
                     }


                     if (widget.onQuantityChange != null) {
                       widget.onQuantityChange!(widget.quantity,
                           QtyChangeType.increase);
                     }

                     },
                    child: const Icon(
                      Icons.add_circle_outline_rounded,
                      size: 18,
                      color: Colors.white,
                    )),
              ],
            ),
          );
  }
}
