import 'package:flutter/material.dart';
import 'package:zoom_clone/resources/auth_methods.dart';
import 'package:zoom_clone/resources/jitsi_meet_methods.dart';
import 'package:zoom_clone/utils/colors.dart';
import 'package:zoom_clone/widgets/meeting_option.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AuthMethods _authMethods = AuthMethods();
  late bool _isUsingLink = false;
  late TextEditingController serverTextController = TextEditingController();
  late TextEditingController meetingIdController;
  late TextEditingController nameController;
  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();
  bool isAudioMuted = true;
  bool isAudioOnly = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    serverTextController = TextEditingController();
    meetingIdController = TextEditingController();
    nameController = TextEditingController(
      text: _authMethods.user.displayName,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    serverTextController.dispose();
    meetingIdController.dispose();
    nameController.dispose();
  }

  _joinMeeting() {
    if (!_isUsingLink || serverTextController.text.trim().isEmpty) {
      meetingIdController.text = 'defaultMeetingId';
    }
    if (meetingIdController.text.trim().isEmpty) {
      print("Meeting ID is empty");
      return;
    }
    _jitsiMeetMethods.createMeeting(
      serverText: serverTextController.text,
      roomName: meetingIdController.text,
      isAudioMuted: isAudioMuted,
      isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
      username: nameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text(
          'Join a Meeting',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            child: TextField(
              controller:
                  _isUsingLink ? meetingIdController : serverTextController,
              maxLines: 1,
              textAlign: TextAlign.center,
              keyboardType: _isUsingLink ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                fillColor: secondaryBackgroundColor,
                filled: true,
                border: InputBorder.none,
                hintText: _isUsingLink
                    ? 'Room ID'
                    : 'Hint: Leave empty for meet.jitsi.si',
                contentPadding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isUsingLink = !_isUsingLink;
                if (_isUsingLink) {
                  meetingIdController.text = '';
                } else {
                  serverTextController.text = '';
                }
              });
            },
            child: Text(
              _isUsingLink
                  ? 'Don\'t have a room ID? Use link'
                  : 'Don\'t have a link? Use room ID',
            ),
          ),
          SizedBox(
            height: 60,
            child: TextField(
              controller: nameController,
              maxLines: 1,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                fillColor: secondaryBackgroundColor,
                filled: true,
                border: InputBorder.none,
                hintText: 'Name',
                contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: _joinMeeting,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Join Meeting',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MeetingOption(
            text: 'Mute Audio',
            isMute: isAudioMuted,
            onChange: onAudioMuted,
          ),
          MeetingOption(
            text: 'Audio Only',
            isMute: isAudioOnly,
            onChange: onAudioOnly,
          ),
          MeetingOption(
            text: 'Turn Off My Video',
            isMute: isVideoMuted,
            onChange: onVideoMuted,
          ),
        ],
      ),
    );
  }

  void onAudioMuted(bool? val) {
    setState(() {
      isAudioMuted = val!;
    });
  }

  void onAudioOnly(bool? val) {
    setState(() {
      isAudioOnly = val!;
    });
  }

  void onVideoMuted(bool? val) {
    setState(() {
      isVideoMuted = val!;
    });
  }
}
