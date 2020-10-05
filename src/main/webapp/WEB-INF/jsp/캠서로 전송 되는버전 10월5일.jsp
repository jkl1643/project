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
    String create = (String)session.getAttribute("create");
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

<video playsinline id="left_cam" controls preload="metadata" autoplay></video>
<video playsinline id="right_cam" controls preload="metadata" autoplay></video>



<br>
<button id="btn1" onclick="start()">Start</button>
<button id="btn2" onclick="stop()">Stop</button>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js"></script>
<script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>
<script type = "text/javascript">
    var output, webSocket;
    var roomid = "${roomid}";
    var roompw = "${roompw}";
    var userNickName = "${User_list}";
    var messageTextArea = document.getElementById("messageTextArea");
    var create = "${create}";
    var answercount = 0;


    var isChannelReady = false;
    var isInitiator = false;
    var isStarted = false;
    var localStream;
    var pc;
    var remoteStream;

    var remoteVideo = document.getElementById('right_cam');
    var localVideo = document.getElementById('left_cam');

    var pcConfig = {
        'iceServers': [{
            urls: 'stun:stun.l.google.com:19302'
        },
            {urls: "turn:numb.viagenie.ca",
                credential: "muazkh",
                username: "webrtc@live.com"}
        ]};

    var sdpConstraints = {
        offerToReceiveAudio: true,
        offerToReceiveVideo: true
    };

    localVideo.addEventListener("loadedmetadata", function () {
        console.log('left: gotStream with width and height:', localVideo.videoWidth, localVideo.videoHeight);
    });

    remoteVideo.addEventListener("loadedmetadata", function () {
        console.log('right: gotStream with width and height:', remoteVideo.videoWidth, remoteVideo.videoHeight);
    });

    remoteVideo.addEventListener('resize', () => {
        console.log(`Remote video size changed to ${remoteVideo.videoWidth}x${remoteVideo.videoHeight}`);
    });

    //function invite() {
    navigator.mediaDevices.getUserMedia({
        audio: false,
        video: true
    })
        .then(gotStream)
        .catch(function (e) {
            alert('getUserMedia() error: ' + e.name);
        });
    //}

    function gotStream(stream) {
        console.log('Adding local stream. -- 1');
        localStream = stream;
        localVideo.srcObject = stream;
        sendMessage('got user media');
        console.log("isInitiator전 : " + isInitiator);
        if (isInitiator) {
            maybeStart();
        }
        console.log("isInitiator후 : " + isInitiator);
    }


    var constraints = {
        video: true
    };

    console.log('Getting user media with constraints', constraints);

    if (location.hostname !== 'localhost') {
        requestTurn(
            "stun:stun.l.google.com:19302"
        );
    }

    function maybeStart() {
        console.log('>>>>>>> maybeStart() ', isStarted, localStream, isChannelReady);
        console.log("maybestart중 isStarted : " + isStarted + ", localstream : " + localStream + ", iscannel : " + isChannelReady);
        if (!isStarted && typeof localStream !== 'undefined' && isChannelReady) {
            console.log('>>>>>> creating peer connection');
            createPeerConnection();
            pc.addStream(localStream);
            isStarted = true;
            console.log('isInitiator : ' + isInitiator);
            if (isInitiator) {
                doCall();
            }
        }
    }

    window.onbeforeunload = function () {
        sendMessage('bye');
    };

    /////////////////////////////////////////////////////////

    function createPeerConnection() {
        try {
            pc = new RTCPeerConnection(pcConfig);
            pc.onicecandidate = handleIceCandidate;
            pc.onaddstream = handleRemoteStreamAdded;
            pc.onremovestream = handleRemoteStreamRemoved;
            console.log('Created RTCPeerConnnection');
        } catch (e) {
            console.log('Failed to create PeerConnection, exception: ' + e.message);
            alert('Cannot create RTCPeerConnection object.');
            return;
        }
    }

    function handleIceCandidate(event) {
        console.log('icecandidate event: ', event);
        if (event.candidate) {
            sendMessage({
                type: 'candidate',
                label: event.candidate.sdpMLineIndex,
                id: event.candidate.sdpMid,
                candidate: event.candidate.candidate
            });
        } else {
            console.log('End of candidates.');
        }
    }

    function handleCreateOfferError(event) {
        console.log('createOffer() error: ', event);
    }

    function doCall() {
        console.log('Sending offer to peer');
        pc.createOffer(setLocalAndSendMessage, handleCreateOfferError);
    }

    function doAnswer() {
        console.log('Sending answer to peer.');
        try {
            pc.createAnswer().then(
                setLocalAndSendMessage,
                onCreateSessionDescriptionError
            );
        } catch (e) {
            alert("doAnswer에러");
        }
    }

    function setLocalAndSendMessage(sessionDescription) {
        pc.setLocalDescription(sessionDescription);
        console.log('setLocalAndSendMessage sending message', sessionDescription);
        if(answercount == 0) {
            console.log("answercount : " + answercount);
            sendMessage(sessionDescription);
            //answercount = 1;
        }
    }

    function onCreateSessionDescriptionError(error) {
        console.log('Failed to create session description: ' + error.toString());
    }

    /*turn 서버 요청 CORS 문제 발생*/
    function requestTurn(turnURL) {
        var turnExists = true;
        if (!turnExists) {
            console.log("!turnExiste");
        } else {
            console.log("turnExiste");
        }
    }

    function handleRemoteStreamAdded(event) {
        console.log('Remote stream added.');
        remoteStream = event.stream;
        console.log(event);
        remoteVideo.srcObject = remoteStream;
    }

    function handleRemoteStreamRemoved(event) {
        console.log('Remote stream removed. Event: ', event);
    }

    function hangup() {
        console.log('Hanging up.');
        stop();
        sendMessage('bye');
    }

    function handleRemoteHangup() {
        console.log('Session terminated.');
        stop();
        isInitiator = false;
    }

    function stop() {
        isStarted = false;
        pc.close();
        pc = null;
    }

    $(document).ready(function () {
        //$("#userlist").load("refreshuserlist");
    });

    document.addEventListener('keydown', function (e) {
        entersend(e);
    })

    function entersend(e) {
        if (e.keyCode == 13)
            sendMessage();
    }

    function sendMessage(message) {
        msg = document.getElementById("msg").value;

        if(msg != null){
            webSocket.send(JSON.stringify({type : "chat", userNickName : userNickName, roomID : roomid, roomPW : roompw, msg : msg}));
            document.getElementById("msg").value = "";
        }

        webSocket.send(JSON.stringify(message));
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
        //$('#userlist').load("refreshuserlist");
    }

    function onClose(evt) {
        window.location.href='home';
    }

    function onMessage(evt) {
        var js = evt.data;
        var data = JSON.parse(js);
        chatroom = document.getElementById("messageTextArea");
        /*if (data.type == "chat") {
            if (data.roomID == roomid && data.roomPW == roompw) {
                if (data.msg != null || data.msg != undefined || data.msg != "" || data.msg != '\n' || data.msg != "undefined") {
                    chatroom.innerHTML = chatroom.innerHTML + "<br>" + data.msg;
                }
            }
        }*/
        if (data === "got user media"/* && create != "create"*/) {
            console.log("got user media받음");
            maybeStart();
        } else if (data.type === "offer") {
            console.log("offer받음");
            if (!isInitiator && !isStarted) {
                maybeStart();
            }
            pc.setRemoteDescription(new RTCSessionDescription(data));
            doAnswer();
        } else if (data.type === "answer" && isStarted) {
            console.log("answer받음");
            pc.setRemoteDescription(new RTCSessionDescription(data));
        } else if (data.type === "candidate" && isStarted) {
            console.log("candidate받음");
            var candidate = new RTCIceCandidate({
                sdpMLineIndex: data.label,
                candidate: data.candidate
            });
            pc.addIceCandidate(candidate).catch(e => {
                console.log("Failure during addIceCandidate(): " + e.name);
            });
        } else if (data === "bye" && isStarted) {
            console.log("bye받음");
            handleRemoteHangup();
        }
        if (create == "create" && data.userNickName == "[jkl1643@naver.com, jkl4976@naver.com]") {
            console.log("create == true");
            isInitiator = true;
            isChannelReady = true;
        } else {
            console.log("create == else");
            isChannelReady = true;
        }



        chatroom.scrollTop = chatroom.scrollHeight;
        //$('#userlist').load("refreshuserlist");
    }

    function onError(evt) {

    }


    window.addEventListener("load", init, false);
</script>
</html>
