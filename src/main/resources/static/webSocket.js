function sendMessage(message) {
    msg = document.getElementById("msg").value;
    if (msg == "" || msg == " " || msg == null || msg == "{}" || msg == undefined || msg == "undefined") { //메세지가 비어있을때
        if (roomUserNum != null) { //인원수가 있는사람이 보내기
            webSocket.send(JSON.stringify({
                type: "roomUserNum",
                roomUserNum: roomUserNum,
                userNickName: userNickName,
                roomID: roomid,
                roomPW: roompw
            }));
        }
        webSocket.send(JSON.stringify({type: "CHAT", userNickName: userNickName, roomID: roomid, roomPW: roompw}));

        webSocket.send(JSON.stringify(message));
    } else { //메세지가 비어있지 않을때
        if (roomUserNum != null) {
            webSocket.send(JSON.stringify({
                type: "roomUserNum",
                roomUserNum: roomUserNum,
                userNickName: userNickName,
                roomID: roomid,
                roomPW: roompw
            }));
        }
        webSocket.send(JSON.stringify({
            type: "chat",
            userNickName: userNickName,
            roomID: roomid,
            roomPW: roompw,
            msg: msg,
            userName: userName
        }));
        document.getElementById("msg").value = "";
    }
}

function onMessage(evt) {
    var js = evt.data;
    var data = JSON.parse(js);
    chatroom = document.getElementById("messageTextArea");


    var videoNum = $("video").length;
    if (drawCanvasCheck === 1) {
        var canvasNum = 1;
    } else if (drawCanvasCheck === 0) {
        var canvasNum = 0;
    }

    if (data === "got user media") {
        maybeStart();
    } else if (data.type === "got user media2") {
        console.log("screesstream : " + data.screenStream);
        maybeStart2(data.screenStream);
    } else if (data.type === "got user media3") {
        console.log("data.drawstream : " + data.drawStream);
        maybeStart3();
    } else if (data.type === "offer") {
        if (!isInitiator && !isStarted) {
            maybeStart();
        }
        pc.setRemoteDescription(new RTCSessionDescription(data));
        doAnswer();
    } else if (data.type === "answer" && isStarted) {
        pc.setRemoteDescription(new RTCSessionDescription(data));
    } else if (data.type === "candidate" && isStarted) {
        console.log("candidate받음 : " + data.value);
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
    } else if (data === "end") {
        console.log("end받음")
    } else if (data.type === "voice") {
        document.getElementById("voice").innerHTML = data.voiceText;
    }
    if (data.type == "chat") { //채팅전송 받은거 처리
        if (data.roomID == roomid && data.roomPW == roompw) {
            if (data.msg != "undefined") {
                chatroom.innerHTML = chatroom.innerHTML + "<br>" + data.userName + " : " + data.msg;
                chatroom.scrollTop = chatroom.scrollHeight;
            } else {
                //console.log("아래 : " + data.msg);
            }
        }
    }
    chatroom.scrollTop = chatroom.scrollHeight;
    voice.scrollTop = voice.scrollHeight;
    if (create == "create") {
        isInitiator = true;
        isChannelReady = true;
        $('#userlist').load("refreshuserlist");
    } else {
        isChannelReady = true;
        isInitiator = true;
        $('#userlist').load("refreshuserlist");
    }
}

function init() {
    testWebSocket();
}

function testWebSocket() {
    webSocket = new WebSocket("ws://" + location.host + "/game");
    webSocket.onopen = function (evt) {
        onOpen(evt);
    };
    webSocket.onclose = function (evt) {
        onClose(evt);
    };
    webSocket.onmessage = function (evt) {
        onMessage(evt);
    };
    webSocket.onerror = function (evt) {
        onError(evt);
    };
}

function onOpen(evt) {
    webSocket.send(JSON.stringify({type: "join", userNickName: userNickName, roomID: roomid, roomPW: roompw}));
    $('#userlist').load("refreshuserlist");
    console.log("입장")

    var videoNum = $("video").length;
    if (drawCanvasCheck === 1) {
        var canvasNum = 1;
    } else if (drawCanvasCheck === 0) {
        var canvasNum = 0;
    }

    console.log("비디오개수 : " + videoNum + "캔버스 개수 : " + canvasNum + "합 : " + (videoNum + canvasNum));
    totalNum = videoNum + canvasNum;
    console.log("totalNum : " + totalNum);
    document.documentElement.style.setProperty('--videoNum', videoNum);
    document.documentElement.style.setProperty('--canvasNum', canvasNum);
    document.documentElement.style.setProperty('--totalNum', totalNum);
    console.log("totalNum2 : " + totalNum);
}

function onClose(evt) {
    window.location.href = 'home';
    $('#userlist').load("refreshuserlist");
}

function onError(evt) {
}

window.addEventListener("load", init, false);