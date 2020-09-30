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
    <title>Title</title>
</head>
<body>
<%
    Room room = (Room)request.getAttribute("room");
    String roomid = (String)request.getAttribute("roomid");
    String roompw = (String)request.getAttribute("roompw");
%>
회의 아이디 : ${roomid} <BR>
회의 비밀번호 : ${roompw}<BR>
<input id="msg" type="text">
<input type="button" onclick="sendMessage()" value="Send">
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
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js"></script>
<script type = "text/javascript">
    var output, webSocket;
    var roomid = "${roomid}";
    var roompw = "${roompw}";
    var userNickName = "${User_list}";
    var messageTextArea = document.getElementById("messageTextArea");
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
        /*var msg = document.getElementById("msg");
        messageTextArea.value += msg.value + "\n";
        webSocket.send(JSON.stringify({userNickName : userNickName, roomID : roomid, roomPW : roompw, msg : msg.value}));
        msg.value = "";*/
        msg = document.getElementById("msg").value;
        webSocket.send(JSON.stringify({type : "chat", userNickName : userNickName, roomID : roomid, roomPW : roompw, msg : msg}));
        document.getElementById("msg").value = "";
        //window.alert("sendMessage");
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
        //webSocket.send(JSON.stringify({cmd : "start", selecto : userId, roomId : roomId}));
        webSocket.send(JSON.stringify({userNickName : userNickName, roomID : roomid, roomPW : roompw}));
        $('#userlist').load("refreshuserlist");
    }

    function onClose(evt) {
        window.location.href='home';
    }

    function onMessage(evt) {
        //window.alert("onMessage");

        /*var msg = document.getElementById("msg");
        var js = JSON.parse(evt.data);
        window.alert("dd");
        /!*chatroom = document.getElementById("msg");
        chatroom.innerHTML = chatroom.innerHTML + "<br>" + js.message;*!/
        messageTextArea.value += msg.value + "\n";
        chatroom = document.getElementById("messageTextArea");
        chatroom.innerHTML = chatroom.innerHTML + "<br>" + js.message + js.msg;
        chatroom.scrollTop = chatroom.scrollHeight;*/

        /*var data = evt.data;
        window.alert("서버에서 데이터 받음" + data);*/

        var js = evt.data;
        var data = JSON.parse(js);

        if(data.type == "chat")
        if(data.roomID == roomid && data.roomPW == roompw) {
            if (data.msg != null || data.msg != undefined || data.msg != "" || data.msg != '\n' || data.msg != "undefined") {
                chatroom = document.getElementById("messageTextArea");
                chatroom.innerHTML = chatroom.innerHTML + "<br>" + data.msg;
            }
        }

        chatroom.scrollTop = chatroom.scrollHeight;
        //window.alert("js.message : " + js.message + ", js: " + js + ", msg : " + msg + ", msg.value : " + msg.value + ", js.data:" + js.data + ", js.msg :" + js.msg);
        /*messageTextArea.value += msg + "\n";*/

        $('#userlist').load("refreshuserlist");
    }

    function onError(evt) {

    }
    window.addEventListener("load", init, false);
</script>
</html>
