import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_ai_test/utils/constant.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textEditingController = TextEditingController();
  String answer = '';
  XFile? image;
  final ImagePicker imagePicker = ImagePicker();
  GenerativeModel model =
      GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
  bool isLoading = false;

  Future<void> pickImage() async {
    final XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff149954),
        title: const Text(
          'AI Sandbox🥪',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Markdown(
                    data: answer,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      p: const TextStyle(fontSize: 16),
                      textAlign: WrapAlignment.spaceBetween,
                      unorderedListAlign: WrapAlignment.spaceBetween,
                      orderedListAlign: WrapAlignment.spaceBetween,
                    ),
                    selectable: true,
                  ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 12),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null)
                  Column(
                    children: [
                      SizedBox(
                        width: 112,
                        height: 80,
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: 104,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: const Color(0xff149954),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(File(image!.path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.white),
                                      side: WidgetStatePropertyAll(BorderSide(
                                        color: Color(0xff149954),
                                        width: 1,
                                      ))),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color(0xff149954),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: pickImage,
                            icon: const Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Color(0xff149954),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 56,
                      width: 56,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          model.generateContent([
                            Content.multi([
                              TextPart(textEditingController.text),
                              if (image != null)
                                DataPart('image/jpeg',
                                    File(image!.path).readAsBytesSync()),
                            ]),
                          ]).then(
                            (value) {
                              setState(() {
                                answer = value.text.toString();
                                isLoading = false;
                              });
                            },
                          );
                        },
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Color(0xff149954),
                          ),
                        ),
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
