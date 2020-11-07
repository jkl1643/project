function screenShare() {
    navigator.mediaDevices.getUserMedia({
        audio: false,
        video: true
    }).then(function (audioStream) {
        navigator.mediaDevices.getDisplayMedia({
            audio: true,
            video: true
        }).then(function (screenStream) {
            console.log("dasf")
            //screenStream.addTrack(audioStream.getAudioTracks());
            const video = document.createElement('video')
            addVideo(screenStream)
            addVideoStream(video);
            video.srcObject = screenStream;

            console.log('Adding local screenStream. -- 1');
            //sendMessage('');
            webSocket.send(JSON.stringify({type: "got user media2", screenStream: screenStream}));
            if (isInitiator) {
                maybeStart2(screenStream);
            }
            console.log("22")
        })
    })
}

function maybeStart2(screenStream) {
    console.log('>>>>>>> maybeStart2() ');
    //console.log("maybestart중 isStarted : " + isStarted + ", localstream : " + localStream + ", iscannel : " + isChannelReady);
    //if (!isStarted && isChannelReady) {
    console.log('>>>>>> creating peer connection2');
    createPeerConnection();
    pc.addStream(screenStream);
    isStarted = true;
    console.log('isInitiator : ' + isInitiator);
    if (isInitiator) {
        doCall();
    }
    //}
}