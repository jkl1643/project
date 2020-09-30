<%--
  Created by IntelliJ IDEA.
  User: Yu
  Date: 2020-09-30
  Time: 오후 5:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <script src="http://code.jquery.com/jquery-latest.js"></script>

    <title>Title</title>
</head>
<body>

<script type="text/javascript">
    /*function hasGetUserMedia() {
        return !!(navigator.mediaDevices &&
            navigator.mediaDevices.getUserMedia);
    }

    if (hasGetUserMedia()) {
        // Good to go!
    } else {
        alert('getUserMedia() is not supported by your browser');
    }*/
</script>
<div id="camdiv">
    <video autoplay></video>
</div>
<br>
<button id="btn1" onclick="start()">Start</button>
<button id="btn2" onclick="stop()">Stop</button>
<script type = "text/javascript">
    var cam = document.getElementById("cam");

    function start() {
        var tmp ="";
        tmp = tmp + "<video autoplay></video>"
        $("#camdiv").append(tmp);
        video = document.querySelector('video');

        navigator.mediaDevices.getUserMedia(constraints).
        then((stream) => {video.srcObject = stream});
        /*constraints = {
            video: true
        };
        let video = document.querySelector('video');

        navigator.mediaDevices.getUserMedia(constraints).
        then((stream) => {video.srcObject = stream});*/
    }

    function stop(){
        $("#camdiv *").remove();

    }

    let constraints = {
        video: true
    };
    let video = document.querySelector('video');

    navigator.mediaDevices.getUserMedia(constraints).
    then((stream) => {video.srcObject = stream});
</script>
</body>
</html>

