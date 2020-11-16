<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="EUC-KR">
    <title></title>
</head>

<style>
    *{
        margin: 0;
        padding: 0;
    }
    .buttons1 {
        display: grid;
        grid-template-columns: 200px 10px 200px;
        width: 100%;
        height: 100%;
        padding: 100px;
        justify-content: center;
        align-content: space-evenly;
        margin: 0px 0 0 -120px;
        border: 1px solid black;
        top: 0px;
    }
    .buttons2 {
        display: grid;
        grid-template-columns: 200px 10px 200px 10px 200px;
        width: 100%;
        height: 100%;
        padding: 100px;
        justify-content: center;
        align-content: space-evenly;
        margin: 170px 0 0 -120px;
    }

    .modal {
        display: none;
        position: fixed;
        z-index: 1;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgb(0,0,0);
        background-color: rgba(0,0,0,0.4);
    }

    .modal-content {
        background-color: #fefefe;
        margin: 15% auto;
        padding: 20px;
        border: 1px solid #000000;
        width: 500px;
        height: 180px;
    }

    .close {
        color: #aaa;
        float: right;
        font-size: 28px;
        font-weight: bold;
    }
    .close:hover,
    .close:focus {
        color: black;
        text-decoration: none;
        cursor: pointer;
    }
    .buttonclass{
        box-shadow:inset 0px 34px 0px -15px #3263d5;
        background-color: #3045cd;
        border:1px solid #241d13;
        display:inline-block;
        cursor:pointer;
        color:#ffffff;
        font-family:Arial;
        font-size:27px;
        font-weight:bold;
        padding:9px 23px;
        text-decoration:none;
        text-shadow:0px -1px 0px #121e50;
        width: 200px;
        height: 80px;
    }
    .buttonclass:hover {
        background-color: #17176c;
    }
    .buttonclass:active {
        position:relative;
        top:1px;
    }


</style>

<body>
<div style="font-size: 50pt; text-align: center; left: 50%; margin: 0px 0 0 -180px; position: absolute">
    웹 화상채팅
</div>
<div id="buttons1" class="buttons1">
    <button type="button" OnClick="location.href ='createroom'" class="buttonclass">회의 방 생성</button>
    <button style="width: 50px; height: 100px; border: none; background: white"></button>
    <button id="myBtn" class="buttonclass">회의 방 입장</button>

</div>
<div style="font-size: 50pt; text-align: center; top: 300px; left: 50%; margin: 160px 0 0 -180px; position: absolute">
    사용자 메뉴
</div>
<div class="buttons2">
    <form action="logout" method="post">
        <button type="button" OnClick="location.href ='logout'" id="but5" class="buttonclass">로그아웃</button>
    </form>
    <button style="width: 50px; height: 100px; border: none; background: white"></button>
    <form action="editaccount" method="post">
        <Input Type="Submit" Value="정보수정" class="buttonclass">
    </form>
    <button style="width: 50px; height: 100px; border: none; background: white"></button>
    <form action="delaccount" method="post">
        <Input Type="Submit" Value="계정삭제" class="buttonclass">
    </form>
</div>

<form action="joinroom" method="post">
    <div id="myModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <br>
            <div class="inp_text">
                <p>
                    <label for="roomId" class="screen_out" style="size: 20px">방 번호</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="text" placeholder="방 번호" id="roomId" name="roomId" style="height: 20px; width: 300px">
                </p>
            </div>
            <br>
            <div class="inp_text">
                <label for="roomPw" class="screen_out">방 비밀번호</label>
                <input type="password" placeholder="방 비밀번호" id="roomPw" name="roomPw" style="height: 20px; width: 300px">
            </div>
            <br>
            <button type="submit" style="box-shadow:inset 0px 34px 0px -15px #3263d5;
    background-color: #3045cd;
    border:1px solid #241d13;
    display:inline-block;
    cursor:pointer;
    color:#ffffff;
    font-family:Arial;
    font-size:14px;
    font-weight:bold;
    text-decoration:none;
    text-shadow:0px -1px 0px #121e50;
    width: 120px;
    height: 30px;">회의 방 입장</button>
        </div>
    </div>
</form>

<script type = "text/javascript">
    var modal = document.getElementById('myModal');
    var btn = document.getElementById("myBtn");
    var span = document.getElementsByClassName("close")[0];

    btn.onclick = function() {
        modal.style.display = "block";
    }

    span.onclick = function() {
        modal.style.display = "none";
    }

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>
</body>
</html>