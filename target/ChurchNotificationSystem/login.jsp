<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - City Church</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Roboto+Mono:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>City Church</h2>
            <h3>Login</h3>
            
            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                if (error != null) {
            %>
                <div class="error"><%= error %></div>
            <%
                }
                if (success != null) {
            %>
                <div class="success"><%= success %></div>
            <%
                }
            %>
            
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <input type="submit" value="Login">
            </form>
            
            <div class="links">
                Don't have an account? <a href="registration.jsp">Register here</a>
            </div>
            
            <div style="margin-top:20px; font-size:14px; color:var(--text-secondary); text-align:center;">
                Test: admin / admin123 (Leader) | member1 / pass123 (Member)
            </div>
        </div>
    </div>
</body>
</html>