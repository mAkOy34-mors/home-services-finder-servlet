<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    HttpSession Session = request.getSession();
    String userId = (String) Session.getAttribute("userID");

    // Handle delete request
    String deleteId = request.getParameter("id");
    String message = "";
    if (deleteId != null && !deleteId.trim().isEmpty()) {
        try {
            int deleteRecordId = Integer.parseInt(deleteId);
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql:///MyProject", "root", "");

            String deleteSql = "DELETE FROM FindJob WHERE id = ? AND userID = ?";
            PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
            deleteStmt.setInt(1, deleteRecordId);
            deleteStmt.setString(2, userId);

            int rowsDeleted = deleteStmt.executeUpdate();
            message = rowsDeleted > 0 ? "Submitted details deleted successfully!" : "Failed to delete worker profile.";

            deleteStmt.close();
            conn.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Manage Worker Details</title>
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

            @media (min-width: 769px) {
                .navbar.expanded {
                    padding-left: 70px;
                }
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
            .sidebar::-webkit-scrollbar {
                width: 8px;
            }
            .menu-toggle.open .fa-bars::before {
                content: '\f00d';
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

            .sidebar a[href="WorkerDeleteDetails.jsp"] {
                background: linear-gradient(90deg, rgba(103, 126, 234, 0.2), rgba(118, 75, 162, 0.2));
                border-left-color: #667eea;
                color: white;
            }

            

            .main {
                margin-left: 260px; 
                padding: 70px 40px 40px 40px;
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
                    padding: 100px 20px 40px 20px;
                }
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                padding: 40px;
                border-radius: 24px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            }

            .page-title {
                font-size: 36px;
                font-weight: 800;
                color: #2d3748;
                margin-bottom: 10px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                text-align: center;
            }

            .page-subtitle {
                color: #718096;
                font-size: 16px;
                text-align: center;
                margin-bottom: 30px;
            }

            .message {
                padding: 15px 20px;
                margin-bottom: 20px;
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

            .debug-info {
                background: #fff3cd;
                color: #856404;
                border: 1px solid #ffeaa7;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
            }

            .workers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
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

            .worker-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 35px rgba(103, 126, 234, 0.2);
            }

            .skill-badge {
                display: inline-block;
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: 600;
                margin-bottom: 15px;
            }

            .worker-info {
                margin-bottom: 20px;
            }

            .info-row {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
                font-size: 14px;
                color: #4a5568;
            }

            .info-row i {
                width: 20px;
                color: #667eea;
                margin-right: 10px;
            }

            .delete-btn {
                background: linear-gradient(135deg, #ff6b6b, #ee5a24);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
                width: 100%;
                justify-content: center;
            }

            .delete-btn:hover {
                background: linear-gradient(135deg, #ff5252, #d84315);
                transform: translateY(-2px);
            }

            .no-workers {
                text-align: center;
                padding: 60px 20px;
                color: #718096;
                grid-column: 1 / -1;
            }

            .no-workers i {
                font-size: 64px;
                color: #cbd5e0;
                margin-bottom: 20px;
            }

            .add-worker-btn {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 15px 30px;
                border: none;
                border-radius: 12px;
                text-decoration: none;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                margin-top: 20px;
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
                margin: 15% auto;
                padding: 30px;
                border-radius: 16px;
                width: 400px;
                max-width: 90%;
                text-align: center;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            }

            .modal h3 {
                color: #2d3748;
                margin-bottom: 15px;
                font-size: 24px;
            }

            .modal p {
                color: #718096;
                margin-bottom: 25px;
                font-size: 16px;
            }

            .modal-buttons {
                display: flex;
                gap: 15px;
                justify-content: center;
            }

            .confirm-btn, .cancel-btn {
                padding: 12px 25px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .confirm-btn {
                background: #ff6b6b;
                color: white;
            }

            .cancel-btn {
                background: #e2e8f0;
                color: #4a5568;
            }

            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }

                .main {
                    margin-left: 0;
                    width: 100%;
                    padding: 120px 20px 40px 20px;
                }

                .workers-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <<div class="navbar">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <i class="fas fa-folder-open"></i>
            Manage Your Submitted Details
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
                <h1 class="page-title">Manage Your Details</h1>
                <p class="page-subtitle">View and manage all your registered Details</p>



                <% if (!message.isEmpty()) {%>
                <div class="message <%= message.contains("successfully") ? "success" : "error"%>">
                    <%= message%>
                </div>
                <% } %>

                <div class="workers-grid">
                    <%
                        try {
                            // Check if user is logged in - Fixed comparison
                            if (userId == null || userId.trim().isEmpty()) {
                                out.println("<div class='message error'>Please log in to view your Details.</div>");
                            } else {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql:///MyProject", "root", "");

                                // Query to get worker profiles for the logged-in user
                                String sql = "SELECT id, type, Address, Experience, userID FROM FindJob WHERE userID = ?";
                                PreparedStatement stmt = conn.prepareStatement(sql);
                                stmt.setString(1, userId); // userID is varchar, so use setString
                                ResultSet rs = stmt.executeQuery();

                                boolean hasWorkers = false;
                                int recordCount = 0;

                                while (rs.next()) {
                                    hasWorkers = true;
                                    recordCount++;

                                    int recordId = rs.getInt("id");
                                    String skillType = rs.getString("type");
                                    String address = rs.getString("Address");
                                    String Experience = rs.getString("Experience");
                                    String recordUserId = rs.getString("userID"); // Changed to getString since it's varchar

                                    // Handle null values
                                    skillType = (skillType != null && !skillType.trim().isEmpty()) ? skillType : "Not specified";
                                    address = (address != null && !address.trim().isEmpty()) ? address : "Location not specified";
                                    Experience = (Experience != null && !Experience.trim().isEmpty()) ? Experience : "No Experience provided";
                    %>
                    <div class="worker-card">
                        <div class="skill-badge">
                            <i class="fas fa-tools"></i> <%= skillType%>
                        </div>

                        <div class="worker-info">
                            <div class="info-row">
                                <i class="fas fa-map-marker-alt"></i>
                                <span><strong>Location:</strong> <%= address%></span>
                            </div>

                            <div class="info-row">
                                <i class="fas fa-trophy"></i>
                                <span><strong>Experience:</strong> <%= Experience%></span>
                            </div>

                        </div>

                        <button class="delete-btn" onclick="confirmDelete(<%= recordId%>, '<%= skillType.replace("'", "\\'")%>')">
                            <i class="fas fa-trash"></i>
                            Delete Details
                        </button>
                    </div>
                    <%
                        }

                        // Debug information
                        out.println("<!-- Debug: Found " + recordCount + " records for user ID " + userId + " -->");

                        if (!hasWorkers) {
                    %>
                    <div class="no-workers">
                        <i class="fas fa-user-times"></i>
                        <h3>No Submitted Details Found</h3>
                        <p>You haven't registered as a worker yet. Start by creating your first worker details.</p>

                        <a href="register_worker.jsp" class="add-worker-btn">
                            <i class="fas fa-plus"></i>
                            Register as Worker
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
                            out.println("<!-- Debug: Exception details: " + e.getClass().getName() + " - " + e.getMessage() + " -->");
                            e.printStackTrace(); // This will print to server logs
                        }
                    %>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div id="deleteModal" class="modal">
            <div class="modal-content">
                <h3><i class="fas fa-exclamation-triangle" style="color: #ff6b6b;"></i> Confirm Deletion</h3>
                <p>Are you sure you want to delete this details?</p>
                <p><strong id="skillToDelete"></strong></p>
                <div class="modal-buttons">
                    <button class="confirm-btn" onclick="deleteWorker()">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                    <button class="cancel-btn" onclick="closeModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </div>
        </div>

        <script>
            let workerIdToDelete = null;

            function confirmDelete(workerId, skillType) {
                workerIdToDelete = workerId;
                document.getElementById('skillToDelete').textContent = skillType;
                document.getElementById('deleteModal').style.display = 'block';
            }

            function deleteWorker() {
                if (workerIdToDelete) {
                    window.location.href = 'WorkerDeleteDetails.jsp?id=' + workerIdToDelete;
                }
            }

            function closeModal() {
                document.getElementById('deleteModal').style.display = 'none';
                workerIdToDelete = null;
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                const modal = document.getElementById('deleteModal');
                if (event.target === modal) {
                    closeModal();
                }
            }

            // Add smooth animations
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