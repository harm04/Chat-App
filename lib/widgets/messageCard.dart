// import 'package:chat_app/methods/firestoremethods.dart';
// import 'package:chat_app/models/message.dart';
// import 'package:chat_app/widgets/formated_date.dart';
// import 'package:flutter/material.dart';

// class MessageCard extends StatefulWidget {
//   final Message message;
//   const MessageCard({super.key, required this.message});

//   @override
//   State<MessageCard> createState() => _MessageCardState();
// }

// class _MessageCardState extends State<MessageCard> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.message.fromId == FirestoreMethods.user.uid
//         ? _greenMessage()
//         : _greyMessage();
//   }

//   Widget _greyMessage() {
//     if(widget.message.read.isEmpty){
//       FirestoreMethods.updateReadMessage(widget.message);
//     }
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Flexible(
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                   vertical: MediaQuery.of(context).size.width * 0.02,
//                   horizontal: MediaQuery.of(context).size.width * 0.05),
//               decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 98, 100, 98),
//                   borderRadius: BorderRadius.circular(10),
//                   border:
//                       Border.all(color: const Color.fromARGB(255, 219, 214, 214))),
//               child: Text(
//                 widget.message.message,
//                 style: const TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//           ),
//               SizedBox(width: 5,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Text(
//                  formatedDate.getFormattedTime(context: context, time:   widget.message.sent,),
//                 style: const TextStyle(fontSize: 10),
//               ),

//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _greenMessage() {
//     return Padding(
//       padding: const EdgeInsets.only(top:8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [

//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Text(
//               formatedDate.getFormattedTime(context: context, time:   widget.message.sent,),
//                 style: const TextStyle(fontSize: 10),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               if(widget.message.read.isNotEmpty)
//               const Icon(
//                 Icons.done_all_rounded,color: Colors.blue,
//                 size: 15,
//               )
//             ],
//           ),
//           SizedBox(width: 5,),
//            Flexible(
//              child: Container(
//               padding: EdgeInsets.symmetric(
//                   vertical: MediaQuery.of(context).size.width * 0.02,
//                   horizontal: MediaQuery.of(context).size.width * 0.05),
//               decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 24, 102, 24),
//                   borderRadius: BorderRadius.circular(10),
//                   border:
//                       Border.all(color: const Color.fromARGB(255, 219, 214, 214))),
//               child: Text(
//                 widget.message.message,
//                 style: const TextStyle(color: Colors.white, fontSize: 18),
//               ),
//                      ),
//            ),
//         ],
//       ),
//     );
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/methods/firestoremethods.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/formated_date.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return FirestoreMethods.user.uid == widget.message.fromId
        ? greenMessage()
        : greyMessage();
  }

  Widget greyMessage() {
    if (widget.message.read.isEmpty)
      FirestoreMethods.updateReadMessage(widget.message);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 98, 100, 100),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: widget.message.type == Type.text
                ? Text(widget.message.message)
                : ClipRRect(
                  child: CachedNetworkImage(
                                 placeholder: (context,url)=>const CircularProgressIndicator(),
                    errorWidget: (context,url,error)=>
                      const Icon(Icons.image),
                  
                    imageUrl: widget.message.message),
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(formatedDate.getFormattedTime(
              context: context, time: widget.message.sent)),
        ),
      ],
    );
  }

  Widget greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Row(
              children: [
                if (widget.message.read.isNotEmpty)
                  const Icon(Icons.done_all_rounded,
                      color: Colors.blue, size: 20),
                Text(formatedDate.getFormattedTime(
                    context: context, time: widget.message.sent)),
              ],
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: widget.message.type == Type.text
                ? Text(widget.message.message)
                : ClipRRect(
                  
                  child: CachedNetworkImage(
                    placeholder: (context,url)=>const CircularProgressIndicator(),
                    errorWidget: (context,url,error)=>
                      const Icon(Icons.image),
                  
                    imageUrl: widget.message.message),
                ),
          ),
        ),
      ],
    );
  }
}
