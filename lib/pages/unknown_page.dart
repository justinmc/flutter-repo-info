import 'package:flutter/material.dart';

class UnknownPage extends MaterialPage {
  const UnknownPage() : super(
    key: const ValueKey('UnknownPage'),
    restorationId: 'home-page',
    child: const _UnknownPage(),
  );
}

class _UnknownPage extends StatelessWidget {
  const _UnknownPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('404'),
      ),
    );
  }
}
