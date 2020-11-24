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
        grid-template-columns: 120px 40px 120px;
        width: 30%;
        /*height: 100%;*/
        /*padding: 100px;*/
        justify-content: center;
        align-content: space-evenly;
        /*margin: 0px 0 0 -120px;*/
        /*border: 1px solid black;*/
        top: 173px;
        grid-template-rows: 90px 90px 121px 113px;
        position: absolute;
        gap: 20px 0;
    }
    .buttons2 {
        display: grid;
        grid-template-columns: 121px 10px 121px 10px 121px;
        /*width: 100%;*/
        /*height: 100%;*/
        /*padding: 100px;*/
        justify-content: center;
        align-content: space-evenly;
        /*margin: 170px 0 0 -120px;*/
    }

    .modal {
        display: none;
        position: fixed;
        z-index: 30;
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

    /*.close {
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
    }*/
    /*.buttonclass{
        box-shadow:inset 0px 34px 0px -15px #3263d5;
        background-color: #3045cd;
        border:1px solid #241d13;
        display:inline-block;
        cursor:pointer;
        !*color:#ffffff;*!
        font-family:Arial;
        font-size:21px;
        font-weight:bold;
        !*padding:9px 23px;*!
        text-decoration:none;
        text-shadow:0px -1px 0px #121e50;
        width: 120px;
        height: 70px;
    }
    .buttonclass:hover {
        background-color: #17176c;
    }
    .buttonclass:active {
        position:relative;
        top:1px;
    }*/

    .bttn-default {
        color: #fff;
    }
    .bttn-primary,
    .bttn,
    .bttn-lg,
    .bttn-md,
    .bttn-sm,
    .bttn-xs {
        color: #1d89ff;
    }
    .bttn-warning {
        color: #feab3a;
    }
    .bttn-danger {
        color: #ff5964;
    }
    .bttn-success {
        color: #28b78d;
    }
    .bttn-royal {
        color: #bd2df5;
    }
    .bttn,
    .bttn-lg,
    .bttn-md,
    .bttn-sm,
    .bttn-xs {
        margin: 0;
        padding: 0;
        border-width: 0;
        border-color: transparent;
        background: transparent;
        font-weight: 400;
        cursor: pointer;
        position: relative;
    }
    .bttn-lg {
        padding: 8px 15px;
        font-size: 24px;
        font-family: inherit;
    }
    .bttn-md {
        font-size: 20px;
        font-family: inherit;
        padding: 5px 12px;
    }
    .bttn-sm {
        padding: 4px 10px;
        font-size: 16px;
        font-family: inherit;
    }
    .bttn-xs {
        padding: 3px 8px;
        font-size: 12px;
        font-family: inherit;
    }
    .bttn-fill {
        margin: 0;
        padding: 0;
        border-width: 0;
        border-color: transparent;
        background: transparent;
        font-weight: 400;
        cursor: pointer;
        position: relative;
        font-size: 20px;
        font-family: inherit;
        padding: 5px 12px;
        z-index: 0;
        border: none;
        background: #fff;
        color: #1d89ff;
        -webkit-transition: all 0.3s cubic-bezier(0.02, 0.01, 0.47, 1);
        transition: all 0.3s cubic-bezier(0.02, 0.01, 0.47, 1);
    }
    .bttn-fill:before {
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: #1d89ff;
        content: '';
        opacity: 0;
        -webkit-transition: opacity 0.15s ease-out, -webkit-transform 0.15s ease-out;
        transition: opacity 0.15s ease-out, -webkit-transform 0.15s ease-out;
        transition: transform 0.15s ease-out, opacity 0.15s ease-out;
        transition: transform 0.15s ease-out, opacity 0.15s ease-out, -webkit-transform 0.15s ease-out;
        z-index: -1;
        -webkit-transform: scaleX(0);
        transform: scaleX(0);
    }
    .bttn-fill:hover,
    .bttn-fill:focus {
        box-shadow: 0 1px 8px rgba(58,51,53,0.3);
        color: #fff;
        -webkit-transition: all 0.5s cubic-bezier(0.02, 0.01, 0.47, 1);
        transition: all 0.5s cubic-bezier(0.02, 0.01, 0.47, 1);
    }
    .bttn-fill:hover:before,
    .bttn-fill:focus:before {
        opacity: 1;
        -webkit-transition: opacity 0.2s ease-in, -webkit-transform 0.2s ease-in;
        transition: opacity 0.2s ease-in, -webkit-transform 0.2s ease-in;
        transition: transform 0.2s ease-in, opacity 0.2s ease-in;
        transition: transform 0.2s ease-in, opacity 0.2s ease-in, -webkit-transform 0.2s ease-in;
        -webkit-transform: scaleX(1);
        transform: scaleX(1);
    }
    .bttn-fill.bttn-xs {
        padding: 3px 8px;
        font-size: 12px;
        font-family: inherit;
    }
    .bttn-fill.bttn-xs:hover,
    .bttn-fill.bttn-xs:focus {
        box-shadow: 0 1px 4px rgba(58,51,53,0.3);
    }
    .bttn-fill.bttn-sm {
        padding: 4px 10px;
        font-size: 16px;
        font-family: inherit;
    }
    .bttn-fill.bttn-sm:hover,
    .bttn-fill.bttn-sm:focus {
        box-shadow: 0 1px 6px rgba(58,51,53,0.3);
    }
    .bttn-fill.bttn-md {
        font-size: 27px;
        font-family: inherit;
        padding: 0px 0px;
    }
    .bttn-fill.bttn-md:hover,
    .bttn-fill.bttn-md:focus {
        box-shadow: 0 1px 8px rgba(58,51,53,0.3);
    }
    .bttn-fill.bttn-lg {
        padding: 8px 15px;
        font-size: 24px;
        font-family: inherit;
    }
    .bttn-fill.bttn-lg:hover,
    .bttn-fill.bttn-lg:focus {
        box-shadow: 0 1px 10px rgba(58,51,53,0.3);
    }
    .bttn-fill.bttn-default {
        background: #fff;
        color: #1d89ff;
    }
    .bttn-fill.bttn-default:hover,
    .bttn-fill.bttn-default:focus {
        color: #fff;
    }
    .bttn-fill.bttn-default:before {
        background: #1d89ff;
    }
    .bttn-fill.bttn-primary {
        background: #3263d5;
        color: #fff;
        width: 125px;
        height: 75px;
        border: 1px solid #0020bb;
    }
    .bttn-fill.bttn-primary:hover,
    .bttn-fill.bttn-primary:focus {
        color: #1d89ff;
    }
    .bttn-fill.bttn-primary:before {
        background: #fff;
    }
    .bttn-fill.bttn-warning {
        background: #feab3a;
        color: #fff;
    }
    .bttn-fill.bttn-warning:hover,
    .bttn-fill.bttn-warning:focus {
        color: #feab3a;
    }
    .bttn-fill.bttn-warning:before {
        background: #fff;
    }
    .bttn-fill.bttn-danger {
        background: #ff5964;
        color: #fff;
    }
    .bttn-fill.bttn-danger:hover,
    .bttn-fill.bttn-danger:focus {
        color: #ff5964;
    }
    .bttn-fill.bttn-danger:before {
        background: #fff;
    }
    .bttn-fill.bttn-success {
        background: #28b78d;
        color: #fff;
    }
    .bttn-fill.bttn-success:hover,
    .bttn-fill.bttn-success:focus {
        color: #28b78d;
    }
    .bttn-fill.bttn-success:before {
        background: #fff;
    }
    .bttn-fill.bttn-royal {
        background: #bd2df5;
        color: #fff;
    }
    .bttn-fill.bttn-royal:hover,
    .bttn-fill.bttn-royal:focus {
        color: #bd2df5;
    }
    .bttn-fill.bttn-royal:before {
        background: #fff;
    }

</style>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Gothic+A1:wght@900&display=swap');
</style>
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Gothic+A1:wght@900&display=swap" rel="stylesheet">
<body>
<%--<div style="font-size: 50pt; text-align: center; left: 50%; margin: 0px 0 0 -180px; position: absolute">
    웹 화상채팅
</div>--%>
<div style="font-size: 41pt; text-align: center; top: 11%; /*margin: -12px 0 0 -180px;*/ color: #0021c1; font-family: 'Gothic A1', sans-serif; position: absolute; z-index: 5; left: 72.5%;">
    웹 화상채팅
</div>

<div id="buttons1" class="buttons1">


    <%--<button style="width: 50px; height: 100px; border: none; background: white"></button>--%>
    <form action="editaccount" method="post">
        <button type="button" OnClick="location.href ='editaccount'" Value="정보수정" class="bttn-fill bttn-md bttn-primary">정보수정</button>
    </form>
    <button style="width: 50px; height: 100px; border: none; background: white"></button>
    <form action="delaccount" method="post">
        <button type="button" OnClick="location.href ='delaccount'" Value="계정삭제" class="bttn-fill bttn-md bttn-primary">계정삭제</button>
    </form>

        <button type="button" OnClick="location.href ='createroom'" class="bttn-fill bttn-md bttn-primary">방 생성</button>
        <button style="width: 50px; height: 100px; border: none; background: white"></button>
        <button id="myBtn" class="bttn-fill bttn-md bttn-primary">방 입장</button>
        <form action="logout" method="post">
            <button type="button" OnClick="location.href ='logout'" id="but5" class="bttn-fill bttn-md bttn-primary">로그아웃</button>
        </form>
</div>
<%--<div style="font-size: 50pt; text-align: center; top: 300px; left: 50%; margin: 160px 0 0 -180px; position: absolute">
    사용자 메뉴
</div>--%>
<%--<div class="buttons2">

</div>--%>

<form action="joinroom" method="post">
    <div id="myModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <br>
            <div class="inp_text">
                <p>
                    <label for="roomId" class="screen_out" style="size: 20px; color: black">방 번호</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="text" placeholder="방 번호" id="roomId" name="roomId" style="height: 20px; width: 300px; color: black">
                </p>
            </div>
            <br>
            <div class="inp_text">
                <label for="roomPw" class="screen_out" style="color: black">방 비밀번호</label>
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