<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.example.Room" %>
<%@ page import="com.example.SocketHandler" %>

<html>
<head>
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <title>Title</title>
</head>
<%
    Room room = (Room)request.getAttribute("room");
    String roomid = (String)request.getAttribute("roomid");
    String roompw = (String)request.getAttribute("roompw");
    System.out.println(session.getAttribute("cap"));
    String create = (String)session.getAttribute("create");
    String username = (String)request.getAttribute("username");
%>
<body bgcolor="black">
    <div style="width: 100%; height: 100%; background-color: blueviolet">
        <div style="width: 100%; height: 30%; background-color: #7f7c7c">
            <div style="width: 100%; height: 50%">
                회의 아이디 : ${roomid} <br>
                회의 비밀번호 : ${roompw}<br>
                <table>
                    <tr>
                        <userlist id="pguserlist">
                            <div id="userlist">
                            </div>
                        </userlist>
                    </tr>
                </table>
                <ul class="userlistbox"></ul>
            </div>

            <div id="messageTextArea" style="overflow:auto; width:51%; height: 35%; background-color: #ffffff; outline:none;"></div><br>
            <input id="msg" type="text" style="position:absolute; bottom:70%; width:50%; height:3.5%; border:none; outline:none; font-size:1.2em;">
            <input type="button" align="right" onclick="sendMessage();" style="position:absolute; right: 49%; bottom:70%; width: 7%; height: 3.5%; border:none; background-color: #ffffff;" value="보내기">
        </div>

        <div style="width:100%; height:70%; background-color: #000000;">
            <video id="left_cam" width="100%" height="50%" autoplay></video>
            <video id="right_cam" width="100%" height="50%" autoplay></video>
        </div>
    </div>
</body>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js"></script>
<script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>
<script type = "text/javascript">
    var output, webSocket;
    var roomid = "${roomid}";
    var roompw = "${roompw}";
    var userNickName = "${User_list}";
    var userName = "${username}";
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

    /*localVideo.addEventListener("loadedmetadata", function () {
        console.log('left: gotStream with width and height:', localVideo.videoWidth, localVideo.videoHeight);
    });

    remoteVideo.addEventListener("loadedmetadata", function () {
        console.log('right: gotStream with width and height:', remoteVideo.videoWidth, remoteVideo.videoHeight);
    });

    remoteVideo.addEventListener('resize', () => {
        console.log(`Remote video size changed to ${remoteVideo.videoWidth}x${remoteVideo.videoHeight}`);
    });*/

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
        $("#userlist").load("refreshuserlist");
    });

    document.addEventListener('keydown', function (e) {
        entersend(e);
    })

    function entersend(e) {
        if (e.keyCode == 13)
            sendMessage();
    }

    /*function sendChatMessage() {
        msg = document.getElementById("msg").value;

        if(msg == ""){

        } else {
            webSocket.send(JSON.stringify({type : "chat", userNickName : userNickName, roomID : roomid, roomPW : roompw, msg : msg}));
            document.getElementById("msg").value = "";
        }
    }*/

    function sendMessage(message) {
        /*if(msg != null){
            webSocket.send(JSON.stringify({type : "chat", userNickName : userNickName, roomID : roomid, roomPW : roompw, msg : msg}));
            document.getElementById("msg").value = "";
        }*/
        msg = document.getElementById("msg").value;
        if (msg == "" || msg == " " || msg == null || msg == "{}" || msg == undefined || msg == "undefined") { //메세지가 비어있을때
            webSocket.send(JSON.stringify({type : "CHAT", userNickName : userNickName, roomID : roomid, roomPW : roompw}));
            webSocket.send(JSON.stringify(message));
        } else { //메세지가 비어있지 않을때
            webSocket.send(JSON.stringify({type : "chat", userNickName : userNickName, roomID : roomid, roomPW : roompw, msg : msg, userName : userName}));
            document.getElementById("msg").value = "";
        }
        //webSocket.send(JSON.stringify(message));
    }

    function onMessage(evt) {
        var js = evt.data;
        var data = JSON.parse(js);
        chatroom = document.getElementById("messageTextArea");

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
        } else if (data.type == "chat") { //채팅전송 받은거 처리
            if (data.roomID == roomid && data.roomPW == roompw) {
                if (/*data.msg != null || data.msg != undefined || data.msg != "" || data.msg != '\n' || */data.msg != "undefined") {
                    console.log("위 : " + data.msg);
                    chatroom.innerHTML = chatroom.innerHTML + "<br>" + data.userName + " : " + data.msg;
                    chatroom.scrollTop = chatroom.scrollHeight;
                } else {
                    console.log("아래 : " + data.msg);

                }
            }
        }

        if (create == "create"/* && data.userNickName == "[jkl1643@naver.com, jkl4976@naver.com]"*/) {
            //console.log("create == true");
            isInitiator = true;
            isChannelReady = true;
        } else {
            //console.log("create == else");
            isChannelReady = true;
        }

        //chatroom.scrollTop = chatroom.scrollHeight;
        $('#userlist').load("refreshuserlist");
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
        $('#userlist').load("refreshuserlist");
    }

    function onError(evt) {

    }


    window.addEventListener("load", init, false);
</script>
</html>
