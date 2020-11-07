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
    //webSocket.send(JSON.stringify(message));
}

function onMessage(evt) {
    var js = evt.data;
    var data = JSON.parse(js);
    chatroom = document.getElementById("messageTextArea");

    if (data === "got user media"/* && create != "create"*/) {
        //console.log("got user media받음");
        maybeStart();
    } else if (data.type === "got user media2") {
        maybeStart2(data.screenStream);
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

    if (create == "create"/* && data.userNickName == "[jkl1643@naver.com, jkl4976@naver.com]"*/) {
        //console.log("create == true");
        isInitiator = true;
        isChannelReady = true;
    } else {
        //console.log("create == else");
        isChannelReady = true;
        isInitiator = true;

        //chatroom.scrollTop = chatroom.scrollHeight;
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
    //const video = document.createElement('video')
    //addVideoStream(video);
    console.log("입장")

}

function onClose(evt) {
    window.location.href = 'home';
    //webSocket.close();
    $('#userlist').load("refreshuserlist");
}

function onError(evt) {
}

window.addEventListener("load", init, false);