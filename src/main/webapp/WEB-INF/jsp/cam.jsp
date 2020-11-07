<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>
<button id="btn5" onclick="sstart()">new start</button>
<button id="btn6" onclick="sstop()">new start</button>
<script src="https://www.WebRTC-Experiment.com/RecordRTC.js"></script>
<script src="https://www.webrtc-experiment.com/screenshot.js"></script>
<%--<div id="element-to-record" style="width:100%;height:100%;background:green;">
    <input type="text" placeholder="아이디" id="loginqId" name="lqoginId">
</div>--%>
<button onclick="sstart()">Start Recording</button>
<button onclick="sstop()">Stop Recording</button>
<script>
    var recorder = new RecordRTC_Extension();

    function sstart() {
        recorder.startRecording({
            enableScreen: true,
            enableMicrophone: true,
            enableSpeakers: true
        });
    }

    function sstop() {


        recorder.stopRecording(function(blob) {
            console.log(blob.size, blob);
            var url = URL.createObjectURL(blob);

            var doc = document,
                link = doc.createElementNS("http://www.w3.org/1999/xhtml", "a"),
                event = doc.createEvent("MouseEvents");
            link.href = URL.createObjectURL(blob);
            link.download = "file11.webm";

            event.initEvent("click", true, false);
            link.dispatchEvent(event);
        });
    };
</script>
</body>
</html>