<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Title</title>
    <style>
        table {
            text-align: center;
        }
        tr, td {
            padding: 15px;
        }
    </style>
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
