<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <title>Title</title>
    <style>

        :root {
            --videoNum : 100%;
            --canvasNum : 100%;
            --totalNum : 0;
        }

        ::-webkit-scrollbar {
            display: none;
        }

        #middle {
            z-index: 1;
            -ms-overflow-style: none;
        }
        #video-grid {
            display: grid;
            grid-template-columns: repeat(var(--totalNum), 1fr);
            z-index: 2;
        }

        video {
            width: 100%;
            height: 100%;
            object-fit: contain;
            z-index: 3;
            border: 2px solid #000000;
        }

        canvas {
            border: 1px solid #525252;
            background-color: white;
            position: center;
        }
        * {
            margin: 0;
            padding: 0;
        }

        #menu {
            float: left;
            position: fixed;
            width: 100%;
            height: 55.5px;
            top: 0px;
            background-color: #2e57c9;
            display: none;
            border-radius: 3px;
            font-size: 16px;
            color: #fff;
            pointer-events: auto;
            z-index: 4;
        }

        #menu ul li {
            float: left;
            width: 24.92%;
            height: 25%;
            list-style: none;
            text-align: center;
            vertical-align: middle;
            pointer-events: auto;
        }

        #menu ul li a {
            display: block;
            width: 100%;
            padding: 17.4px 0px;
            pointer-events: auto;
        }

        #menu ul li a:hover {
            background: #244372;
            color: white;
            pointer-events: auto;
        }

        #bottom {
            float: left;
            position: fixed;
            width: 100%;
            height: 55.5px;
            bottom: 0px;
            background-color: #2e57c9;
            display: none;
            border-radius: 3px;
            font-size: 16px;
            color: #fff;
            pointer-events: auto;
            z-index: 5;
        }

        .liClass{
            float: left;
            width: 15%;
            height: 100%;
            list-style: none;
            text-align: center;
            vertical-align: middle;
        }

        .idClass {
            float: left;
            width: 450px;
            height: 100%;
            list-style: none;
            text-align: center;
            vertical-align: middle;
        }

        #bottom ul li a {
            display: block;
            width: 100%;
            padding: 17.4px 0px;
            pointer-events: auto;
        }

        #bottom ul li a:hover {
            background: #244372;
            color: white;
        }

        #userListMenu {
            position: absolute;
            right: 0px;
            height: 100%;
            width: 400px;
            background-color: #001836;
            display: none;
            color: #fff;
            border-radius: 3px;
            font-size: 16px;
            z-index: 6;
            border: 2px solid dimgray;
        }

        #userListMenu table {
            color: #fff;
            font-size: 16px;
            width: 100%;
            border: 1px solid dimgray;
        }

        #myCanvas {
            display: none;
        }

        #blank {
            float: left;
            width: 1%;
            height: 25%;
            list-style: none;
            text-align: center;
            /* display: block; */

            vertical-align: middle;
        }

        #menu ul ol {
            float: left;
            width: 1px;
            height: 100%;
            list-style: none;
            text-align: center;
            /* display: block; */
            background: black;
            vertical-align: middle;
            /*padding: 17.4px 0px;*/
            border: 0px solid black;
        }

        #bottom ul ol {
            float: left;
            width: 1px;
            height: 100%;
            list-style: none;
            text-align: center;
            background: black;
            vertical-align: middle;
            border: 0px solid black;
        }

    </style>
</head>
<%
    System.out.println(session.getAttribute("cap"));
%>
<body>
<div id="main" style="position: absolute; width: 100%; height: 100%; background-color: #ffffff; -ms-overflow-style: none;">
    <div id="userListMenu" class="userListMenu">
        <div style="height: 25%">
            <table>
                <tr>
                    <userlist id="pguserlist">
                        <div id="userlist">
                        </div>
                    </userlist>
                </tr>
            </table>
        </div>
        <div style="position:absolute;text-align: center; width: 100%; height: 50px; bottom: 46.7%; border: 1px solid white; line-height: 50px;">
            음성 기록
        </div>
        <div id="voice" style="position:absolute; color: #000000; background: white; width: 100%; height: 20%; border: 1px solid black; bottom: 26.3%; overflow: auto;">
        </div>
        <div style="position:absolute;text-align: center; width: 100%; height: 50px; bottom: 20.5%; border: 1px solid white; line-height: 50px;">
            채팅창
        </div>
        <div id="messageTextArea" style="position:absolute; overflow: auto; bottom: 0px; width:100%; height: 20%; background-color: #ffffff; outline:none; color: black; border: 1px solid black;">
        </div>
        <br>
        <input id="msg" type="text" placeholder="채팅 입력"
               style="position:absolute; bottom:0px; width:100%; height:3.5%; border:1px solid black; outline:none; font-size:1.2em;">
        <input type="button" align="right" onclick="sendMessage();"
               style="position:absolute; right: 0px; bottom:0px; width: 100px; height: 3.5%; border: 1px solid black; background-color: #ffffff;"
               value="보내기">
    </div>
    <div class="menu" id="menu">
        <ul>
            <li>
                <a onclick="screenShare()">화면 공유</a>
            </li>
            <ol class="blank">
                <a></a>
            </ol>
            <li>
                <a onclick="recordstart()">녹화 시작</a>
            </li>
            <ol class="blank">
                <a></a>
            </ol>
            <li>
                <a onclick="recordstop()">녹화 종료</a>
            </li>
            <ol class="blank">
                <a></a>
            </ol>
        </ul>
        <br>
    </div>
    <div id="middle" class="middle" style="height: 100%; width: 100%; background-color: #ffffff">
        <div id="video-grid" class="video-grid" style="width:100%; height:100%; background-color: #ffffff;">
            <video id="left_cam" class="left_cam" autoplay></video>
        </div>

    </div>
    <div id="bottom" class="bottom">
        <ul>
            <li class="liClass">
                <a onclick="userListOpen()">참가자 목록</a>
            </li>
            <ol class="blank">
                <a></a>
            </ol>
            <li class="idClass">
                <div style="width: 100%; height: 100%; line-height: 27px; text-align: left">
                    &emsp; 회의 아이디 : ${roomid} <br>
                    &emsp; 회의 비밀번호 : ${roompw}
                </div>
            </li>
            <ol class="blank">
                <a></a>
            </ol>
            <li class="liClass">
                <a onclick="copy()">복사하기</a>
            </li>
        </ul>
    </div>


</div>
<input type="button" value="복사하기" onclick="copy()"><br>
<div style="display:block">
    <pre>
<textarea id="idPw">
회의 아이디 : ${roomid}
회의 비밀번호 : ${roompw}</textarea>
    </pre>
    <br>
</div>
</body>
<script src="https://www.webrtc-experiment.com/RecordRTC/Whammy.js"></script>
<script src="https://www.webrtc-experiment.com/RecordRTC/CanvasRecorder.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js"></script>
<script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>
<script src="https://www.WebRTC-Experiment.com/RecordRTC.js"></script>
<script src="https://www.webrtc-experiment.com/screenshot.js"></script>
<script src="${pageContext.request.contextPath}/cam.js"></script>
<script src="${pageContext.request.contextPath}/webSocket.js"></script>
<script src="${pageContext.request.contextPath}/screenShare.js"></script>
<script src="${pageContext.request.contextPath}/record.js"></script>
<script src="${pageContext.request.contextPath}/menu.js"></script>
<script src="${pageContext.request.contextPath}/idPwCopy.js"></script>
<script src="${pageContext.request.contextPath}/draw.js"></script>
<script src="${pageContext.request.contextPath}/voice.js"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.0/themes/base/jquery-ui.css" />
<script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
<script type="text/javascript">
    var canvasNum = $("canvas").length;
    var output, webSocket;
    var roomid = "${roomid}";
    var roompw = "${roompw}";
    var roomUserNum = "${room.getPlayer()}";
    var size = "${User_number}";
    console.log("size : " + size + ", " + roomUserNum + ", " + roomid);
    var roominfo = "${roominfo}";
    var roominfo2 = "${room}";
    var idPw = "회의 아이디 : " + "${roomid}" + "회의 비밀번호 : " + "${roompw}";

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
    var remoteStream2 = new Array();
    var check = 0;

    var localVideo = document.getElementById('left_cam'); //내캠
    var localVideo2 = document.getElementById('left_cam2');
    let remoteVideo = new Array();
    const videoGrid = document.getElementById('video-grid')
    var pcConfig = {
        'iceServers': [{
            urls: 'stun:stun.l.google.com:19302'
        },
            {
                urls: "turn:numb.viagenie.ca",
                credential: "muazkh",
                username: "webrtc@live.com"
            }
        ]
    };

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
</script>
</html>