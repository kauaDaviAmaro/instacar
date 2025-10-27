// import 'package:flutter/material.dart';

// class TittleGenerator extends StatefulWidget {
//   Text
//   const TittleGenerator({super.key});
  
// @override
//   State<TittleGenerator> createState() => _TittleGeneratorState();

// }

// class _TittleGeneratorState extends State<TittleGenerator>{
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       "Tipo de veículo:",
//       style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//     );
//   }
// }

import 'package:flutter/material.dart';

Text TittleGenerator(BuildContext context, text){
  return Text(
      text,
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
}