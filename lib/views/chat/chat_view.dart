import 'dart:io';

import 'package:chat_app/shared/ui_helpers.dart';
import 'package:chat_app/viewmodels/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_file/open_file.dart';
import 'package:stacked/stacked.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () => ChatViewModel(),
      onModelReady: (viewModel) => viewModel.initializeChatBox(),
      onDispose: (viewModel) => viewModel.onDispose(),
      builder: (context, viewModel, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Chat Box',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: viewModel.isBusy
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView(
                        padding: const EdgeInsets.only(top: 15),
                        reverse: true,
                        children: List.generate(
                          viewModel.messages?.length ?? 0,
                          (index) => Align(
                            alignment: viewModel.messages![index].from ==
                                    viewModel.myUid
                                ? Alignment.bottomRight
                                : Alignment.bottomLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      screenWidth(context, percentage: 0.7)),
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(
                                  bottom: 15, left: 15, right: 15),
                              decoration: BoxDecoration(
                                color: viewModel.messages![index].from ==
                                        viewModel.myUid
                                    ? Colors.blue
                                    : Colors.blueGrey[800],
                                borderRadius:
                                    BorderRadius.circular(15).subtract(
                                  BorderRadius.only(
                                    topLeft: Radius.circular(
                                        viewModel.messages![index].from ==
                                                viewModel.myUid
                                            ? 0
                                            : 15),
                                    topRight: Radius.circular(
                                        viewModel.messages![index].from ==
                                                viewModel.myUid
                                            ? 15
                                            : 0),
                                  ),
                                ),
                              ),
                              child: viewModel.messages![index].fileName != null
                                  ? viewModel.messages![index].buffered
                                      ? Container(
                                          height: 42,
                                          width: double.maxFinite,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Row(
                                            children: const [
                                              Expanded(
                                                  child: Text(
                                                'Uploading',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                              CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )
                                      : viewModel.checkFilePathExistance(
                                              viewModel
                                                  .messages![index].filePath!)
                                          ? viewModel.messages![index]
                                                      .fileType ==
                                                  'image'
                                              ? GestureDetector(
                                                  onTap: () {
                                                    OpenFile.open(viewModel
                                                            .registry[
                                                        viewModel
                                                            .messages![index]
                                                            .filePath!]!);
                                                  },
                                                  child: Image.file(File(
                                                      viewModel.registry[
                                                          viewModel
                                                              .messages![index]
                                                              .filePath!]!)),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    OpenFile.open(viewModel
                                                            .registry[
                                                        viewModel
                                                            .messages![index]
                                                            .filePath!]!);
                                                  },
                                                  child: Container(
                                                    height: 42,
                                                    width: double.maxFinite,
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 2),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                          viewModel
                                                              .messages![index]
                                                              .fileName!,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )),
                                                        const Icon(
                                                          Icons.file_copy,
                                                          color: Colors.white,
                                                          size: 35,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                          : viewModel.isFileDownloading(
                                                  viewModel.messages![index].id)
                                              ? Container(
                                                  height: 42,
                                                  width: double.maxFinite,
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  child: Row(
                                                    children: const [
                                                      Expanded(
                                                          child: Text(
                                                        'Downloading',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () => viewModel
                                                      .downloadFile(viewModel
                                                          .messages![index].id),
                                                  child: Container(
                                                    height: 42,
                                                    width: double.maxFinite,
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 2),
                                                    child: Row(
                                                      children: const [
                                                        Expanded(
                                                            child: Text(
                                                          'Download',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )),
                                                        Icon(
                                                          Icons.download,
                                                          color: Colors.white,
                                                          size: 35,
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                  : Text(
                                      viewModel.messages![index].message,
                                      textWidthBasis:
                                          TextWidthBasis.longestLine,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
              ),
              Container(
                height: 55,
                color: Colors.blue,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: viewModel.messageController,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.blueGrey[800],
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              fillColor: Colors.transparent,
                              labelText: 'Message',
                              labelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blueGrey[800],
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => viewModel.sendFile(context, 'file'),
                      child: Container(
                        height: 33,
                        width: 33,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.create_new_folder,
                          color: Colors.blue,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => viewModel.sendFile(context, 'image'),
                      child: Container(
                        height: 33,
                        width: 33,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.blue,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => viewModel
                          .sendMessage(viewModel.messageController.text),
                      child: Container(
                        height: 33,
                        width: 33,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.blue,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
