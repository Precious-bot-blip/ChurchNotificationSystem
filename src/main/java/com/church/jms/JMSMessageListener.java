package com.church.jms;

import com.church.websocket.NotificationWebSocket;
import javax.ejb.MessageDriven;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

@MessageDriven(mappedName = "jms/ChurchNotificationQueue")
public class JMSMessageListener implements MessageListener {
    
    @Override
    public void onMessage(Message message) {
        try {
            if (message instanceof TextMessage) {
                TextMessage textMessage = (TextMessage) message;
                String messageText = textMessage.getText();
                
                System.out.println("JMS Message received: " + messageText);
                
                NotificationWebSocket.broadcastMessage(messageText);
            }
        } catch (JMSException e) {
            System.err.println("Error processing JMS message: " + e.getMessage());
            e.printStackTrace();
        }
    }
}