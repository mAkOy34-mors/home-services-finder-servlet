<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userId = (String) session.getAttribute("userID");
    boolean hasUnreadMessages = false;
    String senderId = null;
    String senderName = null;
    String messageText = null;
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    if (userId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql:///MyProject", "root", "");
            String sql = "SELECT m.sender_id, m.message, m.timestamp, m.is_read, u.name " +
                         "FROM messages m " +
                         "JOIN userRegistration u ON m.sender_id = u.userID " +
                         "WHERE m.receiver_id = ? AND m.is_read = false " +
                         "ORDER BY m.timestamp DESC LIMIT 1";
            ps = conn.prepareStatement(sql);
            ps.setString(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                hasUnreadMessages = true;
                senderId = rs.getString("sender_id");
                senderName = rs.getString("name");
                messageText = rs.getString("message");
            }
        } catch (Exception e) {
            out.println("<div class='error-message'>Error checking messages: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
%>

<% if (hasUnreadMessages) { %>
    <div id="notificationPopup" class="notification-popup fade-in">
        <div class="notification-content">
            <h3 id="notificationHeader">New Message from <%= senderName != null && !senderName.isEmpty() ? senderName : "Unknown User" %>!</h3>
            <p class="message-preview">
                <%= messageText != null ? (messageText.length() > 100 ? messageText.substring(0, 100) + "..." : messageText) : "No message content" %>
            </p>
            <p>Would you like to reply or dismiss?</p>
            <div class="notification-actions">
                <form action="chat.jsp" method="get" style="display: inline;">
                    <input type="hidden" name="chatPartnerId" value="<%= senderId != null ? senderId : "" %>"/>
                    <input type="hidden" name="SenderName" value="<%= senderName != null ? senderName : "" %>"/>
                    <button type="submit" class="notification-btn reply-btn">
                        <i class="fas fa-reply"></i> Reply
                    </button>
                </form>
                <button class="notification-btn dismiss-btn" onclick="dismissNotification()">
                    <i class="fas fa-times"></i> Dismiss
                </button>
            </div>
        </div>
    </div>

    <style>
        .notification-popup {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            padding: 20px;
            max-width: 350px;
            z-index: 2000;
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideInBottom 0.5s ease-out;
            display: none;
        }

        .notification-content h3 {
            color: #2d3748;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .notification-content p {
            color: #4a5568;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .message-preview {
            background: rgba(247, 250, 252, 0.8);
            padding: 10px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            font-style: italic;
            word-wrap: break-word;
            max-height: 100px;
            overflow-y: auto;
        }

        .notification-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .notification-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .reply-btn {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .reply-btn:hover {
            background: linear-gradient(135deg, #5a67d8, #6b46c1);
            transform: translateY(-2px);
        }

        .dismiss-btn {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
        }

        .dismiss-btn:hover {
            background: linear-gradient(135deg, #e53e3e, #c05621);
            transform: translateY(-2px);
        }

        @keyframes slideInBottom {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in {
            animation: slideInBottom 0.5s ease-out;
        }

        @keyframes slideOutBottom {
            from {
                opacity: 1;
                transform: translateY(0);
            }
            to {
                opacity: 0;
                transform: translateY(50px);
            }
        }
    </style>

    <script>
        // Store the current notification data to avoid redundant updates
        let currentNotification = {
            senderId: null,
            senderName: null,
            messageText: null
        };

        // Store the constant header name that won't change
        let constantSenderName = null;

        document.addEventListener('DOMContentLoaded', function () {
            const popup = document.getElementById('notificationPopup');
            if (popup) {
                popup.style.display = 'block';
                // Initialize current notification with initial values
                currentNotification.senderId = '<%= senderId != null ? senderId : "" %>';
                currentNotification.senderName = '<%= senderName != null ? senderName : "Unknown" %>';
                currentNotification.messageText = '<%= messageText != null ? messageText : "No message content" %>';
                
                // Set the constant sender name from the first message
                constantSenderName = currentNotification.senderName;
            }
            // Start periodic message check
            setInterval(checkForNewMessages, 5000); // Increased to 5 seconds to reduce server load
        });

        // Store dismissed messages to prevent re-showing
        let dismissedMessages = new Set();

        function dismissNotification() {
            const popup = document.getElementById('notificationPopup');
            if (popup) {
                popup.style.animation = 'slideOutBottom 0.5s ease-out';
                setTimeout(() => {
                    popup.style.display = 'none';
                }, 500);
                
                // Add current message to dismissed set
                if (currentNotification.senderId && currentNotification.messageText) {
                    const messageKey = currentNotification.senderId + ':' + currentNotification.messageText;
                    dismissedMessages.add(messageKey);
                }
                
                // Reset current notification and constant sender name
                currentNotification = { senderId: null, senderName: null, messageText: null };
                constantSenderName = null;
            }
        }

        function checkForNewMessages() {
            fetch('CheckNotif')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Received data:', data); // Debug line
                    if (data.hasUnreadMessages) {
                        // Validate data before showing notification
                        if (data.senderId && data.senderName && data.messageText) {
                            // Create message key to check if it was dismissed
                            const messageKey = data.senderId + ':' + data.messageText;
                            
                            // Don't show if message was already dismissed
                            if (dismissedMessages.has(messageKey)) {
                                return;
                            }
                            
                            // Check if the message is different from the current one
                            if (data.senderId !== currentNotification.senderId ||
                                data.senderName !== currentNotification.senderName ||
                                data.messageText !== currentNotification.messageText) {
                                showNotification(data.senderId, data.senderName, data.messageText);
                                // Update current notification
                                currentNotification.senderId = data.senderId;
                                currentNotification.senderName = data.senderName;
                                currentNotification.messageText = data.messageText;
                            }
                        } else {
                            console.warn('Invalid message data:', data);
                        }
                    }
                })
                .catch(error => console.error('Error fetching messages:', error));
        }

        function showNotification(senderId, senderName, messageText) {
            const popup = document.getElementById('notificationPopup');
            if (popup) {
                // Set constant sender name only if it's not already set (first message)
                if (!constantSenderName) {
                    const displayName = (typeof senderName === 'string' && senderName.trim() && senderName !== 'false') 
                        ? senderName.trim() 
                        : 'Unknown';
                    constantSenderName = displayName;
                    // Update the header with the constant sender name
                    popup.querySelector('#notificationHeader').innerText = `New Message from ${constantSenderName}!`;
                }
                // Note: We don't update the header for subsequent messages - it stays constant

                // Update only the message content (not the header)
                const displayMessage = (typeof messageText === 'string' && messageText.trim()) 
                    ? messageText.trim() 
                    : 'No message content';
                popup.querySelector('.message-preview').innerText = 
                    displayMessage.length > 100 ? displayMessage.substring(0, 100) + '...' : displayMessage;

                // Update form inputs for reply button (use constant sender name)
                const form = popup.querySelector('form');
                if (form) {
                    form.querySelector('input[name="chatPartnerId"]').value = senderId || '';
                    form.querySelector('input[name="SenderName"]').value = constantSenderName;
                }

                // Show popup with animation
                popup.style.display = 'block';
                popup.style.animation = 'slideInBottom 0.5s ease-out';
            }
        }
    </script>
<% } %>