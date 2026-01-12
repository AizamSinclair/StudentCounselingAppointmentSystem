<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Includes the HTML start, Header-specific CSS, and the Header navigation bar.
--%>
<%@include file="header.jsp" %>

    <style>
        /* === ALERT STYLES === */
        .login-success-alert {
            position: fixed;
            top: 20px; 
            left: 50%;
            transform: translateX(-50%);
            padding: 15px 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            z-index: 9999; 
            font-size: 1.1em;
            font-weight: bold;
            text-align: center;
            opacity: 0; 
            transition: opacity 0.5s, transform 0.5s;
            pointer-events: none;
        }
        
        /* Success (Green) for Login */
        .alert-success {
            background-color: #d4edda; 
            color: #155724; 
            border: 1px solid #c3e6cb;
        }

        /* Info (Blue) for Logout */
        .alert-info {
            background-color: #d1ecf1; 
            color: #0c5460; 
            border: 1px solid #bee5eb;
        }

        .login-success-alert.show {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }

        /* --- CONTENT AREA WRAPPER --- */
        .content-area {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            position: relative;
        }
        
        /* HERO SECTION */
        .hero-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: calc(100vh - 120px); 
            width: 100%;
            position: relative;
            background-image: url('images/index2.jpg');
            background-size: cover;
            background-position: center;
        }

        .content-overlay {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: rgba(0, 0, 0, 0.4);
        }
        
        .main-content {
            position: relative;
            z-index: 10;
            color: white;
            max-width: 600px;
            padding: 20px;
        }

        .icountm-logo {
            width: 300px;
            height: auto;
            margin-bottom: 20px;
        }
        
        .welcome-text {
            font-size: clamp(1.5em, 5vw, 2.2em); 
            font-weight: bold;
            margin-bottom: 10px;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
        }

        .support-text {
            font-size: clamp(1em, 3vw, 1.2em);
            margin-bottom: 30px;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
        }

        .book-btn {
            padding: 15px 30px;
            background-color: #3aa2e6;
            color: white !important;
            border: 2px solid #3aa2e6;
            border-radius: 30px;
            font-size: 1.1em;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .book-btn:hover { background-color: #2980b9; }

        /* === INTRO SECTION === */
        .intro-section {
            width: 100%;
            padding: 80px 20px;
            box-sizing: border-box;
            display: flex;
            justify-content: center;
            position: relative; 
            background-image: url('images/index3.jpg'); 
            background-size: cover; 
            background-position: center;
            min-height: 500px; 
        }

        .intro-background-wrapper {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: rgba(0, 0, 0, 0.5); 
            backdrop-filter: blur(2px);
            z-index: 1; 
        }

        .intro-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 25px;
            max-width: 800px; 
            width: 100%;
            position: relative; 
            z-index: 5;
        }
        
        .intro-title {
            background-color: #f8f9fa; 
            color: #2d3436;
            font-size: 2em;
            font-weight: 800;
            padding: 15px 45px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2); 
            margin: 0;
            border: 1px solid rgba(255,255,255,0.8);
        }
        
        .intro-card {
            background-color: #f1f2f6; 
            color: #2d3436;
            padding: 45px;
            border-radius: 20px; 
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3); 
            max-width: 650px;
            width: 100%;
            text-shadow: none;
        }

        .intro-text {
            font-size: 1.2em;
            line-height: 1.7;
            margin-bottom: 30px;
            font-weight: 500;
            color: #4b4b4b;
        }
    </style>
    
    <div class="content-area">
        
        <%-- LOGIN SUCCESS ALERT --%>
        <div id="loginAlert" class="login-success-alert alert-success">
           Login successful! Welcome, <c:out value="${sessionScope.userName}" default="Student"/>
        </div>

        <%-- LOGOUT SUCCESS ALERT --%>
        <div id="logoutAlert" class="login-success-alert alert-info">
           Logout successful! See you again
        </div>
        
        <div class="hero-section">
            <div class="content-overlay"></div>
            <div class="main-content">
                <img src="images/index.png" alt="i-Care UiTM Logo" class="icountm-logo">
                <p class="welcome-text">Welcome to UiTM booking appointment for student</p>
                <p class="support-text">Your Space for Support and Guidance Starts Here</p>
                
                <c:choose>
                    <c:when test="${not empty sessionScope.userName}">
                        <a href="${pageContext.request.contextPath}/bookAppointment" class="book-btn">Book Your Confidential Session Now</a>
                    </c:when>
                    <c:otherwise>
                        <a href="login.jsp" class="book-btn">Book Your Confidential Session Now</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="intro-section">
            <div class="intro-background-wrapper"></div>
            <div class="intro-container">
                <h2 class="intro-title">Student Counseling Appointment System</h2>
                <div class="intro-card">
                    <p class="intro-text">
                        This system helps students easily schedule sessions with university counselors, 
                        ensuring faster support and a smoother appointment process.
                    </p>
                    <a href="aboutus.jsp" class="book-btn">Read More About Us</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            
            const loginAlert = document.getElementById('loginAlert');
            const logoutAlert = document.getElementById('logoutAlert');

            if (status === 'LoginSuccess' && loginAlert) {
                loginAlert.classList.add('show');
                setTimeout(() => { loginAlert.classList.remove('show'); }, 4000); 
            } else if (status === 'LogoutSuccess' && logoutAlert) {
                logoutAlert.classList.add('show');
                setTimeout(() => { logoutAlert.classList.remove('show'); }, 4000); 
            }

            // Cleanup URL after 1 second
            if (status) {
                setTimeout(() => {
                    history.replaceState(null, null, window.location.pathname);
                }, 1000);
            }
        });
    </script>

<%@include file="footer.jsp" %>