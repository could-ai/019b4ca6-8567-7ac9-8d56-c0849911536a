import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isListening = false;
  bool _isVoiceMode = true; // Default to voice mode

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hello! I am Noor, your personal medical assistant. How can I help you analyze your health data today?',
      'time': 'Now'
    }
  ];

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final userText = _textController.text;
    setState(() {
      _messages.add({
        'isUser': true,
        'text': userText,
        'time': 'Now',
      });
      _textController.clear();
    });

    _scrollToBottom();

    // Mock Noor's response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'isUser': false,
            'text': _generateMockResponse(userText),
            'time': 'Now',
          });
        });
        _scrollToBottom();
      }
    });
  }

  String _generateMockResponse(String input) {
    input = input.toLowerCase();
    if (input.contains('headache')) {
      return "I'm sorry to hear that. Have you been drinking enough water? Frequent headaches can sometimes be a sign of dehydration or stress.";
    } else if (input.contains('blood') || input.contains('pressure')) {
      return "Your last recorded blood pressure was 120/80, which is healthy. Do you want to log a new reading?";
    } else if (input.contains('upload') || input.contains('report')) {
      return "You can upload your medical report in the 'Records' tab. I can analyze PDF or image files to explain the results to you.";
    } else {
      return "I understand. Could you tell me more about your symptoms or upload a medical document for me to analyze?";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
    
    if (_isListening) {
      // Mock listening behavior
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listening... (Voice simulation)')),
      );
      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isListening) {
          setState(() {
            _isListening = false;
            // Mock voice-to-text result
            final voiceText = "I have a mild fever.";
            _messages.add({
              'isUser': true,
              'text': voiceText,
              'time': 'Now',
            });
            
            // Trigger response
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                setState(() {
                  _messages.add({
                    'isUser': false,
                    'text': _generateMockResponse(voiceText),
                    'time': 'Now',
                  });
                });
                _scrollToBottom();
              }
            });
          });
          _scrollToBottom();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Noor&background=009688&color=fff'), // Placeholder
              child: Icon(Icons.face_3, size: 20, color: Colors.white), // Fallback
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Noor', style: TextStyle(fontSize: 16)),
                Text('Medical Assistant', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'] as bool;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Theme.of(context).colorScheme.primary : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                        bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isVoiceMode)
              _buildVoiceInterface()
            else
              _buildTextInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceInterface() {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleListening,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isListening ? Colors.redAccent : Theme.of(context).colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: (_isListening ? Colors.redAccent : Theme.of(context).colorScheme.primary).withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _isListening ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isVoiceMode = false;
                });
              },
              icon: const Icon(Icons.keyboard),
              label: const Text("Type instead"),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextInput() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.mic),
          onPressed: () {
            setState(() {
              _isVoiceMode = true;
            });
          },
          color: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onSubmitted: (_) => _sendMessage(),
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          mini: true,
          onPressed: _sendMessage,
          elevation: 0,
          child: const Icon(Icons.send),
        ),
      ],
    );
  }
}
