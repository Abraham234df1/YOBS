import 'package:flutter/material.dart';
import '../models/models.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final List<ChatMessage> messages;

  const ChatScreen({
    super.key,
    required this.title,
    required this.messages,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  late List<ChatMessage> _chatList;

  @override
  void initState() {
    super.initState();
    _chatList = List.from(widget.messages);
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final newMsg = ChatMessage(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'client1',
      senderName: 'Tú',
      content: text,
      timestamp: DateTime.now(),
      isFromClient: true,
    );

    setState(() {
      _chatList.add(newMsg);
    });

    _msgController.clear();

    // Auto simulated reply after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _chatList.add(ChatMessage(
            id: 'm_${DateTime.now().millisecondsSinceEpoch}',
            senderId: 'worker1',
            senderName: widget.title,
            content: '¡Entendido! Recibí tu mensaje. En un momento te respondo.',
            timestamp: DateTime.now(),
            isFromClient: false,
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFFF6600).withAlpha(20),
              child: Text(
                widget.title.isNotEmpty ? widget.title.substring(0, 1) : 'Y',
                style: const TextStyle(color: Color(0xFFFF6600), fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const Row(
                  children: [
                    CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                    SizedBox(width: 4),
                    Text('En línea', style: TextStyle(fontSize: 11, color: Color(0xFF10B981))),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: Color(0xFF6B7280)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Llamada directa en proceso...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Nota de seguridad (sección 4.7 del doc)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFFEF3C7),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFFD97706), size: 14),
                SizedBox(width: 6),
                Expanded(child: Text('Usa el chat solo para asuntos relacionados con el servicio.', style: TextStyle(color: Color(0xFFD97706), fontSize: 11))),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _chatList.length,
              itemBuilder: (ctx, idx) {
                final msg = _chatList[idx];
                final isMe = msg.isFromClient;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFFF6600) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: isMe ? const Radius.circular(18) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : const Radius.circular(18),
                      ),
                      border: isMe ? null : Border.all(color: const Color(0xFFEBEBE6)),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.content,
                          style: TextStyle(
                            color: isMe ? Colors.white : const Color(0xFF111827),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: isMe ? Colors.white70 : const Color(0xFF9CA3AF),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEBEBE6))),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded, color: Color(0xFF6B7280)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Adjuntar fotos o ubicación')),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      fillColor: const Color(0xFFF7F7F2),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFFFF6600),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
