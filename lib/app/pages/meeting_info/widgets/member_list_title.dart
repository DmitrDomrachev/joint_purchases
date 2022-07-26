import 'package:flutter/material.dart';
import 'package:meetings_api/meetings_api.dart';

class MemberListTitle extends StatelessWidget {
  const MemberListTitle(
      {Key? key, required this.member, this.onTapMember, this.onTapDel})
      : super(key: key);

  final Member member;
  final VoidCallback? onTapMember;
  final VoidCallback? onTapDel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onTapMember,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(member.name),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onTapDel,
            ),
          ],
        ),
      ),
    );
  }
}
