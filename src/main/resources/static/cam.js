function addVideoStream(video) {
    /*$( document ).ready(function() {
        console.log("fffffffff")
        $('.video-grid').append('<div id="videoClass" class="videoClass"></div>');
        console.log("fffffffff")
    });
    var videoClass = document.getElementById('videoClass')*/
    video.addEventListener('loadedmetadata', () => {
        video.play()
    })
    /*$(document).ready(function () {
        $('.videoClass').resizable();
        $('video').resizable();
        /!*selectVideo[1].addEventListener("mouseup",
            function(b) {
                console.log("aaaaaaaaa");
            });*!/
    });*/
    videoGrid.append(video)
    video.setAttribute("class", "videoClass" + videoCount);
    videoCount = videoCount + 1;
    var videoClass = video.getAttribute("class");
    video.addEventListener("mouseup",
        function(a){
            console.log("selectVideo_status : " + selectVideo_status + " totalnum : " + totalNum);
            if (selectVideo_status == 0) {
                if (totalNum == 2) {
                    selectVideo_status = 1;
                    console.log("totalNum22 : " + totalNum);
                    videoGrid.style.gridTemplateColumns = "20% 80%";
                } else if (totalNum == 3) {
                    selectVideo_status = 1;
                    if (videoClass == "videoClass1") {
                        videoGrid.style.gridTemplateColumns = "15% 70% 15%";
                    } else if (videoClass == "videoClass2") {
                        videoGrid.style.gridTemplateColumns = "15% 15% 70%";
                    }
                } else if (totalNum == 4) {
                    selectVideo_status = 1;
                    if (videoClass == "videoClass1") {
                        videoGrid.style.gridTemplateColumns = "10% 60% 10% 10%";
                    } else if (videoClass == "videoClass2") {
                        videoGrid.style.gridTemplateColumns = "10% 10% 60% 10%";
                    } else if (videoClass == "videoClass3") {
                        videoGrid.style.gridTemplateColumns = "10% 10% 10% 60%";
                    }
                }
            } else if (selectVideo_status == 1) {
                if (totalNum == 2) {
                    selectVideo_status = 0;
                    videoGrid.style.gridTemplateColumns = "50% 50%";
                } else if (totalNum == 3) {
                    selectVideo_status = 0;
                    videoGrid.style.gridTemplateColumns = "33% 33% 33%";
                } else if (totalNum == 4) {
                    selectVideo_status = 0;
                    console.log("aaaa");
                    videoGrid.style.gridTemplateColumns = "25% 25% 25% 25%";
                }
            }
        });
    var videoNum = $("video").length;
    //var totalNum = 0;
    console.log("비디오개수 : " + videoNum + "캔버스 개수 : " + canvasNum + "합 : " + (videoNum + canvasNum));
    totalNum = videoNum + canvasNum;
    console.log("totalNum : " + totalNum);
    document.documentElement.style.setProperty('--videoNum', videoNum);
    document.documentElement.style.setProperty('--canvasNum', canvasNum);
    document.documentElement.style.setProperty('--totalNum', totalNum);
    console.log("totalNum2 : " + totalNum);
    selectVideo_exist = 1;
    console.log("selectVideo_existㅂㅂ : " + selectVideo_exist);

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
    console.log('Adding local stream. -- 11');
    localStream = stream;
    localVideo.srcObject = stream;
    console.log("2");
    //localVideo2.srcObject = stream;
    sendMessage('got user media');
    console.log("3");
    if (isInitiator) {
        console.log("4");
        maybeStart();
    }
    console.log("5");
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
    console.log("remotestream")
    //console.log('Remote stream added. : ' + event + ", event.stream : " + event.stream);
    //remoteStream = event.stream;
    var video = document.createElement('video')
    addVideoStream(video);
    var remoteStream = event.stream;
    //remoteStream2[camCount] = event.stream;
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
    console.log("remotestream2")
    camCount++;
}

function handleRemoteStreamRemoved(event) {
    console.log('Remote stream removed. Event: ', event);
    var video = document.getElementById("video");
    /*video.remove();*/
    /*$('video').remove();*/
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
    var video = document.getElementById("video");
    /*video.remove();*/
    $('video:last').remove();
    var videoNum = $("video").length;
    if (drawCanvasCheck === 1) {
        var canvasNum = 1;
    } else if (drawCanvasCheck === 0) {
        var canvasNum = 0;
    }
    videoCount = videoCount - 1;
    console.log("비디오개수 : " + videoNum + "캔버스 개수 : " + canvasNum + "합 : " + (videoNum + canvasNum));
    totalNum = videoNum + canvasNum;
    console.log("totalNum : " + totalNum);
    document.documentElement.style.setProperty('--videoNum', videoNum);
    document.documentElement.style.setProperty('--canvasNum', canvasNum);
    document.documentElement.style.setProperty('--totalNum', totalNum);
    console.log("totalNum2 : " + totalNum);
    pc.close();

    pc = null;
}