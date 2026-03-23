<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>HomeConnect | Welcome</title>
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
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: auto;
            padding: 15px;
        }

        /* Animated background elements */
        body::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 50px 50px;
            animation: float 20s ease-in-out infinite;
            z-index: 1;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(5deg); }
        }

        /* Floating orbs */
        .orb {
            position: absolute;
            border-radius: 50%;
            background: linear-gradient(45deg, rgba(255,255,255,0.3), rgba(255,255,255,0.1));
            backdrop-filter: blur(10px);
            z-index: 2;
        }

        .orb:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 20%;
            left: 15%;
            animation: drift 15s ease-in-out infinite;
        }

        .orb:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 60%;
            right: 20%;
            animation: drift 20s ease-in-out infinite reverse;
        }

        .orb:nth-child(3) {
            width: 60px;
            height: 60px;
            bottom: 20%;
            left: 25%;
            animation: drift 12s ease-in-out infinite;
        }

        @keyframes drift {
            0%, 100% { transform: translateY(0px) translateX(0px); }
            33% { transform: translateY(-30px) translateX(20px); }
            66% { transform: translateY(20px) translateX(-20px); }
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 30px;
            border-radius: 24px;
            box-shadow: 
                0 25px 50px rgba(0, 0, 0, 0.25),
                0 0 0 1px rgba(255, 255, 255, 0.3);
            text-align: center;
            width: 100%;
            max-width: 420px;
            max-height: 90vh;
            backdrop-filter: blur(20px);
            position: relative;
            z-index: 10;
            animation: slideUp 0.8s ease-out;
            margin: 0 auto;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logo {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 18px;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: white;
            font-weight: bold;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .header-section {
            margin-bottom: 25px;
        }

        h1 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -0.5px;
            line-height: 1.2;
        }

        .subtitle {
            font-size: 15px;
            color: #6b7280;
            font-weight: 400;
            line-height: 1.4;
            max-width: 300px;
            margin: 0 auto;
        }

        .role-selection {
            display: flex;
            flex-direction: column;
            gap: 14px;
           
            align-items: center;
        }

        .role-form {
            width: 100%;
            margin: 0;
        }

        .role-btn {
            position: relative;
            padding: 16px 20px;
            border: none;
            border-radius: 14px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            overflow: hidden;
            width: 100%;
            font-family: inherit;
        }

        .client-btn {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .provider-btn {
            background: white;
            color: #374151;
            border: 2px solid #e5e7eb;
        }

        .role-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
        }

        .provider-btn:hover {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-color: transparent;
        }

        .role-icon {
            font-size: 20px;
            display: flex;
            align-items: center;
        }

        .features {
            border-top: 1px solid #e5e7eb;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
            margin-top: 15px;
        }

        .feature-item {
            text-align: center;
            padding: 12px 8px;
            background: rgba(102, 126, 234, 0.05);
            border-radius: 10px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .feature-item:hover {
            background: rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .feature-icon {
            font-size: 20px;
            margin-bottom: 6px;
            opacity: 0.7;
            display: block;
        }

        .feature-text {
            font-size: 11px;
            color: #6b7280;
            font-weight: 500;
            text-align: center;
        }

        /* Mobile responsiveness */
        @media (max-width: 480px) {
            body {
                padding: 10px;
            }
            
            .container {
                width: 100%;
                max-width: none;
                padding: 30px 20px;
                border-radius: 18px;
                max-height: 95vh;
            }
            
            h1 {
                font-size: 26px;
            }
            
            .subtitle {
                font-size: 14px;
                max-width: 280px;
            }
            
            .role-btn {
                padding: 15px 18px;
                font-size: 14px;
            }
            
            .feature-grid {
                gap: 10px;
            }
            
            .feature-item {
                padding: 10px 6px;
            }
            
            .feature-text {
                font-size: 10px;
            }
        }

        @media (max-width: 360px) {
            .container {
                padding: 25px 15px;
                max-height: 96vh;
            }
            
            h1 {
                font-size: 24px;
            }
            
            .subtitle {
                font-size: 13px;
            }
            
            .logo {
                width: 60px;
                height: 60px;
                font-size: 24px;
            }
        }

        @media (max-height: 700px) {
            .container {
                padding: 25px 30px;
                max-height: 92vh;
            }
            
            .header-section {
                margin-bottom: 20px;
            }
            
            .role-selection {
                margin-bottom: 20px;
            }
            
            .logo {
                margin-bottom: 15px;
            }
        }

        /* Smooth loading animation */
        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.95);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .container > * {
            animation: fadeInScale 0.6s ease-out forwards;
        }

        .container > *:nth-child(2) { animation-delay: 0.1s; }
        .container > *:nth-child(3) { animation-delay: 0.2s; }
        .container > *:nth-child(4) { animation-delay: 0.3s; }

        /* Ripple animation */
        @keyframes ripple {
            to {
                transform: scale(2);
                opacity: 0;
            }
        }
    </style>
</head>
<body>
    <div class="orb"></div>
    <div class="orb"></div>
    <div class="orb"></div>
    
    <div class="container">
        <div class="logo">H</div>
        
        <div class="header-section">
            <h1>Home Services Finder</h1>
            <p class="subtitle">Connect with trusted professionals or offer your expertise to those who need it most.</p>
        </div>
        
        <div class="role-selection">
            <form action="ClientRegistration.jsp" method="get" class="role-form">
                <button type="submit" class="role-btn client-btn">
                    <span class="role-icon">🏠</span>
                    I Need Services
                </button>
            </form>
            
            <form action="WorkerRegistration.jsp" method="get" class="role-form">
                <button type="submit" class="role-btn provider-btn">
                    <span class="role-icon">⚡</span>
                    I Provide Services
                </button>
            </form>
        </div>
        
        <div class="features">
            <div class="feature-grid">
                <div class="feature-item">
                    <span class="feature-icon">🔒</span>
                    <span class="feature-text">Secure & Trusted</span>
                </div>
                <div class="feature-item">
                    <span class="feature-icon">⭐</span>
                    <span class="feature-text">Top Rated</span>
                </div>
                <div class="feature-item">
                    <span class="feature-icon">💬</span>
                    <span class="feature-text">24/7 Support</span>
                </div>
                <div class="feature-item">
                    <span class="feature-icon">⚡</span>
                    <span class="feature-text">Quick Match</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add smooth hover effects and interactions
        document.querySelectorAll('.role-btn').forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px) scale(1.02)';
            });
            
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
            
            btn.addEventListener('mousedown', function() {
                this.style.transform = 'translateY(-1px) scale(0.98)';
            });
            
            btn.addEventListener('mouseup', function() {
                this.style.transform = 'translateY(-3px) scale(1.02)';
            });
        });

        // Add click ripple effect
        document.querySelectorAll('.role-btn').forEach(button => {
            button.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.height, rect.width);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.width = ripple.style.height = size + 'px';
                ripple.style.left = x + 'px';
                ripple.style.top = y + 'px';
                ripple.style.position = 'absolute';
                ripple.style.borderRadius = '50%';
                ripple.style.background = 'rgba(255, 255, 255, 0.4)';
                ripple.style.transform = 'scale(0)';
                ripple.style.animation = 'ripple 0.6s linear';
                ripple.style.pointerEvents = 'none';
                
                this.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });

        // Parallax effect for background orbs
        document.addEventListener('mousemove', (e) => {
            const orbs = document.querySelectorAll('.orb');
            const x = e.clientX / window.innerWidth;
            const y = e.clientY / window.innerHeight;
            
            orbs.forEach((orb, index) => {
                const speed = (index + 1) * 0.5;
                const xPos = (x - 0.5) * speed * 20;
                const yPos = (y - 0.5) * speed * 20;
                orb.style.transform = `translate(${xPos}px, ${yPos}px)`;
            });
        });
    </script>
</body>
</html>