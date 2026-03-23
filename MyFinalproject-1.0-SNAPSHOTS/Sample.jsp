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
                border-bottom: 1px solid var(--gray-200);
                color: var(--gray-800);
                padding: 1rem 2rem;
                font-size: 1.25rem;
                font-weight: 600;
                box-shadow: var(--shadow-sm);
                z-index: 1000;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .navbar-brand {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .navbar-brand i {
                color: var(--primary);
                font-size: 1.5rem;
            }

            .mobile-menu-btn {
                display: none;
                background: none;
                border: none;
                font-size: 1.5rem;
                color: var(--gray-600);
                cursor: pointer;
                padding: 0.5rem;
                border-radius: var(--radius);
                transition: all 0.2s ease;
            }

            .mobile-menu-btn:hover {
                background: var(--gray-100);
                color: var(--primary);
            }

            .sidebar {
                width: 280px;
                height: 100vh;
                background: var(--white);
                padding-top: 5rem;
                position: fixed;
                top: 0;
                left: 0;
                box-shadow: var(--shadow-lg);
                overflow-y: auto;
                transition: transform 0.3s ease;
                z-index: 999;
            }

            .sidebar.mobile-hidden {
                transform: translateX(-100%);
            }

            .sidebar-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 998;
            }

            .profile-container {
                text-align: center;
                padding: 2rem 1.5rem;
                border-bottom: 1px solid var(--gray-200);
                margin-bottom: 1rem;
            }

            .profile-container img {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                object-fit: cover;
                border: 4px solid var(--primary-light);
                margin-bottom: 1rem;
                transition: transform 0.2s ease;
            }

            .profile-container img:hover {
                transform: scale(1.05);
            }

            .profile-container h5 {
                color: var(--gray-800);
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .sidebar-section {
                margin-bottom: 2rem;
            }

            .sidebar h4 {
                padding: 0 1.5rem;
                font-weight: 600;
                font-size: 0.875rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                color: var(--gray-500);
                margin-bottom: 0.5rem;
            }

            .sidebar a {
                display: flex;
                align-items: center;
                padding: 0.75rem 1.5rem;
                color: var(--gray-700);
                text-decoration: none;
                transition: all 0.2s ease;
                border-left: 3px solid transparent;
                position: relative;
            }

            .sidebar a:hover {
                background: var(--gray-50);
                color: var(--primary);
                border-left-color: var(--primary);
            }

            .sidebar a.active {
                background: var(--primary-light);
                background: rgba(59, 130, 246, 0.1);
                color: var(--primary);
                border-left-color: var(--primary);
                font-weight: 500;
            }

            .sidebar a i {
                margin-right: 0.75rem;
                width: 1.25rem;
                text-align: center;
                font-size: 1.1rem;
            }

            #messageNotification {
                position: absolute;
                top: 50%;
                right: 1rem;
                transform: translateY(-50%);
                background: var(--danger);
                color: white;
                border-radius: 50%;
                width: 8px;
                height: 8px;
                font-size: 0;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% { transform: translateY(-50%) scale(1); }
                50% { transform: translateY(-50%) scale(1.2); }
                100% { transform: translateY(-50%) scale(1); }
            }

            .main {
                margin-left: 280px;
                padding: 6rem 2rem 2rem;
                min-height: 100vh;
                transition: margin-left 0.3s ease;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
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
        </style>
    </head>
    <body>
        <div class="navbar">
            <div class="navbar-brand">
                <i class="fas fa-tools"></i>
                Find Available Jobs
            </div>
            <button class="mobile-menu-btn" onclick="toggleMobileMenu()">
                <i class="fas fa-bars"></i>
            </button>
        </div>

        <div class="sidebar-overlay" onclick="closeMobileMenu()"></div>
        <div class="sidebar">
            <div class="sidebar-section">
                <h4>Menu</h4>
                <a href="WorkerDashboard.jsp"><i class="fas fa-home"></i>Dashboard</a>
            </div>
            
            <div class="sidebar-section">
                <h4>Submit</h4>
                <a href="register_woker.jsp"><i class="fas fa-clipboard-list"></i>Post Work You Need Done</a>
            </div>
            
            <div class="sidebar-section">
                <h4>Find</h4>
                <a href="find_works.jsp" class="active"><i class="fas fa-search-location"></i>Find Workers Near You</a>
            </div>
            
            <div class="sidebar-section">
                <h4>Account</h4>
                <a href="profile.jsp"><i class="fas fa-user-circle"></i>Profile</a>
                <a href="messages.jsp" style="position: relative;">
                    <i class="fas fa-envelope"></i> Messages
                    <span id="messageNotification"></span>
                </a>
                <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <div class="main">
            <div class="container">
                <div class="search-section">
                    <div class="search-header">
                        <h2>Find Available Jobs</h2>
                        <p>Connect with skilled professionals in your area</p>
                    </div>
                    
                    <div class="form-layout">
                        <form action="searchWorks" method="post" class="search-form">
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
                                        <option value="Cleaning">🧽 Cleaning</option>
                                        <option value="Painting">🎨 Painting</option>
                                        <option value="Gardening">🌱 Gardening</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-row">
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
                                        City
                                    </label>
                                    <input type="text" name="city" id="city" class="form-control" 
                                           placeholder="e.g. Bayawan City" required>
                                </div>
                            </div>

                            <div class="search-button">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i>
                                    Search Works
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
                            Matching Jobs
                        </h3>
                        <span class="results-count"><%= workers.size() %> found</span>
                    </div>

                    <div class="workers-grid">
                        <%
                            int index = 0;
                            for (String[] w : workers) {
                        %>
                        <div class="worker-card">
                            <div class="worker-header">
                                <div class="worker-type"><%= w[0] %></div>
                                <div class="worker-distance">
                                    <i class="fas fa-location-arrow"></i>
                                    <%= w[1] %> km
                                </div>
                            </div>

                            <div class="worker-info">
                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div class="info-content">
                                        <strong>Name:</strong> <%= w[4] %>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <div class="info-content">
                                        <strong>Address:</strong> <%= w[3] %>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon">
                                        <i class="fas fa-briefcase"></i>
                                    </div>
                                    <div class="info-content">
                                        <strong>Description::</strong> <%= w[2] %>
                                    </div>
                                </div>

                                
                            </div>

                            <div class="worker-actions">
                                <form action="Sendmessage.jsp" method="get" style="margin: 0; flex: 1;">
                                    <input type="hidden" name="name" value="<%= w[4] %>">
                                    <input type="hidden" name="id" value="<%= w[5] %>">
                                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                                        <i class="fas fa-envelope"></i>
                                        Message
                                    </button>
                                </form>
                                
                                <button type="button" class="btn btn-outline btn-location" 
                                        onclick="toggleMap('<%= w[1] %>', 'map-<%= index %>', this)">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span class="btn-text">Show Location</span>
                                </button>
                            </div>

                            <div id="map-<%= index %>" class="map-container"></div>
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
            document.querySelector('form').addEventListener('submit', function() {
                setTimeout(() => {
                    const resultsSection = document.querySelector('.results-section');
                    if (resultsSection) {
                        resultsSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                }, 100);
            });

            // Add loading state to search button
            document.querySelector('form').addEventListener('submit', function(e) {
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
        </script>
    </body>
</html>