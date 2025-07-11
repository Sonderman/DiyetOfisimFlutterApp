import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfileListItem extends StatefulWidget {
  final Map? jsonData;

  const ProfileListItem({super.key, this.jsonData});
  @override
  State<ProfileListItem> createState() => _ProfileListItemState();
}

class _ProfileListItemState extends State<ProfileListItem> {
  Map? get data => widget.jsonData;

  @override
  Widget build(BuildContext context) {
    var userService = locator<UserService>();
    return FutureBuilder(
      //ANCHOR Her bir list itemi için kullanıcı bilgisi getirir
      future: userService.findUserByID(data!['CommentOwnerID']),
      builder: (BuildContext context, AsyncSnapshot user) {
        if (user.connectionState == ConnectionState.done) {
          return buildItem(user.data);
        } else {
          return PageComponents(context)
              .loadingCustomOverlay(spinSize: 32, spinColor: Colors.white);
        }
      },
    );
  }

  Widget buildItem(Map user) {
    return _ProfileListItemInternal(
      image: user['ProfilePhotoUrl'],
      name: user['Name'] + " " + user['Surname'],
      comment: data!['Comment'],
    );
  }
}

class _ProfileListItemInternal extends StatefulWidget {
//  final Map<String,dynamic> user;
  final String name;
  final String image;
  final String comment;

  const _ProfileListItemInternal(
      {required this.name, required this.image, required this.comment});

  @override
  State<_ProfileListItemInternal> createState() =>
      _ProfileListItemInternalState();
}

class _ProfileListItemInternalState extends State<_ProfileListItemInternal> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  bool isOpen = false;
  double _height = 200;

  @override
  Widget build(BuildContext context) {
    _height = isOpen ? 400 : 200;
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print("Item is open? $isOpen ${DateTime.now()}");
        }
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Container(
//        height: _height,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: const Color(0xffdfdeff),
            border: Border.all(color: MyColors().greyTextColor, width: 0.3)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                height: heightSize(7),
                width: widthSize(14),
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        ExtendedNetworkImageProvider(widget.image, cache: true),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: widthSize(3),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //username
                  Text(
                    widget.name,
                    style: TextStyle(
                        fontFamily: "Kavom",
                        fontSize: heightSize(2),
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    endIndent: 15,
                    height: 15,
                    color: MyColors().blackOpacityContainer,
                    thickness: 2,
                  ),
                  Text(
                    widget.comment,
                    maxLines: isOpen ? 2000 : 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: "Kavom",
                      fontSize: heightSize(1.7),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
