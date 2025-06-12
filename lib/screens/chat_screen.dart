import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:avaition_chat/provider/chat_provider.dart';
import 'package:avaition_chat/widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(ChatProvider chatProvider) {
    if (_controller.text.isNotEmpty) {
      chatProvider.sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flight Status Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  reverse: true,
                  itemCount: chatProvider.messages.length + (chatProvider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (chatProvider.isLoading && index == 0) {
                      return ChatBubble(
                        message: "Generating...",
                        isUser: false,
                        isLoading: true, // Add loading animation
                      );
                    }
                    var message = chatProvider.messages.reversed.toList()[index - (chatProvider.isLoading ? 1 : 0)];
                    return ChatBubble(
                      message: message['text']!,
                      isUser: message['sender'] == "user",
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Ask about flight status..."),
                    onSubmitted: (_) => _sendMessage(context.read<ChatProvider>()),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(context.read<ChatProvider>()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
