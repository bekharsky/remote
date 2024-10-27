import 'package:flutter/material.dart';

class RemoteTvName extends StatelessWidget {
  const RemoteTvName({
    super.key,
    required this.name,
    required this.modelName,
  });

  final String name;
  final String modelName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            modelName,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ],
      ),
    );
  }
}
