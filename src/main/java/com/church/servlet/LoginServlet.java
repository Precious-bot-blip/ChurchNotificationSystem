package com.church.servlet;

import com.church.model.User;
import com.church.storage.UserStorage;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private UserStorage userStorage;
    
    @Override
    public void init() throws ServletException {
        userStorage = UserStorage.getInstance();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 2.1 Accept username and password from HTML form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // 2.2 Validate input data
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "Username and password are required!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate the user
        User user = userStorage.authenticateUser(username, password);
        
        if (user != null) {
            // 2.3 On successful login, create HTTP Session and store authenticated user
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            
            // Check role for redirection
            if ("leader".equals(user.getRole())) {
                response.sendRedirect("notification.jsp");
            } else {
                response.sendRedirect("home.jsp");
            }
        } else {
            // 2.4 Error response
            request.setAttribute("error", "Invalid username or password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}