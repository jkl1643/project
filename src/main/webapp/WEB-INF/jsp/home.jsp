<%@ page import="com.example.RegisterRequest" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.Member" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.example.MainController" %>

<%@ page import="org.python.util.PythonInterpreter" %>
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

	/*모달*/
	.modal {
		display: none; /* Hidden by default */
		position: fixed; /* Stay in place */
		z-index: 1; /* Sit on top */
		left: 0;
		top: 0;
		width: 100%; /* Full width */
		height: 100%; /* Full height */
		overflow: auto; /* Enable scroll if needed */
		background-color: rgb(0,0,0); /* Fallback color */
		background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
	}

	/* Modal Content/Box */
	.modal-content {
		background-color: #fefefe;
		margin: 15% auto; /* 15% from the top and centered */
		padding: 20px;
		border: 1px solid #000000;
		width: 25%; /* Could be more or less, depending on screen size */
		height: 30%;
	}
	/* The Close Button */
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
<%--<button type="button" OnClick="location.href ='createroom?=${1}'">회의 방 생성</button>
<button id="myBtn">회의 방 입장</button>--%>
<div style="font-size: 50pt; text-align: center; top: 10%; left: 50%; margin: -12px 0 0 -180px; position: absolute">
	웹 화상채팅
</div>
<form action="joinroom" method="post">
<!-- The Modal -->
<div id="myModal" class="modal">

	<!-- Modal content -->
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
				<%--<div style="margin-left: 200px; margin-top: 20px; float: left; display: inline;">아이디</div>
				<div style="margin-left: 300px; margin-top: -25px; float: left; display: inline;"><input type="text" placeholder="아이디 조건" Name="id" id="inputid1"%></div>
				<br><br><br><br>
				<div style="margin-left: 200px; margin-top: 20px; float: left;">패스워드</div>
				<div style="margin-left: 300px; margin-top: -25px; float: left;"><input type="password" placeholder="비밀번호 조건" Name ="pwd"></div>
				<div style="margin-left: 250px; margin-top: 20px; float: left;"></div>
				<div><Input Type = "Submit" Value = "로그인" id="loginbutton1"></div>--%>
				<div <%--style="border: 1px solid black; width: 10px; height: 10px;"--%>>

				</div>
			</fieldset>

	</div>

	<tr>

	</tr>
	<td>

	</td>
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

		<%--<div OnClick="location.href ='findpwd'" style="cursor: pointer; margin-left: 310px; margin-top: -50px; float: left; display: inline;" id="asdf">비밀번호 찾기</div>--%>
	</div>
</table>
<script type = "text/javascript">
	// Get the modal
	var modal = document.getElementById('myModal');

	// Get the button that opens the modal
	var btn = document.getElementById("myBtn");

	// Get the <span> element that closes the modal
	var span = document.getElementsByClassName("close")[0];

	// When the user clicks on the button, open the modal
	btn.onclick = function() {
		modal.style.display = "block";
	}

	// When the user clicks on <span> (x), close the modal
	span.onclick = function() {
		modal.style.display = "none";
	}

	// When the user clicks anywhere outside of the modal, close it
	window.onclick = function(event) {
		if (event.target == modal) {
			modal.style.display = "none";
		}
	}

</script>
	<%--<P CLASS="part1"><B> 보드게임 </B></P> <!-- 제목 -->
	<ul>
		<li><a class="active" href="#home">홈</a></li> <!-- 메뉴바의 홈 버튼 -->
		<li><a href="<c:url value='/gamerank'/>">게임목록</a></li> <!-- 메뉴바의 게임목록 버튼 -->
		<li><a href="<c:url value='/custom'/>">고객문의</a></li> <!-- 메뉴바의 고객문의 버튼 -->
	</ul>
	<%
		int login = (int) request.getAttribute("login");
		String idid = (String) session.getAttribute("idid");
		Member mem = (Member) session.getAttribute("mem");
		int users = (int) request.getAttribute("users");

		boolean loginduplicate = (boolean) request.getAttribute("loginduplicate");

		Cookie [] cookie = request.getCookies();
		String cookieId = "";
		if(cookie != null) {
			for(Cookie i : cookie) {
				if(i.getName().equals("saveId")) {
					cookieId = i.getValue();
				}
			}
		}

		if(mem == null){
			if(loginduplicate){ %>
				<script>
					alert("이미 로그인 되어 있습니다.");
				</script>
			<%}%>


		<div id="logbox1">
			<div id="logbox2">
				<p id="yuba">현재 접속자 수 : ${users}명</p>
			</div>
			<form action="main" method="post">
				<div style="margin-left: 200px; margin-top: 20px; float: left; display: inline;">아이디</div>
				<div style="margin-left: 300px; margin-top: -25px; float: left; display: inline;"><input type="text" placeholder="아이디 조건" Name="id" id="inputid1" value="<%=cookieId !="" ? cookieId : "" %>"></div>
				<div style="margin-left: 200px; margin-top: 20px; float: left;">패스워드</div>
				<div style="margin-left: 300px; margin-top: -25px; float: left;"><input type="password" placeholder="비밀번호 조건" Name ="pwd"></div>
				<div style="margin-left: 250px; margin-top: 20px; float: left;"></div>
				<div><Input Type = "Submit" Value = "로그인" id="loginbutton1"></div>
			</form>
				<div>
					<form action="newaccount" method="post">
						<Input Type="Submit" Value="회원가입" id="signupbutton1">
					</form>
				</div>
				<div>
					<%
					boolean email = (boolean)request.getAttribute("unknown_email");
					boolean emailpwd = (boolean)request.getAttribute("email_pwd_match");
					boolean logout = (boolean)request.getAttribute("logout");
					boolean delaccount = (boolean)request.getAttribute("delaccount");
					boolean created_account = (boolean)request.getAttribute("created_account");
					boolean error = (boolean)request.getAttribute("error");
					if(email) {	%>
					<div id="yu">존재하지 않는 아이디입니다.</div>
					<%} else if (email){ %>
						<div id="yu">아이디를 입력해주세요.</div>
					<%}	else if (emailpwd) {%>
						<div id="yu">이메일과 암호가 일치하지 않습니다.</div>
					<%} else if (delaccount) {%>
						<div id="yu">계정이 삭제되었습니다.</div>
					<%} else if (logout) {%>
						<div id="yu">로그아웃 되었습니다.</div>
					<%}
						if (created_account) { %> <div id="yu">계정이 생성되었습니다.</div> <%}
						if (error) { %>	<div id="yu">이미 있는 닉네임입니다.</div> <%}
					%>
				</div>
			<label for="saveId"><div style="margin-left: 200px; margin-top: -50px; float: left;"><input type="checkbox" id="saveId" name="saveId"<%=cookieId!=""?"checked" : ""%>>&nbsp;아이디 저장&nbsp; / &nbsp;</div></label>
				<div OnClick="location.href ='findpwd'" style="cursor: pointer; margin-left: 310px; margin-top: -50px; float: left; display: inline;" id="asdf">비밀번호 찾기</div>
		</div>
	<%}	else {
		Enumeration en = MainController.loginUsers.keys();

		while(en.hasMoreElements()){
			String key = en.nextElement().toString();
			if(loginduplicate){%>
				<script>
					alert("이미 로그인 되어 있습니다.");
				</script>
				<div id="logbox1">
					<div id="logbox2">
						<p id="yuba">현재 접속자 수 : ${users}명</p>
					</div>
					<form action="main" method="post">
						<div style="margin-left: 200px; margin-top: 20px; float: left; display: inline;">아이디</div>
						<div style="margin-left: 300px; margin-top: -25px; float: left; display: inline;"><input type="text" placeholder="아이디 조건" Name="id" id="inputid1" value="<%=cookieId !="" ? cookieId : "" %>"></div>
						<div style="margin-left: 200px; margin-top: 20px; float: left;">패스워드</div>
						<div style="margin-left: 300px; margin-top: -25px; float: left;"><input type="password" placeholder="비밀번호 조건" Name ="pwd"></div>
						<div style="margin-left: 250px; margin-top: 20px; float: left;"></div>
						<div><Input Type = "Submit" Value = "로그인" id="loginbutton1"> &lt;%&ndash;유병렬 입력한것&ndash;%&gt;</div>
					</form>
					<div>
						<form action="newaccount" method="post">
							<Input Type="Submit" Value="회원가입" id="signupbutton1">
						</form>
					</div>
					<div>
						<%
							boolean email = (boolean)request.getAttribute("unknown_email");
							boolean emailpwd = (boolean)request.getAttribute("email_pwd_match");
							boolean logout = (boolean)request.getAttribute("logout");
							boolean delaccount = (boolean)request.getAttribute("delaccount");
							boolean created_account = (boolean)request.getAttribute("created_account");
							boolean error = (boolean)request.getAttribute("error");
							if(email) {	%>
						<div id="yu">존재하지 않는 아이디입니다.</div>
						<%} else if (email){ %>
						<div id="yu">아이디를 입력해주세요.</div>
						<%}	else if (emailpwd) {%>
						<div id="yu">이메일과 암호가 일치하지 않습니다.</div>
						<%} else if (delaccount) {%>
						<div id="yu">계정이 삭제되었습니다.</div>
						<%} else if (logout) {%>
						<div id="yu">로그아웃 되었습니다.</div>
						<%}
							if (created_account) { %> <div id="yu">계정이 생성되었습니다.</div> <%}
						if (error) { %>	<div id="yu">이미 있는 닉네임입니다.</div> <%}
					%>
					</div>
					<div style="margin-left: 350px; margin-top: 17px; float: left;"><input type="checkbox" id="saveId" name="saveId" <%=cookieId!=""?"checked" : ""%>></div>
					<div style="margin-left: 370px; margin-top: -20px; float: left; display: inline;">아이디 저장</div>
					<div OnClick="location.href ='findaccount'" style="cursor: pointer; margin-left: 300px; margin-top: 20px; float: left; display: inline;">아이디/비밀번호 찾기</div>
				</div>

			  <%} else {%>
					<div id="logbox1_2">
						<div id="logbox2">
							<p id="yuba">현재 접속자 수 : ${users}명</p>
						</div>
						<center><table id="table1">
							<tr>
								<td id="nono">${mem.getEmail()}님 환영합니다!</td>
								<td><%
									boolean editaccount = (boolean)request.getAttribute("editaccount");
									boolean chkpwd = (boolean)request.getAttribute("chkpwd");
									boolean currentpwd = (boolean)request.getAttribute("currentpwd");
									if (editaccount) {%>
									<p id="yu">정보를 수정했습니다.</p>
									<%}%>
									<%if (chkpwd) {%>
									<p id="yu">확인 비밀번호가 일치하지 않습니다.</p>
									<%}%>
									<%if (currentpwd) {%>
									<p id="yu">현재 비밀번호가 일치하지 않습니다.</p>
									<%}%></td>
							</tr>
						</table></center>
						<table id="table2">
							<tr>
								<td>
									<form action="record" method="post"> <!-- 내 전적으로 바꿈 -->
									<div style="display:none;">
										<Input Type="Text" Name="memnum" value="${mem.getId()}">
									</div>
										<button type="submit" id="but2"><img src="ma1.jpg" id="img1"></button>
									</form>
								</td>
								<td>
									<form action="mygamelist" method="get"> <!-- form 태그 안에 내용 바꿔라 -->
										<button type="button" OnClick="location.href ='mygamelist'" id="but3"><img src="ma2.jpg" id="img2"/></button>
									</form>
								</td>
							</tr>
							<tr>
								<td>
									<form action="editaccount" method="post">
										<button type="button" OnClick="location.href ='editaccount'" id="but4"><img src="ma3.jpg" id="img3"></button>
									</form>
									</form>
								</td>
								<td>
									<form action="logout" method="post">
										<button type="button" OnClick="location.href ='logout'" id="but5"><img src="ma4.jpg" id="img4"></button>
									</form>
								</td>
							</tr>
						</table>
					</div>
	<%}
			break;
	}
	}%>
	<div id="logbox4">
		게임 랭킹<BR><BR>
		<table>
			<br>
			<c:forEach var="game" items="${Rank_list}" varStatus="status" begin="0" end="2">
				<gameimage>
					<a href="gameinfo?game=${game.game_number}">
						&nbsp;&nbsp;<img class="img" src="image/${game.game_image}"/>&nbsp;&nbsp;&nbsp;&nbsp;
					</a>
				</gameimage>
			</c:forEach>
		</table>
	</div>--%>
</body>
</html>