import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:silviamaharjan_2408228_fyp/src/core/theme/theme.dart';
import '../../core/services/gemini_service.dart';
import '../../core/utils/phase_calculator.dart';
import '../../core/services/phasegetter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chatMessages = [];

  ChatSession? _chatSession;

  bool _isSending = false;
  bool _isLoading = false;
  bool _showScrollDownButton = false;
  bool _isTypingActive = false;

  CyclePhase? _phase;

  @override
  void initState() {
    super.initState();
    _loadUserPhase();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 300 && !_showScrollDownButton) {
      setState(() => _showScrollDownButton = true);
    } else if (_scrollController.offset <= 300 && _showScrollDownButton) {
      setState(() => _showScrollDownButton = false);
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _loadUserPhase() async {
    final phaseHelper = PhaseHelper();
    final result = await phaseHelper.getUserPhase();
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _phase = result.phase;
        _chatSession = GeminiService.startNewChat(_phase!);
      });
    }
  }

  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty || _phase == null) return;

    _chatSession ??= GeminiService.startNewChat(_phase!);

    setState(() {
      _chatMessages.insert(0, {'user': userMessage});
      _isSending = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final reply = await GeminiService.sendMessage(
        session: _chatSession!,
        message: userMessage,
      );

      if (!mounted) return;

      setState(() {
        _chatMessages.insert(0, {
          'sakhi': reply,
          'isNew': true,
        });
        _isTypingActive = true;
      });
    } catch (e) {
      debugPrint("Gemini Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _stopAIResponse() {
    if (!mounted) return;

    setState(() {
      _isTypingActive = false;
      _isSending = false;

      for (int i = 0; i < _chatMessages.length; i++) {
        if (_chatMessages[i].containsKey('isNew')) {
          _chatMessages[i]['isNew'] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double currentBottomPadding = keyboardHeight > 0 ? 20.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9DEE4),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFF1C0CB),
                width: 1.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/sakhi icons/sakhi.png',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'AskSakhi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFD65A72),
                      fontFamily: 'Satoshi',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: _chatMessages.isEmpty ? 1 : _chatMessages.length,
                  itemBuilder: (context, index) {

                    // ✅ SHOW INTRO ONLY WHEN EMPTY
                    if (_chatMessages.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              "Hi, I am Sakhi, your personal health companion. How can I help you today?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 18,
                                color: appColors.heading,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Divider(
                              color: const Color(0xFFF1C0CB).withOpacity(0.5),
                              indent: 50,
                              endIndent: 50,
                            ),
                          ],
                        ),
                      );
                    }

                    final message = _chatMessages[index];
                    bool isUser = message.containsKey('user');

                    if (isUser) {
                      return Align(
                        alignment: Alignment.topRight,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6E7EA),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              message['user']!,
                              style: const TextStyle(
                                color: Color(0xFFA63F60),
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 0, right: 20, top: 10, bottom: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: _TypewriterText(
                        text: message['sakhi']!,
                        isAnimated: message['isNew'] ?? false,
                        isGlobalActive: _isTypingActive,
                        onFinished: () {
                          setState(() => _isTypingActive = false);
                          message['isNew'] = false;
                        },
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, currentBottomPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6E7EA),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        constraints: const BoxConstraints(
                          minHeight: 56,
                          maxHeight: 120,
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: 17,
                            color: Color(0xFFA63F60),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Ask me anything',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            hintStyle: TextStyle(color: Color(0xFFA63F60)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _isTypingActive ? _stopAIResponse : (_isSending ? null : _sendMessage),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD85C7B),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: _isTypingActive
                              ? const Icon(Icons.stop_rounded, color: Colors.white, size: 28)
                              : _isSending
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Icon(
                            Icons.keyboard_return,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_showScrollDownButton)
            Positioned(
              bottom: currentBottomPadding + 80,
              right: 30,
              child: FloatingActionButton.small(
                backgroundColor: const Color(0xFFE97B90).withOpacity(0.8),
                child: const Icon(Icons.arrow_downward, color: Colors.white),
                onPressed: _scrollToBottom,
              ),
            ),
        ],
      ),
    );
  }
}

class _TypewriterText extends StatefulWidget {
  final String text;
  final bool isAnimated;
  final bool isGlobalActive;
  final VoidCallback onFinished;

  const _TypewriterText({
    required this.text,
    required this.isAnimated,
    required this.isGlobalActive,
    required this.onFinished,
  });

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  String _displayText = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isAnimated && widget.isGlobalActive) {
      _startTyping();
    } else {
      _displayText = widget.text;
    }
  }

  @override
  void didUpdateWidget(_TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isGlobalActive || !widget.isAnimated) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _startTyping() {
    int index = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (!mounted) return;
      if (index < widget.text.length && widget.isGlobalActive) {
        setState(() {
          _displayText += widget.text[index];
          index++;
        });
      } else {
        _timer?.cancel();
        _timer = null;
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: _displayText,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(
          color: Color(0xFFA63F60),
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w400,
          fontSize: 17,
          height: 1.5,
        ),
        strong: const TextStyle(
          color: Color(0xFFA63F60),
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        blockSpacing: 12.0,
        listBullet: const TextStyle(
          color: Color(0xFFA63F60),
          fontSize: 17,
        ),
        listIndent: 20.0,
      ),
    );
  }
}