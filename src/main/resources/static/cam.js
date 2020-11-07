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
    const video = document.createElement('video')
    addVideoStream(video);
    const remoteStream = event.stream;
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
    pc.close();
    pc = null;
}