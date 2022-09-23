import 'dart:io';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/shared/ui_helpers.dart';
import 'package:chat_app/viewmodels/send_file_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked/stacked.dart';

class SendFileView extends StatelessWidget {
  String fileType;
  String filePath;
  SendFileView({Key? key, required this.fileType, required this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SendFileViewModel>.nonReactive(
      viewModelBuilder: () => SendFileViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: screenWidth(context, percentage: 0.8),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[800],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: screenWidth(context, percentage: 0.8) * 1.2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 3, color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                        image: fileType == 'file'
                            ? null
                            : DecorationImage(
                                image: FileImage(File(filePath)),
                                fit: BoxFit.cover)),
                    child: fileType == 'image'
                        ? null
                        : Text(
                            'Document',
                            style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () => viewModel.send(),
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
