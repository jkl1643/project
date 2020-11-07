var recorder = new RecordRTC_Extension();

function recordstart() {
    recorder.startRecording({
        enableScreen: true,
        enableMicrophone: true, //캠에 소리추가되면 됨
        enableSpeakers: true
    });
}

function recordstop() {
    recorder.stopRecording(function (blob) {
        console.log(blob.size, blob);

        var doc = document,
            link = doc.createElementNS("http://www.w3.org/1999/xhtml", "a"),
            event = doc.createEvent("MouseEvents");
        link.href = URL.createObjectURL(blob);
        link.download = "file.webm";

        event.initEvent("click", true, false);
        link.dispatchEvent(event);
    });
};