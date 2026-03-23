<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file ="notifications.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Client Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            :root {
                --primary: #3b82f6;
                --primary-dark: #2563eb;
                --primary-light: #93c5fd;
                --secondary: #64748b;
                --success: #10b981;
                --warning: #f59e0b;
                --danger: #ef4444;
                --dark: #1e293b;
                --light: #f8fafc;
                --white: #ffffff;
                --gray-50: #f9fafb;
                --gray-100: #f3f4f6;
                --gray-200: #e5e7eb;
                --gray-300: #d1d5db;
                --gray-400: #9ca3af;
                --gray-500: #6b7280;
                --gray-600: #4b5563;
                --gray-700: #374151;
                --gray-800: #1f2937;
                --gray-900: #111827;
                --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
                --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
                --radius: 0.5rem;
                --radius-lg: 0.75rem;
                --radius-xl: 1rem;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            @keyframes bgFlow {
                0%, 100% {
                    background-position: 0% 50%;
                }
                50% {
                    background-position: 100% 50%;
                }
            }

            @keyframes cardFloat {
                0%, 100% {
                    transform: translateY(0px);
                }
                50% {
                    transform: translateY(-5px);
                }
            }

            @keyframes shimmer {
                0% {
                    background-position: -200% 0;
                }
                100% {
                    background-position: 200% 0;
                }
            }

            @keyframes pulse {
                0% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.1);
                }
                100% {
                    transform: scale(1);
                }
            }

            body {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                background-size: 400% 400%;
                animation: bgFlow 15s ease infinite;
                display: flex;
                min-height: 100vh;
            }

            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="50" r="0.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
                opacity: 0.3;
                z-index: -1;
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

            .sidebar a.active {
                background: rgba(59, 130, 246, 0.1);
                color: #e2e8f0;
                border-left-color: var(--primary);
                font-weight: 500;
            }

            .main {
                margin-left: 250px;
                padding: 120px 40px 40px 40px;
                flex: 1;
                position: relative;
            }


            .card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                padding: 35px;
                border-radius: 20px;
                box-shadow:
                    0 25px 50px rgba(0, 0, 0, 0.15),
                    0 0 0 1px rgba(255, 255, 255, 0.2);
                margin-bottom: 30px;
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
                animation: cardFloat 6s ease-in-out infinite;
            }

            .card::before {
                content: '';
                position: absolute;
                top: 0;
                left: -200%;
                width: 200%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
                animation: shimmer 3s infinite;
            }

            .card:hover {
                transform: translateY(-8px) scale(1.02);
                box-shadow:
                    0 35px 70px rgba(0, 0, 0, 0.2),
                    0 0 0 1px rgba(255, 255, 255, 0.3);
            }

            .card h2, .card h3 {
                margin-top: 0;
                background: linear-gradient(135deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                font-weight: 700;
                position: relative;
                z-index: 1;
            }

            .card h2 {
                font-size: 2.2rem;
                margin-bottom: 15px;
            }

            .card h3 {
                font-size: 1.6rem;
                margin-bottom: 20px;
            }

            .card p {
                color: var(--gray-700);
                font-size: 1.1rem;
                line-height: 1.7;
                position: relative;
                z-index: 1;
            }

            .action-buttons {
                display: flex;
                gap: 20px;
                flex-wrap: wrap;
                margin-top: 20px;
            }

            .btn {
                padding: 15px 30px;
                border: none;
                border-radius: 15px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
                position: relative;
                overflow: hidden;
            }

            .btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }

            .btn:hover::before {
                left: 100%;
            }

            .btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
            }

            .btn:active {
                transform: translateY(-1px);
            }

            .btn-secondary {
                background: linear-gradient(135deg, #64748b, #475569);
                box-shadow: 0 8px 25px rgba(100, 116, 139, 0.3);
            }

            .btn-secondary:hover {
                box-shadow: 0 15px 35px rgba(100, 116, 139, 0.4);
            }

            .btn-danger {
                background: linear-gradient(135deg, #ef4444, #dc2626);
                box-shadow: 0 8px 25px rgba(239, 68, 68, 0.3);
            }

            .btn-danger:hover {
                box-shadow: 0 15px 35px rgba(239, 68, 68, 0.4);
            }

           

            ul {
                padding-left: 20px;
                position: relative;
                z-index: 1;
            }

            li {
                margin-bottom: 15px;
                line-height: 1.7;
                color: var(--gray-700);
                font-size: 1.05rem;
                position: relative;
                padding-left: 10px;
            }

            li::before {
                content: '✨';
                position: absolute;
                left: -15px;
                top: 0;
            }

            li strong {
                background: linear-gradient(135deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                font-weight: 600;
            }

            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }

                .sidebar.active {
                    transform: translateX(0);
                }

                .main {
                    margin-left: 0;
                    padding: 100px 20px 20px 20px;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }
            }
            /* Hamburger Menu Toggle - Always Visible */
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

            .search-container {
                position: absolute;
                right: 30px;
                top: 50%;
                transform: translateY(-50%);
                display: flex;
                align-items: center;
            }

            .search-bar {
                position: relative;
                display: flex;
                align-items: center;
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(20px);
                border: 2px solid rgba(102, 126, 234, 0.2);
                border-radius: 25px;
                padding: 8px 20px 8px 45px;
                width: 300px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .search-bar:hover {
                border-color: #667eea;
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.2);
                transform: translateY(-2px);
            }

            .search-bar:focus-within {
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                background: rgba(255, 255, 255, 0.95);
            }

            .search-input {
                border: none;
                outline: none;
                background: transparent;
                width: 100%;
                font-size: 14px;
                color: #2d3748;
                font-weight: 500;
            }

            .search-input::placeholder {
                color: #9ca3af;
                font-weight: 400;
            }

            .search-icon {
                position: absolute;
                left: 15px;
                color: #667eea;
                font-size: 16px;
                transition: all 0.3s ease;
            }

            .search-bar:focus-within .search-icon {
                color: #5a67d8;
                transform: scale(1.1);
            }

            .search-btn {
                position: absolute;
                right: 8px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                border: none;
                border-radius: 50%;
                width: 32px;
                height: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
            }

            .search-btn:hover {
                transform: scale(1.1);
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }

            .search-btn i {
                color: white;
                font-size: 12px;
            }

            @media (max-width: 768px) {
                .search-container {
                    right: 15px;
                }

                .search-bar {
                    width: 200px;
                    padding: 6px 15px 6px 35px;
                }
            }
            /* Modal Overlay */
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                backdrop-filter: blur(5px);
                z-index: 2000;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .modal-overlay.show {
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 1;
            }

            
            .no-workers-modal {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.25);
                max-width: 400px;
                max-height: 600px;
                width: 85%;
                text-align: center;
                position: relative;
                transform: scale(0.7);
                transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            .modal-overlay.show .no-workers-modal {
                transform: scale(1);
            }

            .modal-close {
                position: absolute;
                top: 12px;
                right: 15px;
                background: none;
                border: none;
                font-size: 20px;
                color: #9ca3af;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .modal-close:hover {
                color: #ef4444;
                transform: scale(1.1);
            }

            .no-workers-modal .icon {
                font-size: 3rem;
                background: linear-gradient(135deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 15px;
            }

            .no-workers-modal h3 {
                font-size: 1.5rem;
                margin-bottom: 12px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                font-weight: 700;
            }

            .no-workers-modal p {
                color: var(--gray-600);
                font-size: 1rem;
                line-height: 1.5;
                margin-bottom: 20px;
            }

            .no-workers-modal .suggestions {
                background: rgba(103, 126, 234, 0.05);
                border: 1px solid rgba(103, 126, 234, 0.1);
                border-radius: 10px;
                padding: 15px;
                margin: 15px 0;
                text-align: left;
            }

            .no-workers-modal .suggestions h4 {
                color: #667eea;
                font-size: 1rem;
                margin-bottom: 8px;
                font-weight: 600;
            }

            .no-workers-modal .suggestions ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .no-workers-modal .suggestions li {
                color: var(--gray-600);
                padding: 6px 0;
                position: relative;
                padding-left: 20px;
                font-size: 0.9rem;
            }

            .no-workers-modal .suggestions li::before {
                content: '💡';
                position: absolute;
                left: 0;
                top: 6px;
            }

            .no-workers-modal .action-buttons {
                display: flex;
                gap: 15px;
                flex-wrap: wrap;
                justify-content: center;
            }

            .no-workers-modal .btn {
                padding: 12px 25px;
                font-size: 14px;
            }

            @media (max-width: 768px) {
                .no-workers-modal {
                    padding: 20px 15px;
                    margin: 15px;
                }

                .no-workers-modal .icon {
                    font-size: 2.5rem;
                }

                .no-workers-modal h3 {
                    font-size: 1.3rem;
                }

                .no-workers-modal p {
                    font-size: 0.95rem;
                }

                .no-workers-modal .suggestions {
                    padding: 12px;
                }

                .no-workers-modal .suggestions h4 {
                    font-size: 0.95rem;
                }

                .no-workers-modal .suggestions li {
                    font-size: 0.85rem;
                    padding-left: 18px;
                }

                .no-workers-modal .btn {
                    padding: 10px 20px;
                    font-size: 13px;
                }
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <div class="navbar-brand">
                <i class="fas fa-user"></i>
                Client Dashboard
            </div>


            <div class="search-container">
                <form action="SearchWorker" method="post" style="margin: 0;">
                    <div class="search-bar">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" name="searchQuery" class="search-input" placeholder="Search workers" value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : ""%>">
                        <button class="search-btn" type="submit">
                            <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>
                </form>
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

        <div class="main">
            <div class="card">
                <h2>Welcome, Client!</h2>
                <p>Manage your job postings, find workers, and track your projects all in one place.</p>


            </div>

            <div class="card">
                <h3>Dashboard Features</h3>
                <ul>
                    <li><strong>Post Jobs:</strong> Create detailed job listings to find the right workers</li>
                    <li><strong>Find Workers:</strong> Browse and search for qualified professionals</li>
                    <li><strong>Messaging:</strong> Communicate directly with potential workers</li>
                    <li><strong>Profile Management:</strong> Keep your information up to date</li>
                </ul>
            </div>
        </div>

        <!-- Modal for No Workers Found -->
        <div class="modal-overlay" id="noWorkersModal">
            <div class="no-workers-modal">
                <button class="modal-close" onclick="closeNoWorkersModal()">
                    <i class="fas fa-times"></i>
                </button>

                <div class="icon">
                    <i class="fas fa-search"></i>
                </div>
                <h3>No Workers Found</h3>
                <p>We couldn't find any workers matching your search criteria: "<strong id="searchQueryText"></strong>"</p>

                <div class="suggestions">
                    <h4>Try these suggestions:</h4>
                    <ul>
                        <li>Check your spelling and try again</li>
                        <li>Use more general search terms</li>
                        <li>Browse all available workers</li>
                    </ul>
                </div>

                <div class="action-buttons">
                    <button class="btn" onclick="focusSearchInput()">
                        <i class="fas fa-search"></i> Search Again
                    </button>
                    <a href="find_workers.jsp" class="btn btn-secondary">
                        <i class="fas fa-users"></i> Browse All Workers
                    </a>
                </div>
            </div>
        </div>
        <script>
            function checkNewMessages() {
                fetch('CheckNewMessages')
                        .then(response => response.json())
                        .then(data => {
                            const notification = document.getElementById('messageNotification');
                            if (data.unreadCount && data.unreadCount > 0) {
                                notification.style.display = 'inline-block';
                                notification.textContent = data.unreadCount;
                            } else {
                                notification.style.display = 'none';
                            }
                        })
                        .catch(error => {
                            console.error('Error checking messages:', error);
                        });
            }

            setInterval(checkNewMessages, 5000);
            window.onload = checkNewMessages;


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
            function showSuccessMessage() {
                showToast('Operation completed successfully!', 'success');
            }

            function showErrorMessage() {
                showToast('Something went wrong!', 'error');
            }

            function showInfoMessage() {
                showToast('New information available', 'info');
            }
            // Show modal if no workers found
            <% if (request.getAttribute("noWorkersFound") != null && (Boolean) request.getAttribute("noWorkersFound")) {%>
            window.addEventListener('load', function () {
                showNoWorkersModal('<%= request.getAttribute("searchQuery")%>');
            });
            <% }%>

            function showNoWorkersModal(searchQuery) {
                const modal = document.getElementById('noWorkersModal');
                const searchQueryText = document.getElementById('searchQueryText');

                if (searchQueryText && searchQuery) {
                    searchQueryText.textContent = searchQuery;
                }

                modal.classList.add('show');
                document.body.style.overflow = 'hidden';
            }

            function closeNoWorkersModal() {
                const modal = document.getElementById('noWorkersModal');
                modal.classList.remove('show');
                document.body.style.overflow = 'auto';
            }

            function focusSearchInput() {
                closeNoWorkersModal();
                document.querySelector('.search-input').focus();
            }

// Close modal when clicking outside
            document.addEventListener('click', function (event) {
                const modal = document.getElementById('noWorkersModal');
                const modalContent = document.querySelector('.no-workers-modal');

                if (event.target === modal && !modalContent.contains(event.target)) {
                    closeNoWorkersModal();
                }
            });

// Close modal with Escape key
            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape') {
                    closeNoWorkersModal();
                }
            });
        </script>
    </body>
</html>