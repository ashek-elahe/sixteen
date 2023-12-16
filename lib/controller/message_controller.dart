import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/model/conversation_model.dart';
import 'package:sixteen/model/message_model.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/db_table.dart';
import 'package:sixteen/widget/custom_snackbar.dart';

class MessageController extends GetxController implements GetxService {

  List<ConversationModel>? _conversations;
  ConversationModel? _conversation;
  List<MessageModel>? _messages;
  DocumentSnapshot? _lastDocument;
  bool _paginate = true;
  List<XFile>? _attachments;
  StreamSubscription? _conversationSubscription;
  StreamSubscription? _subscription;
  List<String> _ids = [];
  bool _isLoading = false;

  List<ConversationModel>? get conversations => _conversations;
  ConversationModel? get conversation => _conversation;
  List<MessageModel>? get messages => _messages;
  bool get paginate => _paginate;
  List<XFile>? get attachments => _attachments;
  bool get isLoading => _isLoading;

  Future<void> getConversations() async {
    UserModel user = Get.find<AuthController>().user!;
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(DbTable.messages.name).where(Filter.or(
        Filter('user_1_email', isEqualTo: user.email),
        Filter('user_2_email', isEqualTo: user.email),
    )).orderBy('last_message_time', descending: true);
    _conversationSubscription?.cancel();
    _conversationSubscription = query.snapshots().listen((QuerySnapshot<Map<String, dynamic>> event) {
      _conversations = [];
      for(DocumentSnapshot document in event.docs) {
        _conversations!.add(ConversationModel.fromJson(document.data() as Map<String, dynamic>, true));
      }
      _sortUnread(user);
      debugPrint(('Fetched Size:=====> ${event.docs.length}'));
      update();
    });
  }

  void _sortUnread(UserModel user) {
    List<ConversationModel> tempList = [];
    tempList.addAll(_conversations!.toList());
    List<int> unreadIndexes = [];
    for(int index = 0; index < _conversations!.length; index++) {
      if((_conversations![index].user1Email == user.email && _conversations![index].user1Unread! > 0)
          || (_conversations![index].user2Email == user.email && _conversations![index].user2Unread! > 0)) {
        unreadIndexes.add(index);
      }
    }
    _conversations!.removeWhere((conversation) => (conversation.user1Email == user.email && conversation.user1Unread! > 0)
        || (conversation.user2Email == user.email && conversation.user2Unread! > 0));
    for(int index = (unreadIndexes.length-1); index >= 0; index--) {
      _conversations!.insert(0, tempList[unreadIndexes[index]]);
    }
  }

  void cancelListeningConversation() {
    _conversationSubscription?.cancel();
    debugPrint((':=====> Conversation Listening cancelled'));
  }

  Query<Map<String, dynamic>> _getQueryFromId({required String id}) => FirebaseFirestore.instance.collection(DbTable.messages.name)
      .doc(id).collection('replies').orderBy('time', descending: true);

  Future<void> listenMessages({required String id}) async {
    Query<Map<String, dynamic>> query = _getQueryFromId(id: id);
    _subscription?.cancel();
    _subscription = query.snapshots().listen((QuerySnapshot<Map<String, dynamic>> event) {
      for(DocumentChange changes in event.docChanges) {
        if(!_ids.contains(changes.doc.id)) {
          MessageModel messageModel = MessageModel.fromJson(changes.doc.data() as Map<String, dynamic>, true);
          _messages!.insert(0, messageModel);
          _ids.insert(0, changes.doc.id);
          _readReply(id, messageModel);
        }
      }
      debugPrint(('Fetched Size:=====> ${event.docChanges.length}/${event.docs.length}'));
      update();
    });
  }

  void _readReply(String id, MessageModel messageModel) {
    if(messageModel.userEmail != Get.find<AuthController>().user!.email && !messageModel.isSeen! && messageModel.id!.isNotEmpty) {
      Map<String, dynamic> m = MessageModel(isSeen: true).toJson(true);
      m.removeWhere((key, value) => value == null);
      FirebaseFirestore.instance.collection(DbTable.messages.name).doc(id).collection('replies').doc(messageModel.id).update(m);
    }
  }

  void cancelListeningMessage() {
    _subscription?.cancel();
    debugPrint((':=====> Message Listening cancelled'));
  }

  Future<void> getMessages({required String id, bool reload = false}) async {
    if(reload || _messages == null) {
      _lastDocument = null;
      _paginate = true;
    }
    try {
      Query<Map<String, dynamic>> query = _getQueryFromId(id: id).limit(Constants.pagination);
      if(_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }
      QuerySnapshot snapshot = await query.get();
      if(reload || _messages == null) {
        _messages = [];
        _ids = [];
      }
      if(snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }
      if(snapshot.docs.length < Constants.pagination) {
        _paginate = false;
      }
      for(QueryDocumentSnapshot document in snapshot.docs) {
        MessageModel messageModel = MessageModel.fromJson(document.data() as Map<String, dynamic>, true);
        _messages!.add(messageModel);
        _ids.add(document.id);
        _readReply(id, messageModel);
      }

      listenMessages(id: id);
      debugPrint(('Fetched Size:=====> ${snapshot.docs.length}'));
    } catch (e) {
      showSnackBar(message: e.toString());
      debugPrint(('Error:=====> ${e.toString()}'));
    }
    update();
  }

  Future<bool> sendMessage({required String reply}) async {
    _isLoading = true;
    bool success = false;
    update();
    try {
      UserModel me = Get.find<AuthController>().user!;
      List<String> attachments = await uploadAttachment(_attachments);
      MessageModel message = MessageModel(
        id: '', userId: me.uid, userEmail: me.email, userPhone: me.phone,
        message: reply, attachments: attachments, isSeen: false, time: DateTime.now(),
      );

      _updateConversation(me, reply);

      CollectionReference reference = FirebaseFirestore.instance.collection(DbTable.messages.name).doc(_conversation!.id).collection('replies');
      DocumentReference documentReference = await reference.add(message.toJson(true));
      message.id = documentReference.id;
      Map<String, dynamic> m = MessageModel(id: documentReference.id).toJson(true);
      m.removeWhere((key, value) => value == null);
      await reference.doc(documentReference.id).update(m);

      debugPrint(('Data:=====> ${message.toJson(true)}'));
      _attachments = [];
      success = true;
    } catch (e) {
      showSnackBar(message: e.toString());
      debugPrint(('Error:=====> ${e.toString()}'));
    }
    _isLoading = false;
    update();
    return success;
  }

  Future<void> _updateConversation(UserModel me, String reply) async {
    _conversation!.lastMessage = reply;
    _conversation!.lastMessageTime = DateTime.now();
    if(_conversation!.id == null) {
      _conversation!.user2Unread = 0;
      _conversation!.user1Unread = 1;
      DocumentReference reference = await FirebaseFirestore.instance.collection(DbTable.messages.name).add(_conversation!.toJson(true));
      Map<String, dynamic> c = ConversationModel(id: reference.id).toJson(true);
      c.removeWhere((key, value) => value == null);
      _conversation!.id = reference.id;
      await FirebaseFirestore.instance.collection(DbTable.messages.name).doc(reference.id).update(c);
      listenMessages(id: reference.id);
    }else {
      if(_conversation!.user1Email == me.email) {
        _conversation!.user2Unread = _conversation!.user2Unread! + 1;
      }else {
        _conversation!.user1Unread = _conversation!.user1Unread! + 1;
      }
      Map<String, dynamic> c = ConversationModel(
        lastMessage: _conversation!.lastMessage, lastMessageTime: _conversation!.lastMessageTime,
        user1Unread: _conversation!.user1Unread, user2Unread: _conversation!.user2Unread,
      ).toJson(true);
      c.removeWhere((key, value) => value == null);
      await FirebaseFirestore.instance.collection(DbTable.messages.name).doc(_conversation!.id).update(c);
    }
  }

  Future<ConversationModel?> getConversationAndMessages({required ConversationModel conversation}) async {
    _messages = null;
    _conversation = ConversationModel.fromJson(conversation.toJson(false), false);
    if(_conversation?.id == null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(DbTable.messages.name).where(Filter.or(
          Filter('user_1_email', isEqualTo: _conversation!.user1Email),
          Filter('user_2_email', isEqualTo: _conversation!.user1Email),
        )).where(Filter.or(
          Filter('user_1_email', isEqualTo: _conversation!.user2Email),
          Filter('user_2_email', isEqualTo: _conversation!.user2Email),
        )).limit(1).get();

        if(snapshot.docs.isNotEmpty) {
          _conversation = ConversationModel.fromJson(snapshot.docs.first.data() as Map<String, dynamic>, true);
        }
        debugPrint(('Fetched Size:=====> ${snapshot.docs.length}'));
      } catch (e) {
        showSnackBar(message: e.toString());
        debugPrint(('Error:=====> ${e.toString()}'));
      }
    }
    if(_conversation?.id != null) {
      await _resetUnreadCount();
      getMessages(id: _conversation!.id!);
    }else {
      _lastDocument = null;
      _paginate = false;
      _messages = [];
      _ids = [];
      update();
    }
    return _conversation;
  }

  Future<void> _resetUnreadCount() async {
    bool isMeUser1 = _conversation!.user1Email == Get.find<AuthController>().user!.email;
    if(isMeUser1 && _conversation!.user1Unread! > 0) {
      Map<String, dynamic> c = ConversationModel(user1Unread: 0).toJson(true);
      c.removeWhere((key, value) => value == null);
      await FirebaseFirestore.instance.collection(DbTable.messages.name).doc(_conversation!.id).update(c);
    }else if(!isMeUser1 && _conversation!.user2Unread! > 0) {
      Map<String, dynamic> c = ConversationModel(user2Unread: 0).toJson(true);
      c.removeWhere((key, value) => value == null);
      await FirebaseFirestore.instance.collection(DbTable.messages.name).doc(_conversation!.id).update(c);
    }
  }

  Future<List<String>> uploadAttachment(List<XFile>? attachments) async {
    List<String> references = [];
    if(attachments != null) {
      try {
        for(XFile file in attachments) {
          Uint8List data = await file.readAsBytes();
          UploadTask task = FirebaseStorage.instance.ref().child(DbTable.messages.name)
              .child('${DateTime.now().toIso8601String()}.${file.name.split('.').last}').putData(data);
          TaskSnapshot snapshot = await task.whenComplete(() {});
          String url = await snapshot.ref.getDownloadURL();
          references.add(url);
        }
      }catch(e) {
        showSnackBar(message: e.toString());
        debugPrint(('Error:=====> ${e.toString()}'));
      }
    }
    return references;
  }

  void pickAttachments() async {
    List<XFile> files = await ImagePicker().pickMultiImage(imageQuality: 40);
    _attachments!.addAll(files);
    update();
  }

  String? getReceiverImage(ConversationModel conversation) {
    return conversation.user1Email == Get.find<AuthController>().user!.email ? conversation.user2Image : conversation.user1Image;
  }

  String? getReceiverName(ConversationModel conversation) {
    return conversation.user1Email == Get.find<AuthController>().user!.email
        ? (conversation.user2Name!.isNotEmpty ? conversation.user2Name : conversation.user2Email)
        : (conversation.user1Name!.isNotEmpty ? conversation.user1Name : conversation.user1Email);
  }

  int? getMyUnreadCount(ConversationModel conversation) {
    return conversation.user1Email == Get.find<AuthController>().user!.email ? conversation.user1Unread : conversation.user2Unread;
  }

  bool isMe(MessageModel message) {
    return message.userEmail == Get.find<AuthController>().user!.email;
  }

}