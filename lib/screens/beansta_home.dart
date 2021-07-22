import 'package:blackbeans/auth/complete_registration.dart';
import 'package:blackbeans/bloc/beansta_provider.dart';
import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/models/beansta_comment.dart';
import 'package:blackbeans/models/profile.dart';
import 'package:blackbeans/screens/beansta_comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class BeanstaHome extends StatefulWidget {
  const BeanstaHome({Key key}) : super(key: key);

  static const routeName = 'beansta-home';

  @override
  _BeanstaHomeState createState() => _BeanstaHomeState();
}

class _BeanstaHomeState extends State<BeanstaHome> {
  ScrollController _scrollController = ScrollController();
  bool profileCheck = true;
  Profile user;

  final Stream<QuerySnapshot> _beanstaStream = FirebaseFirestore.instance
      .collection('beansTimeLine')
      .orderBy('creationTime', descending: true)
      .snapshots();

  @override
  void initState() {
    final userData = Provider.of<UserRepository>(context, listen: false);
    if (profileCheck) {
      setState(() {
        user = userData.userProfile;
        profileCheck = false;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user.name == null || user.name == 'User') {
      return CompleteRegistration();
    } else {
      return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
          stream: _beanstaStream,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (ctx, i) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _itemHeader(
                            user: user,
                            authorName: snapshot.data.docs
                                .elementAt(i)['creatorName']
                                .toString(),
                            authorAvatar: snapshot.data.docs
                                .elementAt(i)['creatorPhoto']
                                .toString(),
                            photoLocation: snapshot.data.docs
                                .elementAt(i)['itemLocation']
                                .toString(),
                            itemImageUrl: snapshot.data.docs
                                .elementAt(i)['itemPhoto']
                                .toString(),
                            itemId: snapshot.data.docs.elementAt(i).id,
                            isOwner:
                                snapshot.data.docs.elementAt(i)['creatorId'] ==
                                    user.profileId,
                          ),
                          SizedBox(height: 7),
                          Image.network(
                              snapshot.data.docs
                                  .elementAt(i)['itemPhoto']
                                  .toString(),
                              fit: BoxFit.fitWidth),
                          SizedBox(height: 7),
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Ionicons.heart_outline,
                                    size: 27,
                                  ),
                                  onPressed: () {}),
                              SizedBox(width: 7),
                              IconButton(
                                  icon: Icon(Ionicons.chatbubble_outline),
                                  onPressed: () {}),
                            ],
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (snapshot.data.docs
                                        .elementAt(i)['itemDescription']
                                        .toString()
                                        .length >
                                    0)
                                  ReadMoreText(
                                    snapshot.data.docs
                                        .elementAt(i)['itemDescription']
                                        .toString(),
                                    trimLines: 3,
                                    colorClickableText: Colors.blue,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'more',
                                    trimExpandedText: 'less',
                                    moreStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    lessStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                const SizedBox(height: 2),
                                _commentsArea(
                                    itemId: snapshot.data.docs.elementAt(i).id,
                                    author: user.name),

                                // Text('View all 10 comments',
                                //     style:
                                //         Theme.of(context).textTheme.headline6)
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
          }),
    );
    }
  }
}

class _itemHeader extends StatelessWidget {
  @required
  Profile user;
  @required
  String authorName;
  @required
  String authorAvatar;
  @required
  String photoLocation;
  @required
  String itemImageUrl;
  @required
  String itemId;
  @required
  bool isOwner;

  _itemHeader({
    this.user,
    this.authorName,
    this.authorAvatar,
    this.photoLocation,
    this.itemImageUrl,
    this.itemId,
    this.isOwner,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity(horizontal: -2),
      dense: true,
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(authorAvatar),
      ),
      title: Text(authorName, style: Theme.of(context).textTheme.bodyText2),
      subtitle:
          Text(photoLocation, style: Theme.of(context).textTheme.bodyText1),
      trailing: isOwner
          ? IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        titleTextStyle: Theme.of(context).textTheme.bodyText1,
                        title: Text(
                          'This will delete this photo forever. Are you sure?',
                        ),
                        actions: [
                          FlatButton(
                              onPressed: Navigator.of(context).pop,
                              child: Text('Cancel')),
                          FlatButton(
                              onPressed: () => Provider.of<BeanstaProvider>(
                                      context,
                                      listen: false)
                                  .deletePhotoItem(
                                      mealImageUrl: itemImageUrl,
                                      itemId: itemId,
                                      user: user),
                              child: Text('OK'))
                        ],
                      )),
              icon: Icon(
                Ionicons.close,
              ))
          : null,
    );
  }
}

class _commentsArea extends StatelessWidget {
  @required
  final String itemId;
  final String author;

  _commentsArea({this.itemId, this.author, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('beansTimeLine')
            .doc(itemId)
            .collection('comments')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : snapshot.data.docs.length > 2
                  ? Container(
                      child: FlatButton(
                          padding: EdgeInsets.only(left: 0),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                BeanstaComments.routeName,
                                arguments: BeanstaComment(
                                    itemId: itemId, commentAuthor: author));
                          },
                          child: Text(
                              'View all ${snapshot.data.docs.length} comments',
                              style: Theme.of(context).textTheme.headline6)),
                    )
                  : ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (ctx, e) {
                        return Container(
                            padding:
                                EdgeInsets.only(right: 5, bottom: 4, top: 7),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    snapshot.data.docs
                                        .elementAt(e)['commentAuthor']
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    snapshot.data.docs
                                        .elementAt(e)['comment']
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ));
                      });
        });
  }
}
