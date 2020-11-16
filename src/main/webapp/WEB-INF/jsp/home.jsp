<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title></title>
</head>

<style>
	a {
		color: #333;
		text-decoration: none;
	}
	input {
		-webkit-writing-mode: horizontal-tb !important;
		text-rendering: auto;
		color: initial;
		letter-spacing: normal;
		word-spacing: normal;
		text-transform: none;
		text-indent: 0px;
		text-shadow: none;
		display: inline-block;
		text-align: start;
		-webkit-appearance: textfield;
		background-color: white;
		-webkit-rtl-ordering: logical;
		cursor: text;
		margin: 0em;
		font: 400 13.3333px Arial;
		padding: 1px 0px;
		border-width: 2px;
		border-style: inset;
		border-color: initial;
		border-image: initial;
	}
	.inner_login {
		position: absolute;
		left: 50%;
		top: 50%;
		margin: -145px 0 0 -160px;
	}
	.login{
		position: relative;
		width: 320px;
		margin: 0 auto;
	}
	.screen_out {
		position: absolute;
		width: 0;
		height: 0;
		overflow: hidden;
		line-height: 0;
		text-indent: -9999px;
	}
	body, button, input, select, td, textarea, th {
		font-size: 13px;
		line-height: 1.5;
		-webkit-font-smoothing: antialiased;
	}
	fieldset, img {
		border: 0;
	}
	.login .box_login {
		margin: 35px 0 0;
		border: 2px solid #363636;
		border-radius: 3px;
		background-color: #fff;
		box-sizing: border-box;
	}
	.login .inp_text {
		position: relative;
		width: 100%;
		margin: 10px;
		padding: 18px 19px 19px;
		box-sizing: border-box;
	}
	.login.inp_text .inp_text {
		border-top: 1px solid #ddd;
	}
	.inp_text input {
		display: block;
		width: 100%;
		height: 100%;
		font-size: 13px;
		color: #000;
		border: none;
		outline: 0;
		-webkit-appearance: none;
		background-color: transparent;
	}
	.btn_login {
		margin: 20px 0 0;
		width: 100%;
		height: 48px;
		border-radius: 3px;
		font-size: 16px;
		color: #fff;
		background-color: #10167f;
	}
	.login_append {
		overflow: hidden;
		padding: 15px 0 0;
	}
	.inp_chk {
		display: inline-block;
		position: relative;
		margin-bottom: -1px;
	}
	.login_append .inp_chk {
		float: left;
	}
	.inp_chk .saveId {
		position: absolute;
		z-index: -1;
		top: 0;
		left: 0;
		width: 18px;
		height: 18px;
		border: 0;
	}
	.inp_chk .lab_g {
		display: inline-block;
		margin-right: 19px;
		color: #909090;
		font-size: 13px;
		line-height: 19px;
		vertical-align: top;
	}
	.inp_chk .ico_check {
		display: inline-block;
		width: 18px;
		height: 18px;
		margin: 1px 4px 0 0;
		background-position: -60px 0;
		color: #333;
	}
	.inp_chk .txt_lab {
		vertical-align: top;
	}
	.login_append .txt_find {
		float: right;
		color: #777;
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
		width: 25%;
		height: 30%;
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


</style>

<body>
<%
	Cookie [] cookie = request.getCookies();
	String cookieId = "";
	if(cookie != null) {
		for(Cookie i : cookie) {
			if(i.getName().equals("saveId")) {
				cookieId = i.getValue();
			}
		}
	}
	System.out.println("cookie : " + cookieId);
%>
<div style="font-size: 50pt; text-align: center; top: 10%; left: 50%; margin: -12px 0 0 -180px; position: absolute">
	웹 화상채팅
</div>
<form action="joinroom" method="post">
	<div id="myModal" class="modal">
		<div class="modal-content">
			<span class="close">&times;</span>

			<div class="inp_text">
				<p>
					<label for="roomId" class="screen_out">방 번호</label>
					<input type="text" placeholder="방 번호" id="roomId" name="roomId">
				</p>
			</div>
			<div class="inp_text">
				<label for="roomPw" class="screen_out">방 비밀번호</label>
				<input type="password" placeholder="방 비밀번호" id="roomPw" name="roomPw">
			</div>
			<button type="submit">회의 방 입장</button>
		</div>
	</div>
</form>


<div class="inner_login">
	<div class="login">
		<form action="main" method="post" id="authForm">
			<fieldset>
				<legend class="screen_out">로그인 정보 입력폼</legend>
				<div class="box_login">
					<div class="inp_text">
						<label for="loginId" class="screen_out">아이디</label>
						<input type="text" placeholder="아이디" id="loginId" name="loginId" value="<%=cookieId !="" ? cookieId : "" %>">
					</div>
					<div class="inp_text">
						<label for="loginPw" class="screen_out">비밀번호</label>
						<input type="password" placeholder="비밀번호" id="loginPw" name ="loginPw">
					</div>
				</div>
				<button type="submit" class="btn_login">로그인</button>
		</form>
				<div class="login_append">
					<div class="inp_chk">
						<input type="checkbox" id="saveId" class="saveId" name="saveId">
						<label for="saveId" class="lab_g">
							<span class="img_top ico_check"></span>
							<span class="txt_lab" >아이디 기억하기</span>
						</label>

					</div>

					<form action="newaccount" method="post">
					<span class="txt_find">

							<Input Type="Submit" Value="회원가입 / " id="signupbutton1" style="border: none;">

						<a href="findpwd" class="link_find">비밀번호 찾기</a>
					</span>
					</form>
				</div>
			</fieldset>
	</div>

	<td>
		<div>
			<%
				boolean email = (boolean)request.getAttribute("unknown_email");
				boolean emailpwd = (boolean)request.getAttribute("email_pwd_match");
				boolean logout = (boolean)request.getAttribute("logout");
				boolean delaccount = (boolean)request.getAttribute("delaccount");
				boolean created_account = (boolean)request.getAttribute("created_account");
				boolean error = (boolean)request.getAttribute("error");
				if(email) {	%>
			<div>존재하지 않는 아이디입니다.</div>
			<%} else if (email){ %>
			<div>아이디를 입력해주세요.</div>
			<%}	else if (emailpwd) {%>
			<div>이메일과 암호가 일치하지 않습니다.</div>
			<%} else if (delaccount) {%>
			<div>계정이 삭제되었습니다.</div>
			<%} else if (logout) {%>
			<div>로그아웃 되었습니다.</div>
			<%}
				if (created_account) { %> <div>계정이 생성되었습니다.</div> <%}
			if (error) { %>	<div>이미 있는 닉네임입니다.</div> <%}
		%>
		</div>
	</td>
	</div>
</table>
</body>
</html>