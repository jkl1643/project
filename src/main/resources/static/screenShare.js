function screenShare() {
    navigator.mediaDevices.getUserMedia({
        audio: true,
        video: true
    }).then(function (audioStream) {
        navigator.mediaDevices.getDisplayMedia({
            audio: true,
            video: true
        }).then(function (screenStream) {
            const video = document.createElement('video')
            addVideoStream(video);
            video.srcObject = screenStream;
            console.log("screesstream : " + screenStream);
            console.log('Adding local screenStream. -- 1');
            //sendMessage('');
            webSocket.send(JSON.stringify({type: "got user media2", screenStream: screenStream}));
            if (isInitiator) {
                maybeStart2(screenStream);
            }
        })
    })
}

function maybeStart2(screenStream) {
    console.log('>>>>>>> maybeStart2() ');
    console.log('>>>>>> creating peer connection2');
    createPeerConnection();
    pc.addStream(screenStream);
    isStarted = true;
    console.log('isInitiator : ' + isInitiator);
    if (isInitiator) {
        doCall();
    }
}

function addVideo(screenStream) {
    const video = document.createElement('video')
    videoGrid.append(video)
    video.srcObject = screenStream;
}