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

<h1>Realtime communication with WebRTC</h1>
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


<input type="button" onclick="createoffer()" value="초대">

</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js"></script>
<script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>
<script type = "text/javascript">
    var output, webSocket;
    var roomid = "${roomid}";
    var roompw = "${roompw}";
    var userNickName = "${User_list}";

   /* var peerConnection = new RTCPeerConnection(configuration, {
        optional : [ {
            RtpDataChannels : true
        } ]
    });

    var configuration = {
        "iceServers" : [ {
            "url" : "stun:stun2.1.google.com:19302"
        } ]
    };

    var dataChannel = peerConnection.createDataChannel("dataChannel", { reliable: true });

    dataChannel.onerror = function(error) {
        console.log("Error:", error);
    };
    dataChannel.onclose = function() {
        console.log("Data channel is closed");
    };

    function createoffer() {
        peerConnection.createOffer(function (offer) {
            sendMessage({
                event: "offer",
                data: offer
            });
            peerConnection.setLocalDescription(offer);
        }, function (error) {
            // Handle error here
        });
    }

    function candidate() {
        peerConnection.onicecandidate = function (event) {
            if (event.candidate) {
                sendMessage({
                    event: "candidate",
                    data: event.candidate
                });
            }
        };
    }

    peerConnection.addIceCandidate(new RTCIceCandidate(candidate));


    peerConnection.setRemoteDescription(new RTCSessionDescription(offer));
    peerConnection.createAnswer(function(answer) {
        peerConnection.setLocalDescription(answer);
        send({
            event : "answer",
            data : answer
        });
    }, function(error) {
        // Handle error here
    });

    function handleAnswer(answer){
        peerConnection.setRemoteDescription(new RTCSessionDescription(answer));
    }
*/
    //------------------------------------------------

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
        msg = document.getElementById("msg").value;
        if(msg != null) {
            webSocket.send(JSON.stringify({type : "chat", userNickName : userNickName, roomID : roomid, roomPW : roompw, msg : msg}));
            document.getElementById("msg").value = "";
        } else {
            webSocket.send(JSON.stringify(message));
        }
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
        if (data.type == "chat") {
            if (data.roomID == roomid && data.roomPW == roompw) {
                if (data.msg != null || data.msg != undefined || data.msg != "" || data.msg != '\n' || data.msg != "undefined") {
                    chatroom.innerHTML = chatroom.innerHTML + "<br>" + data.msg;
                }
            }
        }
        if (data.event === "offer"/* && create != "create"*/) {
            candidate();
        } else if (data.event === "candidate") {
            handleAnswer(data);
        } else if (data.event === "answer") {
            handleAnswer(data);
        }



        chatroom.scrollTop = chatroom.scrollHeight;
        //$('#userlist').load("refreshuserlist");
    }

    function onError(evt) {

    }


    window.addEventListener("load", init, false);


</script>
</html>
