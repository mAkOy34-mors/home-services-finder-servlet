<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Find Workers</title>
        <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

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
                --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
                --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
                --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
                --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
                --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
                --radius: 0.5rem;
                --radius-lg: 0.75rem;
                --radius-xl: 1rem;
            }

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
                color: var(--gray-800);
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

            .sidebar a[href="find_workers.jsp"] {
                background: linear-gradient(90deg, rgba(103, 126, 234, 0.2), rgba(118, 75, 162, 0.2));
                border-left-color: #667eea;
                color: white;
            }

           

            .main {
                margin-left: 280px;
                padding: 6rem 2rem 2rem;
                min-height: 100vh;
                transition: margin-left 0.3s ease;
                margin-top: 5px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
            }
            .fade-in {
                animation: fadeIn 0.8s ease-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .slide-up {
                animation: slideUp 0.6s ease-out;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .search-section {
                background: var(--white);
                padding: 2rem;
                border-radius: var(--radius-xl);
                box-shadow: var(--shadow-lg);
                margin-bottom: 2rem;
                border: 1px solid var(--gray-200);
            }

            .search-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .search-header h2 {
                color: var(--gray-800);
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .search-header p {
                color: var(--gray-600);
                font-size: 1.1rem;
            }

            .form-layout {
                display: grid;
                grid-template-columns: 1fr auto;
                gap: 3rem;
                align-items: start;
            }

            .search-form {
                display: grid;
                gap: 1.5rem;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1rem;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group label {
                font-weight: 500;
                color: var(--gray-700);
                margin-bottom: 0.5rem;
                font-size: 0.95rem;
            }

            .form-control {
                padding: 0.75rem 1rem;
                border: 2px solid var(--gray-200);
                border-radius: var(--radius);
                font-size: 1rem;
                transition: all 0.2s ease;
                background: var(--white);
            }

            .form-control:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            .form-control::placeholder {
                color: var(--gray-400);
            }

            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
                padding: 0.75rem 1.5rem;
                font-size: 1rem;
                font-weight: 500;
                border: none;
                border-radius: var(--radius);
                cursor: pointer;
                transition: all 0.2s ease;
                text-decoration: none;
                white-space: nowrap;
            }

            .btn-primary {
                background: var(--primary);
                color: white;
            }

            .btn-primary:hover {
                background: var(--primary-dark);
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
            }

            .btn-secondary {
                background: var(--gray-200);
                color: var(--gray-700);
            }

            .btn-secondary:hover {
                background: var(--gray-300);
            }

            .btn-outline {
                background: transparent;
                color: var(--primary);
                border: 2px solid var(--primary);
            }

            .btn-outline:hover {
                background: var(--primary);
                color: white;
            }

            .btn-sm {
                padding: 0.5rem 1rem;
                font-size: 0.875rem;
            }

            .search-button {
                grid-column: 1 / -1;
                justify-self: start;
            }

            .form-illustration {
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .form-illustration img {
                max-width: 300px;
                height: auto;
                border-radius: var(--radius-lg);
                box-shadow: var(--shadow-md);
            }

            .results-section {
                margin-top: 2rem;
            }

            .results-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 1.5rem;
                padding-bottom: 1rem;
                border-bottom: 2px solid var(--gray-200);
            }

            .results-header h3 {
                color: var(--gray-800);
                font-size: 1.5rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .results-count {
                background: var(--primary-light);
                color: var(--primary);
                padding: 0.25rem 0.75rem;
                border-radius: var(--radius);
                font-size: 0.875rem;
                font-weight: 600;
            }

            .workers-grid {
                display: grid;
                gap: 1.5rem;
            }

            .worker-card {
                background: var(--white);
                border: 1px solid var(--gray-200);
                border-radius: var(--radius-lg);
                padding: 1.5rem;
                box-shadow: var(--shadow);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .worker-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 4px;
                background: linear-gradient(90deg, var(--primary), var(--primary-light));
            }

            .worker-card:hover {
                transform: translateY(-4px);
                box-shadow: var(--shadow-xl);
                border-color: var(--primary-light);
            }

            .worker-header {
                display: flex;
                justify-content: space-between;
                align-items: start;
                margin-bottom: 1rem;
            }

            .worker-type {
                background: var(--primary);
                color: white;
                padding: 0.5rem 1rem;
                border-radius: var(--radius);
                font-size: 0.875rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .worker-distance {
                background: var(--success);
                color: white;
                padding: 0.25rem 0.75rem;
                border-radius: var(--radius);
                font-size: 0.875rem;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            .worker-info {
                display: grid;
                gap: 0.75rem;
                margin-bottom: 1.5rem;
            }

            .info-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .info-icon {
                width: 2rem;
                height: 2rem;
                border-radius: 50%;
                background: var(--gray-100);
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--gray-600);
                font-size: 0.875rem;
            }

            .info-content strong {
                color: var(--gray-700);
                font-weight: 500;
                margin-right: 0.5rem;
            }

            .info-content {
                color: var(--gray-600);
            }

            .rating-stars {
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            .rating-stars i {
                font-size: 1.1rem;
            }

            .star-filled {
                color: #fbbf24;
            }

            .star-half {
                color: #fbbf24;
            }

            .star-empty {
                color: var(--gray-300);
            }

            .worker-actions {
                display: flex;
                gap: 0.75rem;
                flex-wrap: wrap;
            }

            .map-container {
                height: 300px;
                margin-top: 1rem;
                border-radius: var(--radius);
                overflow: hidden;
                box-shadow: var(--shadow-md);
                display: none;
            }

            .map-container.show {
                display: block;
                animation: slideDown 0.3s ease;
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    max-height: 0;
                }
                to {
                    opacity: 1;
                    max-height: 300px;
                }
            }

            .no-results {
                text-align: center;
                padding: 4rem 2rem;
                background: var(--white);
                border-radius: var(--radius-lg);
                box-shadow: var(--shadow);
            }

            .no-results i {
                font-size: 4rem;
                color: var(--gray-400);
                margin-bottom: 1rem;
            }

            .no-results h3 {
                color: var(--gray-700);
                margin-bottom: 0.5rem;
            }

            .no-results p {
                color: var(--gray-500);
            }

            /* Mobile Styles */
            @media (max-width: 1024px) {
                .form-layout {
                    grid-template-columns: 1fr;
                    gap: 2rem;
                }

                .form-illustration img {
                    max-width: 250px;
                }
            }

            @media (max-width: 768px) {
                .mobile-menu-btn {
                    display: block;
                }

                .sidebar {
                    transform: translateX(-100%);
                }

                .sidebar.show {
                    transform: translateX(0);
                }

                .sidebar-overlay.show {
                    display: block;
                }

                .main {
                    margin-left: 0;
                    padding: 5rem 1rem 1rem;
                }

                .search-section {
                    padding: 1.5rem;
                }

                .search-header h2 {
                    font-size: 1.5rem;
                }

                .form-row {
                    grid-template-columns: 1fr;
                }

                .worker-actions {
                    flex-direction: column;
                }

                .btn {
                    justify-content: center;
                }
            }

            @media (max-width: 480px) {
                .navbar {
                    padding: 1rem;
                }

                .search-section {
                    padding: 1rem;
                }

                .worker-card {
                    padding: 1rem;
                }

                .worker-header {
                    flex-direction: column;
                    gap: 0.75rem;
                    align-items: start;
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

            .info-content .rating-badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: linear-gradient(135deg, #4CAF50 0%, #81C784 50%, #66BB6A 100%);
                color: white;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 0.9em;
                font-weight: 600;
                margin-left: 5px;
                box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .info-content .rating-badge:hover {
                transform: translateY(-1px);
                box-shadow: 0 6px 16px rgba(76, 175, 80, 0.4);
            }

            .info-content .rating-badge.no-rating {
                background: linear-gradient(135deg, #95a5a6 0%, #bdc3c7 100%);
                box-shadow: 0 4px 12px rgba(149, 165, 166, 0.3);
                animation: pulse 2s infinite;
            }

            .star-rating {
                display: flex;
                gap: 2px;
            }

            .star-rating i {
                color: #ffd700;
                font-size: 0.85em;
            }



            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.05);
                }
            }



            @media (max-width: 768px) {
                .info-content {
                    font-size: 0.9em;
                }
                .rating-badge {
                    font-size: 0.8em;
                    padding: 2px 6px;
                }
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <i class="fas fa-briefcase"></i>
            Find Workers
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
            <div class="container fade-in">
                <div class="search-section">
                    <div class="search-header">
                        <h2>Find Available Workers</h2>
                        <p>Connect with skilled professionals in your area</p>
                    </div>

                    <div class="form-layout slide-up">
                        <form action="FindWorkers" method="post" class="search-form">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="type">
                                        <i class="fas fa-tools" style="margin-right: 0.5rem; color: var(--primary);"></i>
                                        Type of Work
                                    </label>
                                    <select name="type" id="type" class="form-control">
                                        <option value="">Select Type</option>
                                        <option value="Plumbing">🔧 Plumbing</option>
                                        <option value="Electrician">⚡ Electrician</option>
                                        <option value="General Repair">🛠️ General Repair</option>
                                        <option value="Painting">🎨 Painting</option>
                                        <option value="Carpentry">🔨 Carpentry</option>
                                        <option value="Gardening">🌱 Gardening</option>
                                        <option value="Roofing">🏠 Roofing</option>
                                        <option value="Appliance Repair">📺 Appliance Repair</option>
                                        <option value="Babysitting">👶 Babysitting</option>
                                        <option value="Tile Installation">🧱 Tile Installation</option>
                                        <option value="Flooring">🪵 Flooring</option>
                                        <option value="Computer Repair">💻 Computer Repair</option>
                                        <option value="Furniture Assembly">🛋️ Furniture Assembly</option>
                                        <option value="Interior Design">📐 Interior Design</option>
                                        <option value="Laundry">👕 Laundry</option>
                                        <option value="Tutoring">📚 Tutoring</option>
                                        <option value="Aircon Cleaning">🌬️ Aircon Cleaning</option>
                                        <option value="Auto Mechanic">🚗 Auto Mechanic</option>
                                    </select>

                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="option">
                                        <i class="fas fa-tools" style="margin-right: 0.5rem; color: var(--primary);"></i>
                                        Type Manually 
                                    </label>
                                    <input type="text" name="customType" id="option" class="form-control" placeholder="Input type of work" />
                                </div> 
                                <div class="form-group">
                                    <label for="brgy">
                                        <i class="fas fa-map-marker-alt" style="margin-right: 0.5rem; color: var(--primary);"></i>
                                        Barangay
                                    </label>
                                    <input type="text" name="brgy" id="brgy" class="form-control" 
                                           placeholder="e.g. Brgy. Dawis" required>
                                </div>

                                <div class="form-group">
                                    <label for="city">
                                        <i class="fas fa-city" style="margin-right: 0.5rem; color: var(--primary);"></i>
                                        City/Municipality
                                    </label>
                                    <input type="text" name="city" id="city" class="form-control" 
                                           placeholder="e.g. Bayawan City" required>
                                </div>
                            </div>

                            <div class="search-button">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i>
                                    Search Workers
                                </button>
                            </div>
                        </form>

                        <div class="form-illustration">
                            <img src="Images/Worker.webp" alt="Professional Workers" />
                        </div>
                    </div>
                </div>

                <div class="results-section">
                    <%
                        List<String[]> workers = (List<String[]>) request.getAttribute("workers");
                        if (workers != null && !workers.isEmpty()) {
                    %>
                    <div class="results-header">
                        <h3>
                            <i class="fas fa-users"></i>
                            Matching Workers
                        </h3>
                        <span class="results-count"><%= workers.size()%> found</span>
                    </div>

                    <div class="workers-grid">
                        <%
                            int index = 0;
                            for (String[] w : workers) {
                        %>
                        <div class="worker-card">
                            <div class="worker-header">
                                <div class="worker-type"><%= w[0]%></div>

                            </div>

                            <div class="worker-info">
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div class="info-content">
                                        <strong>Name:</strong> <%= w[4] + ", " + w[5]%>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <div class="info-content">
                                        <strong>Address:</strong> <%= w[1]%>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-briefcase"></i>
                                    </div>
                                    <div class="info-content">
                                        <strong>Experience:</strong> <%= w[2]%>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <div class="info-content">
                                        <strong>Rating:</strong>
                                        <div class="rating-stars" style="display: inline-flex; margin-left: 0.5rem;">
                                            <%
                                                try {
                                                    double rating = Double.parseDouble(w[7]);
                                                    int fullStars = (int) rating;
                                                    boolean halfStar = rating - fullStars >= 0.5;
                                                    int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
                                            %>
                                            <% for (int i = 0; i < fullStars; i++) { %>
                                            <i class="fas fa-star star-filled"></i>
                                            <% } %>
                                            <% if (halfStar) { %>
                                            <i class="fas fa-star-half-alt star-half"></i>
                                            <% } %>
                                            <% for (int i = 0; i < emptyStars; i++) { %>
                                            <i class="far fa-star star-empty"></i>
                                            <% } %>
                                            <%
                                            } catch (Exception e) {
                                            %>
                                            <span style="color: var(--gray-400);">Not rated</span>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-thumbs-up"></i>
                                    </div>
                                    <div class="info-content">
                                        <strong>Clients Rated:</strong>
                                        <span class="rating-badge"><%= w[8] != null && Integer.parseInt(w[8].toString()) > 0 ? w[8] : "No ratings yet"%></span>
                                    </div>
                                </div>
                            </div>

                            <div class="worker-actions">
                                <form action="ClientChat1.jsp" method="get" style="margin: 0; flex: 1;">
                                    <input type="hidden" name="SenderName" value="<%= w[3]%>">
                                    <input type="hidden" name="chatPartnerId" value="<%= w[6]%>">
                                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                                        <i class="fas fa-envelope"></i>
                                        Message
                                    </button>
                                </form>

                                <button type="button" class="btn btn-outline btn-location" 
                                        onclick="toggleMap('<%= w[1]%>', 'map-<%= index%>', this)">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span class="btn-text">Show Location</span>
                                </button>
                            </div>

                            <div id="map-<%= index%>" class="map-container"></div>
                        </div>
                        <%
                                index++;
                            }
                        %>
                    </div>
                    <%
                    } else if (workers != null) {
                    %>
                    <div class="no-results">
                        <i class="fas fa-search"></i>
                        <h3>No Workers Found</h3>
                        <p>Try adjusting your search criteria or check back later for new workers in your area.</p>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>

        <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
        <script>
                                            function toggleMobileMenu() {
                                                const sidebar = document.querySelector('.sidebar');
                                                const overlay = document.querySelector('.sidebar-overlay');

                                                sidebar.classList.toggle('show');
                                                overlay.classList.toggle('show');
                                            }

                                            function closeMobileMenu() {
                                                const sidebar = document.querySelector('.sidebar');
                                                const overlay = document.querySelector('.sidebar-overlay');

                                                sidebar.classList.remove('show');
                                                overlay.classList.remove('show');
                                            }

                                            function toggleMap(address, mapId, button) {
                                                const mapDiv = document.getElementById(mapId);
                                                const btnText = button.querySelector('.btn-text');
                                                const btnIcon = button.querySelector('i');

                                                if (mapDiv.classList.contains('show')) {
                                                    mapDiv.classList.remove('show');
                                                    mapDiv.style.display = 'none';
                                                    mapDiv.innerHTML = '';
                                                    btnText.textContent = 'Show Location';
                                                    btnIcon.className = 'fas fa-map-marker-alt';
                                                    button.classList.remove('btn-primary');
                                                    button.classList.add('btn-outline');
                                                } else {
                                                    mapDiv.style.display = 'block';
                                                    mapDiv.classList.add('show');
                                                    btnText.textContent = 'Hide Location';
                                                    btnIcon.className = 'fas fa-eye-slash';
                                                    button.classList.remove('btn-outline');
                                                    button.classList.add('btn-primary');

                                                    // Show loading state
                                                    mapDiv.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 300px; color: var(--gray-500);"><i class="fas fa-spinner fa-spin" style="margin-right: 0.5rem;"></i> Loading map...</div>';

                                                    fetch("https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(address), {
                                                        headers: {"User-Agent": "WorkerFinderApp/1.0"}
                                                    })
                                                            .then(response => response.json())
                                                            .then(data => {
                                                                if (data && data.length > 0) {
                                                                    const location = data[0];
                                                                    const lat = parseFloat(location.lat);
                                                                    const lon = parseFloat(location.lon);

                                                                    // Clear loading state
                                                                    mapDiv.innerHTML = '';

                                                                    const map = L.map(mapId).setView([lat, lon], 15);
                                                                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                                                                        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                                                                    }).addTo(map);

                                                                    // Custom marker icon
                                                                    const customIcon = L.divIcon({
                                                                        html: '<div style="background: var(--primary); color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 3px solid white; box-shadow: 0 2px 10px rgba(0,0,0,0.3);"><i class="fas fa-user" style="font-size: 12px;"></i></div>',
                                                                        className: 'custom-marker',
                                                                        iconSize: [30, 30],
                                                                        iconAnchor: [15, 15]
                                                                    });

                                                                    L.marker([lat, lon], {icon: customIcon}).addTo(map)
                                                                            .bindPopup(`
                                    <div style="text-align: center; padding: 0.5rem;">
                                        <strong style="color: var(--primary);">Worker Location</strong><br>
                                        <span style="color: var(--gray-600); font-size: 0.9rem;">${address}</span>
                                    </div>
                                `)
                                                                            .openPopup();

                                                                    // Resize map after a short delay to ensure proper rendering
                                                                    setTimeout(() => {
                                                                        map.invalidateSize();
                                                                    }, 100);
                                                                } else {
                                                                    mapDiv.innerHTML = `
                                <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 300px; color: var(--gray-500); text-align: center;">
                                    <i class="fas fa-exclamation-triangle" style="font-size: 2rem; margin-bottom: 1rem; color: var(--warning);"></i>
                                    <h4 style="margin-bottom: 0.5rem; color: var(--gray-700);">Location Not Found</h4>
                                    <p style="margin: 0; font-size: 0.9rem;">Unable to find the specified address on the map.</p>
                                </div>
                            `;
                                                                }
                                                            })
                                                            .catch(error => {
                                                                console.error("Error:", error);
                                                                mapDiv.innerHTML = `
                            <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 300px; color: var(--gray-500); text-align: center;">
                                <i class="fas fa-wifi" style="font-size: 2rem; margin-bottom: 1rem; color: var(--danger);"></i>
                                <h4 style="margin-bottom: 0.5rem; color: var(--gray-700);">Connection Error</h4>
                                <p style="margin: 0; font-size: 0.9rem;">Please check your internet connection and try again.</p>
                            </div>
                        `;
                                                            });
                                                }
                                            }

                                            // Close mobile menu when clicking on menu items
                                            document.querySelectorAll('.sidebar a').forEach(link => {
                                                link.addEventListener('click', closeMobileMenu);
                                            });

                                            // Handle window resize
                                            window.addEventListener('resize', () => {
                                                if (window.innerWidth > 768) {
                                                    closeMobileMenu();
                                                }
                                            });

                                            // Add smooth scrolling to results when search is performed
                                            document.querySelector('form').addEventListener('submit', function () {
                                                setTimeout(() => {
                                                    const resultsSection = document.querySelector('.results-section');
                                                    if (resultsSection) {
                                                        resultsSection.scrollIntoView({behavior: 'smooth', block: 'start'});
                                                    }
                                                }, 100);
                                            });

                                            // Add loading state to search button
                                            document.querySelector('form').addEventListener('submit', function (e) {
                                                const submitBtn = this.querySelector('button[type="submit"]');
                                                const originalText = submitBtn.innerHTML;
                                                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Searching...';
                                                submitBtn.disabled = true;

                                                // Re-enable button after a delay (in case of errors)
                                                setTimeout(() => {
                                                    submitBtn.innerHTML = originalText;
                                                    submitBtn.disabled = false;
                                                }, 10000);
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