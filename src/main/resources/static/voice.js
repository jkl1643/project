window.SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

// 인스턴스 생성
const recognition = new SpeechRecognition();

// true면 음절을 연속적으로 인식하나 false면 한 음절만 기록함
recognition.interimResults = true;
recognition.lang = "ko-KR";
recognition.continuous = true;

// maxAlternatives가 크면 이상한 단어도 문장에 적합하게 알아서 수정합니다.
recognition.maxAlternatives = 100;

var voice = document.getElementById('voice');
let speechToText = "";
recognition.addEventListener("result", (e) => {
    let today = new Date();
    let year = today.getFullYear();
    let month = today.getMonth() + 1;
    let date = today.getDate();
    let hours = today.getHours();
    let minutes = today.getMinutes();
    let seconds = today.getSeconds();
    var time = '[' + year + '/' + month + '/' + date + ' '+ hours + ':' + minutes + ':' + seconds + ']';
    let interimTranscript = "";
    for (let i = e.resultIndex, len = e.results.length; i < len; i++) {
        let transcript = e.results[i][0].transcript;
        console.log(transcript);
        if (e.results[i].isFinal) {
            speechToText += transcript;
        } else {
            interimTranscript += transcript;
        }
    }
    if (speechToText != "")
        voice.innerHTML = voice.innerHTML + "<br>" + (time + ' : ' + speechToText);
    speechToText = "";
    voice.scrollTop = voice.scrollHeight;
    webSocket.send(JSON.stringify({type:"voice", voiceText: (voice.innerHTML + "<br>" + (speechToText + ' ' + time))}))
    });


// 음성인식이 끝나면 자동으로 재시작
recognition.addEventListener("end", recognition.start);

recognition.start();