<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Worker Registration - Create Your Account</title>
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
                padding: 10px;
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
                width: 60px;
                height: 60px;
                top: 15%;
                left: 10%;
                animation-delay: 0s;
            }

            .shape:nth-child(2) {
                width: 80px;
                height: 80px;
                top: 70%;
                right: 10%;
                animation-delay: 2s;
            }

            .shape:nth-child(3) {
                width: 40px;
                height: 40px;
                bottom: 15%;
                left: 20%;
                animation-delay: 4s;
            }

            @keyframes float {
                0%, 100% {
                    transform: translateY(0px) rotate(0deg);
                }
                50% {
                    transform: translateY(-15px) rotate(180deg);
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
                padding: 8px 15px;
                text-align: center;
                font-size: 16px;
                font-weight: 600;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                z-index: 1000;
                transition: all 0.3s ease;
            }

            .container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(15px);
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
                max-width: 420px;
                width: 100%;
                margin-top: 50px;
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                max-height: calc(100vh - 60px);
                overflow-y: auto;
            }

            .container:hover {
                transform: translateY(-3px);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            }

            .header {
                text-align: center;
                margin-bottom: 20px;
            }

            .header h1 {
                color: #2c3e50;
                font-size: 22px;
                font-weight: 700;
                margin-bottom: 5px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .header p {
                color: #7f8c8d;
                font-size: 12px;
            }

            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 12px;
                margin-bottom: 12px;
            }

            .form-group {
                position: relative;
                margin-bottom: 15px;
            }

            .form-group.full-width {
                grid-column: 1 / -1;
            }

            .form-group label {
                display: block;
                font-weight: 600;
                font-size: 12px;
                color: #34495e;
                margin-bottom: 5px;
                transition: color 0.3s ease;
            }

            .input-container {
                position: relative;
            }

            .input-container i {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: #bdc3c7;
                transition: color 0.3s ease;
                font-size: 12px;
            }

            .form-control {
                width: 100%;
                padding: 10px 10px 10px 35px;
                border: 2px solid #e1e8ed;
                border-radius: 8px;
                font-size: 13px;
                background: rgba(255, 255, 255, 0.8);
                transition: all 0.3s ease;
                font-family: inherit;
            }

            .form-control:focus {
                outline: none;
                border-color: #667eea;
                background: rgba(255, 255, 255, 1);
                box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
                transform: translateY(-1px);
            }

            .form-control:focus + i,
            .form-control:not(:placeholder-shown) + i {
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
                    transform: translateX(-3px);
                }
                75% {
                    transform: translateX(3px);
                }
            }

            .password-strength {
                height: 3px;
                background: #ecf0f1;
                border-radius: 2px;
                margin-top: 5px;
                overflow: hidden;
            }

            .password-strength-bar {
                height: 100%;
                width: 0%;
                transition: all 0.3s ease;
                border-radius: 2px;
            }

            .strength-weak {
                background: #e74c3c;
                width: 25%;
            }
            .strength-fair {
                background: #f39c12;
                width: 50%;
            }
            .strength-good {
                background: #f1c40f;
                width: 75%;
            }
            .strength-strong {
                background: #27ae60;
                width: 100%;
            }

            .password-requirements {
                font-size: 10px;
                color: #7f8c8d;
                margin-top: 5px;
                line-height: 1.3;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 2px;
            }

            .requirement {
                display: flex;
                align-items: center;
                margin: 1px 0;
            }

            .requirement i {
                margin-right: 4px;
                font-size: 8px;
            }

            .requirement.met {
                color: #27ae60;
            }

            .btn-register {
                width: 100%;
                padding: 12px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 8px;
                position: relative;
                overflow: hidden;
            }

            .btn-register::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }

            .btn-register:hover::before {
                left: 100%;
            }

            .btn-register:hover {
                transform: translateY(-1px);
                box-shadow: 0 8px 15px rgba(102, 126, 234, 0.3);
            }

            .btn-register:active {
                transform: translateY(0);
            }

            .divider {
                text-align: center;
                margin: 15px 0;
                position: relative;
                color: #7f8c8d;
                font-size: 12px;
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
                padding: 0 10px;
                position: relative;
                z-index: 2;
            }

            .login-link {
                text-align: center;
                font-size: 12px;
            }

            .login-link a {
                color: #667eea;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .login-link a:hover {
                color: #764ba2;
                text-decoration: underline;
            }

            .error-message {
                background: #fdf2f2;
                color: #e74c3c;
                padding: 8px;
                border-radius: 6px;
                font-size: 12px;
                margin-bottom: 10px;
                border-left: 3px solid #e74c3c;
                display: none;
            }

            .success-message {
                background: #f0f9f0;
                color: #27ae60;
                padding: 8px;
                border-radius: 6px;
                font-size: 12px;
                margin-bottom: 10px;
                border-left: 3px solid #27ae60;
                display: none;
            }

            @media (max-width: 768px) {
                .container {
                    margin: 10px;
                    padding: 15px;
                    margin-top: 45px;
                }

                .form-grid {
                    grid-template-columns: 1fr;
                    gap: 10px;
                }

                .navbar {
                    font-size: 14px;
                    padding: 6px 10px;
                }

                .password-requirements {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 480px) {
                .header h1 {
                    font-size: 20px;
                }

                .form-control {
                    padding: 8px 8px 8px 30px;
                    font-size: 12px;
                }

                .container {
                    padding: 12px;
                }
            }

            @media (max-height: 600px) {
                .container {
                    margin-top: 40px;
                    padding: 15px;
                }

                .header {
                    margin-bottom: 15px;
                }

                .form-group {
                    margin-bottom: 12px;
                }

                .header h1 {
                    font-size: 20px;
                    margin-bottom: 3px;
                }

                .header p {
                    display: none;
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
            <i class="fas fa-user-plus"></i> Worker Registration Portal
        </div>

        <div class="container">
            <div class="header">
                <h1>Join Our Team</h1>
                <p>Create your account to get started</p>
            </div>

            <div id="errorMessage" class="error-message"></div>
            <div id="successMessage" class="success-message"></div>

            <form id="registrationForm" action="Registration" method="post">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <div class="input-container">
                            <input type="text" name="FirstName" id="firstName" class="form-control" 
                                   placeholder="Enter first name" required>
                            <i class="fas fa-user"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <div class="input-container">
                            <input type="text" name="LastName" id="lastName" class="form-control" 
                                   placeholder="Enter last name" required>
                            <i class="fas fa-user"></i>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="username">Username</label>
                    <div class="input-container">
                        <input type="text" name="username" id="username" class="form-control" 
                               placeholder="Choose a unique username" required>
                        <i class="fas fa-at"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-container">
                        <input type="email" name="email" id="email" class="form-control" 
                               placeholder="Enter your email" required>
                        <i class="fas fa-envelope"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-container">
                        <input type="password" name="password" id="password" class="form-control" 
                               placeholder="Create a strong password" required>
                        <i class="fas fa-lock"></i>
                    </div>
                    <div class="password-strength">
                        <div id="passwordStrengthBar" class="password-strength-bar"></div>
                    </div>
                    <div class="password-requirements">
                        <div class="requirement" id="length">
                            <i class="fas fa-times"></i> At least 8 characters
                        </div>
                        <div class="requirement" id="uppercase">
                            <i class="fas fa-times"></i> One uppercase letter
                        </div>
                        <div class="requirement" id="lowercase">
                            <i class="fas fa-times"></i> One lowercase letter
                        </div>
                        <div class="requirement" id="number">
                            <i class="fas fa-times"></i> One number
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="input-container">
                        <input type="password" name="ConfirmPass" id="confirmPassword" class="form-control" 
                               placeholder="Confirm your password" required>
                        <i class="fas fa-lock"></i>
                    </div>
                </div>

                <button type="submit" class="btn-register">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>

            <div class="divider">
                <span>Already have an account?</span>
            </div>

            <div class="login-link">
                <a href="WorkerLogin.jsp">
                    <i class="fas fa-sign-in-alt"></i> Sign in to your account
                </a>
            </div>
        </div>

        <script>
            const form = document.getElementById('registrationForm');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            const strengthBar = document.getElementById('passwordStrengthBar');
            const requirements = {
                length: document.getElementById('length'),
                uppercase: document.getElementById('uppercase'),
                lowercase: document.getElementById('lowercase'),
                number: document.getElementById('number')
            };

            // Password strength checker
            password.addEventListener('input', function () {
                const value = this.value;
                let strength = 0;

                // Check length
                if (value.length >= 8) {
                    requirements.length.classList.add('met');
                    requirements.length.querySelector('i').className = 'fas fa-check';
                    strength++;
                } else {
                    requirements.length.classList.remove('met');
                    requirements.length.querySelector('i').className = 'fas fa-times';
                }

                // Check uppercase
                if (/[A-Z]/.test(value)) {
                    requirements.uppercase.classList.add('met');
                    requirements.uppercase.querySelector('i').className = 'fas fa-check';
                    strength++;
                } else {
                    requirements.uppercase.classList.remove('met');
                    requirements.uppercase.querySelector('i').className = 'fas fa-times';
                }

                // Check lowercase
                if (/[a-z]/.test(value)) {
                    requirements.lowercase.classList.add('met');
                    requirements.lowercase.querySelector('i').className = 'fas fa-check';
                    strength++;
                } else {
                    requirements.lowercase.classList.remove('met');
                    requirements.lowercase.querySelector('i').className = 'fas fa-times';
                }

                // Check number
                if (/[0-9]/.test(value)) {
                    requirements.number.classList.add('met');
                    requirements.number.querySelector('i').className = 'fas fa-check';
                    strength++;
                } else {
                    requirements.number.classList.remove('met');
                    requirements.number.querySelector('i').className = 'fas fa-times';
                }

                // Update strength bar
                strengthBar.className = 'password-strength-bar';
                if (strength === 1)
                    strengthBar.classList.add('strength-weak');
                else if (strength === 2)
                    strengthBar.classList.add('strength-fair');
                else if (strength === 3)
                    strengthBar.classList.add('strength-good');
                else if (strength === 4)
                    strengthBar.classList.add('strength-strong');
            });

            // Form validation
            form.addEventListener('submit', function (e) {
                let isValid = true;
                const errorMessage = document.getElementById('errorMessage');

                // Clear previous errors
                document.querySelectorAll('.form-control').forEach(input => {
                    input.classList.remove('error');
                });
                errorMessage.style.display = 'none';

                // Check if passwords match
                if (password.value !== confirmPassword.value) {
                    confirmPassword.classList.add('error');
                    password.classList.add('error');
                    errorMessage.textContent = 'Passwords do not match!';
                    errorMessage.style.display = 'block';
                    isValid = false;
                }

                // Check password strength
                const strengthMet = Object.values(requirements).every(req => req.classList.contains('met'));
                if (!strengthMet) {
                    password.classList.add('error');
                    errorMessage.textContent = 'Password does not meet all requirements!';
                    errorMessage.style.display = 'block';
                    isValid = false;
                }

                if (!isValid) {
                    e.preventDefault();
                    return false;
                }
            });

            // Real-time password confirmation
            confirmPassword.addEventListener('input', function () {
                if (this.value && this.value !== password.value) {
                    this.classList.add('error');
                } else {
                    this.classList.remove('error');
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
            });
        </script>
    </body>
</html>