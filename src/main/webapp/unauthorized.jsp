<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Access Denied</title>
</head>
<body>
    <h1>Access Denied</h1>
    <% 
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
            <p style="color: red; font-weight: bold;"><%= error %></p>
    <% 
        } else {
    %>
            <p style="color: red; font-weight: bold;">You are not authorized to view this resource.</p>
    <%
        }
    %>
    <p>Please <a href="login.jsp">sign in</a> with the correct credentials.</p>
</body>
</html>