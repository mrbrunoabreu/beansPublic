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
  final ScrollController _scrollController = ScrollController();
  bool profileCheck = true;
  Profile user;
  BeanstaProvider beanstaData;

  final Stream<QuerySnapshot> _beanstaStream = FirebaseFirestore.instance
      .collection('beansTimeLine')
      .orderBy('creationTime', descending: true)
      .snapshots();

  @override
  void initState() {
    final userData = Provider.of<UserRepository>(context, listen: false);
    final beanstaInit = Provider.of<BeanstaProvider>(context, listen: false);
    if (profileCheck) {
      setState(() {
        user = userData.userProfile;
        beanstaData = beanstaInit;
        profileCheck = false;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user.name == null || user.name == 'User') {
      return const CompleteRegistration();
    } else {
      return SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: _beanstaStream,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
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
                            ItemHeader(
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
                              isOwner: snapshot.data.docs
                                      .elementAt(i)['creatorId'] ==
                                  user.profileId,
                            ),
                            const SizedBox(height: 7),
                            Image.network(
                                snapshot.data.docs
                                    .elementAt(i)['itemPhoto']
                                    .toString(),
                                fit: BoxFit.fitWidth),
                            const SizedBox(height: 7),
                            Row(
                              children: [
                                snapshot.data.docs
                                      .elementAt(i)['likes'].toString().contains(user.profileId) ?
                                IconButton(
                                    icon: const Icon(
                                      Ionicons.heart,
                                      color: Colors.red,
                                      size: 27,
                                    ),
                                    onPressed: () => beanstaData.addFavorite(
                                        item:
                                            snapshot.data.docs.elementAt(i).id,
                                        user: user)) : IconButton(
                                    icon: const Icon(
                                      Ionicons.heart_outline,
                                      size: 27,
                                    ),
                                    onPressed: () => beanstaData.addFavorite(
                                        item:
                                            snapshot.data.docs.elementAt(i).id,
                                        user: user)),
                                const SizedBox(width: 7),
                                IconButton(
                                  icon: const Icon(Ionicons.chatbubble_outline),
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(BeanstaComments.routeName,
                                          arguments: BeanstaComment(
                                              itemId: snapshot.data.docs
                                                  .elementAt(i)
                                                  .id,
                                              commentAuthor: user.name)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (snapshot.data.docs
                                      .elementAt(i)['itemDescription']
                                      .toString()
                                      .isNotEmpty)
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
                                  CommentsArea(
                                      itemId:
                                          snapshot.data.docs.elementAt(i).id,
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

class ItemHeader extends StatelessWidget {
  @required
  final Profile user;
  @required
  final String authorName;
  @required
  final String authorAvatar;
  @required
  final String photoLocation;
  @required
  final String itemImageUrl;
  @required
  final String itemId;
  @required
  final bool isOwner;

  const ItemHeader({
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: const VisualDensity(horizontal: -2),
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
                        title: const Text(
                          'This will delete this photo forever. Are you sure?',
                        ),
                        actions: [
                          FlatButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text('Cancel')),
                          FlatButton(
                              onPressed: () => Provider.of<BeanstaProvider>(
                                      context,
                                      listen: false)
                                  .deletePhotoItem(
                                      mealImageUrl: itemImageUrl,
                                      itemId: itemId,
                                      user: user),
                              child: const Text('OK'))
                        ],
                      )),
              icon: const Icon(
                Ionicons.close,
              ))
          : null,
    );
  }
}

class CommentsArea extends StatelessWidget {
  @required
  final String itemId;
  final String author;

  const CommentsArea({this.itemId, this.author, Key key}) : super(key: key);

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
              ? const Center(child: CircularProgressIndicator())
              : snapshot.data.docs.length > 2
                  ? FlatButton(
                      padding: const EdgeInsets.only(left: 0),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            BeanstaComments.routeName,
                            arguments: BeanstaComment(
                                itemId: itemId, commentAuthor: author));
                      },
                      child: Text(
                          'View all ${snapshot.data.docs.length} comments',
                          style: Theme.of(context).textTheme.headline6))
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (ctx, e) {
                        return Container(
                            padding: const EdgeInsets.only(
                                right: 5, bottom: 4, top: 7),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    snapshot.data.docs
                                        .elementAt(e)['commentAuthor']
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                const SizedBox(width: 5),
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
