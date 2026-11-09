package com.church.servlet;

import com.church.model.User;
import com.church.storage.MessageStorage;
import com.church.websocket.NotificationWebSocket;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/sendMessage")
public class MessageServlet extends HttpServlet {
    
    private MessageStorage messageStorage;
    
    @Override
    public void init() throws ServletException {
        messageStorage = MessageStorage.getInstance();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        if (!"leader".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only church leaders can send notifications.");
            return;
        }
        
        String message = request.getParameter("message");
        String category = request.getParameter("category");
        
        if (category == null || category.trim().isEmpty()) {
            category = "General";
        }
        
        if (message == null || message.trim().isEmpty()) {
            request.setAttribute("error", "Message cannot be empty!");
            request.getRequestDispatcher("notification.jsp").forward(request, response);
            return;
        }
        
        // Store message with category in MessageStorage
        messageStorage.addMessage(message, category);
        
        String categoryTag = "";
        if (!"General".equals(category)) {
            categoryTag = "[" + category.toUpperCase() + "] ";
        }
        String formattedMessage = categoryTag + user.getUsername() + ": " + message;
        
        // Broadcast via WebSocket
        NotificationWebSocket.broadcastMessage(formattedMessage);
        
        request.setAttribute("success", "Notification sent successfully via WebSocket!");
        request.getRequestDispatcher("notification.jsp").forward(request, response);
    }
}