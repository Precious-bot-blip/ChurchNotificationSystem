package com.church.websocket;

import com.church.storage.MessageStorage;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import javax.websocket.OnClose;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/notifications")
public class NotificationWebSocket {
    
    private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
    private static MessageStorage messageStorage = MessageStorage.getInstance();
    
    @OnOpen
    public void onOpen(Session session) {
        sessions.add(session);
        System.out.println("WebSocket opened: " + session.getId());
        
        try {
            Map<String, String> messages = messageStorage.getAllMessagesWithTimestamps();
            for (String message : messages.values()) {
                session.getBasicRemote().sendText(message);
            }
        } catch (IOException e) {
            System.err.println("Error sending messages to new client: " + e.getMessage());
        }
    }
    
    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
        System.out.println("WebSocket closed: " + session.getId());
    }
    
    public static void broadcastMessage(String message) {
        messageStorage.addMessage(message, "General");
        
        synchronized (sessions) {
            for (Session session : sessions) {
                if (session.isOpen()) {
                    try {
                        session.getBasicRemote().sendText(message);
                    } catch (IOException e) {
                        System.err.println("Error broadcasting message: " + e.getMessage());
                        sessions.remove(session);
                    }
                }
            }
        }
    }
}