<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    HttpSession Session = request.getSession();
    String userId = (String) Session.getAttribute("userID");

    String message = "";
    String action = request.getParameter("action");

    // Handle delete request
    if ("delete".equals(action)) {
        String deleteId = request.getParameter("id");
        if (deleteId != null && !deleteId.trim().isEmpty()) {
            try {
                int deleteRecordId = Integer.parseInt(deleteId);
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql:///MyProject", "root", "");

                String deleteSql = "DELETE FROM userRegistration WHERE id = ? AND userID = ?";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                deleteStmt.setInt(1, deleteRecordId);
                deleteStmt.setString(2, userId);

                int rowsDeleted = deleteStmt.executeUpdate();
                message = rowsDeleted > 0 ? "Worker Account deleted successfully!" : "Failed to delete Account.";
                response.sendRedirect("WorkerRegistration.jsp"); 
                deleteStmt.close();
                conn.close();
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            }
        }
    }

    // Handle update request
    if ("update".equals(action)) {
        String updateId = request.getParameter("id");
        String newUsername = request.getParameter("name");
        String newFirstname = request.getParameter("FirstName");
        String newLastname = request.getParameter("LastName");
        String newPassword = request.getParameter("password");

        if (updateId != null && !updateId.trim().isEmpty()) {
            try {
                int recordId = Integer.parseInt(updateId);
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql:///MyProject", "root", "");

                StringBuilder updateSql = new StringBuilder("UPDATE userRegistration SET ");
                boolean hasUpdates = false;

                if (newUsername != null && !newUsername.trim().isEmpty()) {
                    updateSql.append("name = ?");
                    hasUpdates = true;
                }

                if (newFirstname != null && !newFirstname.trim().isEmpty()) {
                    if (hasUpdates) {
                        updateSql.append(", ");
                    }
                    updateSql.append("FirstName = ?");
                    hasUpdates = true;
                }
                if (newLastname != null && !newLastname.trim().isEmpty()) {
                    if (hasUpdates) {
                        updateSql.append(", ");
                    }
                    updateSql.append("LastName = ?");
                    hasUpdates = true;
                }

                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    if (hasUpdates) {
                        updateSql.append(", ");
                    }
                    updateSql.append("password = ?");
                    hasUpdates = true;
                }

                if (hasUpdates) {
                    updateSql.append(" WHERE id = ? AND userID = ?");

                    PreparedStatement updateStmt = conn.prepareStatement(updateSql.toString());
                    int paramIndex = 1;

                    if (newUsername != null && !newUsername.trim().isEmpty()) {
                        updateStmt.setString(paramIndex++, newUsername.trim());
                    }
                    if (newFirstname != null && !newFirstname.trim().isEmpty()) {
                        updateStmt.setString(paramIndex++, newFirstname.trim());
                    }
                    if (newLastname != null && !newLastname.trim().isEmpty()) {
                        updateStmt.setString(paramIndex++, newLastname.trim());
                    }
                    if (newPassword != null && !newPassword.trim().isEmpty()) {
                        updateStmt.setString(paramIndex++, newPassword.trim());
                    }

                    updateStmt.setInt(paramIndex++, recordId);
                    updateStmt.setString(paramIndex, userId);

                    int rowsUpdated = updateStmt.executeUpdate();
                    message = rowsUpdated > 0 ? "Worker profile updated successfully!" : "Failed to update worker profile.";

                    updateStmt.close();
                } else {
                    message = "No fields provided for update.";
                }

                conn.close();
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Manage Worker Profiles</title>
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

            .sidebar a[href="WorkerProfileInformation.jsp"] {
                background: linear-gradient(90deg, rgba(103, 126, 234, 0.2), rgba(118, 75, 162, 0.2));
                border-left-color: #667eea;
                color: white;
            }

            .main {
                margin-left: 260px; 
                padding: 90px 40px 40px 40px;
                width: calc(100% - 260px); 
                min-height: 100vh;
                transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1), width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            @media (min-width: 769px) {
                .main.expanded {
                    margin-left: 0;
                    width: 100%; 
                }
            }

            @media (max-width: 768px) {
                .main {
                    margin-left: 0;
                    width: 100%;
                    padding: 100px 15px 30px 15px;
                }
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                padding: 30px;
                border-radius: 24px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            }

            .page-title {
                font-size: 32px;
                font-weight: 800;
                color: #2d3748;
                margin-bottom:8px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                text-align: center;
            }

            .page-subtitle {
                color: #718096;
                font-size: 14px;
                text-align: center;
                margin-bottom: 20px;
            }

            .message {
                padding: 10px 15px;
                margin-bottom: 15px;
                border-radius: 12px;
                font-weight: 500;
                text-align: center;
            }

            .message.success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .message.error {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

          

            .worker-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 35px rgba(103, 126, 234, 0.2);
            }

            .worker-header {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
                padding-bottom: 8px;
                border-bottom: 2px solid #f7fafc;
            }
            .workers-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 25px;
                margin-top: 30px;
            }
            .worker-card {
                background: white;
                border-radius: 16px;
                padding: 25px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
                border: 1px solid #e2e8f0;
                transition: all 0.3s ease;
                position: relative;
            }

            .worker-avatar {
                width: 50px;
                height: 50px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 10px;
                color: white;
                font-size: 20px;
                font-weight: bold;
            }

            .worker-info {
                margin-bottom: 10px;
            }

            .info-row {
                display: flex;
                align-items: center;
                margin-bottom: 6px;
                font-size: 13px;
                color: #4a5568;
            }

            .info-row i {
                width: 18px;
                color: #667eea;
                margin-right: 8px;
            }

            .info-row strong {
                color: #2d3748;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
                margin-top: 10px;
            }

            .edit-btn, .delete-btn {
                flex: 1;
                padding: 10px 15px; 
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 6px; 
                font-size: 13px; 
            }

            .edit-btn {
                background: linear-gradient(135deg, #4CAF50, #45A049);
                color: white;
            }

            .edit-btn:hover {
                background: linear-gradient(135deg, #45A049, #3D8B40);
                transform: translateY(-2px);
            }

            .delete-btn {
                background: linear-gradient(135deg, #ff6b6b, #ee5a24);
                color: white;
            }

            .delete-btn:hover {
                background: linear-gradient(135deg, #ff5252, #d84315);
                transform: translateY(-2px);
            }

            .no-workers {
                text-align: center;
                padding: 40px 20px; 
                color: #718096;
                grid-column: 1 / -1;
            }

            .no-workers i {
                font-size: 48px; 
                color: #cbd5e0;
                margin-bottom: 15px; 
            }


            .add-worker-btn {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 12px 25px; 
                border: none;
                border-radius: 12px;
                text-decoration: none;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 8px; 
                margin-top: 15px; 
                transition: all 0.3s ease;
            }

            .add-worker-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(103, 126, 234, 0.3);
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 2000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(5px);
            }

            .modal-content {
                background: white;
                margin: 5% auto;
                padding: 20px; 
                border-radius: 16px;
                width: 500px;
                max-width: 90%;
                max-height: 80vh;
                overflow-y: auto;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            }

            .modal h3 {
                color: #2d3748;
                margin-bottom: 15px; 
                font-size: 22px; 
                text-align: center;
            }

            .form-group {
                margin-bottom: 15px; 
            }

            .form-group label {
                display: block;
                margin-bottom: 6px; 
                color: #2d3748;
                font-weight: 600;
            }

            .form-group input {
                width: 100%;
                padding: 10px 12px; 
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 13px; 
                transition: border-color 0.3s ease;
            }

            .form-group input:focus {
                outline: none;
                border-color: #667eea;
            }

            .modal-buttons {
                display: flex;
                gap: 10px; 
                justify-content: center;
                margin-top: 20px; 
            }

            .confirm-btn, .cancel-btn {
                padding: 10px 20px; 
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 13px; 
            }

            .confirm-btn {
                background: #4CAF50;
                color: white;
            }

            .confirm-btn:hover {
                background: #45A049;
            }

            .cancel-btn {
                background: #e2e8f0;
                color: #4a5568;
            }

            .cancel-btn:hover {
                background: #cbd5e0;
            }

            .delete-modal .confirm-btn {
                background: #ff6b6b;
            }

            .delete-modal .confirm-btn:hover {
                background: #ff5252;
            }

            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }

                .main {
                    margin-left: 0;
                    width: 100%;
                    padding: 100px 15px 30px 15px; 
                }

                .workers-grid {
                    grid-template-columns: 1fr;
                    gap: 15px; 
                }

                .worker-card {
                    padding: 12px; 
                }

                .modal-content {
                    width: 95%;
                    margin: 10% auto;
                    padding: 15px; 
                }
            }

            .rating-stars {
                display: flex;
                align-items: center;
                gap: 0.2rem; 
            }

            .rating-stars i {
                font-size: 1rem; 
            }

            .star-filled {
                color: #fbbf24;
            }

            .star-half {
                color: #fbbf24;
            }

            .star-empty {
                color: #d1d5db;
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
                Manage Your Profile
            </div>
        </div>

        <div class="sidebar-overlay" onclick="closeSidebar()"></div>
        <div class="sidebar">
            <h4>Menu</h4>
            <a href="WorkerDashboard.jsp" class="active"><i class="fas fa-home"></i>Dashboard</a>

            <h4>Submit</h4>
            <a href="register_worker.jsp"><i class="fas fa-clipboard-list"></i>Register As A Worker</a>

            <h4>Find</h4>
            <a href="find_works.jsp"><i class="fas fa-search-location"></i>Find Available Jobs</a>

            <h4>Account</h4>
            <a href="WorkerDeleteDetails.jsp"><i class="fas fa-user-circle"></i>View Details</a>
            <a href="WorkerProfileInformation.jsp"><i class="fas fa-user-cog"></i>Manage Profiles</a>
            <a href="messages.jsp" style="position: relative;">
                <i class="fas fa-envelope"></i> Messages
                <span id="messageNotification">!</span>
            </a>
            <a href="WorkerLogin.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>

        <div class="main">
            <div class="container">
                <h1 class="page-title">Manage Your Profiles</h1>
                <p class="page-subtitle">View, edit, and manage all your profiles</p>

                <% if (!message.isEmpty()) {%>
                <div class="message <%= message.contains("successfully") ? "success" : "error"%>">
                    <%= message%>
                </div>
                <% } %>

                <div class="workers-grid">
                    <%
                        try {
                            if (userId == null || userId.trim().isEmpty()) {
                                out.println("<div class='message error'>Please log in to view your profiles.</div>");
                            } else {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql:///MyProject", "root", "");

                                String sql = "SELECT u.id, u.name, u.FirstName, u.LastName, u.password, "
                                        + "COALESCE(ROUND(AVG(r.rating), 1), 0) AS averageRating "
                                        + "FROM userRegistration u "
                                        + "LEFT JOIN ratings r ON u.userID = r.worker_id "
                                        + "WHERE u.userID = ? "
                                        + "GROUP BY u.id, u.name, u.FirstName, u.LastName, u.password";
                                PreparedStatement stmt = conn.prepareStatement(sql);
                                stmt.setString(1, userId);
                                ResultSet rs = stmt.executeQuery();

                                boolean hasWorkers = false;

                                while (rs.next()) {
                                    hasWorkers = true;

                                    int recordId = rs.getInt("id");
                                    String username = rs.getString("name");
                                    String firstname = rs.getString("FirstName");
                                    String lastname = rs.getString("LastName");
                                    String password = rs.getString("password");
                                    double ratings = rs.getDouble("averageRating");

                                    username = (username != null && !username.trim().isEmpty()) ? username : "Not specified";
                                    firstname = (firstname != null && !firstname.trim().isEmpty()) ? firstname : "Not specified";
                                    lastname = (lastname != null && !lastname.trim().isEmpty()) ? lastname : "Not specified";
                                    password = (password != null && !password.trim().isEmpty()) ? "••••••••" : "Not set";
                    %>
                    <div class="worker-card">
                        <div class="worker-header">
                            <div class="worker-avatar">
                                <%= firstname.substring(0, 1).toUpperCase()%>
                            </div>
                            <div>
                                <h3 style="color: #2d3748; margin-bottom: 3px; font-size: 18px;"><%= firstname%></h3> <!-- Reduced margin and font-size -->
                                <p style="color: #718096; font-size: 13px;">@<%= username%></p> <!-- Reduced font-size -->
                            </div>
                        </div>
                        <div class="worker-info">
                            <div class="info-row">
                                <i class="fas fa-id-card"></i>
                                <span><strong>First Name:</strong> <%= firstname%></span>
                            </div>
                            <div class="info-row">
                                <i class="fas fa-id-card"></i>
                                <span><strong>Last Name:</strong> <%= lastname%></span>
                            </div>
                            <div class="info-row">
                                <i class="fas fa-key"></i>
                                <span><strong>Password:</strong> <%= password%></span>
                            </div>

                            <div class="info-row">
                                <i class="fas fa-star"></i>
                                <span><strong>Rating:</strong></span>
                                <div class="rating-stars" style="display: inline-flex; margin-left: 8px;"> <!-- Reduced margin-left -->
                                    <%
                                        if (ratings > 0) {
                                            int fullStars = (int) Math.floor(ratings);
                                            boolean halfStar = (ratings - fullStars) >= 0.5;
                                            int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

                                            for (int i = 0; i < fullStars; i++) {
                                    %>
                                    <i class="fas fa-star star-filled"></i>
                                    <%
                                        }
                                        if (halfStar) {
                                    %>
                                    <i class="fas fa-star-half-alt star-half"></i>
                                    <%
                                        }
                                        for (int i = 0; i < emptyStars; i++) {
                                    %>
                                    <i class="far fa-star star-empty"></i>
                                    <%
                                        }
                                    %>
                                    <span style="margin-left: 6px; color: #718096; font-size: 13px;">(<%= String.format("%.1f", ratings)%>)</span> <!-- Reduced margin and font-size -->
                                    <%
                                    } else {
                                    %>
                                    <span style="color: #9ca3af; font-size: 13px;">Not rated yet</span> <!-- Reduced font-size -->
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                        </div>
                        <div class="action-buttons">
                            <button class="edit-btn" onclick="openEditModal(<%= recordId%>, '<%= username.replace("'", "\\'")%>', '<%= firstname.replace("'", "\\'")%>', '<%= lastname.replace("'", "\\'")%>') ">
                                <i class="fas fa-edit"></i>
                                Edit Profile
                            </button>
                            <button class="delete-btn" onclick="confirmDelete(<%= recordId%>, '<%= firstname.replace("'", "\\'")%>')">
                                <i class="fas fa-trash"></i>
                                Delete
                            </button>
                        </div>
                    </div>
                    <%
                        }

                        if (!hasWorkers) {
                    %>
                    <div class="no-workers">
                        <i class="fas fa-user-times"></i>
                        <h3 style="font-size: 20px;">No Profiles Found</h3> <!-- Reduced font-size -->
                        <p style="font-size: 14px;">You haven't created any profiles yet. Start by adding your first profile.</p> <!-- Reduced font-size -->
                        <a href="AddWorkerProfile.jsp" class="add-worker-btn">
                            <i class="fas fa-plus"></i>
                            Add New Profile
                        </a>
                    </div>
                    <%
                                }

                                rs.close();
                                stmt.close();
                                conn.close();
                            }
                        } catch (Exception e) {
                            out.println("<div class='message error'>Error loading worker profiles: " + e.getMessage() + "</div>");
                        }
                    %>
                </div>
            </div>
        </div>

        <!-- Edit Profile Modal -->
        <div id="editModal" class="modal">
            <div class="modal-content">
                <h3><i class="fas fa-edit" style="color: #4CAF50;"></i> Edit Worker Profile</h3>
                <form id="editForm" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editWorkerId">
                    <div class="form-group">
                        <label for="editUsername">
                            <i class="fas fa-user"></i> Username
                        </label>
                        <input type="text" id="editUsername" name="name" placeholder="Enter new username (optional)">
                    </div>
                    <div class="form-group">
                        <label for="editFirstname">
                            <i class="fas fa-id-card"></i> First Name
                        </label>
                        <input type="text" id="editFirstname" name="FirstName" placeholder="Enter new first name (optional)">
                    </div>
                    <div class="form-group">
                        <label for="editLastname">
                            <i class="fas fa-id-card"></i> Last Name
                        </label>
                        <input type="text" id="editLastname" name="LastName" placeholder="Enter new last name (optional)">
                    </div>
                    <div class="form-group">
                        <label for="editPassword">
                            <i class="fas fa-lock"></i> New Password
                        </label>
                        <input type="password" id="editPassword" name="password" placeholder="Enter new password (optional)">
                    </div>
                    <div class="modal-buttons">
                        <button type="submit" class="confirm-btn">
                            <i class="fas fa-save"></i> Update Profile
                        </button>
                        <button type="button" class="cancel-btn" onclick="closeEditModal()">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div id="deleteModal" class="modal delete-modal">
            <div class="modal-content">
                <h3><i class="fas fa-exclamation-triangle" style="color: #ff6b6b;"></i> Confirm Deletion</h3>
                <p>Are you sure you want to permanently delete this Account?</p>
                <p><strong id="workerToDelete"></strong></p>
                <p style="color: #718096; font-size: 13px; margin-top: 8px;">This action cannot be undone.</p> <!-- Reduced font-size and margin -->
                <div class="modal-buttons">
                    <button class="confirm-btn" onclick="deleteWorker()">
                        <i class="fas fa-trash"></i> Delete Profile
                    </button>
                    <button class="cancel-btn" onclick="closeDeleteModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </div>
        </div>

        <script>
            let workerIdToDelete = null;
            let workerIdToEdit = null;

            function openEditModal(workerId, username, firstname,lastname) {
                workerIdToEdit = workerId;
                document.getElementById('editWorkerId').value = workerId;
                document.getElementById('editUsername').placeholder = 'Current: ' + username;
                document.getElementById('editFirstname').placeholder = 'Current: ' + firstname;
                document.getElementById('editLastname').placeholder = 'Current: ' + lastname;
                document.getElementById('editModal').style.display = 'block';
            }

            function closeEditModal() {
                document.getElementById('editModal').style.display = 'none';
                document.getElementById('editForm').reset();
                workerIdToEdit = null;
            }

            function confirmDelete(workerId, firstname) {
                workerIdToDelete = workerId;
                document.getElementById('workerToDelete').textContent = firstname;
                document.getElementById('deleteModal').style.display = 'block';
            }

            function deleteWorker() {
                if (workerIdToDelete) {
                    window.location.href = '?action=delete&id=' + workerIdToDelete;
                }
            }

            function closeDeleteModal() {
                document.getElementById('deleteModal').style.display = 'none';
                workerIdToDelete = null;
            }

            window.onclick = function (event) {
                const editModal = document.getElementById('editModal');
                const deleteModal = document.getElementById('deleteModal');

                if (event.target === editModal) {
                    closeEditModal();
                }
                if (event.target === deleteModal) {
                    closeDeleteModal();
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                const cards = document.querySelectorAll('.worker-card');
                cards.forEach((card, index) => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    setTimeout(() => {
                        card.style.transition = 'all 0.5s ease';
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, index * 100);
                });
            });

            document.getElementById('editForm').addEventListener('submit', function (e) {
                const username = document.getElementById('editUsername').value.trim();
                const firstname = document.getElementById('editFirstname').value.trim();
                const lastname = document.getElementById('editLastname').value.trim();
                const password = document.getElementById('editPassword').value.trim();

                if (!username && !firstname && !lastname && !password && !lastname) {
                    e.preventDefault();
                    alert('Please fill at least one field to update.');
                    return false;
                }

                if (password && password.length < 6) {
                    e.preventDefault();
                    alert('Password must be at least 6 characters long.');
                    return false;
                }
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
          


            document.addEventListener('DOMContentLoaded', function () {
                const message = document.querySelector('.message');
                if (message) {
                   
                    setTimeout(function () {
                        message.style.transition = 'opacity 0.3s ease-out';
                        message.style.opacity = '0';

                        
                        setTimeout(function () {
                            message.remove();
                        }, 500);
                    }, 3000); 

                    
                    message.style.cursor = 'pointer';
                    message.title = 'Click to dismiss';
                    message.addEventListener('click', function () {
                        message.style.transition = 'opacity 0.3s ease-out';
                        message.style.opacity = '0';
                        setTimeout(function () {
                            message.remove();
                        }, 300);
                    });
                }
            });
        </script>
    </body>
</html>