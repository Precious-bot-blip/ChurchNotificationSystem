package com.church.jms;

import com.church.websocket.NotificationWebSocket;
import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.JMSException;
import javax.jms.MessageProducer;
import javax.jms.Queue;
import javax.jms.Session;
import javax.jms.TextMessage;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

public class JMSProducer {
    
    private ConnectionFactory connectionFactory;
    private Queue notificationQueue;
    private boolean jmsAvailable = false;
    
    public JMSProducer() {
        try {
            Context ctx = new InitialContext();
            connectionFactory = (ConnectionFactory) ctx.lookup("jms/ChurchConnectionFactory");
            notificationQueue = (Queue) ctx.lookup("jms/ChurchNotificationQueue");
            jmsAvailable = true;
            System.out.println("JMS resources initialized successfully!");
        } catch (NamingException e) {
            System.err.println("JMS resources not available: " + e.getMessage());
            jmsAvailable = false;
        }
    }
    
    public void sendNotification(String message) {
        if (!jmsAvailable) {
            System.err.println("JMS not available. Sending via WebSocket only.");
            NotificationWebSocket.broadcastMessage(message);
            return;
        }
        
        Connection connection = null;
        Session session = null;
        MessageProducer producer = null;
        
        try {
            connection = connectionFactory.createConnection();
            connection.start();
            
            session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
            producer = session.createProducer(notificationQueue);
            
            TextMessage textMessage = session.createTextMessage(message);
            producer.send(textMessage);
            
            System.out.println("JMS Message sent: " + message);
            
        } catch (JMSException e) {
            System.err.println("JMS Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (producer != null) producer.close();
                if (session != null) session.close();
                if (connection != null) connection.close();
            } catch (JMSException e) {
                System.err.println("Error closing JMS resources: " + e.getMessage());
            }
        }
    }
}