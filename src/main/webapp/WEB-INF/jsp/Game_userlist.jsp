<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020-08-12
  Time: 오후 11:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<table border="1">
    <tr align="center">
        <td>참가자</td>
    </tr>
    <c:forEach var="user" items="${User_list}" varStatus="status">
        <tr>
            <td>${user}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
