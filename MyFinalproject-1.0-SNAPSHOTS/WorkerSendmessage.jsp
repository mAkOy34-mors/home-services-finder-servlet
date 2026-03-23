<%@ page import="java.sql.*, java.util.*" %>

<%
    String userID = (String) session.getAttribute("userID");
    String withUser = request.getParameter("id");
    String Username = request.getParameter("name");
    if (userID == null || withUser== null) {
        response.sendRedirect("Login.jsp");
        return;
    } 
%> 
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Messages</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
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
                padding: 20px 30px;
                font-size: 24px;
                font-weight: 700;
                box-shadow: 0 8px 32px rgba(31, 38, 135, 0.1);
                z-index: 1000;
                display: flex;
                align-items: center;
                gap: 15px;
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

            .go-back-btn {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 50%;
                cursor: pointer;
                font-size: 16px;
                margin-right: 15px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }

            .go-back-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            }

            /* Replace your existing .sidebar CSS with this improved version */
            .sidebar {
                width: 260px;
                height: 100vh; /* Changed from max-height to height */
                background: rgba(45, 55, 72, 0.95);
                backdrop-filter: blur(20px);
                padding-top: 100px;
                padding-bottom: 20px; /* Add bottom padding */
                position: fixed;
                top: 0;
                left: 0;
                color: white;
                box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1);
                border-right: 1px solid rgba(255, 255, 255, 0.1);
                overflow-y: auto;
                overflow-x: hidden;
                transition: transform 0.3s ease;
                box-sizing: border-box; /* Ensure padding is included in height calculation */
            }

            /* Improve scrollbar styling for the sidebar */
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
                margin: 25px 0 15px 0;
                color: #a0aec0;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .sidebar a {
                display: flex;
                align-items: center;
                padding: 16px 25px;
                color: #e2e8f0;
                text-decoration: none;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border-left: 3px solid transparent;
                position: relative;
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
                transform: translateX(8px);
            }

            #messageNotification {
                position: absolute;
                top: 12px;
                right: 20px;
                background: linear-gradient(135deg, #ff6b6b, #ee5a24);
                color: white;
                border-radius: 50%;
                width: 20px;
                height: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                font-weight: bold;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% {
                    transform: scale(1);
                    box-shadow: 0 0 0 0 rgba(255, 107, 107, 0.7);
                }
                70% {
                    transform: scale(1.05);
                    box-shadow: 0 0 0 10px rgba(255, 107, 107, 0);
                }
                100% {
                    transform: scale(1);
                    box-shadow: 0 0 0 0 rgba(255, 107, 107, 0);
                }
            }

            .main {
                margin-left: 260px;
                padding: 100px 40px 40px 40px;
                min-height: 100vh;
            }

            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }

                .sidebar.open {
                    transform: translateX(0);
                }

                .main {
                    margin-left: 0;
                    padding: 100px 20px 40px 20px;
                }

                .menu-toggle {
                    display: block;
                    position: fixed;
                    top: 25px;
                    left: 20px;
                    z-index: 1001;
                    background: rgba(255, 255, 255, 0.9);
                    border: none;
                    border-radius: 8px;
                    padding: 10px;
                    cursor: pointer;
                    font-size: 18px;
                    color: #667eea;
                }
            }

            .menu-toggle {
                display: none;
            }

            #chatContainer {
                width: 100%;
                max-width: 500px;
                margin: 0 auto;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            #chatBox {
                border: none;
                border-radius: 0;
                height: 300px;
                overflow-y: auto;
                padding: 20px;
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                position: relative;
            }

            #chatBox::-webkit-scrollbar {
                width: 6px;
            }

            #chatBox::-webkit-scrollbar-track {
                background: rgba(255, 255, 255, 0.1);
                border-radius: 10px;
            }

            #chatBox::-webkit-scrollbar-thumb {
                background: linear-gradient(135deg, #667eea, #764ba2);
                border-radius: 10px;
            }

            .chat-message {
                max-width: 70%;
                margin: 15px 0;
                padding: 15px 20px;
                border-radius: 20px;
                display: inline-block;
                clear: both;
                position: relative;
                animation: messageSlide 0.3s ease-out;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            @keyframes messageSlide {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .me {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                float: right;
                text-align: right;
                border-bottom-right-radius: 5px;
            }

            .other {
                background: rgba(255, 255, 255, 0.9);
                color: #2d3748;
                float: left;
                text-align: left;
                border-bottom-left-radius: 5px;
                backdrop-filter: blur(10px);
            }

            #messageText {
                width: calc(100% - 110px);
                height: 60px;
                margin-top: 10px;
                border-radius: 25px;
                border: 2px solid #e2e8f0;
                padding: 15px 20px;
                resize: none;
                font-family: inherit;
                font-size: 14px;
                transition: all 0.3s ease;
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(10px);
            }

            #messageText:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            #sendBtn {
                height: 60px;
                width: 60px;
                padding: 0;
                margin-left: 15px;
                margin-top: 10px;
                border: none;
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                border-radius: 50%;
                cursor: pointer;
                font-size: 18px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }

            #sendBtn:hover {
                transform: translateY(-2px) scale(1.05);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }

            #inputArea {
                display: flex;
                margin-top: 0;
                padding: 20px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                gap: 10px;
                align-items: flex-end;
            }

            h2 {
                text-align: center;
                margin: 0;
                padding: 25px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                font-weight: 600;
                font-size: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            h2::before {
                content: '\f007';
                font-family: 'Font Awesome 6 Free';
                font-weight: 900;
            }

            #chatAndRatingContainer {
                display: flex;
                gap: 40px;
                justify-content: center;
                flex-wrap: wrap;
                max-width: 1000px;
                margin: 0 auto;
            }

            #chatContainer {
                flex: 1 1 500px;
                min-width: 300px;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            #ratingContainer {
                flex: 0 1 300px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                padding: 30px;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                text-align: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                height: fit-content;
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            #ratingContainer h3 {
                margin-bottom: 25px;
                color: #2d3748;
                font-weight: 600;
                font-size: 18px;
            }

            .star-rating {
                display: flex;
                justify-content: center;
                gap: 12px;
                font-size: 32px;
                cursor: pointer;
                user-select: none;
                margin-bottom: 25px;
                height: 50px;
            }

            .star-rating span {
                color: #e2e8f0;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                cursor: pointer;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .star-rating span:hover,
            .star-rating span.selected {
                color: #fbbf24;
                transform: scale(1.2);
                text-shadow: 0 4px 8px rgba(251, 191, 36, 0.3);
            }

            #submitRatingBtn {
                background: linear-gradient(135deg, #10b981, #059669);
                border: none;
                color: white;
                padding: 15px 30px;
                font-size: 16px;
                border-radius: 25px;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
                font-weight: 600;
            }

            #submitRatingBtn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
            }

            @media (max-width: 768px) {
                #chatAndRatingContainer {
                    flex-direction: column;
                    gap: 30px;
                    padding: 0 20px;
                }

                #chatContainer,
                #ratingContainer {
                    min-width: auto;
                    flex: unset;
                    max-width: 100%;
                }

                .navbar {
                    padding: 15px 60px 15px 20px;
                }
            }

            /* Loading animation */
            .loading {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 3px solid rgba(255, 255, 255, 0.3);
                border-radius: 50%;
                border-top-color: #fff;
                animation: spin 1s ease-in-out infinite;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }

            /* Notification styles */
            .notification {
                position: fixed;
                top: 100px;
                right: 20px;
                background: linear-gradient(135deg, #10b981, #059669);
                color: white;
                padding: 15px 20px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
                transform: translateX(100%);
                transition: transform 0.3s ease;
                z-index: 1001;
                font-weight: 600;
            }

            .notification.show {
                transform: translateX(0);
            }

            .notification.error {
                background: linear-gradient(135deg, #ef4444, #dc2626);
                box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
            }
        </style>
    </head>
    <body>
       

        <div class="navbar">
          
            <i class="fas fa-envelope"></i>
            Chat with Client
        </div>

         <div class="sidebar-overlay" onclick="closeMobileMenu()"></div>
        <div class="sidebar">
            <h4>Menu</h4>
            <a href="WorkerDashboard.jsp"  class="active"><i class="fas fa-home"></i>Dashboard</a>

            <h4>Submit</h4>
            <a href="register_worker.jsp"><i class="fas fa-clipboard-list"></i>Register As A Worker</a>

            <h4>Find</h4>
            <a href="find_works.jsp"><i class="fas fa-search-location"></i>Find Available Jobs</a>

            <h4>Account</h4>
            <a href="WorkerDeleteDetails.jsp"><i class="fas fa-user-circle"></i>Manage Details</a>
             <a href="WorkerProfileInformation.jsp"><i class="fas fa-user-cog"></i>Manage Profiles</a>
            <a href="messages.jsp" style="position: relative;">
                <i class="fas fa-envelope"></i> Messages
                <span id="messageNotification">!</span>
            </a>
            <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>

        <div class="main">
            <div id="chatAndRatingContainer">
                <div id="chatContainer">
                    <h2>Chat with: <%= Username%></h2>
                    <div id="chatBox"></div>
                    <div id="inputArea">
                        <textarea id="messageText" placeholder="Type your message here"></textarea>
                        <button id="sendBtn" onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
                    </div>
                </div>

                
            </div>
        </div>

       

        <script>
        

            const userId = "<%= userID%>";
            const withUser = "<%= withUser%>";

            function sendMessage() {
                const message = document.getElementById("messageText").value;
                if (message.trim() === "")
                    return;

                const xhr = new XMLHttpRequest();
                xhr.open("POST", "SendMessage", true);
                xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xhr.onload = function () {
                    document.getElementById("messageText").value = "";
                    fetchMessages();
                };
                xhr.send("receiver_id=" + encodeURIComponent(withUser) + "&message=" + encodeURIComponent(message));
            }
            let previousContent = "";

            function fetchMessages() {
                const xhr = new XMLHttpRequest();
                xhr.open("GET", "GetMessages?with=" + withUser, true);
                xhr.onload = function () {
                    const box = document.getElementById("chatBox");

                    if (this.responseText !== previousContent) {
                        previousContent = this.responseText;
                        box.innerHTML = this.responseText;

                        requestAnimationFrame(() => {
                            box.scrollTop = box.scrollHeight;
                        });
                    }
                };
                xhr.send();
            }



            // Go back functionality
            function goBack() {
                if (document.referrer) {
                    window.history.back();
                } else {
                    window.location.href = 'ClientMessages.jsp';
                }
            }

            // Mobile sidebar toggle
            function toggleSidebar() {
                document.getElementById('sidebar').classList.toggle('open');
            }

            // Close sidebar when clicking outside on mobile
            document.addEventListener('click', function (event) {
                const sidebar = document.getElementById('sidebar');
                const menuToggle = document.querySelector('.menu-toggle');

                if (window.innerWidth <= 768) {
                    if (!sidebar.contains(event.target) && !menuToggle.contains(event.target)) {
                        sidebar.classList.remove('open');
                    }
                }
            });

            // Notification system
            function showNotification(message, type = 'success') {
                const notification = document.getElementById('notification');
                notification.textContent = message;
                notification.className = `notification ${type}`;
                notification.classList.add('show');

                setTimeout(() => {
                    notification.classList.remove('show');
                }, 3000);
            }

            // Enhanced message refresh
            setInterval(fetchMessages, 3000);
            window.onload = fetchMessages;

            // Enter key to send message
            document.getElementById('messageText').addEventListener('keypress', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });
        </script>
    </body>
</html>