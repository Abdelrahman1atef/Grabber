import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../models/checkout_component_model.dart';
import '../../models/checkout_radio_component_model.dart';

class CheckoutComponentWidget extends StatefulWidget {
  const CheckoutComponentWidget({
    super.key,
    required this.title,
    this.items,
    this.trailingWidget,
    this.isListTile,
    this.haveRadioGroup,
    this.action,
  });

  final String title;
  final List? items;
  final Widget? trailingWidget;
  final bool? isListTile;
  final bool? haveRadioGroup;
  final void Function()? action;

  @override
  State<CheckoutComponentWidget> createState() =>
      _CheckoutComponentWidgetState();
}

class _CheckoutComponentWidgetState extends State<CheckoutComponentWidget> {
  List<CheckoutRadioComponentModel> radioButtonList = [
    CheckoutRadioComponentModel(
      icon: Icons.fast_forward_outlined,
      val: "Priority",
      title: "Priority (10 -20 mins)",
    ),
    CheckoutRadioComponentModel(
      icon: Icons.fact_check_outlined,
      val: "Standard",
      title: "Standard (30 - 45 mins)",
    ),
  ];
  late String? selectedValue = radioButtonList.first.val;
  bool _requestAnInvoice = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 15,
            vertical: 13,
          ),
          child: Text(
            widget.title,
            style: TextStyles.normalTextStyle.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorName.grayBackGroundColor, width: 2),
          ),
          child: widget.haveRadioGroup ?? false
              ? _buildRadioGroup()
              : _buildListView(),
        ),
      ],
    );
  }

  _buildListView() {
    return ListView.separated(
      itemCount: widget.items!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const Divider(
        thickness: 2,
        color: ColorName.grayBackGroundColor,
        height: 2,
      ),
      itemBuilder: (context, index) {
        CheckoutComponentModel item = widget.items?[index];
        return InkWell(
          onTap: widget.action, // if null, InkWell is disabled
          splashColor: widget.action != null ? null : Colors.transparent,
          highlightColor:
              Colors.transparent, // 👈 disables the gray "pressed" overlay
          child: Container(
            color: item.haveBackGround ?? false
                ? ColorName.grayBackGroundColor
                : null,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 15,
                vertical: 13,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.isListTile ?? false
                      ? SizedBox(
                          width: 300,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: item.icon,
                            title: Text(
                              item.text,
                              style: TextStyles.normalTextStyle,
                            ),
                            subtitle: Text(
                              item.subText ?? "",
                              style: TextStyles.normalTextStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            if (item.icon != null) ...[
                              SizedBox(height: 30, width: 50, child: item.icon),
                              const Gap(10),
                            ],
                            Text(
                              item.text,
                              style: item.grayTextStyle ?? false
                                  ? TextStyles.normalTextStyle.copyWith(
                                      color: ColorName.grayTextColor,
                                    )
                                  : TextStyles.normalTextStyle,
                            ),
                          ],
                        ),
                  if (item.trailingText != null) ...[
                    Text(
                      item.trailingText!,
                      style: item.grayTextStyle ?? false
                          ? TextStyles.normalTextStyle.copyWith(
                              color: ColorName.grayTextColor,
                            )
                          : TextStyles.normalTextStyle,
                    ),
                  ],
                  if (widget.trailingWidget != null) ...[
                    SizedBox(width: 24, child: widget.trailingWidget),
                  ],
                  if (item.haveSwitch != null) ...[
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scale: 0.8, // 80% of original size
                        child: CupertinoSwitch(
                          value: _requestAnInvoice,
                          onChanged: (value) {
                            setState(() {
                              _requestAnInvoice =
                                  value; // 👈 fix: assign `value`, not toggle manually
                            });
                          },
                          // activeThumbColor:ColorName.primaryColor,
                          // inactiveThumbColor:ColorName.blackColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildRadioGroup() {
    return Column(
      children: [
        RadioGroup<String>(
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          child: ListView.separated(
            itemCount: radioButtonList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(thickness: 2, color: ColorName.grayBackGroundColor),

            itemBuilder: (BuildContext context, int index) {
              CheckoutRadioComponentModel radioButton = radioButtonList[index];
              return Padding(
                padding: const EdgeInsetsDirectional.only(start: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(radioButton.icon),
                        const Gap(10),
                        Text(
                          radioButton.title,
                          style: TextStyles.normalTextStyle,
                        ),
                      ],
                    ),
                    Radio<String>(
                      visualDensity: const VisualDensity(horizontal: 3, vertical: 0),
                      value: radioButton.val,
                      activeColor: ColorName.primaryColor,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const Divider(thickness: 2, color: ColorName.grayBackGroundColor),

        ///Schedule
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 15,
            vertical: 13,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timelapse),
                  const Gap(10),
                  Text("Schedule", style: TextStyles.normalTextStyle),
                ],
              ),
              Assets.svgs.arrowRight.svg(),
            ],
          ),
        ),
      ],
    );
  }
}
