<%@ page import="java.sql.*, java.util.*" %>

<%
    String userID = (String) session.getAttribute("userID");
    String withUser = request.getParameter("chatPartnerId");
    String SenderName = request.getParameter("SenderName");
    if (userID == null || withUser == null) {
        response.sendRedirect("ClientLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Client Messages</title>
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
                padding: 20px 30px 20px 80px;
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
                transform: translateX(0); /* Default: visible on desktop */
            }

            /* Hide sidebar on mobile by default */
            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }

                .sidebar.mobile-open {
                    transform: translateX(0);
                }
            }

            /* Desktop: sidebar can be toggled */
            @media (min-width: 769px) {
                .sidebar.desktop-hidden {
                    transform: translateX(-100%);
                }
            }


            .main {
                margin-left: 260px;
                padding: 70px 40px 40px 40px;
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
                height: 280px;
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
                transition: all 0.3s ease;
                cursor: pointer;
                user-select: none;
                word-wrap: break-word;
                word-break: break-word;
                overflow-wrap: break-word;
                white-space: pre-wrap;
                hyphens: auto;
                box-sizing: border-box;
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
                cursor: pointer;
            }

            .me:hover {
                cursor: pointer;
            }

            .other {
                background: rgba(255, 255, 255, 0.9);
                color: #2d3748;
                float: left;
                text-align: left;
                border-bottom-left-radius: 5px;
                backdrop-filter: blur(10px);
                cursor: default;
            }

            #messageText {
                width: calc(100% - 110px);
                height: 30px;
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
                margin-top: 10px;
            }

            #chatContainer {
                flex: 1 1 450px;
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

            .delete-btn {
                position: absolute;
                top: -35px;
                right: 10px;
                background: rgba(239, 68, 68, 0.9);
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 18px;
                font-size: 12px;
                cursor: pointer;
                opacity: 0;
                visibility: hidden;
                transition: all 0.3s ease;
                z-index: 10;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 6px;
                box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
            }

            .me.selected .delete-btn {
                opacity: 1;
                visibility: visible;
                animation: deleteButtonSlide 0.3s ease-out;
            }

            @keyframes deleteButtonSlide {
                from {
                    opacity: 0;
                    transform: translateY(10px) scale(0.8);
                }
                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .delete-btn:hover {
                background: rgba(220, 38, 38, 0.95);
                transform: scale(1.05);
                box-shadow: 0 6px 20px rgba(239, 68, 68, 0.5);
            }


            .notification {
                position: fixed;
                top: 20px;
                left: 50%;
                transform: translateX(-50%) translateY(-100%);
                padding: 15px 25px;
                border-radius: 10px;
                color: black;
                font-weight: 600;
                z-index: 2000;
                opacity: 0;
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                min-width: 300px;
                text-align: center;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
                backdrop-filter: blur(10px);
            }

            .notification.show {
                opacity: 1;
                transform: translateX(-50%) translateY(0);
            }

            .notification.success {
                background: linear-gradient(135deg, #60a5fa, #3b82f6);
                color: black;
                border: 1px solid rgba(96, 165, 250, 0.4);
            }

            .notification.error {
                background: linear-gradient(135deg, #60a5fa, #3b82f6);
                color: black;
                border: 1px solid rgba(96, 165, 250, 0.4);
            }

            /* Add slide-in animation */
            @keyframes slideInFromTop {
                from {
                    opacity: 0;
                    transform: translateX(-50%) translateY(-100%);
                }
                to {
                    opacity: 1;
                    transform: translateX(-50%) translateY(0);
                }
            }

            .notification.show {
                animation: slideInFromTop 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            }

            .me.selected {
                background: linear-gradient(135deg, #4c51bf, #553c9a);
                transform: scale(1.02);
                box-shadow: 0 6px 20px rgba(76, 81, 191, 0.4);
                border: 2px solid rgba(255, 255, 255, 0.5);
            }

            .me.selected::after {
                content: '\f00c';
                font-family: 'Font Awesome 6 Free';
                font-weight: 900;
                position: absolute;
                top: -8px;
                right: -8px;
                background: #10b981;
                color: white;
                border-radius: 50%;
                width: 20px;
                height: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                border: 2px solid white;
            }

            .sidebar-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 999;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .sidebar-overlay.show {
                display: block;
                opacity: 1;
            }

            .sidebar.collapsed ~ * .navbar {
                padding-left: 80px;
            }

            
            @media (max-width: 768px) {
                .navbar {
                    padding: 15px 20px 15px 70px;
                }

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

                .notification {
                    left: 20px;
                    right: 20px;
                    transform: translateY(-100%);
                    min-width: auto;
                    max-width: calc(100% - 40px);
                }

                .notification.show {
                    transform: translateY(0);
                }
            }
            #imageInput {
                display: none;
            }

            #imagePreview {
                max-width: 100px;
                max-height: 100px;
                border-radius: 10px;
                margin: 10px 0;
                display: none;
            }

            #imageUploadBtn {
                height: 60px;
                width: 60px;
                padding: 0;
                margin-left: 10px;
                border: none;
                background: linear-gradient(135deg, #10b981, #059669);
                color: white;
                border-radius: 50%;
                cursor: pointer;
                font-size: 18px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
            }

            #imageUploadBtn:hover {
                transform: translateY(-2px) scale(1.05);
                box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
            }

            .chat-message img {
                max-width: 200px;
                border-radius: 10px;
                margin-top: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }
            #imagePreviewContainer {
                position: relative;
                display: none;
                margin: 10px 0;
            }

            #imagePreview {
                max-width: 100px;
                max-height: 100px;
                border-radius: 10px;
                display: block;
            }

            #cancelImageBtn {
                position: absolute;
                top: 0;
                right: 8px;
                background: #ef4444;
                color: white;
                border: none;
                border-radius: 50%;
                width: 20px;
                height: 20px;
                cursor: pointer;
                font-size: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 8px rgba(239, 68, 68, 0.4);
                transition: all 0.3s ease;
                transform: translateY(-50%);
            }

            #cancelImageBtn:hover {
                background: #dc2626;
                transform: translateY(-50%) scale(1.1);
            }
        </style>


    </head>
    <body> 
        <div class="navbar">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <div class="navbar-brand">
                <i class="fas fa-envelope"></i>
                Chat With Worker
            </div>
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
        <div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>
        <div class="main">
            <div id="chatAndRatingContainer">
                <div id="chatContainer">
                    <h2>Chat with: <%= SenderName%></h2>
                    <div id="chatBox"></div>
                    <div id="inputArea">
                        <textarea id="messageText" placeholder="Type your message here"></textarea>
                        <input type="file" id="imageInput" accept="image/jpeg,image/png,image/gif">
                        <button id="imageUploadBtn" onclick="document.getElementById('imageInput').click()">
                            <i class="fas fa-image"></i>
                        </button>
                        <button id="sendBtn" onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
                    </div>
                    <div id="imagePreviewContainer">
                        <img id="imagePreview" src="" alt="Image Preview">
                        <button id="cancelImageBtn" onclick="cancelImage()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>

                <div id="ratingContainer">
                    <h3>Rate This Worker</h3>
                    <div id="star-rating" class="star-rating">
                        <span data-value="1">&#9733;</span>
                        <span data-value="2">&#9733;</span>
                        <span data-value="3">&#9733;</span>
                        <span data-value="4">&#9733;</span>
                        <span data-value="5">&#9733;</span>
                    </div>
                    <input type="hidden" id="rating" name="rating" value="0">
                    <button id="submitRatingBtn" onclick="submitRating()">Submit Rating</button>
                </div>
            </div>
        </div>

        <div class="notification" id="notification"></div>

        <script>
            
            const stars = document.querySelectorAll('#star-rating span');
            const ratingInput = document.getElementById('rating');
            let selectedRating = 0;

            stars.forEach(star => {
                star.addEventListener('click', () => {
                    const value = parseInt(star.getAttribute('data-value'));
                    selectedRating = (value === selectedRating) ? 0 : value;
                    ratingInput.value = selectedRating;
                    updateStars();
                });

                star.addEventListener('mouseover', () => {
                    const hoverValue = parseInt(star.getAttribute('data-value'));
                    highlightStars(hoverValue);
                });

                star.addEventListener('mouseout', updateStars);
            });

            function updateStars() {
                stars.forEach(star => {
                    const value = parseInt(star.getAttribute('data-value'));
                    star.classList.toggle('selected', value <= selectedRating);
                });
            }

            function highlightStars(hoverValue) {
                stars.forEach(star => {
                    const value = parseInt(star.getAttribute('data-value'));
                    star.classList.toggle('selected', value <= hoverValue);
                });
            }

            function submitRating() {
                if (selectedRating === 0) {
                    showNotification("Please select a rating.", 'error');
                    return;
                }

                const xhr = new XMLHttpRequest();
                xhr.open("POST", "SubmitRating", true);
                xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xhr.onload = function () {
                    if (this.status === 200) {
                        showNotification("Rating submitted!", 'success');
                        selectedRating = 0;
                        ratingInput.value = 0;
                        updateStars();
                    } else {
                        showNotification("Error submitting rating.", 'error');
                    }
                };
                xhr.onerror = function () {
                    showNotification("Connection error. Could not submit rating.", 'error');
                };
                xhr.send("worker_id=" + encodeURIComponent("<%= withUser%>") + "&rating=" + selectedRating);
            }

            // CHAT FUNCTIONALITY
            const userId = "<%= userID%>";
            const withUser = "<%= withUser%>";
            const imageInput = document.getElementById('imageInput');
            const imagePreview = document.getElementById('imagePreview');

            imageInput.addEventListener('change', function () {
                const file = this.files[0];
                if (file) {
                    if (file.size > 10 * 1024 * 1024) { // 10MB limit
                        showNotification("Image size must be less than 10MB.", "error");
                        imageInput.value = "";
                        imagePreview.style.display = 'none';
                        imagePreview.src = '';
                    } else {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            imagePreview.src = e.target.result;
                            imagePreview.style.display = 'block';
                        };
                        reader.readAsDataURL(file);
                    }
                } else {
                    imagePreview.style.display = 'none';
                    imagePreview.src = '';
                }
            });

            function sendMessage() {
                const message = document.getElementById("messageText").value;
                const imageInput = document.getElementById("imageInput");
                const sendBtn = document.getElementById("sendBtn");
                const formData = new FormData();
                formData.append("receiver_id", "<%= withUser%>");
                formData.append("message", message);

                if (imageInput.files[0]) {
                    formData.append("image", imageInput.files[0]);
                }

                if (message.trim() === "" && !imageInput.files[0]) {
                    showNotification("Please enter a message or select an image.", "error");
                    return;
                }

                sendBtn.innerHTML = '<span class="loading"></span>';
                const xhr = new XMLHttpRequest();
                xhr.open("POST", "SendMessage", true);
                xhr.onload = function () {
                    sendBtn.innerHTML = '<i class="fas fa-paper-plane"></i>';
                    if (xhr.status === 200) {
                        document.getElementById("messageText").value = "";
                        imageInput.value = "";
                        imagePreview.style.display = 'none';
                        imagePreview.src = '';
                        imagePreviewContainer.style.display = 'none';
                        imagePreview.src = '';
                        fetchMessages();
                        showNotification("Message sent successfully!", "success");
                    } else {
                        showNotification(xhr.responseText || "Error sending message.", "error");
                    }
                };
                xhr.onerror = function () {
                    sendBtn.innerHTML = '<i class="fas fa-paper-plane"></i>';
                    showNotification("Connection error. Could not send message.", "error");
                };
                xhr.send(formData);
            }

            let previousContent = "";
            let selectedMessage = null;

            function fetchMessages() {
                const xhr = new XMLHttpRequest();
                xhr.open("GET", "GetMessages?with=" + withUser, true);
                xhr.onload = function () {
                    const box = document.getElementById("chatBox");
                    if (this.responseText !== previousContent) {
                        previousContent = this.responseText;
                        box.innerHTML = this.responseText;
                        addMessageClickHandlers();
                        requestAnimationFrame(() => {
                            box.scrollTop = box.scrollHeight;
                        });
                    }
                };
                xhr.onerror = function () {
                    showNotification("Error fetching messages.", "error");
                };
                xhr.send();
            }

            function addMessageClickHandlers() {
                const userMessages = document.querySelectorAll('.chat-message.me');

                userMessages.forEach(message => {

                    const existingBtn = message.querySelector('.delete-btn');
                    const existingHint = message.querySelector('.click-hint');
                    if (existingBtn)
                        existingBtn.remove();
                    if (existingHint)
                        existingHint.remove();

                    // Create delete button
                    const deleteBtn = document.createElement('button');
                    deleteBtn.className = 'delete-btn';
                    deleteBtn.innerHTML = '<i class="fas fa-trash"></i> ';
                    deleteBtn.onclick = function (e) {
                        e.stopPropagation();
                        deleteMessage(message.getAttribute('data-message-id'));
                    };
                    message.appendChild(deleteBtn);

                    // Add click handler for selection
                    message.onclick = function (e) {
                        e.stopPropagation();
                        toggleMessageSelection(message);
                    };
                });

                // Add click handler to chat box to deselect messages
                document.getElementById('chatBox').onclick = function (e) {
                    if (e.target === this) {
                        deselectAllMessages();
                    }
                };
            }

            function toggleMessageSelection(message) {
                // Deselect other messages first
                const allMessages = document.querySelectorAll('.chat-message.me');
                allMessages.forEach(msg => {
                    if (msg !== message) {
                        msg.classList.remove('selected');
                    }
                });

                // Toggle selection of clicked message
                if (message.classList.contains('selected')) {
                    message.classList.remove('selected');
                    selectedMessage = null;
                } else {
                    message.classList.add('selected');
                    selectedMessage = message;
                }
            }

            function deselectAllMessages() {
                const allMessages = document.querySelectorAll('.chat-message.me.selected');
                allMessages.forEach(message => {
                    message.classList.remove('selected');
                });
                selectedMessage = null;
            }

            function deleteMessage(messageId) {
                if (!confirm('Are you sure you want to delete this message?')) {
                    return;
                }

                const xhr = new XMLHttpRequest();
                xhr.open("POST", "DeleteMessage", true);
                xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xhr.onload = function () {
                    if (xhr.status === 200 && !xhr.responseText.includes("Error")) {
                        showNotification("Message deleted successfully.", "success");
                        selectedMessage = null;
                        fetchMessages();
                    } else {
                        showNotification(xhr.responseText || "Failed to delete message.", "error");
                    }
                };
                xhr.onerror = function () {
                    showNotification("Connection error. Could not delete message.", "error");
                };
                xhr.send("message_id=" + encodeURIComponent(messageId));
            }

            // NOTIFICATION SYSTEM
            function showNotification(message, type = 'success') {
                const existingNotifications = document.querySelectorAll('.notification');
                existingNotifications.forEach(notif => notif.remove());

                const notification = document.createElement('div');
                notification.className = `notification ${type}`;
                notification.innerHTML = message; // Use innerHTML to support retry button
                document.body.appendChild(notification);

                setTimeout(() => {
                    notification.classList.add('show');
                }, 100);

                setTimeout(() => {
                    notification.classList.remove('show');
                    setTimeout(() => {
                        if (notification.parentNode) {
                            notification.remove();
                        }
                    }, 300);
                }, 4000);
            }

            // SIDEBAR TOGGLE
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

            // INITIALIZATION
            setInterval(fetchMessages, 3000);
            window.onload = fetchMessages;

            document.getElementById('messageText').addEventListener('keypress', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });
            function cancelImage() {
                const imageInput = document.getElementById('imageInput');
                const imagePreview = document.getElementById('imagePreview');
                const imagePreviewContainer = document.getElementById('imagePreviewContainer');

                imageInput.value = "";
                imagePreview.src = "";
                imagePreviewContainer.style.display = 'none';

                showNotification("Image selection cancelled.", "success");
            }


            imageInput.addEventListener('change', function () {
                const file = this.files[0];
                const imagePreviewContainer = document.getElementById('imagePreviewContainer');

                if (file) {
                    if (file.size > 10 * 1024 * 1024) { // 10MB limit
                        showNotification("Image size must be less than 10MB.", "error");
                        imageInput.value = "";
                        imagePreviewContainer.style.display = 'none';
                        imagePreview.src = '';
                    } else {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            imagePreview.src = e.target.result;
                            imagePreviewContainer.style.display = 'block';
                        };
                        reader.readAsDataURL(file);
                    }
                } else {
                    imagePreviewContainer.style.display = 'none';
                    imagePreview.src = '';
                }
            });


            document.getElementById('imagePreviewContainer').style.display = 'none';
        </script> 
    </body>
</html>