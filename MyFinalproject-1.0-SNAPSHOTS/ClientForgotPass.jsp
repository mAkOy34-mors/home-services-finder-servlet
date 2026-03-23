<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Forgot Password - Reset Your Password</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                overflow-x: hidden;
            }

            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('https://images.unsplash.com/photo-1600585154340-be6161a56a0c') no-repeat center center;
                background-size: cover;
                opacity: 0.1;
                z-index: -1;
            }

            .floating-shapes {
                position: absolute;
                width: 100%;
                height: 100%;
                overflow: hidden;
                z-index: -1;
            }

            .shape {
                position: absolute;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.1);
                animation: float 6s ease-in-out infinite;
            }

            .shape:nth-child(1) {
                width: 80px;
                height: 80px;
                top: 20%;
                left: 10%;
                animation-delay: 0s;
            }

            .shape:nth-child(2) {
                width: 120px;
                height: 120px;
                top: 60%;
                right: 10%;
                animation-delay: 2s;
            }

            .shape:nth-child(3) {
                width: 60px;
                height: 60px;
                bottom: 20%;
                left: 20%;
                animation-delay: 4s;
            }

            @keyframes float {
                0%, 100% {
                    transform: translateY(0px) rotate(0deg);
                }
                50% {
                    transform: translateY(-20px) rotate(180deg);
                }
            }

            .navbar {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                background: rgba(0, 123, 255, 0.95);
                backdrop-filter: blur(10px);
                color: white;
                padding: 15px 20px;
                text-align: center;
                font-size: 20px;
                font-weight: 600;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                z-index: 1000;
                transition: all 0.3s ease;
            }

            .container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(15px);
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                max-width: 450px;
                width: 90%;
                margin-top: 80px;
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .container:hover {
                transform: translateY(-5px);
                box-shadow: 0 30px 60px rgba(0, 0, 0, 0.15);
            }

            .header {
                text-align: center;
                margin-bottom: 30px;
            }

            .header .icon {
                font-size: 48px;
                color: #667eea;
                margin-bottom: 15px;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.1);
                }
            }

            .header h1 {
                color: #2c3e50;
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 8px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .header p {
                color: #7f8c8d;
                font-size: 14px;
                line-height: 1.5;
            }

            .form-group {
                position: relative;
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                font-weight: 600;
                font-size: 14px;
                color: #34495e;
                margin-bottom: 8px;
                transition: color 0.3s ease;
            }

            .input-container {
                position: relative;
            }

            .input-container i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #bdc3c7;
                transition: color 0.3s ease;
            }

            .form-control {
                width: 100%;
                padding: 15px 15px 15px 45px;
                border: 2px solid #e1e8ed;
                border-radius: 12px;
                font-size: 14px;
                background: rgba(255, 255, 255, 0.8);
                transition: all 0.3s ease;
                font-family: inherit;
            }

            .form-control:focus {
                outline: none;
                border-color: #667eea;
                background: rgba(255, 255, 255, 1);
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-2px);
            }

            .form-control:focus + i {
                color: #667eea;
            }

            .form-control.error {
                border-color: #e74c3c;
                animation: shake 0.5s ease-in-out;
            }

            @keyframes shake {
                0%, 100% {
                    transform: translateX(0);
                }
                25% {
                    transform: translateX(-5px);
                }
                75% {
                    transform: translateX(5px);
                }
            }

            .btn-send {
                width: 100%;
                padding: 15px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                border: none;
                border-radius: 12px;
                font-weight: 600;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 10px;
                position: relative;
                overflow: hidden;
            }

            .btn-send::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }

            .btn-send:hover::before {
                left: 100%;
            }

            .btn-send:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            }

            .btn-send:active {
                transform: translateY(0);
            }

            .divider {
                text-align: center;
                margin: 25px 0;
                position: relative;
                color: #7f8c8d;
                font-size: 14px;
            }

            .divider::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 1px;
                background: #e1e8ed;
                z-index: 1;
            }

            .divider span {
                background: rgba(255, 255, 255, 0.95);
                padding: 0 15px;
                position: relative;
                z-index: 2;
            }

            .login-link {
                text-align: center;
                font-size: 14px;
            }

            .login-link a {
                color: #667eea;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }

            .login-link a:hover {
                color: #764ba2;
                text-decoration: underline;
                transform: translateX(-5px);
            }

            .error-message {
                background: #fdf2f2;
                color: #e74c3c;
                padding: 10px;
                border-radius: 8px;
                font-size: 14px;
                margin-bottom: 15px;
                border-left: 4px solid #e74c3c;
                display: none;
            }

            .success-message {
                background: #f0f9f0;
                color: #27ae60;
                padding: 10px;
                border-radius: 8px;
                font-size: 14px;
                margin-bottom: 15px;
                border-left: 4px solid #27ae60;
                display: none;
            }

            .info-box {
                background: rgba(102, 126, 234, 0.1);
                border: 1px solid rgba(102, 126, 234, 0.2);
                border-radius: 12px;
                padding: 15px;
                margin-bottom: 20px;
                font-size: 13px;
                color: #5a6c7d;
                line-height: 1.5;
            }

            .info-box i {
                color: #667eea;
                margin-right: 8px;
            }

            @media (max-width: 768px) {
                .container {
                    margin: 20px;
                    padding: 30px 20px;
                }

                .navbar {
                    font-size: 18px;
                    padding: 12px 15px;
                }
            }

            @media (max-width: 480px) {
                .header h1 {
                    font-size: 24px;
                }

                .header .icon {
                    font-size: 40px;
                }

                .form-control {
                    padding: 12px 12px 12px 40px;
                }
            }
        </style>
    </head>
    <body>
        <div class="floating-shapes">
            <div class="shape"></div>
            <div class="shape"></div>
            <div class="shape"></div>
        </div>

        <div class="navbar">
            <i class="fas fa-key"></i> Password Recovery
        </div>

        <div class="container">
     

            <div class="header">
                <div class="icon">
                    <i class="fas fa-unlock-alt"></i>
                </div>
                <h1>Forgot Password</h1>
                <p>Enter your email address for verification</p>
            </div>
 <% String errorMsg = (String) request.getAttribute("errorMessage");
        if (errorMsg != null) {%>
            <div class="error-message" style="display: block;">
                <i class="fas fa-exclamation-triangle"></i> <%= errorMsg%>
            </div>
            <% } %>

            <% String emailNotFound = (String) request.getAttribute("EmailNotFound");
        if (emailNotFound != null) {%>
            <div class="error-message" style="display: block;">
                <i class="fas fa-exclamation-triangle"></i> <%= emailNotFound%>
            </div>
            <% }%>
            <div class="info-box">
                <i class="fas fa-info-circle"></i>
                Please enter the email address associated with your account.
            </div>

            <form id="forgotPasswordForm" action="SearchEmail" method="post">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-container">
                        <input type="email" name="email" id="email" class="form-control" 
                               placeholder="Enter your registered email" required>
                        <i class="fas fa-envelope"></i>
                    </div>
                </div>

                <button type="submit" class="btn-send">
                    <i class="fas fa-paper-plane"></i> Send
                </button>
            </form>

            <div class="divider">
                <span>Remember your password?</span>
            </div>

            <div class="login-link">
                <a href="ClientLogin.jsp">
                    <i class="fas fa-arrow-left"></i> Back to Login
                </a>
            </div>
        </div>

        <script>
            const form = document.getElementById('forgotPasswordForm');

            // Form validation
            form.addEventListener('submit', function (e) {
                const errorMessage = document.getElementById('errorMessage');
                const email = document.getElementById('email');

                // Clear previous errors
                email.classList.remove('error');
                errorMessage.style.display = 'none';

                // Validate email
                if (!email.value.trim()) {
                    email.classList.add('error');
                    errorMessage.textContent = 'Please enter your email address!';
                    errorMessage.style.display = 'block';
                    e.preventDefault();
                    return false;
                }

                // Email format validation
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailPattern.test(email.value.trim())) {
                    email.classList.add('error');
                    errorMessage.textContent = 'Please enter a valid email address!';
                    errorMessage.style.display = 'block';
                    e.preventDefault();
                    return false;
                }
            });

            // Input animations
            document.querySelectorAll('.form-control').forEach(input => {
                input.addEventListener('focus', function () {
                    this.parentElement.parentElement.querySelector('label').style.color = '#667eea';
                });

                input.addEventListener('blur', function () {
                    this.parentElement.parentElement.querySelector('label').style.color = '#34495e';
                });

                input.addEventListener('input', function () {
                    this.classList.remove('error');
                    const errorMessage = document.getElementById('errorMessage');
                    errorMessage.style.display = 'none';
                });
            });
        </script>
    </body>
</html>