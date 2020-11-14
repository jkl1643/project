<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.example.Room" %>
<%@ page import="com.example.SocketHandler" %>
<%@ page import="org.python.antlr.op.In" %>
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

        /*div {
            resize: horizontal;
            overflow: auto;
        }*/

        #middle {
            /*display: grid;
            !*grid-template-columns: repeat(auto-fill, var(--totalNum));
            grid-auto-rows: var(--totalNum);*!
            pointer-events: none;
            grid-template-columns: repeat(auto-fill, 300px);
            grid-auto-rows: 300px;*/
            z-index: 1;
        }
        #video-grid {
            display: grid;
            /*resize: horizontal;
            overflow: auto;*/
            /*grid-template-columns: repeat(auto-fill, 300px);
            grid-auto-rows: 300px;*/

            /*grid-template-rows: repeat(var(--totalNum), 1fr);*/
            grid-template-columns: repeat(var(--totalNum), 1fr);

            z-index: 2;
        }
        #videoClass1 {
            resize: horizontal;
            overflow: auto;
        }

        video {
            /*width: var(--totalNum);
            height: var(--totalNum);*/
            width: 100%;
            height: 100%;
            object-fit: contain;
            /*position: absolute;*/
            /*top: 50%;*/
            z-index: 3;
            border: 2px solid #000000;
        }

        canvas {
            border: 1px solid #525252;
            background-color: white;
            /*width: 300px;
            height: 300px;*/
            position: center;
            display: none;
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
            width: 25%;
            height: 25%;
            list-style: none;
            text-align: center;
            /* display: block; */

            vertical-align: middle;
            pointer-events: auto;
        }

        #menu ul li a {
            display: block;
            width: 90%;
            padding: 17.5px;
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

        #bottom ul li {
            float: left;
            width: 25%;
            height: 25%;
            list-style: none;
            text-align: center;
            vertical-align: middle;
        }

        #bottom ul li a {
            display: block;
            width: 90%;
            padding: 17.5px;
        }

        #bottom ul li a:hover {
            background: #244372;
            color: white;
        }

        #userListMenu {
            position: absolute;
            right: 0px;
            height: 100%;
            width: 500px;
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


    </style>
</head>
<%
    /*Room room = (Room)request.getAttribute("room");*/
    String roomid = (String) request.getAttribute("roomid");
    String roompw = (String) request.getAttribute("roompw");
    System.out.println(session.getAttribute("cap"));
    String create = (String) session.getAttribute("create");
    String username = (String) request.getAttribute("username");
    /*int size = (int)request.getAttribute("User_number");*/
%>
<body <%--onload="startDrawCanvas()"--%><%--bgcolor="black" onload="startDrawCanvas()"--%>>
<%--<script src="${pageContext.request.contextPath}/webSocket.js"></script>--%>
<div id="main" style="position: absolute; width: 100%; height: 100%; background-color: #ffffff;">
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
        <div id="voice" style="color: white">
        </div>
        <div id="messageTextArea"
             style="position:absolute; overflow: auto; bottom: 90px; width:100%; height: 20%; background-color: #ffffff; outline:none; color: black;">
        </div>
        <br>
        <input id="msg" type="text" placeholder="채팅 입력"
               style="position:absolute; bottom:55px; width:100%; height:3.5%; border:none; outline:none; font-size:1.2em;">
        <input type="button" align="right" onclick="sendMessage();"
               style="position:absolute; right: 0px; bottom:55px; width: 100px; height: 3.5%; border:none; background-color: #ffffff;"
               value="보내기">
    </div>
    <div class="menu" id="menu">
        <ul>
            <li>
                <a onclick="screenShare()">화면 공유</a>
            </li>
            <li>
                <a onclick="recordstart()">녹화 시작</a>
            </li>
            <li>
                <a onclick="recordstop()">녹화 종료</a>
            </li>
            <li>
                <a onclick="startDrawCanvas()">화이트보드 열기</a>
            </li>
        </ul>
        <%--<div style="width: 100%; height: 100%">
            <canvas id="myCanvas" style="background-color: aliceblue; width: 100%; height: 100%"></canvas>
        </div>--%>

        <br>
        <%--회의 아이디 : ${roomid} <br>
        회의 비밀번호 : ${roompw}<br>--%>
        <%--<table>
            <tr>
                <userlist id="pguserlist">
                    <div id="userlist">
                    </div>
                </userlist>
            </tr>
        </table>
        <ul class="userlistbox"></ul>--%>
    </div>
    <div id="middle" class="middle" style="height: 100%; width: 100%; background-color: #ffffff">
        <div id="video-grid" class="video-grid" style="width:100%; height:100%; background-color: #ffffff;">
            <video id="left_cam" class="left_cam" autoplay></video>
            <%--<video style="height: 10%; width: 10%;"></video>--%>
            <%--<canvas id="myCanvas" style="background-color: aliceblue; width: 500px; height: 500px"></canvas>--%>
            <%--<canvas id="canvas" width="500" height="500"></canvas>--%>
        </div>
        <%--<div id="userListMenu" class="userListMenu">
            <div style="height: 50%">
                <table>
                    <tr>
                        <userlist id="pguserlist">
                            <div id="userlist">

                            </div>
                        </userlist>
                    </tr>
                </table>
            </div>

            <div id="messageTextArea"
                 style="position:absolute; overflow: auto; bottom: 90px; width:100%; height: 20%; background-color: #ffffff; outline:none; color: black;">
            </div>
            <br>
            <input id="msg" type="text" placeholder="채팅 입력"
                   style="position:absolute; bottom:55px; width:100%; height:3.5%; border:none; outline:none; font-size:1.2em;">
            <input type="button" align="right" onclick="sendMessage();"
                   style="position:absolute; right: 0px; bottom:55px; width: 100px; height: 3.5%; border:none; background-color: #ffffff;"
                   value="보내기">
        </div>--%>
    </div>
    <div id="bottom" class="bottom">
        <ul>
            <li>
                <text>회의 아이디 : ${roomid} <br> 회의 비밀번호 : ${roompw}</text>
            </li>
            <li>
                <%--<input type="button" value="복사하기" onclick="copy()">--%>
                <a onclick="copy()">복사하기</a>
            </li>
            <li>
                <a onclick="userListOpen()">참가자 목록</a>
            </li>
        </ul>

    </div>




    <%--<div id="camdiv" style="width:100%; height:70%; background-color: #000000;">--%>
    <%--<div id="camdiv" style="width:30%; height:30%; background-color: #a85c5c;">
        &lt;%&ndash;본인캠&ndash;%&gt;
        &lt;%&ndash;<video id="right_cam" width="100%" height="50%" autoplay></video>&ndash;%&gt;&lt;%&ndash;상대캠&ndash;%&gt;
    </div>--%>


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

<%--<script src="/RecordRTC.js"></script>--%>
<script type="text/javascript">

    /*if (totalNum != 0) {
        console.log("totalNum11 : " + totalNum);
        left_cam.addEventListener("mouseup",
            function (a) {
                console.log("totalNum22 : " + totalNum);
                videoGrid.style.gridTemplateColumns = "70% 30%";
            });
    } else {
        console.log("totalNum33 : " + totalNum);
    }*/

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
    /*function addVideoStream(video) {
        video.addEventListener('loadedmetadata', () => {
            video.play()
        })
        videoGrid.append(video)
    }

    function addVideo(screenStream) {
        const video = document.createElement('video')
        videoGrid.append(video)
        video.srcObject = screenStream;
    }*/

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


    /*function camStart() { //var remoteVideo = document.getElementById('right_cam');
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
    }*/
    /*var elementToShare = document.getElementById('record-d');
    var recorder = RecordRTC(elementToShare, {
    type: 'canvas'
    });

    document.getElementById('btn3').onclick = function () {
    recorder.startRecording();
    //setTimeout(2000);
    }
    document.getElementById('btn4').onclick = function () {
    recorder.stopRecording(function (url) {
    window.open(url);
    });
    }*/
    /*let video = document.querySelector('video');
    navigator.mediaDevices.getUserMedia(constraints).
    then((stream) => {video.srcObject = stream});*/


</script>
</html>