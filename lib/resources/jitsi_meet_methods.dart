// import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:zoom_clone/resources/auth_methods.dart';
import 'package:zoom_clone/resources/firestore_methods.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  // late TextEditingController subjectText = TextEditingController();
  // late TextEditingController tokenText = TextEditingController();
  
  void createMeeting({
    // required String serverText,
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    required bool isAudioOnly,
    String username = '',
  }) async {
    try {
      // String? serverUrl =
      //     serverText.trim().isEmpty ? null : serverText;
      Map<String, Object> featureFlags = {};
      String name;
      if (username.isEmpty) {
        name = _authMethods.user.displayName!;
      } else {
        name = username;
      }
      // Define meetings options here
      var options = JitsiMeetingOptions(
      roomNameOrUrl: roomName,
      // serverUrl: serverUrl,
      // subject: subjectText.text,
      // token: tokenText.text,
      isAudioMuted: isAudioMuted,
      isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
      userDisplayName: name,
      userEmail: _authMethods.user.email,
      featureFlags: featureFlags,
    );

      _firestoreMethods.addToMeetingHistory(roomName);
      print("JitsiMeetingOptions: $options");
      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onOpened: () => print("onOpened"),
          onConferenceWillJoin: (url) {
            print("onConferenceWillJoin: url: $url");
          },
          onConferenceJoined: (url) {
            print("onConferenceJoined: url: $url");
          },
          onConferenceTerminated: (url, error) {
            print("onConferenceTerminated: url: $url, error: $error");
          },
          onAudioMutedChanged: (isMuted) {
            print("onAudioMutedChanged: isMuted: $isMuted");
          },
          onVideoMutedChanged: (isMuted) {
            print("onVideoMutedChanged: isMuted: $isMuted");
          },
          onScreenShareToggled: (participantId, isSharing) {
            print(
              "onScreenShareToggled: participantId: $participantId, "
              "isSharing: $isSharing",
            );
          },
          onParticipantJoined: (email, name, role, participantId) {
            print(
              "onParticipantJoined: email: $email, name: $name, role: $role, "
              "participantId: $participantId",
            );
          },
          onParticipantLeft: (participantId) {
            print("onParticipantLeft: participantId: $participantId");
          },
          onParticipantsInfoRetrieved: (participantsInfo, requestId) {
            print(
              "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
              "requestId: $requestId",
            );
          },
          onChatMessageReceived: (senderId, message, isPrivate) {
            print(
              "onChatMessageReceived: senderId: $senderId, message: $message, "
              "isPrivate: $isPrivate",
            );
          },
          onChatToggled: (isOpen) => print("onChatToggled: isOpen: $isOpen"),
          onClosed: () => print("onClosed"),
        ),
      );
    } catch (e) {
      print("error: $e");
    }
  }
}
