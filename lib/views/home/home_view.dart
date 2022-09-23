import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (viewModel) => viewModel.getData(),
      builder: (context, viewModel, child) => Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => viewModel.generateNewMessage(),
        //   child: const Center(child: Icon(Icons.add)),
        // ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Conversations',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => viewModel.showAddContactDialog(context),
          child: const Padding(
            padding: EdgeInsets.only(right: 2.5, bottom: 1.5),
            child: Icon(
              Icons.person_add,
              color: Colors.white,
              size: 27,
            ),
          ),
        ),
        body: viewModel.isBusy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: List.generate(
                  viewModel.conversations.length,
                  (index) => GestureDetector(
                    onTap: () => viewModel.openChat(
                        viewModel.conversations[index].id,
                        viewModel.conversations[index].email),
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 20)
                          .add(const EdgeInsets.only(top: 20)),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Text(
                            viewModel.conversations[index].email,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chat,
                            color: Colors.white,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
