package com.church.storage;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class MessageStorage {
    private static MessageStorage instance = null;
    private Map<String, String> messages; 
    private DateTimeFormatter formatter;
    
    private MessageStorage() {
        messages = new LinkedHashMap<>();
        formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy hh:mm a");
        
        addMessage("Welcome to City Church Notification System!", "General");
        addMessage("Sunday service at 10:00 AM - All are welcome!", "Service");
        addMessage("Youth ministry meeting this Friday at 6:30 PM.", "Ministry");
        addMessage("Christmas Eve Service at 7:00 PM on December 24th!", "Event");
    }
    
    public static MessageStorage getInstance() {
        if (instance == null) {
            instance = new MessageStorage();
        }
        return instance;
    }
    
    public void addMessage(String message, String category) {
        if (message == null || message.trim().isEmpty()) {
            return;
        }
        
        String timestamp = LocalDateTime.now().format(formatter);
        String categoryTag = "";
        
        if (category != null && !category.trim().isEmpty() && !"General".equals(category)) {
            categoryTag = "[" + category.toUpperCase() + "] ";
        }
        
        messages.put(timestamp, categoryTag + message);
    }
    
    // Get all messages with timestamps
    public Map<String, String> getAllMessagesWithTimestamps() {
        return new LinkedHashMap<>(messages);
    }
    
    public List<String> getAllMessages() {
        List<String> result = new ArrayList<>();
        for (Map.Entry<String, String> entry : messages.entrySet()) {
            result.add(entry.getValue());
        }
        return result;
    }
    
    public int getMessageCount() {
        return messages.size();
    }
    
    public void clearMessages() {
        messages.clear();
    }
}