<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.example.Room" %>
<%@ page import="com.example.SocketHandler" %>
<%@ page import="org.python.antlr.op.In" %>

<html>
<head>
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <title>Title</title>
    <style>
        #video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, 300px);
            grid-auto-rows: 300px;
        }

        video {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
    </style>
</head>
<%
    /*Room room = (Room)request.getAttribute("room");*/

    String roomid = (String)request.getAttribute("roomid");
    String roompw = (String)request.getAttribute("roompw");
    System.out.println(session.getAttribute("cap"));
    String create = (String)session.getAttribute("create");
    String username = (String)request.getAttribute("username");
    /*int size = (int)request.getAttribute("User_number");*/
%>
<body bgcolor="black">
<div style="width: 100%; height: 100%; background-color: blueviolet">
    <div style="width: 100%; height: 30%; background-color: #bbbbbb">
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
        <input id="msg" type="text" placeholder="채팅 입력" style="position:absolute; bottom:70%; width:50%; height:3.5%; border:none; outline:none; font-size:1.2em;">
        <input type="button" align="right" onclick="sendMessage();" style="position:absolute; right: 49%; bottom:70%; width: 7%; height: 3.5%; border:none; background-color: #ffffff;" value="보내기">
    </div>

    <div id="camdiv" style="width:100%; height:70%; background-color: #000000;">
        <video id="left_cam" width="30px" height="30px" autoplay></video><%--본인캠--%>
        <%--<video id="right_cam" width="100%" height="50%" autoplay></video>--%><%--상대캠--%>
    </div>
    <div id="video-grid">
        <video></video>
        <video></video>
        <video></video>

    </div>
</div>
<button id="btn1" onclick="camStart()">Start</button>
<button id="btn2" onclick="camStop()">Stop</button>
</body>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js"></script>
<script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>
<script type = "text/javascript">

    var output, webSocket;
    var roomid = "${roomid}";
    var roompw = "${roompw}";
    var roomUserNum = "${room.getPlayer()}";
    var size = "${User_number}";
    console.log("size : " + size + ", " + roomUserNum + ", " + roomid);
    var roominfo = "${roominfo}";
    var roominfo2 = "${room}";
    //console.log("room : " + roominfo2);
    //console.log("room2 : " + roominfo);

    var userNickName = "${User_list}";
    var userName = "${username}";
    var messageTextArea = document.getElementById("messageTextArea");
    var create = "${create}";
    var answercount = 0;
    var camCount = 0;

    var isChannelReady = false;
    var isInitiator = false;
    var isStarted = false;
    var localStream;
    var pc;
    //var remoteStream;
    var remoteStream2 = new Array();
    var check = 0;

    //var remoteVideo = document.getElementById('right_cam');
    var localVideo = document.getElementById('left_cam'); //내캠
    let remoteVideo = new Array();
    const videoGrid = document.getElementById('video-grid')
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
    function addVideoStream(video) {
        video.addEventListener('loadedmetadata', () => {
            video.play()
        })
        videoGrid.append(video)
    }


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
        if (isInitiator) {
            maybeStart();
        }
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
        //console.log("maybestart중 isStarted : " + isStarted + ", localstream : " + localStream + ", iscannel : " + isChannelReady);
        //if (!isStarted && typeof localStream !== 'undefined' && isChannelReady) {
        console.log('>>>>>> creating peer connection');
        createPeerConnection();
        pc.addStream(localStream);
        isStarted = true;
        console.log('isInitiator : ' + isInitiator);
        if (isInitiator) {
            doCall();
        }
        //}
    }

    window.onbeforeunload = function () {
        sendMessage('bye');
    };

    /////////////////////////////////////////////////////////

    function createPeerConnection() {
        try {
            pc = new RTCPeerConnection(pcConfig);
            console.log("1")
            pc.onicecandidate = handleIceCandidate;
            console.log("2")
            pc.onaddstream = handleRemoteStreamAdded;
            console.log("3")
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
        //if(answercount == 0) {
        //console.log("answercount : " + answercount);
        sendMessage(sessionDescription);
        //answercount = 1;
        //}
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
        //console.log('Remote stream added. : ' + event + ", event.stream : " + event.stream);
        //remoteStream = event.stream;
        const video = document.createElement('video')
        addVideoStream(video);
        const remoteStream = event.stream;

        remoteStream2[camCount] = event.stream;
        //console.log(event);
        video.srcObject = remoteStream;
        //remoteVideo.srcObject = remoteStream;
        /*for (var j = 0; j < size; j++) {
            remoteVideo[j].srcObject = remoteStream;
        }*/
        //remoteVideo.srcObject = remoteStream;
        /*if (create == "create") {
            remoteVideo[size].srcObject = remoteStream;
        } else {
            for (var j = 0; j < size; j++) {
                remoteVideo[size].srcObject = remoteStream
            }
        }*/
        camCount++;
    }

    function handleRemoteStreamRemoved(event) {
        console.log('Remote stream removed. Event: ', event);
        video.remove();
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
        //pc.close();
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

    function sendMessage(message) {
        /*if(msg != null){
            webSocket.send(JSON.stringify({type : "chat", userNickName : userNickName, roomID : roomid, roomPW : roompw, msg : msg}));
            document.getElementById("msg").value = "";
        }*/
        msg = document.getElementById("msg").value;
        if (msg == "" || msg == " " || msg == null || msg == "{}" || msg == undefined || msg == "undefined") { //메세지가 비어있을때
            if (roomUserNum != null){ //인원수가 있는사람이 보내기
                webSocket.send(JSON.stringify({type : "roomUserNum", roomUserNum : roomUserNum, userNickName : userNickName, roomID : roomid, roomPW : roompw}));
            }
            webSocket.send(JSON.stringify({type : "CHAT", userNickName : userNickName, roomID : roomid, roomPW : roompw}));

            webSocket.send(JSON.stringify(message));
        } else { //메세지가 비어있지 않을때
            if (roomUserNum != null){
                webSocket.send(JSON.stringify({type : "roomUserNum", roomUserNum : roomUserNum, userNickName : userNickName, roomID : roomid, roomPW : roompw}));
            }
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
            //console.log("got user media받음");
            maybeStart();
        } else if (data.type === "offer") {
            //console.log("offer받음");
            if (!isInitiator && !isStarted) {
                maybeStart();
            }
            pc.setRemoteDescription(new RTCSessionDescription(data));
            doAnswer();
        } else if (data.type === "answer" && isStarted) {
            //console.log("answer받음");
            pc.setRemoteDescription(new RTCSessionDescription(data));
        } else if (data.type === "candidate" && isStarted) {
            //console.log("candidate받음");
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
        } else if (data.type === "join") {
            console.log("join")
        }
        if (data.type == "chat") { //채팅전송 받은거 처리
            if (data.roomID == roomid && data.roomPW == roompw) {
                //console.log("data.roomID : " + data.roomID + ", roomid : " + roomid);
                //console.log("data.roomPW : " + data.roomPW + ", roompw : " + roompw);
                if (/*data.msg != null || data.msg != undefined || data.msg != "" || data.msg != '\n' || */data.msg != "undefined") {
                    //console.log("위 : " + data.msg);
                    chatroom.innerHTML = chatroom.innerHTML + "<br>" + data.userName + " : " + data.msg;
                    chatroom.scrollTop = chatroom.scrollHeight;
                } else {
                    //console.log("아래 : " + data.msg);
                }
            }
        }

        if (data.type == "roomUserNum") {
            console.log("roomUserNum들어감");
            if (data.roomID == roomid && data.roomPW == roompw) {
                //console.log("roomUserNum들어가고 아디비번도들어감");
                roomUserNum = data.roomUserNum;
                //console.log("1111111roomUserNum : " + roomUserNum);
                //console.log("222222roomUserNum : " + data.roomUserNum);
                //console.log("333333333 : " + "${room.getPlayer()}");
            }
        }

        if (create == "create"/* && data.userNickName == "[jkl1643@naver.com, jkl4976@naver.com]"*/) {
            //console.log("create == true");
            isInitiator = true;
            isChannelReady = true;
            /*if (check == 0) {
                for (var i = 0; i < size; i++) {
                    check = 1;
                    console.log("for size : " + size);
                    var tmp = "";
                    tmp = tmp + "<video id='right_cam" + i + "' class='right_cam" + i + "' autoplay></video>"
                    $("#camdiv").append(tmp);
                    remoteVideo[i] = document.getElementById('right_cam' + i);
                    video = document.querySelector('video');
                    navigator.mediaDevices.getUserMedia(constraints).then((stream) => {
                        video.srcObject = stream
                    });
                }
                invite();
            }*/
        } else {
            //console.log("create == else");
            isChannelReady = true;
            isInitiator = true;
            /*if (check == 0) {
                for (var i = 0; i < size; i++) {
                    check = 1;
                    console.log("for size : " + size);
                    var tmp = "";
                    tmp = tmp + "<video id='right_cam" + i + "' class='right_cam" + i + "' autoplay></video>"
                    $("#camdiv").append(tmp);
                    remoteVideo[i] = document.getElementById('right_cam' + i);
                    video = document.querySelector('video');
                    navigator.mediaDevices.getUserMedia(constraints).then((stream) => {
                        video.srcObject = stream
                    });
                }
                invite();
            }*/
        }

        /*if (data.type == "join") {
            console.log("join");
            camStart();
            invite();
        }*/

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
        webSocket.send(JSON.stringify({type : "join", userNickName : userNickName, roomID : roomid, roomPW : roompw}));
        $('#userlist').load("refreshuserlist");
        //const video = document.createElement('video')
        //addVideoStream(video);
        console.log("입장")
        /*if (create != null) { //새로운 유저가 접속했을 때 실행, 방장과 아닌사람 둘다 실행되나
            //console.log("캠주고받기");
            //if (data.roomID == roomid && data.roomPW == roompw) { //같은 방에 들어왔을 때 캠생성, 주고받기
            invite();
            //}
            //캠주고받기 시작
        } else {
            invite();
        }*/
        /*for (var i = 0; i < size; i++) {
            var tmp ="";
            tmp = tmp + "<video id='right_cam" + size + "' class='right_cam" + size + "' autoplay></video>"
            $("#camdiv").append(tmp);
            remoteVideo[size] = document.getElementById('right_cam' + size);
            video = document.querySelector('video');
            navigator.mediaDevices.getUserMedia(constraints).
            then((stream) => {video.srcObject = stream});
        }*/

        /*if (check == 0) {
            for (var i = 0; i < size; i++) {
                check = 1;
                console.log("for size : " + size);
                var tmp = "";
                tmp = tmp + "<video id='right_cam" + i + "' class='right_cam" + i + "' autoplay></video>"
                $("#camdiv").append(tmp);
                remoteVideo[i] = document.getElementById('right_cam' + i);
                video = document.querySelector('video');
                navigator.mediaDevices.getUserMedia(constraints).then((stream) => {
                    video.srcObject = stream
                });
            }
            invite();
        }*/

    }

    function onClose(evt) {
        window.location.href='home';
        //webSocket.close();
        $('#userlist').load("refreshuserlist");
    }

    function onError(evt) { }

    function camStart() { //var remoteVideo = document.getElementById('right_cam');
        var tmp ="";
        tmp = tmp + "<video id='right_cam" + size + "' class='right_cam" + size + "' autoplay></video>"
        $("#camdiv").append(tmp);
        remoteVideo[size] = document.getElementById('right_cam' + size);
        video = document.querySelector('video');
        navigator.mediaDevices.getUserMedia(constraints).
        then((stream) => {video.srcObject = stream});
    }

    function camStop() {
        $("camdiv *").remove(".right_cam" + size);
    }
    /*let video = document.querySelector('video');
    navigator.mediaDevices.getUserMedia(constraints).
    then((stream) => {video.srcObject = stream});*/

    window.addEventListener("load", init, false);
</script>
</html>