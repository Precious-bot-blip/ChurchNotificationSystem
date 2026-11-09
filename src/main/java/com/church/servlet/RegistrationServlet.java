package com.church.servlet;

import com.church.storage.UserStorage;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    
    private UserStorage userStorage;
    
    @Override
    public void init() throws ServletException {
        userStorage = UserStorage.getInstance();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1.1 Accept username and password from HTML form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        // 1.2 Validate input data
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("registration.jsp").forward(request, response);
            return;
        }
        
        // 1.3 & 1.4 Store user credentials - prevent duplicate usernames
        boolean registered = userStorage.registerUser(username, password, role);
        
        if (registered) {
            // 1.5 Success response
            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // 1.5 Error response
            if (userStorage.userExists(username)) {
                request.setAttribute("error", "Username already exists. Please choose another.");
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
            }
            request.getRequestDispatcher("registration.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("registration.jsp");
    }
}