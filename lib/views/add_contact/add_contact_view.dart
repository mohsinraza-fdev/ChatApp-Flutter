import 'package:chat_app/shared/ui_helpers.dart';
import 'package:chat_app/viewmodels/add_contact_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked/stacked.dart';

class AddContactView extends StatelessWidget {
  const AddContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddContactViewModel>.reactive(
      viewModelBuilder: () => AddContactViewModel(),
      onDispose: (viewModel) => viewModel.onDispose(),
      builder: (context, viewModel, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: viewModel.isAddingUser
              ? null
              : screenWidth(context, percentage: 0.7),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.blueGrey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: viewModel.isAddingUser
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 30,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Material(
                        borderOnForeground: true,
                        color: Colors.transparent,
                        child: TextField(
                          controller: viewModel.textController,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey[800],
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              fillColor: Colors.transparent,
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey[800],
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () => viewModel.addConversation(),
                      child: Container(
                        height: 37,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            'Add Contact',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
        ),
      ),
    );
  }
}
