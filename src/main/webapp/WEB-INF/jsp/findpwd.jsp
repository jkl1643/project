<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.Member" %>
<%@ page import="org.springframework.context.annotation.AnnotationConfigApplicationContext" %>
<%@ page import="com.example.JavaConfig" %>
<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="com.example.MemberDao" %>
<!DOCTYPE html>
<html>
<head>
	<%Member mem = (Member) session.getAttribute("mem");%>
<meta charset="EUC-KR">
<title>비밀번호찾기</title>
	<STYLE TYPE="text/css">
		<!--
		BODY {background-image: url(""); background-repeat: no-repeat; background-size: cover}
		h1#text {text-align: center}
		div#box1 {width: 750px; height: 300px; background-color: #ffffff; border: 5px solid black; position: relative; left: 20%; top: 20px}
		p#dd1 {position: relative; left: 200px; top: 30px}
		input#text1 {position: relative; left: 300px; top: -6px}
		p#dd2 {position: relative; left: 200px; top: 20px}
		input#text2 {position: relative; left: 300px; top: -15px}
		input#submit1 {width: 120px; height: 50px; background-color: black; color: white; position: relative; left: 300px; top: 60px}
		button#button1 {width: 200px; height: 100px; background-color: black; color: white; position: relative; left: 40%; top: 200px}
		-->
	</STYLE>
	<script type = "text/javascript">
		var email2;
		var nick;
		function validate(){
			var email = document.getElementById("text1");
			var nickname = document.getElementById("text2");

			var re = /^[a-zA-Z0-9]{4,12}$/ // 아이디와 패스워드가 적합한지 검사할 정규식
			var re2 = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
			// 이메일이 적합한지 검사할 정규식

			if(email.value=="") {
				alert("이메일을 입력해 주세요");
				email.focus();
				return false;
			}

			if(!check(re2, email, "적합하지 않은 이메일 형식입니다.")) {
				return false;
			}

			if(nickname.value=="") {
				alert("닉네임을 입력해 주세요");
				nickname.focus();
				return false;
			}
			return true;
		}

		function check(re, what, message) {
			if(re.test(what.value)) {
				return true;
			}
			alert(message);
			what.value = "";
			what.focus();
			return false;
		}
	</script>
</head>
<body>
<h1 id="text">비밀번호찾기</h1>
<div id="box1">
	<form name="join" onsubmit="return validate();" action="resultfindpwd" method="post">
		<p id="dd1">아이디 : </p>
		<Input Type = "Text" Name = "id" id="text1"> <BR>
		<p id="dd2">닉네임 : </p>
		<Input Type = "Text" Name = "nickname" id="text2"> <BR>
		<Input Type = "Submit" Value = "비밀번호 찾기" id="submit1">
	</form>
</div>
<button id="button1" onClick="history.back();">뒤로가기</button>
</body>
</html>