<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.church.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - City Church</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Roboto+Mono:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .notification-container {
            max-height: 500px;
            overflow-y: auto;
            margin-top: 20px;
        }
        .notification-container::-webkit-scrollbar {
            width: 8px;
        }
        .notification-container::-webkit-scrollbar-track {
            background: var(--background-input);
            border-radius: 4px;
        }
        .notification-container::-webkit-scrollbar-thumb {
            background: var(--primary-color);
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>City Church</h1>
        <div class="user-info">
            <span>Welcome, <%= user.getUsername() %> <span class="badge"><%= user.getRole() %></span></span>
            <a href="logout">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <div class="card">
            <h2>Notifications</h2>
            <div id="notifications" class="notification-container">
                <div class="empty">Loading notifications...</div>
            </div>
            <div class="status">Status: <span id="connectionStatus">Connecting...</span></div>
        </div>
        
        <div class="card">
            <p style="color:var(--text-secondary); text-align:center; font-size:16px;">
                Only Church Leaders can send notifications from the Notification page.
            </p>
        </div>
    </div>
    
    <script>
        let ws;
        let reconnectAttempts = 0;
        const maxReconnectAttempts = 5;
        
        function formatTimestamp() {
            const now = new Date();
            return now.toLocaleString('en-US', {
                month: 'short',
                day: 'numeric',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });
        }
        
        function getCategoryClass(category) {
            switch(category) {
                case 'Service': return 'category-service';
                case 'Event': return 'category-event';
                case 'Ministry': return 'category-ministry';
                default: return 'category-general';
            }
        }
        
        function addNotification(message) {
            const notificationsDiv = document.getElementById('notifications');
            
            if (notificationsDiv.innerHTML.includes('Loading notifications') || 
                notificationsDiv.innerHTML.includes('No notifications')) {
                notificationsDiv.innerHTML = '';
            }
            
            const notification = document.createElement('div');
            notification.className = 'notification';
            
            let messageText = message;
            let category = 'General';
            
            if (message.includes('[SERVICE]')) {
                category = 'Service';
                messageText = message.replace('[SERVICE]', '');
            } else if (message.includes('[EVENT]')) {
                category = 'Event';
                messageText = message.replace('[EVENT]', '');
            } else if (message.includes('[MINISTRY]')) {
                category = 'Ministry';
                messageText = message.replace('[MINISTRY]', '');
            }
            
            const timestamp = formatTimestamp();
            notification.innerHTML = 
                '<span class="timestamp">' + timestamp + '</span>' +
                '<span class="category ' + getCategoryClass(category) + '">' + category + '</span>' +
                messageText;
            
            notificationsDiv.prepend(notification);
            
            while (notificationsDiv.children.length > 100) {
                notificationsDiv.removeChild(notificationsDiv.lastChild);
            }
        }
        
        function connectWebSocket() {
            const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            const wsUrl = protocol + '//' + window.location.host + '<%= request.getContextPath() %>/notifications';
            
            try {
                ws = new WebSocket(wsUrl);
                
                ws.onopen = function() {
                    document.getElementById('connectionStatus').textContent = 'Connected';
                    document.getElementById('connectionStatus').style.color = '#3fb950';
                    reconnectAttempts = 0;
                };
                
                ws.onmessage = function(event) {
                    addNotification(event.data);
                };
                
                ws.onclose = function() {
                    document.getElementById('connectionStatus').textContent = 'Disconnected';
                    document.getElementById('connectionStatus').style.color = '#f85149';
                    
                    if (reconnectAttempts < maxReconnectAttempts) {
                        reconnectAttempts++;
                        setTimeout(function() {
                            connectWebSocket();
                        }, 3000);
                    }
                };
                
                ws.onerror = function(error) {
                    console.error('WebSocket error:', error);
                };
            } catch (e) {
                console.error('Connection error:', e);
                document.getElementById('connectionStatus').textContent = 'Error connecting';
                document.getElementById('connectionStatus').style.color = '#f85149';
            }
        }
        
        connectWebSocket();
        
        window.addEventListener('beforeunload', function() {
            if (ws && ws.readyState === WebSocket.OPEN) {
                ws.close();
            }
        });
    </script>
</body>
</html>