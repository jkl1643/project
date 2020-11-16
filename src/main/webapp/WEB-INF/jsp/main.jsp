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
    *{
        margin: 0;
        padding: 0;
    }
    .buttons1 {
        display: grid;
        /*grid-template-rows: repeat(3, 200px);*/
        /*grid-template-columns: repeat(3, 200px);*/
        grid-template-columns: 200px 10px 200px;
        /*
        position: fixed;
        top: 30%;
        left: 30%;*/
        /*float: left;*/
        width: 100%;
        height: 100%;
        /*text-align: center;*/
        padding: 100px;
        justify-content: center;
        align-content: space-evenly;
        margin: 0px 0 0 -120px;
        border: 1px solid black;
        top: 0px;
    }
    .buttons2 {
        display: grid;
        /*grid-template-rows: repeat(3, 200px);*/
        /*grid-template-columns: repeat(3, 200px);*/
        grid-template-columns: 200px 10px 200px 10px 200px;
        /*
        position: fixed;
        top: 30%;
        left: 30%;*/
        /*float: left;*/
        width: 100%;
        height: 100%;
        /*text-align: center;*/
        padding: 100px;
        justify-content: center;
        align-content: space-evenly;
        margin: 170px 0 0 -120px;
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
        width: 500px; /* Could be more or less, depending on screen size */
        height: 180px;
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
        /*margin: 20px;*/
    }
    .buttonclass:hover {
        background-color: #17176c;
    }
    .buttonclass:active {
        position:relative;
        top:1px;
    }
    /*.editInfo{
        box-shadow:inset 0px 34px 0px -15px #b54b3a;
        background-color:#a73f2d;
        border:1px solid #241d13;
        display:inline-block;
        cursor:pointer;
        color:#ffffff;
        font-family:Arial;
        font-size:15px;
        font-weight:bold;
        padding:9px 23px;
        text-decoration:none;
        text-shadow:0px -1px 0px #7a2a1d;
    }
    .delAcc{
        box-shadow:inset 0px 34px 0px -15px #b54b3a;
        background-color:#a73f2d;
        border:1px solid #241d13;
        display:inline-block;
        cursor:pointer;
        color:#ffffff;
        font-family:Arial;
        font-size:15px;
        font-weight:bold;
        padding:9px 23px;
        text-decoration:none;
        text-shadow:0px -1px 0px #7a2a1d;
    }*/


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
            <!-- Modal content -->
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





<%--<div class="inner_login">
    <div class="login">
        <form action="main" method="post" id="authForm">
            <fieldset>
                <legend class="screen_out">로그인 정보 입력폼</legend>
                <div class="box_login">
                    <div class="inp_text">
                        <label for="loginId" class="screen_out">아이디</label>
                        <input type="text" placeholder="아이디" id="loginId" name="loginId">
                    </div>
                    <div class="inp_text">
                        <label for="loginPw" class="screen_out">비밀번호</label>
                        <input type="password" placeholder="비밀번호" id="loginPw" name ="loginPw">
                    </div>
                </div>
                <button type="submit" class="btn_login">로그인</button>
                <div class="login_append">
                    <div class="inp_chk">
                        <input type="checkbox" id="keepLogin" class="inp_radio" name="keepLogin">
                        <label for="keepLogin" class="lab_g">
                            <span class="img_top ico_check"></span>
                            <span class="txt_lab">로그인 상태 유지</span>
                        </label>
                    </div>
                    <span class="txt_find">
						<a href="" class="link_find">아이디</a>
						<a href="" class="link_find">비밀번호 찾기</a>
					</span>
                </div>
                &lt;%&ndash;<div style="margin-left: 200px; margin-top: 20px; float: left; display: inline;">아이디</div>
                <div style="margin-left: 300px; margin-top: -25px; float: left; display: inline;"><input type="text" placeholder="아이디 조건" Name="id" id="inputid1"%></div>
                <br><br><br><br>
                <div style="margin-left: 200px; margin-top: 20px; float: left;">패스워드</div>
                <div style="margin-left: 300px; margin-top: -25px; float: left;"><input type="password" placeholder="비밀번호 조건" Name ="pwd"></div>
                <div style="margin-left: 250px; margin-top: 20px; float: left;"></div>
                <div><Input Type = "Submit" Value = "로그인" id="loginbutton1"></div>&ndash;%&gt;
            </fieldset>
        </form>
    </div>

    <tr>

    </tr>
    <td>
        <div>
            <form action="newaccount" method="post">
                <Input Type="Submit" Value="회원가입" id="signupbutton1">
            </form>
        </div>
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
    </td>

    <div OnClick="location.href ='findpwd'" style="cursor: pointer; margin-left: 310px; margin-top: -50px; float: left; display: inline;" id="asdf">비밀번호 찾기</div>
</div>--%>
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