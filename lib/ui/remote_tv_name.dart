import 'package:flutter/widgets.dart';
import 'package:remote/theme/app_theme.dart';

class RemoteTvName extends StatelessWidget {
  const RemoteTvName({
    super.key,
    required this.name,
    required this.model,
  });

  final String name;
  final String model;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: theme.textStyles.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            model,
            style: theme.textStyles.model,
          ),
        ],
      ),
    );
  }
}
