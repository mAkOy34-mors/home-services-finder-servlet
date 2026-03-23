<%@page import="java.sql.*"%>
<%@page import="javax.naming.*"%>
<%@page import="javax.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String userId = (String) session.getAttribute("userID");
    if (userId == null) {
        response.sendRedirect("ClientLogin.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Messages</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            line-height: 1.6;
        }

        .navbar {
                position: fixed;
                width: 100%;
                top: 0;
                left: 0;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                color: #2d3748;
                padding: 20px 30px 10px 80px;
                font-size: 24px;
                font-weight: 700;
                box-shadow: 0 8px 32px rgba(31, 38, 135, 0.1);
                z-index: 1100;
                display: flex;
                align-items: center;
                gap: 15px;
                transition: padding-left 0.3s ease;
            }

            @media (max-width: 768px) {
                .navbar {
                    padding: 15px 20px 15px 70px;
                }
            }

        .navbar::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(103, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            z-index: -1;
        }

        .navbar i {
            color: #667eea;
            font-size: 28px;
        }

         .sidebar {
                width: 260px;
                height: 100vh;
                background: rgba(45, 55, 72, 0.95);
                backdrop-filter: blur(20px);
                padding-top: 80px;
                padding-bottom: 20px;
                position: fixed;
                top: 0;
                left: 0;
                color: white;
                box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1);
                border-right: 1px solid rgba(255, 255, 255, 0.1);
                overflow-y: auto;
                overflow-x: hidden;
                transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-sizing: border-box;
                z-index: 1000;
                transform: translateX(0); 
            }

          
            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }

                .sidebar.mobile-open {
                    transform: translateX(0);
                }
            }

            
            @media (min-width: 769px) {
                .sidebar.desktop-hidden {
                    transform: translateX(-100%);
                }
            }

            /* Main content area */
            .main {
                margin-left: 260px;
                padding: 100px 40px 40px 40px;
                min-height: 100vh;
                transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            @media (max-width: 768px) {
                .main {
                    margin-left: 0;
                    padding: 100px 20px 40px 20px;
                }
            }

            @media (min-width: 769px) {
                .main.expanded {
                    margin-left: 0;
                }
            }
            .menu-toggle {
                display: block !important;
                position: fixed;
                top: 10px;
                left: 10px;
                z-index: 1200;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border: 2px solid rgba(102, 126, 234, 0.2);
                border-radius: 12px;
                padding: 12px;
                cursor: pointer;
                font-size: 18px;
                color: #667eea;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .menu-toggle:hover {
                background: rgba(102, 126, 234, 0.1);
                border-color: #667eea;
                transform: scale(1.05);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.2);
            }

            .menu-toggle:active {
                transform: scale(0.95);
            }
            .menu-toggle.open .fa-bars::before {
            content: '\f00d';
        }

        .sidebar::-webkit-scrollbar {
                width: 8px;
            }

            .sidebar::-webkit-scrollbar-track {
                background: rgba(255, 255, 255, 0.1);
                border-radius: 10px;
            }

            .sidebar::-webkit-scrollbar-thumb {
                background: linear-gradient(135deg, #667eea, #764ba2);
                border-radius: 10px;
            }

            .sidebar::-webkit-scrollbar-thumb:hover {
                background: linear-gradient(135deg, #5a67d8, #6b46c1);
            }

        .sidebar h4 {
            padding: 0 25px;
            font-weight: 600;
            margin: 20px 0 10px 0;
            color: #a0aec0;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            color: #e2e8f0;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-left: 3px solid transparent;
            position: relative;
            overflow: hidden;
        }

        .sidebar a::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 0;
            height: 100%;
            background: linear-gradient(90deg, rgba(103, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            transition: width 0.3s ease;
            z-index: -1;
        }

        .sidebar a:hover::before {
            width: 100%;
        }

        .sidebar a i {
            margin-right: 15px;
            width: 24px;
            text-align: center;
            font-size: 18px;
        }

        .sidebar a:hover {
            color: white;
            border-left-color: #667eea;
            transform: translateX(5px);
        }

        .sidebar a[href="ClientMessages.jsp"] {
            background: linear-gradient(90deg, rgba(103, 126, 234, 0.2), rgba(118, 75, 162, 0.2));
            border-left-color: #667eea;
            color: white;
        }

       

        .main {
            margin-left: 280px;
            padding: 120px 40px 40px 40px;
            min-height: 100vh;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .page-title {
            font-size: 42px;
            font-weight: 800;
            color: white;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            margin-bottom: 15px;
            position: relative;
        }

        .page-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 18px;
            font-weight: 400;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }

        .messages-container {
            max-width: 900px;
            margin: 0 auto;
        }

        .message {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 32px;
            margin: 24px 0;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
        }

        .message::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        .message.unread {
            background: rgba(255, 248, 220, 0.95);
            border-left: 6px solid #ff6b6b;
            animation: slideInRight 0.6s ease-out;
        }

        .message.unread::before {
            background: linear-gradient(90deg, #ff6b6b, #ee5a24);
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .message:hover {
            transform: translateY(-8px);
            box-shadow: 0 32px 64px rgba(0, 0, 0, 0.15);
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .sender-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .sender-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: bold;
            box-shadow: 0 8px 16px rgba(103, 126, 234, 0.3);
        }

        .sender-details h3 {
            color: #2d3748;
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .message-time {
            color: #718096;
            font-size: 14px;
            font-weight: 500;
            background: rgba(113, 128, 150, 0.1);
            padding: 8px 16px;
            border-radius: 20px;
            white-space: nowrap;
        }

        .message-content {
            color: #4a5568;
            font-size: 16px;
            line-height: 1.7;
            margin: 24px 0;
            padding: 20px;
            background: rgba(247, 250, 252, 0.8);
            border-radius: 16px;
            border-left: 4px solid #e2e8f0;
        }

        .message-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 24px;
        }

        .reply-btn {
            padding: 14px 28px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 8px 20px rgba(103, 126, 234, 0.3);
            display: flex;
            align-items: center;
            gap: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .reply-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(103, 126, 234, 0.4);
            background: linear-gradient(135deg, #5a67d8, #6b46c1);
        }

        .reply-btn:active {
            transform: translateY(0);
        }

        .no-messages {
            text-align: center;
            padding: 80px 40px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .no-messages i {
            font-size: 64px;
            color: #cbd5e0;
            margin-bottom: 24px;
        }

        .no-messages h3 {
            color: #4a5568;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .no-messages p {
            color: #718096;
            font-size: 16px;
        }

        .error-message {
            background: rgba(254, 226, 226, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(248, 113, 113, 0.3);
            border-radius: 16px;
            padding: 20px;
            margin: 20px 0;
            color: #c53030;
            font-weight: 500;
        }

        @media (max-width: 1024px) {
            .sidebar {
                width: 240px;
            }

            .main {
                margin-left: 240px;
                padding: 120px 30px 40px 30px;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }

            .sidebar.open {
                transform: translateX(0);
            }

            .main {
                margin-left: 0;
                padding: 120px 20px 40px 20px;
            }

            .navbar {
                padding: 15px 20px;
                font-size: 20px;
            }

            .page-title {
                font-size: 32px;
            }

            .message {
                padding: 24px;
                margin: 16px 0;
            }

            .message-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .sender-info {
                width: 100%;
            }

            .message-time {
                align-self: flex-end;
            }
        }

        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
         <button class="menu-toggle" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>
        <i class="fas fa-envelope"></i>
        Check Your Messages
    </div>

    <div class="sidebar">
        <h4>Menu</h4>
        <a href="ClientDashboard.jsp" class="active"><i class="fas fa-home"></i>Dashboard</a>

        <h4>Submit</h4>
        <a href="post_job.jsp"><i class="fas fa-plus-circle"></i>Post New Job</a>

        <h4>Find</h4>
        <a href="find_workers.jsp"><i class="fas fa-search-location"></i>Find Workers</a>

        <h4>Account</h4>
        <a href="ClientDeleteDetails.jsp"><i class="fas fa-user-circle"></i>View Details</a>
        <a href="ClientProfileInformation.jsp"><i class="fas fa-user-cog"></i>Manage Profiles</a>
        <a href="ClientMessages.jsp" style="position: relative;">
            <i class="fas fa-envelope"></i> Messages
            <span id="messageNotification">!</span>
        </a>
        <a href="ClientLogin.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main">
        <div class="page-header fade-in">
            <h1 class="page-title">Your Messages</h1>
            <p class="page-subtitle">Stay connected with your network</p>
        </div>

        <div class="messages-container">
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql:///MyProject", "root", "");

        // Mark messages as read
        String markRead = "UPDATE messages SET is_read = true WHERE receiver_id = ?";
        ps = conn.prepareStatement(markRead);
        ps.setString(1, userId);
        ps.executeUpdate();

        // Fetch messages
        String sql = "SELECT m.sender_id, m.message, m.timestamp, m.is_read, u.name " +
                     "FROM messages m " +
                     "JOIN userRegistration u ON m.sender_id = u.userID " +
                     "WHERE m.receiver_id = ? " +
                     "ORDER BY m.timestamp DESC";
        ps = conn.prepareStatement(sql);
        ps.setString(1, userId);
        rs = ps.executeQuery();

        boolean hasMessages = false;
        while (rs.next()) {
            hasMessages = true;
            String sender = rs.getString("sender_id");
            String senderName = rs.getString("name");
            String text = rs.getString("message");
            Timestamp time = rs.getTimestamp("timestamp");
            boolean unread = !rs.getBoolean("is_read");
            
            // Get first letter of sender name for avatar
            String avatarLetter = senderName.substring(0, 1).toUpperCase();
%>
            <div class="message <%= unread ? "unread" : "" %> fade-in">
                <div class="message-header">
                    <div class="sender-info">
                        <div class="sender-avatar"><%= avatarLetter %></div>
                        <div class="sender-details">
                            <h3><%= senderName %></h3>
                            <% if (unread) { %>
                                <span style="color: #ff6b6b; font-size: 12px; font-weight: 600; text-transform: uppercase;">● New Message</span>
                            <% } %>
                        </div>
                    </div>
                    <div class="message-time">
                        <i class="far fa-clock"></i> <%= time %>
                    </div>
                </div>
                
                <div class="message-content">
                    <%= text %>
                </div>
                
                <div class="message-actions">
                    <form action="ClientChat1.jsp" method="get">
                        <input type="hidden" name="chatPartnerId" value="<%= sender %>" />
                        <input type="hidden" name="SenderName" value="<%= senderName %>"/>
                        <button type="submit" class="reply-btn">
                            <i class="fas fa-reply"></i>
                            Reply
                        </button>
                    </form>
                </div>
            </div>
<%
        }
        
        if (!hasMessages) {
%>
            <div class="no-messages fade-in">
                <i class="far fa-envelope"></i>
                <h3>No Messages Yet</h3>
                <p>Your inbox is empty. Messages from workers will appear here.</p>
            </div>
<%
        }
    } catch (Exception e) {
%>
        <div class="error-message fade-in">
            <i class="fas fa-exclamation-triangle"></i>
            <strong>Error:</strong> <%= e.getMessage() %>
        </div>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
        </div>
    </div>

    <script>
        // Add smooth scroll behavior
        document.documentElement.style.scrollBehavior = 'smooth';
        
        // Add intersection observer for fade-in animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.animationDelay = `${Math.random() * 0.3}s`;
                    entry.target.classList.add('fade-in');
                }
            });
        }, observerOptions);

        // Observe all message elements
        document.querySelectorAll('.message').forEach(el => {
            observer.observe(el);
        });

        

function toggleSidebar() {
            const sidebar = document.querySelector('.sidebar');
            const main = document.querySelector('.main');
            const overlay = document.querySelector('.sidebar-overlay');
            const menuToggle = document.querySelector('.menu-toggle');
            if (window.innerWidth <= 768) {
                if (sidebar.classList.contains('mobile-open')) {
                    sidebar.classList.remove('mobile-open');
                    overlay.classList.remove('show');
                    menuToggle.classList.remove('open');
                    document.body.style.overflow = 'auto';
                } else {
                    sidebar.classList.add('mobile-open');
                    overlay.classList.add('show');
                    menuToggle.classList.add('open');
                    document.body.style.overflow = 'hidden';
                }
            } else {
                if (sidebar.classList.contains('desktop-hidden')) {
                    sidebar.classList.remove('desktop-hidden');
                    main.classList.remove('expanded');
                    menuToggle.classList.remove('open');
                } else {
                    sidebar.classList.add('desktop-hidden');
                    main.classList.add('expanded');
                    menuToggle.classList.add('open');
                }
            }
        }

        function closeSidebar() {
            const sidebar = document.querySelector('.sidebar');
            const overlay = document.querySelector('.sidebar-overlay');
            const menuToggle = document.querySelector('.menu-toggle');
            if (window.innerWidth <= 768) {
                sidebar.classList.remove('mobile-open');
                overlay.classList.remove('show');
                menuToggle.classList.remove('open');
                document.body.style.overflow = 'auto';
            }
        }

        window.addEventListener('resize', function () {
            const sidebar = document.querySelector('.sidebar');
            const main = document.querySelector('.main');
            const overlay = document.querySelector('.sidebar-overlay');
            const menuToggle = document.querySelector('.menu-toggle');
            if (window.innerWidth > 768) {
                sidebar.classList.remove('mobile-open');
                overlay.classList.remove('show');
                document.body.style.overflow = 'auto';
                if (!sidebar.classList.contains('desktop-hidden')) {
                    main.classList.remove('expanded');
                    menuToggle.classList.remove('open');
                }
            } else {
                sidebar.classList.remove('desktop-hidden');
                main.classList.remove('expanded');
                if (!sidebar.classList.contains('mobile-open')) {
                    overlay.classList.remove('show');
                    menuToggle.classList.remove('open');
                }
            }
        });

        document.addEventListener('click', function (event) {
            const sidebar = document.querySelector('.sidebar');
            const menuToggle = document.querySelector('.menu-toggle');
            const overlay = document.querySelector('.sidebar-overlay');
            if (window.innerWidth <= 768) {
                if (!sidebar.contains(event.target) &&
                    !menuToggle.contains(event.target) &&
                    sidebar.classList.contains('mobile-open')) {
                    closeSidebar();
                }
            }
        });

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape' && window.innerWidth <= 768) {
                closeSidebar();
            }
        });

    </script>
</body>
</html>