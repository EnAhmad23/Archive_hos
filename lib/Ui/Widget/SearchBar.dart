// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../Controllers/file_controller.dart';

// class SearchBarExample extends StatelessWidget {
//   final FileController searchController = Get.put(FileController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Bar with GetX'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onChanged: (value) {
//                 // searchController.searchText.value = value;
//               },
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: Obx(
//                 () => ListView.builder(
//                   itemCount: searchController.filteredItems.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(searchController.filteredItems[index]),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() => runApp(GetMaterialApp(home: SearchBarExample()));
