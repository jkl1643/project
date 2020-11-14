/*
var canvas, context;

function startDrawCanvas() {
    canvas = document.getElementById("myCanvas");
    context = canvas.getContext("2d");

    context.lineWidth = 2; // 선 굵기를 2로 설정
    context.strokeStyle = "blue";

    // 마우스 리스너 등록. e는 MouseEvent 객체
    canvas.addEventListener("mousemove", function (e) {
        move(e)
    }, false);
    canvas.addEventListener("mousedown", function (e) {
        down(e)
    }, false);
    canvas.addEventListener("mouseup", function (e) {
        up(e)
    }, false);
    canvas.addEventListener("mouseout", function (e) {
        out(e)
    }, false);
}

var startX = 0, startY = 0; // 드래깅동안, 처음 마우스가 눌러진 좌표
var drawing = false;

function draw(curX, curY) {
    context.beginPath();
    context.moveTo(startX, startY);
    context.lineTo(curX, curY);
    context.stroke();
}

function down(e) {
    startX = e.offsetX;
    startY = e.offsetY;
    drawing = true;
}

function up(e) {
    drawing = false;
}

function move(e) {
    if (!drawing) {
        return; // 마우스가 눌러지지 않았으면 리턴
    }
    var curX = e.offsetX
    var curY = e.offsetY;

    draw(curX, curY);

    startX = curX;
    startY = curY;
}

function out(e) {
    drawing = false;
}
*/

var pos = {
    drawable: false,
    x: -1,
    y: -1
};
var canvas, ctx;
let drawCanvasCheck = 0;
function maybeStart3(drawStream) {
    console.log('>>>>>>> maybeStart2() ');
    //console.log("maybestart중 isStarted : " + isStarted + ", localstream : " + localStream + ", iscannel : " + isChannelReady);
    //if (!isStarted && isChannelReady) {
    console.log('>>>>>> creating peer connection2');
    createPeerConnection();
    pc.addStream(drawStream);
    isStarted = true;
    console.log('isInitiator : ' + isInitiator);
    if (isInitiator) {
        doCall();
    }
    //}
}

function canvasShare() {
    /*var video = document.createElement('video');
    var canvasElt = document.createElement('canvas');
    var drawStream = canvasElt.captureStream();
    canvasElt.style.display = "inline";
    console.log("drawstream" + drawStream);

    navigator.mediaDevices.getUserMedia({
        audio: false,
        video: true
    }).then (function (drawStream) {
        console.log("dasf")
        //screenStream.addTrack(audioStream.getAudioTracks());
        //addVideo(screenStream)
        addVideoStream(video);
        video.srcObject = drawStream;

        console.log('Adding local screenStream. -- 1');
        //sendMessage('');
        webSocket.send(JSON.stringify({type: "got user media3", drawStream: drawStream}));
        if (isInitiator) {
            maybeStart3(drawStream);
        }
        console.log("22")
    });*/
    var canvasElt = document.createElement('canvas');
    canvasElt.style.display="inline";
    addVideoStream(canvasElt);
    startDrawCanvas()
}

function startDrawCanvas() {




    //---------------------------------------
    drawCanvasCheck = 1;
    canvas = document.getElementById("canvas");
    canvas.style.display="inline";
    ctx = canvas.getContext("2d");

    canvas.addEventListener("mousedown", listener);
    canvas.addEventListener("mousemove", listener);
    canvas.addEventListener("mouseup", listener);
    canvas.addEventListener("mouseout", listener);


    if (drawCanvasCheck === 1) {
        var canvasNum = 1;
    } else if (drawCanvasCheck === 0) {
        var canvasNum = 0;
    }

    /*console.log("비디오개수 : " + videoNum + "캔버스 개수 : " + canvasNum + "합 : " + (videoNum + canvasNum));
    totalNum = 100 / (videoNum + canvasNum);
    console.log("totalNum : " + totalNum);
    document.documentElement.style.setProperty('--videoNum', videoNum + '%');
    document.documentElement.style.setProperty('--canvasNum', canvasNum);
    document.documentElement.style.setProperty('--totalNum', totalNum + "%");
    console.log("totalNum2 : " + totalNum);*/
    //---------------------------------------

    /*var video = document.createElement('video');
    var canvasElt = document.querySelector('canvas');
    var drawStream = canvasElt.captureStream(25);
    console.log("drawstream" + drawStream);

    //addVideo(screenStream)
    addVideoStream(video);
    video.srcObject = drawStream;*/





}

function listener(event){
    switch(event.type){
        case "mousedown":

            initDraw(event);
            break;

        case "mousemove":
            if(pos.drawable)
                draw(event);
            break;

        case "mouseout":
        case "mouseup":
            finishDraw();
            break;
    }
}
function initDraw(event){
    ctx.beginPath();
    pos.drawable = true;
    var coors = getPosition(event);
    pos.X = coors.X;
    pos.Y = coors.Y;
    ctx.moveTo(pos.X, pos.Y);
}

function draw(event){
    var coors = getPosition(event);
    ctx.lineTo(coors.X, coors.Y);
    pos.X = coors.X;
    pos.Y = coors.Y;
    ctx.stroke();
}

function finishDraw(){
    pos.drawable = false;
    pos.X = -1;
    pos.Y = -1;
}

function getPosition(event){
    var x = event.pageX - canvas.offsetLeft;
    var y = event.pageY - canvas.offsetTop;
    return {X: x, Y: y};
}