
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>계정삭제</title>
</head>
<body>
<h1>계정 삭제</h1>
<form action="checkdelaccount" method="post">
    <table>
        <tr>
            <td>아이디</td>
            <td><Input Type="Text" Name="delid"> <BR></td>
        </tr>
        <tr>
            <td>비밀번호</td>
            <td><Input Type="Text" Name="delpwd"> <BR></td>
        </tr>
    </table>
    <%
        boolean wrongemail = (boolean) request.getAttribute("wrongemail");
        boolean emailpwdmatch2 = (boolean) request.getAttribute("email_pwd_match2");
        if (wrongemail == true) {
    %><BR>잘못된 아이디 입력입니다.
    <%} else if (emailpwdmatch2 == true) {%>
    <BR>아이디와 비밀번호가 일치하지 않습니다.
    <%} %>
    <BR><Input Type="Submit" Value="계정 삭제">
    <Input type="button" value="되돌아가기" onClick="history.back();">
</form>
</body>
</html>