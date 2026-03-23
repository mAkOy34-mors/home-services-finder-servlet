<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Client Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #3b82f6; --primary-dark: #2563eb; --primary-light: #93c5fd;
            --secondary: #64748b; --success: #10b981; --warning: #f59e0b; --danger: #ef4444;
            --dark: #1e293b; --light: #f8fafc; --white: #ffffff;
            --gray-50: #f9fafb; --gray-100: #f3f4f6; --gray-200: #e5e7eb; --gray-300: #d1d5db;
            --gray-400: #9ca3af; --gray-500: #6b7280; --gray-600: #4b5563; --gray-700: #374151;
            --gray-800: #1f2937; --gray-900: #111827;
            --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --radius: 0.5rem; --radius-lg: 0.75rem; --radius-xl: 1rem;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        @keyframes bgFlow {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        @keyframes cardFloat {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-5px); }
        }

        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
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
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="50" r="0.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
            z-index: -1;
        }

        .navbar {
            position: fixed;
            width: 100%; top: 0; left: 0;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            color: #2d3748;
            padding: 20px 30px;
            font-size: 24px; font-weight: 700;
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.1);
            z-index: 1000;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .navbar::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, rgba(103, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            z-index: -1;
        }

        .navbar i {
            color: #667eea;
            font-size: 28px;
        }

        .sidebar {
            width: 260px; height: 100vh;
            background: rgba(45, 55, 72, 0.95);
            backdrop-filter: blur(20px);
            padding-top: 100px; padding-bottom: 20px;
            position: fixed;
            top: 0; left: 0;
            color: white;
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1);
            border-right: 1px solid rgba(255, 255, 255, 0.1);
            overflow-y: auto; overflow-x: hidden;
            transition: transform 0.3s ease;
        }

        .sidebar::-webkit-scrollbar { width: 8px; }
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
            overflow: hidden;
        }

        .sidebar a::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 0; height: 100%;
            background: linear-gradient(90deg, rgba(103, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            transition: width 0.3s ease;
            z-index: -1;
        }

        .sidebar a:hover::before { width: 100%; }

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
            top: 0; left: -200%;
            width: 200%; height: 100%;
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
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before { left: 100%; }

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

        #messageNotification {
            position: absolute;
            top: 12px; right: 20px;
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            border-radius: 50%;
            width: 20px; height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
            animation: pulse 2s infinite;
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
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-brand">
            <i class="fas fa-user"></i>
            Client Dashboard
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
        <a href="profile.jsp"><i class="fas fa-user-circle"></i>Profile</a>
        <a href="ClientMessages.jsp" style="position: relative;">
            <i class="fas fa-envelope"></i> Messages
            <span id="messageNotification">!</span>
        </a>
        <a href="ClientLogin.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main">
        <div class="card">
            <h2>Welcome to Your Dashboard</h2>
            <p>Manage your job postings, find workers, and track your projects all in one place.</p>
            
            <h3>Quick Actions</h3>
            <form action="Profile" method="post">
                <div class="action-buttons">
                    <button type="submit" name="Update" class="btn" value="update">
                        <i class="fas fa-user-edit"></i> Update Profile
                    </button>
                    <button type="submit" name="Search" class="btn btn-secondary" value="search">
                        <i class="fas fa-search"></i> Search Workers
                    </button>
                    <button type="submit" name="View" class="btn btn-danger" value="view">
                        <i class="fas fa-eye"></i> View Details
                    </button>
                </div>
            </form>
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
    </script>
</body>
</html>