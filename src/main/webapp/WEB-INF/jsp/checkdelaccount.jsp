<%@page import="com.example.MainController" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="EUC-KR">
    <title>알림</title>
</head>
<body>
<h1>계정이 삭제되었습니다.</h1>
<form action="home" method="post">
    <Input Type="Submit" Value="확인">
</form>
<%MainController.delaccount = 0;
session.invalidate();

%>
</body>
</html>