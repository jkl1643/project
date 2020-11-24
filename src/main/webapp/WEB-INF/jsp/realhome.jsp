<%--
  Created by IntelliJ IDEA.
  User: Yu
  Date: 2020-11-21
  Time: 오후 3:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <STYLE TYPE="text/css">

        #div1{
            background-image: url('222.jpg');
            background-size: contain;
        }

        * {
            margin: 0;
            padding: 0;
        }

    </STYLE>
    <title>Title</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<body>
<div style="width: 100%; height: 100%; color: #2e57c9; background-image: url(''); background-size: cover; ">
    <div style="width: 1148px; height: 568px; position: absolute; top: 19%; left: 19%; border: 3px solid;">
        <div id="div1" style="height: 100%; width: 70%; float: left; color: white">
        </div>
        <div id="div2" style="height: 100%; width: 30%; float: right; color: white">
            <jsp:include page="home.jsp"/>
        </div>
    </div>
</div>
</body>
</html>
