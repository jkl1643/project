<%--
  Created by IntelliJ IDEA.
  User: Yu
  Date: 2020-09-24
  Time: 오후 9:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.example.Room" %>

<html>
<head>
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <title>Title</title>
</head>
<body>
<%
    Room room = (Room)request.getAttribute("room");
    String roomid = (String)request.getAttribute("roomid");
    String roompw = (String)request.getAttribute("roompw");
    System.out.println(session.getAttribute("cap"));
%>
회의 아이디 : ${roomid} <BR>
회의 비밀번호 : ${roompw}<BR>
<input id="msg" type="text">
<input type="button" onclick="sendMessage()" value="Send">
<input type="button" onclick="invite()" value="초대">
<ul class="userlistbox"></ul>
<div id="messageTextArea" rows="10" cols="50"></div>
<table>
    <tr>
        <userlist id="pguserlist">
            <div id="userlist">
            </div>
        </userlist>
    </tr>
</table>
<div id = "output"></div>

<%--<div id="camdiv">
    <video autoplay></video>
</div>--%>


<%--<video autoplay id="remoteVideo"></video>
<video autoplay id="myVideo"></video>--%>

<div class="flexChild" id="camera-container">
    <div class="camera-box">
        <p>
            received_video<BR>
        <video id="received_video" autoplay></video>
        </p>
        <p>
            received_video2<BR>
            <video id="received_video2" autoplay></video>
        </p>
        <p>
            local_video<BR>
        <video id="local_video" autoplay muted></video>
        </p>

        <button id="hangup-button" onclick="hangUpCall();" disabled>
            Hang Up
        </button>
    </div>
</div>

<br>
<button id="btn1" onclick="start()">Start</button>
<button id="btn2" onclick="stop()">Stop</button>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js"></script>
<script type = "text/javascript">
    var output, webSocket;
    var roomid = "${roomid}";
    var roompw = "${roompw}";
    var userNickName = "${User_list}";
    var messageTextArea = document.getElementById("messageTextArea");
    var remoteVideo = document.getElementById("remoteVideo");
    var localVideo = document.getElementById("myVideo");
    let caller = new RTCPeerConnection();
    let callee = new RTCPeerConnection();
    var myUsername = "jkl4976";
    var targetUsername = "jkl1643";
    $(document).ready(function () {
        $("#userlist").load("refreshuserlist");
    });

    document.addEventListener('keydown', function (e) {
        entersend(e);
    })

    function entersend(e) {
        if (e.keyCode == 13)
            sendMessage();
    }

    function sendMessage() {
        msg = document.getElementById("msg").value;
        webSocket.send(JSON.stringify({type : "chat", userNickName : userNickName, roomID : roomid, roomPW : roompw, msg : msg}));
        document.getElementById("msg").value = "";
    }

    function init() {
        testWebSocket();
    }

    function testWebSocket() {
        webSocket = new WebSocket("ws://" + location.host + "/game");
        webSocket.onopen = function(evt) {
            onOpen(evt);
        };
        webSocket.onclose = function(evt) {
            onClose(evt);
        };
        webSocket.onmessage = function(evt) {
            onMessage(evt);
        };
        webSocket.onerror = function(evt) {
            onError(evt);
        };
    }

    function onOpen(evt) {
        webSocket.send(JSON.stringify({userNickName : userNickName, roomID : roomid, roomPW : roompw}));
        $('#userlist').load("refreshuserlist");
    }

    function onClose(evt) {
        window.location.href='home';
    }

    function onMessage(evt) {
        var js = evt.data;
        var data = JSON.parse(js);
        chatroom = document.getElementById("messageTextArea");
        if (data.type == "chat") {
            if (data.roomID == roomid && data.roomPW == roompw) {
                if (data.msg != null || data.msg != undefined || data.msg != "" || data.msg != '\n' || data.msg != "undefined") {
                    chatroom.innerHTML = chatroom.innerHTML + "<br>" + data.msg;
                }
            }
        } else if (data.type == "video-offer") {
            handleVideoOfferMsg(data);
        } else if (data.type == "video-answer") {
            handleVideoAnswerMsg(data);
        } else if (data.type == "new-ice-candidate") {
            if (data.target == "jkl4976") {
                handleNewICECandidateMsg(data);
            } else if (data.target == "jkl1643") {
                handleNewICECandidateMsg(data);
            }
        }



        chatroom.scrollTop = chatroom.scrollHeight;
        $('#userlist').load("refreshuserlist");
    }

    function onError(evt) {

    }

    //캠-----------------------------------------
    var cam = document.getElementById("cam");

    function start() {
        var tmp ="";
        tmp = tmp + "<video autoplay></video>"
        $("#camdiv").append(tmp);
        video = document.querySelector('video');

        navigator.mediaDevices.getUserMedia(constraints).
        then((stream) => {video.srcObject = stream});
    }

    function stop(){
        $("#camdiv *").remove();
        audio.pause();
    }

    let constraints = {
        video : true,
        audio : true
    };
    let video = document.querySelector('video');
    let audio = document.querySelector('audio');

    navigator.mediaDevices.getUserMedia(constraints).
    then((stream) => {video.srcObject = stream});
    //-----------------------------------------------

    /*navigator.getUserMedia({
        video: true,
        audio: false
    }, getUserMediaSuccess, getUserMediaError);

    function getUserMediaSuccess(mediaStream){
        localVideo.srcObject = mediaStream;
        caller.addStream(mediaStream); //미디어 스트림 입력
        createOffer();
    }

    function getUserMediaError(e) {
        console.log(e);
    }

    function createOffer() {

        caller.createOffer().then((sdp) => createOfferSuccess).catch(err => createOfferError);
        alert("createOffer");
    }

    function createOfferError(e) {
        alert("createOfferError");
        console.log(e);
    }

    function createOfferSuccess(sdp){
        alert("createOfferSuccess");
        caller.setLocalDescription(sdp);
        sendOffer(sdp); //send sdp to callee
    }

    function sendOffer(sdp){
        alert("sendOffer");
        callee.setRemoteDescription(sdp);
        createAnswer();
    }

    function createAnswer(){
        alert("createAnswer");
        callee.createAnswer()
            .then(()=>createAnswerSuccess)
            .catch(err=> createAnswerError);
    }

    function createAnswerError(e){
        alert("createAnswerError");
        console.log(e);
    }

    function createAnswerSuccess(sdp){
        alert("createAnswerSuccess");
        callee.setLocalDescription(sdp);
        sendAnswer(sdp)// send SDP to Caller
    }

    function sendAnswer(sdp){
        alert("sendAnswer");
        caller.setRemoteDescription(sdp);
    }

    caller.onicecandidat = handlerCallerOnicecandidate;
    callee.onicecandidat = handleeCallerOnicecandidate;
    function handleeCallerOnicecandidate(e){
        if(e.candidate) callee.addIceCandidate(e.candidate);

    }
    function handlerCallerOnicecandidate(e){
        if(e.candidate) caller.addIceCandidate(e.candidate);
    }

    callee.onaddstream = handleeCalleeOnAddStream;
    function handleeCalleeOnAddStream(e){
        remoteVideo.srcObject = e.stream
        alert("dsa");
    }*/
    var mediaConstraints = {
        audio: true, // We want an audio track
        video: true // ...and we want a video track
    };

    async function createPeerConnection() {
        alert("createPeerConnection");
        myPeerConnection = new RTCPeerConnection({
            iceServers: [     // Information about ICE servers - Use your own!
                {
                    //urls: "stun:stun.stunprotocol.org"
                    "url" : "stun:stun2.1.google.com:19302"
                }
            ]
        });

        myPeerConnection.onicecandidate = handleICECandidateEvent;
        myPeerConnection.oniceconnectionstatechange = handleICEConnectionStateChangeEvent;
        myPeerConnection.onicegatheringstatechange = handleICEGatheringStateChangeEvent;
        myPeerConnection.onsignalingstatechange = handleSignalingStateChangeEvent;
        myPeerConnection.onnegotiationneeded = handleNegotiationNeededEvent;
        myPeerConnection.ontrack = handleTrackEvent;
        /*myPeerConnection.onicecandidate = handleICECandidateEvent;
        myPeerConnection.ontrack = handleTrackEvent;
        myPeerConnection.onnegotiationneeded = handleNegotiationNeededEvent;
        myPeerConnection.onremovetrack = handleRemoveTrackEvent;
        myPeerConnection.oniceconnectionstatechange = handleICEConnectionStateChangeEvent;
        myPeerConnection.onicegatheringstatechange = handleICEGatheringStateChangeEvent;
        myPeerConnection.onsignalingstatechange = handleSignalingStateChangeEvent;*/
    }

    function invite(evt) {
        alert("invite");
        createPeerConnection();

        navigator.mediaDevices.getUserMedia(mediaConstraints)
            .then(function(localStream) {
                document.getElementById("local_video").srcObject = localStream;
                localStream.getTracks().forEach(track => myPeerConnection.addTrack(track, localStream));
            })
            .catch(handleGetUserMediaError);
    }

    function handleGetUserMediaError(e) {
        switch(e.name) {
            case "NotFoundError":
                alert("Unable to open your call because no camera and/or microphone" +
                    "were found.");
                break;
            case "SecurityError":
            case "PermissionDeniedError":
                // Do nothing; this is the same as the user canceling the call.
                break;
            default:
                alert("Error opening your camera and/or microphone: " + e.message);
                break;
        }

        closeVideoCall();
    }



    function handleNegotiationNeededEvent() {
        alert("handleNegotiationNeededEvent");
        myPeerConnection.createOffer().then(function(offer) {
            return myPeerConnection.setLocalDescription(offer);
        })
            .then(function() {
                sendToServer({
                    name: myUsername,
                    target: targetUsername,
                    type: "video-offer",
                    sdp: myPeerConnection.localDescription
                });
            })
            .catch(reportError);
    }

    function reportError(){
        alert("reportError");
    }

    function handleVideoOfferMsg(msg) {
        alert("handleVideoOfferMsg : " + msg);
        var localStream = null;

        targetUsername = msg.name;
        createPeerConnection();

        var desc = new RTCSessionDescription(msg.sdp);

        myPeerConnection.setRemoteDescription(desc).then(function () {
            return navigator.mediaDevices.getUserMedia(mediaConstraints);
        })
            .then(function(stream) {
                localStream = stream;
                document.getElementById("local_video").srcObject = localStream;
                //document.getElementById("received_video").srcObject = localStream;

                localStream.getTracks().forEach(track => myPeerConnection.addTrack(track, localStream));
            })
            .then(function() {
                return myPeerConnection.createAnswer();
            })
            .then(function(answer) {
                return myPeerConnection.setLocalDescription(answer);
            })
            .then(function() {
                var msg = {
                    name: myUsername,
                    target: targetUsername,
                    type: "video-answer",
                    sdp: myPeerConnection.localDescription
                };

                sendToServer(msg);
            })
            .catch(handleGetUserMediaError);
    }

    async function handleVideoAnswerMsg(msg) {
        //log("*** Call recipient has accepted our call");

        // Configure the remote description, which is the SDP payload
        // in our "video-answer" message.

        var desc = new RTCSessionDescription(msg.sdp);
        await myPeerConnection.setRemoteDescription(desc).catch(reportError);
    }

    function handleICECandidateEvent(event) {
        alert("handleICECandidateEvent");
        if (event.candidate) {
            sendToServer({
                type: "new-ice-candidate",
                target: targetUsername,
                candidate: event.candidate
            });
        }
    }

    function handleNewICECandidateMsg(msg) {
        var candidate = new RTCIceCandidate(msg.candidate);
        alert("msg.data : " + msg.data + ", mag.value : " + msg.value + ", msg.candidate : " + msg.candidate + ", candidate : " + candidate);
        myPeerConnection.addIceCandidate(candidate)
            .catch(reportError);
    }

    function handleTrackEvent(event) {
        alert("handleTrackEvent");
        document.getElementById("received_video").srcObject = event.streams[0];
        //document.getElementById("received_video2").srcObject = event.streams;

        document.getElementById("hangup-button").disabled = false;
    }

    function handleRemoveTrackEvent(event) {
        alert("handleRemoveTrackEvent");
        var stream = document.getElementById("received_video").srcObject;
        var trackList = stream.getTracks();

        if (trackList.length == 0) {
            closeVideoCall();
        }
    }

    function hangUpCall() {
        alert("hangUpCall");
        closeVideoCall();
        sendToServer({
            name: myUsername,
            target: targetUsername,
            type: "hang-up"
        });
    }

    function closeVideoCall() {
        alert("closeVideoCall");
        var remoteVideo = document.getElementById("received_video");
        var localVideo = document.getElementById("local_video");

        if (myPeerConnection) {
            myPeerConnection.ontrack = null;
            myPeerConnection.onremovetrack = null;
            myPeerConnection.onremovestream = null;
            myPeerConnection.onicecandidate = null;
            myPeerConnection.oniceconnectionstatechange = null;
            myPeerConnection.onsignalingstatechange = null;
            myPeerConnection.onicegatheringstatechange = null;
            myPeerConnection.onnegotiationneeded = null;

            if (remoteVideo.srcObject) {
                remoteVideo.srcObject.getTracks().forEach(track => track.stop());
            }

            if (localVideo.srcObject) {
                localVideo.srcObject.getTracks().forEach(track => track.stop());
            }

            myPeerConnection.close();
            myPeerConnection = null;
        }

        remoteVideo.removeAttribute("src");
        remoteVideo.removeAttribute("srcObject");
        localVideo.removeAttribute("src");
        remoteVideo.removeAttribute("srcObject");

        document.getElementById("hangup-button").disabled = true;
        targetUsername = null;
    }

    function handleICEConnectionStateChangeEvent(event) {
        alert("handleICEConnectionStateChangeEvent");
        switch(myPeerConnection.iceConnectionState) {
            case "closed":
            case "failed":
                closeVideoCall();
                break;
        }
    }

    function handleSignalingStateChangeEvent(event) {
        alert("handleSignalingStateChangeEvent");
        switch(myPeerConnection.signalingState) {
            case "closed":
                alert("handleSignalingStateChangeEvent  CLOSED");
                closeVideoCall();
                break;
        }
    };

    function handleICEGatheringStateChangeEvent(event) {
        alert("handleICEGatheringStateChangeEvent");
        // Our sample just logs information to console here,
        // but you can do whatever you need.
    }

    function sendToServer(msg) {
        /*var msgJSON = JSON.stringify(msg);
        /!*alert("msgJSON : " +  msgJSON);*!/
        webSocket.send(msgJSON);*/
        alert("sendToServer");
        webSocket.send(JSON.stringify(msg));
    }

    window.addEventListener("load", init, false);
</script>
</html>
