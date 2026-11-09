package com.church.storage;

import com.church.model.User;
import java.util.HashMap;
import java.util.Map;

public class UserStorage {
    private static UserStorage instance = null;
    private Map<String, User> users; 
    
    private UserStorage() {
        users = new HashMap<>();
        // Default leader for testing
        users.put("admin", new User("admin", "admin123", "leader"));
        // Default member for testing
        users.put("member1", new User("member1", "pass123", "member"));
    }
    
    public static UserStorage getInstance() {
        if (instance == null) {
            instance = new UserStorage();
        }
        return instance;
    }
    
    // Register a new user
    public boolean registerUser(String username, String password, String role) {
        if (users.containsKey(username)) {
            return false;
        }
        
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            return false;
        }
        
        users.put(username, new User(username, password, role));
        return true;
    }
    
    // Authenticate user
    public User authenticateUser(String username, String password) {
        User user = users.get(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }
    
    // Check if username exists
    public boolean userExists(String username) {
        return users.containsKey(username);
    }
    
    public User getUser(String username) {
        return users.get(username);
    }
    
    public Map<String, User> getAllUsers() {
        return users;
    }
}