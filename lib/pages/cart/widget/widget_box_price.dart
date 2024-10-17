// import 'package:flutter/material.dart';
// import 'package:car_app/components/button/cr_elevated_button.dart';

// class BoxPrice extends StatelessWidget {
//   const BoxPrice({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.2,
//       minChildSize: 0.08,
//       maxChildSize: 0.4,
//       builder: (context, scrollController) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(40.0),
//               topRight: Radius.circular(40.0),
//             ),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black26,
//                   offset: Offset(0, -1),
//                   blurRadius: 20.0)
//             ],
//           ),
//           child: SingleChildScrollView(
//             controller: scrollController,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 15, bottom: 40),
//                     child: Container(
//                       height: 6,
//                       width: 40,
//                       decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Product Cost',
//                         style: TextStyle(
//                           fontSize: 20.0,
//                         ),
//                       ),
//                       Text(
//                         '',
//                         style: TextStyle(color: Colors.black, fontSize: 20.0),
//                       )
//                     ],
//                   ),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Delivery Cost',
//                         style: TextStyle(
//                           fontSize: 20.0,
//                         ),
//                       ),
//                       Text(
//                         '\$20',
//                         style: TextStyle(color: Colors.black, fontSize: 20.0),
//                       )
//                     ],
//                   ),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Total Cost',
//                         style: TextStyle(
//                             fontSize: 24.0, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         '',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 30.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 20.0),
//                   CrElevatedButton(
//                     height: 60.0,
//                     borderRadius: BorderRadius.circular(25.0),
//                     text: 'Check Out',
//                     onPressed: () {},
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
