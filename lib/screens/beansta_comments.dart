import 'package:blackbeans/bloc/beansta_provider.dart';
import 'package:blackbeans/models/beansta_comment.dart';
import 'package:blackbeans/screens/beansta_add_photo.dart';
import 'package:blackbeans/widgets/beans_custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class BeanstaComments extends StatefulWidget {
  static const routeName = '/beansta-Comments';

  @override
  _BeanstaCommentsState createState() => _BeanstaCommentsState();
}

class _BeanstaCommentsState extends State<BeanstaComments> {
  List<QueryDocumentSnapshot> comments;
  String _newComment;

  Future<void> _saveForm({String item, String author}) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    try {
      await Provider.of<BeanstaProvider>(context, listen: false)
          .addComment(comment: _newComment, item: item, author: author);
    } catch (error) {
      print(error);
    }
    _formKey.currentState.reset();
    // Navigator.canPop(context)
    //     ? Navigator.of(context).pop()
    //     : Navigator.of(context).popAndPushNamed(TimeLineScreen.routeName);
  }

  final _formKey = GlobalKey<FormState>();

  final _subtitleFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as BeanstaComment;
    return Scaffold(
      body: Column(
        children: [
          BeansCustomAppBar(
            isBackButton: true,
          ),
          _commentsStream(args.itemId),
          Expanded(
            child: GestureDetector(
                onTap: FocusScope.of(context).unfocus,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          style: Theme.of(context).textTheme.bodyText1,
                          onSaved: (String value) {
                            _newComment = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a comment';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: 'Enter your comment',
                              suffixIcon: IconButton(
                                icon: Icon(Ionicons.send),
                                onPressed: () {
                                  _saveForm(item: args.itemId, author: args.commentAuthor);
                                  // _formKey.currentState.reset();
                                },
                              )),
                        ),
                        // SizedBox(height: 10),
                        // RaisedButton(
                        //   onPressed: () {
                        //     _saveForm(args.item, args.uid, args.userName);
                        //     _formKey.currentState.reset();
                        //   },
                        //   child: Text('Submit'),
                        // )
                      ),
                    ))),
          ),
        ],
      ),
    );
  }

  Widget _commentsStream(String itemId) {
    return Expanded(
      flex: 5,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('beansTimeLine')
              .doc(itemId)
              .collection('comments')
              .orderBy('timestamp')
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (ctx, e) {
                      return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                  snapshot.data.docs
                                      .elementAt(e)['commentAuthor']
                                      .toString(),
                                  style: Theme.of(context).textTheme.bodyText2),
                              const SizedBox(width: 5),
                              Text(
                                  snapshot.data.docs
                                      .elementAt(e)['comment']
                                      .toString(),
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ));
                    });
          }),
    );
  }
}
