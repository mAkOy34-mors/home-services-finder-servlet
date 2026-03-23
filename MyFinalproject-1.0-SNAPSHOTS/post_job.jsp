<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    int userId = -1;

    if (session != null && session.getAttribute("userId") != null) {
        Object uidObj = session.getAttribute("userId");
        if (uidObj instanceof Integer) {
            userId = (Integer) uidObj;
        } else if (uidObj instanceof String) {
            try {
                userId = Integer.parseInt((String) uidObj);
            } catch (NumberFormatException e) {
                userId = -1;
            }
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Post a Job</title>

        <!-- Leaflet CSS -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

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
                display: flex;
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
                width: 240px;
                height: 100vh;
                background: rgba(45, 55, 72, 0.95);
                backdrop-filter: blur(20px);
                padding-top: 80px;
                padding-bottom: 15px;
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

            .sidebar-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 999;
                display: none;
                transition: opacity 0.3s ease;
            }

            .sidebar-overlay.show {
                display: block;
                opacity: 1;
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
                padding: 8px 20px;
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

            .sidebar a[href="post_job.jsp"] {
                background: linear-gradient(90deg, rgba(103, 126, 234, 0.2), rgba(118, 75, 162, 0.2));
                border-left-color: #667eea;
                color: white;
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
                padding: 90px 40px 40px 40px;
                min-height: 100vh;
                width: calc(100% - 260px);
                transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1), width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            .main.expanded {
                margin-left: 0;
                width: 100%;
            }

            @media (max-width: 768px) {
                .main {
                    margin-left: 0;
                    width: 100%;
                    padding: 90px 20px 40px 20px;
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
                margin-right: 12px;
                width: 20px;
                text-align: center;
                font-size: 16px;
            }

            .sidebar a:hover {
                color: white;
                border-left-color: #667eea;
                transform: translateX(5px);
            }

            .sidebar a[href="register_worker.jsp"] {
                background: linear-gradient(90deg, rgba(103, 126, 234, 0.2), rgba(118, 75, 162, 0.2));
                border-left-color: #667eea;
                color: white;
            }

            

            .container {
                max-width: 1200px;
                width: 100%;
                margin: 0 auto;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                padding: 30px;
                border-radius: 24px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                display: flex;
                gap: 30px;
                align-items: flex-start;
                position: relative;
                transition: max-width 0.3s ease;
            }

            .container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 6px;
                background: linear-gradient(90deg, #667eea, #764ba2);
            }

            .form-fields {
                flex: 2;
                min-width: 0;
                transition: flex 0.3s ease;
            }

            .form-image {
                flex: 1;
                text-align: center;
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 15px;
                transition: flex 0.3s ease;
            }

            .form-image img {
                max-width: 100%;
                height: auto;
                border-radius: 16px;
                box-shadow: 0 16px 32px rgba(103, 126, 234, 0.2);
                transition: transform 0.3s ease;
            }

            .form-image img:hover {
                transform: scale(1.05);
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
                font-weight: 400;
                text-align: center;
                margin-bottom: 30px;
            }

            .form-container {
                background: rgba(247, 250, 252, 0.8);
                border-radius: 16px;
                padding: 30px;
                border: 1px solid rgba(226, 232, 240, 0.5);
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #2d3748;
                font-size: 15px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            label i {
                color: #667eea;
                width: 18px;
            }

            select, input[type="text"], input[type="number"], textarea {
                width: 100%;
                padding: 12px 16px;
                border-radius: 8px;
                border: 2px solid #e2e8f0;
                background: white;
                font-size: 15px;
                font-family: inherit;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            }

            select:focus, input:focus, textarea:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(103, 126, 234, 0.1);
                transform: translateY(-2px);
            }

            select {
                cursor: pointer;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
                background-position: right 10px center;
                background-repeat: no-repeat;
                background-size: 14px;
                appearance: none;
            }

            .btn {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 14px 30px;
                border: none;
                border-radius: 12px;
                cursor: pointer;
                font-weight: 600;
                font-size: 16px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 0 8px 16px rgba(103, 126, 234, 0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                margin: 20px auto 0;
                min-width: 180px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 24px rgba(103, 126, 234, 0.3);
                background: linear-gradient(135deg, #5a67d8, #6b46c1);
            }

            .btn:active {
                transform: translateY(-1px);
            }

            .work-type-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
                gap: 10px;
                margin-top: 8px;
            }

            .work-type-option {
                display: none;
            }

            .work-type-label {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 15px 10px;
                background: white;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-align: center;
                min-height: 80px;
            }

            .work-type-label i {
                font-size: 20px;
                margin-bottom: 6px;
                color: #718096;
                transition: color 0.3s ease;
            }

            .work-type-label span {
                font-size: 13px;
                font-weight: 600;
                color: #4a5568;
            }

            .work-type-option:checked + .work-type-label {
                border-color: #667eea;
                background: linear-gradient(135deg, rgba(103, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(103, 126, 234, 0.2);
            }

            .work-type-option:checked + .work-type-label i {
                color: #667eea;
            }

            .work-type-option:checked + .work-type-label span {
                color: #667eea;
            }

            .illustration-text {
                color: #718096;
                font-size: 14px;
                text-align: center;
                margin-top: 15px;
                font-weight: 500;
            }

            .stats-card {
                background: rgba(255, 255, 255, 0.8);
                border-radius: 12px;
                padding: 15px;
                text-align: center;
                border: 1px solid rgba(226, 232, 240, 0.5);
            }

            .stats-number {
                font-size: 28px;
                font-weight: 800;
                color: #667eea;
                display: block;
            }

            .stats-label {
                font-size: 13px;
                color: #718096;
                font-weight: 500;
            }

            @media (max-width: 1024px) {
                .sidebar {
                    width: 240px;
                }

                .main {
                    margin-left: 240px;
                    width: calc(100% - 240px);
                    padding: 90px 30px 40px 30px;
                }

                .main.expanded {
                    margin-left: 0;
                    width: 100%;
                }

                .container {
                    padding: 25px;
                    gap: 25px;
                }
            }

            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }

                .sidebar.mobile-open {
                    transform: translateX(0);
                }

                .main {
                    margin-left: 0;
                    width: 100%;
                    padding: 90px 15px 30px 15px;
                }

                .container {
                    flex-direction: column;
                    padding: 20px;
                    gap: 20px;
                }

                .form-image {
                    order: -1;
                }

                .page-title {
                    font-size: 30px;
                }

                .skill-type-grid {
                    grid-template-columns: repeat(2, 1fr);
                }

                .btn {
                    width: 100%;
                }
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
        </style>
    </head>
    <body>

        <div class="navbar">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <i class="fas fa-briefcase"></i>
            Post a Job
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
                <div class="form-fields">
                    <h1 class="page-title">Post a Job</h1>
                    <p class="page-subtitle">Find the perfect worker for your project</p>

                    <div class="form-container slide-up">
                        <form action="Job" method="post">
                            <div class="form-group">
                                <label for="type">
                                    <i class="fas fa-tools"></i>
                                    Type of Work
                                </label>
                                <div class="work-type-grid">

                                    <div class="work-type-grid">
                                        <input type="radio" name="type" value="Plumbing" id="plumbing" class="work-type-option">
                                        <label for="plumbing" class="work-type-label">
                                            <i class="fas fa-wrench"></i>
                                            <span>Plumbing</span>
                                        </label>

                                        <input type="radio" name="type" value="Electrician" id="electrician" class="work-type-option">
                                        <label for="electrician" class="work-type-label">
                                            <i class="fas fa-bolt"></i>
                                            <span>Electrician</span>
                                        </label>

                                        <input type="radio" name="type" value="General Repair" id="generalrepair" class="work-type-option">
                                        <label for="generalrepair" class="work-type-label">
                                            <i class="fas fa-tools"></i>
                                            <span>General Repair</span>
                                        </label>

                                        <input type="radio" name="type" value="Painting" id="painting" class="work-type-option">
                                        <label for="painting" class="work-type-label">
                                            <i class="fas fa-paint-roller"></i>
                                            <span>Painting</span>
                                        </label>

                                        <!-- Fixed: Changed duplicate painting to carpentry with unique ID -->
                                        <input type="radio" name="type" value="Carpentry" id="carpentry" class="work-type-option">
                                        <label for="carpentry" class="work-type-label">
                                            <i class="fas fa-hammer"></i>
                                            <span>Carpentry</span>
                                        </label>

                                        <!-- Add more work types with unique IDs -->
                                        <input type="radio" name="type" value="Gardening" id="gardening" class="work-type-option">
                                        <label for="gardening" class="work-type-label">
                                            <i class="fas fa-seedling"></i>
                                            <span>Gardening</span>
                                        </label>

                                        <input type="radio" name="type" value="Roofing" id="roofing" class="work-type-option">
                                        <label for="roofing" class="work-type-label">
                                            <i class="fas fa-home"></i>
                                            <span>Roofing</span>
                                        </label>

                                        <input type="radio" name="type" value="Appliance Repair" id="appliance" class="work-type-option">
                                        <label for="appliance" class="work-type-label">
                                            <i class="fas fa-tv"></i>
                                            <span>Appliance Repair</span>
                                        </label>
                                        <input type="radio" name="type" value="Babysitting" id="babysitting" class="work-type-option">
                                        <label for="babysitting" class="work-type-label">
                                            <i class="fas fa-baby"></i>
                                            <span>Babysitting</span>
                                        </label>

                                        <input type="radio" name="type" value="Tile Installation" id="tileinstall" class="work-type-option">
                                        <label for="tileinstall" class="work-type-label">
                                            <i class="fas fa-border-style"></i>
                                            <span>Tile Installation</span>
                                        </label>

                                        <input type="radio" name="type" value="Flooring" id="flooring" class="work-type-option">
                                        <label for="flooring" class="work-type-label">
                                            <i class="fas fa-stream"></i>
                                            <span>Flooring</span>
                                        </label>

                                        <input type="radio" name="type" value="Computer Repair" id="computer" class="work-type-option">
                                        <label for="computer" class="work-type-label">
                                            <i class="fas fa-laptop"></i>
                                            <span>Computer Repair</span>
                                        </label>

                                        <input type="radio" name="type" value="Furniture Assembly" id="furniture" class="work-type-option">
                                        <label for="furniture" class="work-type-label">
                                            <i class="fas fa-couch"></i>
                                            <span>Furniture Assembly</span>
                                        </label>

                                        <input type="radio" name="type" value="Interior Design" id="interiordesign" class="work-type-option">
                                        <label for="interiordesign" class="work-type-label">
                                            <i class="fas fa-drafting-compass"></i>
                                            <span>Interior Design</span>
                                        </label>

                                        <input type="radio" name="type" value="Laundry" id="laundry" class="work-type-option">
                                        <label for="laundry" class="work-type-label">
                                            <i class="fas fa-tshirt"></i>
                                            <span>Laundry</span>
                                        </label>

                                        <input type="radio" name="type" value="Tutoring" id="tutoring" class="work-type-option">
                                        <label for="tutoring" class="work-type-label">
                                            <i class="fas fa-book-open"></i>
                                            <span>Tutoring</span>
                                        </label>

                                        <input type="radio" name="type" value="Aircon Cleaning" id="aircon" class="work-type-option">
                                        <label for="aircon" class="work-type-label">
                                            <i class="fas fa-wind"></i>
                                            <span>Aircon Cleaning</span>
                                        </label>

                                        <input type="radio" name="type" value="Auto Mechanic" id="mechanic" class="work-type-option">
                                        <label for="mechanic" class="work-type-label">
                                            <i class="fas fa-car"></i>
                                            <span>Auto Mechanic</span>
                                        </label>

                                    </div>


                                </div>
                            </div>
                            <div class="form-group">
                                <label for="option">
                                    <i class="fas fa-tools"></i>
                                    Type Manually 
                                </label>
                                <input type="text" name="customType" id="option" placeholder="Input type of work"/>
                            </div> 
                            <div class="form-group"> 
                                <label for="street">
                                    <i class="fas fa-map-marker-alt"></i>
                                    Street Address
                                </label>
                                <input type="text" name="street" id="street" placeholder="e.g. Purok 2, Main Street" required />
                            </div>

                            <div class="form-group">
                                <label for="barangay">
                                    <i class="fas fa-location-dot"></i>
                                    Barangay
                                </label>
                                <input type="text" name="barangay" id="barangay" placeholder="e.g. Villarel" required />
                            </div>

                            <div class="form-group">
                                <label for="city">
                                    <i class="fas fa-city"></i>
                                    City/Municipality
                                </label>
                                <input type="text" name="city" id="city" placeholder="e.g. Bayawan City" required />
                            </div>



                            <div class="form-group">
                                <label for="description">
                                    <i class="fas fa-file-alt"></i>
                                    Job Description
                                </label>
                                <textarea name="description" id="description" placeholder="Describe the work that needs to be done, include details about timing, materials, and any specific requirements..." required></textarea>
                            </div>

                            <button type="submit" class="btn">
                                <i class="fas fa-paper-plane"></i>
                                Post Your Job
                            </button>
                        </form>
                    </div>
                </div>

                <div class="form-image slide-up">
                    <img src="Images/OIP.jpg" alt="Job Posting Illustration" />
                    <p class="illustration-text">Connect with skilled workers in your area</p>

                    <div class="stats-card">
                        <span class="stats-number">500+</span>
                        <span class="stats-label">Active Workers</span>
                    </div>
                </div>
            </div>
        </div>

        <script>

            document.querySelector("form").addEventListener("submit", function (e) {
                const radios = document.querySelectorAll('input[name="type"]');
                const customInput = document.getElementById("option");

                const radioSelected = Array.from(radios).some(r => r.checked);
                const customFilled = customInput.value.trim() !== "";

                if (!radioSelected && !customFilled) {
                    e.preventDefault();
                    alert("Please select a type of work or enter a custom type.");
                }
            });


            const customTypeInput = document.getElementById("option");
            const radios = document.querySelectorAll(".work-type-option");

            customTypeInput.addEventListener("input", () => {
                if (customTypeInput.value.trim() !== "") {
                    radios.forEach(radio => radio.checked = false);
                }
            });

            radios.forEach(radio => {
                radio.addEventListener("change", () => {
                    if (radio.checked) {
                        customTypeInput.value = "";
                    }
                });
            });



            // Add smooth scroll behavior
            document.documentElement.style.scrollBehavior = 'smooth';

            // Form validation and enhancement
            document.addEventListener('DOMContentLoaded', function () {
                const form = document.querySelector('form');
                const inputs = form.querySelectorAll('input, textarea, select');

                // Add focus animations
                inputs.forEach(input => {
                    input.addEventListener('focus', function () {
                        this.parentElement.style.transform = 'translateY(-2px)';
                    });

                    input.addEventListener('blur', function () {
                        this.parentElement.style.transform = 'translateY(0)';
                    });
                });

                // Add staggered animation to form groups
                const formGroups = document.querySelectorAll('.form-group');
                formGroups.forEach((group, index) => {
                    group.style.animationDelay = `${index * 0.1}s`;
                    group.classList.add('slide-up');
                });

                // Enhance form submission
                form.addEventListener('submit', function (e) {
                    const submitBtn = form.querySelector('.btn');
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Posting Job...';
                    submitBtn.disabled = true;
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