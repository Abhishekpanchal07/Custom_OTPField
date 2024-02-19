library easy_otpfield;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget customOtpfield({int? otpFieldCount,Function(String ? otpvalues)? onAllFieldsFill,  bool useRoundBorder = true}) {

  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  final formKey = GlobalKey<FormState>();

    return   Get.context !=null && otpFieldCount!=null &&  onAllFieldsFill!= null && otpFieldCount == 4 ||  otpFieldCount == 6 ?    SizedBox(
      height: Get.size.height * 0.06,
      width: otpFieldCount == 4 ? Get.size.width * 0.55 : Get.size.width * 0.8,
      child: Form(
        key: formKey,
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (RawKeyEvent event) {
            _onKeyEvent(event, controllers, focusNodes, otpFieldCount);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              otpFieldCount!,
              (index) {
                if (controllers.length <= index) {
                  controllers.add(TextEditingController());
                  focusNodes.add(FocusNode());
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,),
                    child: TextFormField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      cursorColor: Colors.grey,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration:  InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        enabledBorder: useRoundBorder ? OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Colors.grey),) : const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: useRoundBorder ? OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Colors.pink)): const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink),
                        ),
                      ),
                      maxLength: 1,
                      onChanged: (value) {
                        if(value.isNotEmpty){
                          onAllFieldsFill!(value);

                        }
                       else if(value.isNotEmpty && index == otpFieldCount - 1){
                          FocusScope.of(Get.context!).unfocus();

                        }
                       else if (value.isNotEmpty && index < otpFieldCount - 1) {
                          // Move focus to the next field if the current field is not empty and it's not the last field
                          FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          // Move focus to the previous field if the current field is empty
                          FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
                        }

                        // call callback if all controllers have values
                     

                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ) :  const SizedBox();
  }
  
  void _onKeyEvent(RawKeyEvent event, List<TextEditingController> controller, List<FocusNode> focusNodes, int otpFieldCount) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
              // Handle backspace key press
              for (int i = otpFieldCount - 1; i > 0; i--) {
                if (controller[i].text.isEmpty && controller[i - 1].text.isNotEmpty) {
                  // Move focus to the previous field if the current field is empty and the previous field is not empty
                  FocusScope.of(Get.context!).requestFocus(focusNodes[i - 1]);
                  break;
                }
              }
            } else if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.delete) {
              // Handle delete key press
              for (int i = 0; i < otpFieldCount - 1; i++) {
                if (controller[i].text.isNotEmpty && controller[i + 1].text.isEmpty) {
                  // Move focus to the next field if the current field is not empty and the next field is empty
                  FocusScope.of(Get.context!).requestFocus(focusNodes[i + 1]);
                  break;
                }
              }
            } else {
              // Handle other key presses
              for (int i = 0; i < otpFieldCount - 1; i++) {
                if (controller[i].text.isNotEmpty && controller[i + 1].text.isEmpty) {
                  // Move focus to the next field if the current field is not empty and the next field is empty
                  FocusScope.of(Get.context!).requestFocus(focusNodes[i + 1]);
                  break;
                }
              }
            } 
  }