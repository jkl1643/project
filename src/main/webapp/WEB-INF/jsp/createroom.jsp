<%--
  Created by IntelliJ IDEA.
  User: Yu
  Date: 2020-09-24
  Time: 오후 9:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%String roomId = (String)request.getAttribute("roomId");
    String roomPw = (String)request.getAttribute("roomPw");%>
회의 아이디 : ${roomId} <BR>
회의 비밀번호 : ${roomPw}
<div id = "output"></div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js"></script>
<script type = "text/javascript">
    var output, webSocket;
    var roomId = "${roomId}";
    function sendMessage() {

    }

    function init() {
        //output = document.getElementById("output");
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
        webSocket.send(JSON.stringify({roomId : roomId, }));
        window.alert("aa");


    }

    function onClose(evt) {
        window.location.href='home';
    }

    function onMessage(evt) {

    }

    function onError(evt) {

    }
    window.addEventListener("load", init, false);
</script>
</html>
