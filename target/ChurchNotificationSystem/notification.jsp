<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.church.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (!"leader".equals(user.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only Church Leaders can access this page.");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notification Center - City Church</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Roboto+Mono:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .notification-container {
            max-height: 400px;
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
        .form-row {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .form-row .form-group {
            flex: 1;
            min-width: 200px;
        }
        .two-column {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        @media (max-width: 768px) {
            .two-column {
                grid-template-columns: 1fr;
            }
        }
        .jms-badge {
            display: inline-block;
            background: #2ea043;
            color: #0d1117;
            padding: 2px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-left: 10px;
        }
        .websocket-badge {
            display: inline-block;
            background: var(--primary-color);
            color: #0d1117;
            padding: 2px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-left: 10px;
        }
        .btn-jms {
            background: #2ea043 !important;
        }
        .btn-jms:hover {
            background: #238636 !important;
        }
        .btn-websocket {
            background: var(--primary-color) !important;
        }
        .btn-websocket:hover {
            background: var(--primary-dark) !important;
        }
        .divider {
            border: none;
            border-top: 1px solid var(--border-color);
            margin: 30px 0;
        }
        .legend-box {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 15px;
            padding: 15px;
            background: var(--background-input);
            border-radius: 8px;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: var(--text-secondary);
        }
        .legend-color {
            width: 12px;
            height: 12px;
            border-radius: 3px;
        }
        .legend-color.service { background: #1f6feb; }
        .legend-color.event { background: #d29922; }
        .legend-color.ministry { background: #2ea043; }
        .legend-color.general { background: var(--text-secondary); }
    </style>
</head>
<body>
    <div class="header">
        <h1>City Church</h1>
        <div class="user-info">
            <span>Welcome, <%= user.getUsername() %> <span class="badge">Leader</span></span>
            <div class="nav-links">
                <a href="home.jsp">Home</a>
                <a href="notification.jsp" class="active">Notifications</a>
                <a href="logout">Logout</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        
        <div class="two-column">
            
            <div class="card">
                <h3>Send via WebSocket</h3>
                <span class="websocket-badge">Real-time</span>
                
                <%
                    String wsError = (String) request.getAttribute("wsError");
                    String wsSuccess = (String) request.getAttribute("wsSuccess");
                    if (wsError != null) {
                %>
                    <div class="error"><%= wsError %></div>
                <%
                    }
                    if (wsSuccess != null) {
                %>
                    <div class="success"><%= wsSuccess %></div>
                <%
                    }
                %>
                
                <form action="sendMessage" method="post">
                    <div class="form-group">
                        <label for="wsCategory">Category</label>
                        <select id="wsCategory" name="category" required>
                            <option value="General">General</option>
                            <option value="Service">Service</option>
                            <option value="Event">Event</option>
                            <option value="Ministry">Ministry</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="wsMessage">Message</label>
                        <textarea id="wsMessage" name="message" placeholder="Type your notification here..." required></textarea>
                    </div>
                    
                    <input type="submit" value="Send via WebSocket" class="btn-websocket">
                </form>
                
                <div style="margin-top:15px; padding:12px 16px; background:var(--background-input); border-radius:8px; border-left:4px solid var(--primary-color);">
                    <small style="color:var(--text-secondary); font-size:14px;">
                        WebSocket: Instant delivery to all connected members.
                    </small>
                </div>
            </div>
            
            <div class="card">
                <h3>Send via JMS</h3>
                <span class="jms-badge">Reliable &amp; Persistent</span>
                
                <%
                    String jmsError = (String) request.getAttribute("jmsError");
                    String jmsSuccess = (String) request.getAttribute("jmsSuccess");
                    if (jmsError != null) {
                %>
                    <div class="error"><%= jmsError %></div>
                <%
                    }
                    if (jmsSuccess != null) {
                %>
                    <div class="success"><%= jmsSuccess %></div>
                <%
                    }
                %>
                
                <form action="sendJMSMessage" method="post">
                    <div class="form-group">
                        <label for="jmsCategory">Category</label>
                        <select id="jmsCategory" name="category" required>
                            <option value="General">General</option>
                            <option value="Service">Service</option>
                            <option value="Event">Event</option>
                            <option value="Ministry">Ministry</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="jmsMessage">Message</label>
                        <textarea id="jmsMessage" name="message" placeholder="Type your notification here..." required></textarea>
                    </div>
                    
                    <input type="submit" value="Send via JMS" class="btn-jms">
                </form>
                
                <div style="margin-top:15px; padding:12px 16px; background:var(--background-input); border-radius:8px; border-left:4px solid #2ea043;">
                    <small style="color:var(--text-secondary); font-size:14px;">
                        JMS: Reliable delivery with message persistence.
                    </small>
                </div>
            </div>
            
        </div>
        
        <hr class="divider">
        
        <div class="card">
            <h3>Notification Categories</h3>
            <div class="legend-box">
                <div class="legend-item">
                    <span class="legend-color service"></span>
                    Service
                </div>
                <div class="legend-item">
                    <span class="legend-color event"></span>
                    Event
                </div>
                <div class="legend-item">
                    <span class="legend-color ministry"></span>
                    Ministry
                </div>
                <div class="legend-item">
                    <span class="legend-color general"></span>
                    General
                </div>
            </div>
        </div>
        
        <!-- RECENT NOTIFICATIONS -->
        <div class="card">
            <h3>Recent Notifications</h3>
            <div id="notifications" class="notification-container">
                <div class="empty">Loading notifications...</div>
            </div>
            <div class="status">Status: <span id="connectionStatus">Connecting...</span></div>
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