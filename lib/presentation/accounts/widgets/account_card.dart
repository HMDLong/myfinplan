import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final Gradient? gradient;

  /// Content of the card. [children] is wrapped in [Stack], so preferably use [Positioned] in children
  final List<Widget> children;
  final String title;
  final void Function()? onEdit;
  final void Function()? onDelete;
  const AccountCard({
    super.key,
    this.gradient,
    required this.title,
    this.onEdit,
    this.onDelete,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 300,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.blue,
        child: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: Stack(
            children: <Widget>[
                  Positioned(
                    top: 13,
                    left: 8,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Positioned.directional(
                    textDirection: TextDirection.rtl,
                    start: 0,
                    top: 0,
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            CupertinoIcons.pencil,
                            size: 20,
                          ),
                          onPressed: onEdit,
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            CupertinoIcons.delete_solid,
                            size: 20,
                          ),
                          onPressed: onDelete,
                        ),
                      ],
                    ),
                  ),
                ] +
                children,
          ),
        ),
      ),
    );
  }
}
