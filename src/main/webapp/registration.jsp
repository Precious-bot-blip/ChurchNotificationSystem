<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - City Church</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Roboto+Mono:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>City Church</h2>
            <h3>Register</h3>
            
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
            
            <form action="register" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="role">Role</label>
                    <select id="role" name="role" required>
                        <option value="">Select Role</option>
                        <option value="member">Church Member</option>
                        <option value="leader">Church Leader</option>
                    </select>
                </div>
                <input type="submit" value="Register">
            </form>
            
            <div class="links">
                Already have an account? <a href="login.jsp">Login here</a>
            </div>
        </div>
    </div>
</body>
</html>