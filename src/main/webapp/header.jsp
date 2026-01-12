<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UiTM Student Counseling</title>
    <style>
        :root {
            --dark-green-bg: #384238; 
            --teal-header: #80e6c6; 
            --input-white: #ffffff;
            --blue-btn: #4bb3f7; 
            --dark-text: #000000; 
            --body-bg-light: #f4f4f4; 
            --active-red: #ff4d4d; 
            --hover-gray: #e6e6e6;
        }

        body { margin: 0; font-family: Arial, sans-serif; background-color: var(--dark-green-bg); }

        .header { 
            background-color: var(--teal-header); 
            padding: 10px 30px; 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            width: 100%; 
            box-sizing: border-box; 
        }

        .top-header { 
            display: flex; 
            justify-content: flex-start; 
            align-items: center; 
            width: 100%; 
            padding-bottom: 5px; 
        }

        .logo-container { display: flex; align-items: center; min-width: 150px; }
        .uitm-logo { width: 165px; height: 90px; object-fit: contain; }

        .nav-links { 
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
            width: 100%; 
            padding: 5px 0 0; 
        }

        .nav-links-wrapper { display: flex; align-items: center; }

        .nav-links a { 
            color: var(--dark-text); 
            text-decoration: none; 
            font-weight: bold; 
            padding: 5px 15px; 
            border-right: 1px solid var(--dark-text); 
            white-space: nowrap; 
            transition: background-color 0.2s ease; 
        }

        .nav-links a:last-child { border-right: none; }
        .nav-links a:hover:not(.active, .auth-link) { background-color: var(--hover-gray); border-radius: 5px; }
        
        .nav-links a.active { 
            background-color: var(--input-white); 
            border-radius: 5px; 
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2); 
            border-right: none; 
        }
        
        /* --- AUTH LINKS STYLING --- */
        .auth-links-wrapper {
            display: flex;
            align-items: center;
            background: var(--input-white);
            padding: 2px 12px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .auth-link { 
            color: var(--dark-text) !important; 
            text-decoration: none; 
            font-weight: bold; 
            padding: 5px 10px !important;
            border-right: none !important; /* Remove the pipe border for these specific links */
            transition: color 0.2s;
        }

        .auth-link:hover { color: #3aa2e6 !important; }

        .auth-divider {
            color: #888;
            font-weight: normal;
            margin: 0 2px;
            user-select: none;
        }

        /* --- USER MENU --- */
        .user-menu-container { position: relative; display: flex; align-items: center; }
        .user-icon-clickable { cursor: pointer; padding: 5px; display: flex; align-items: center; height: 30px; }
        .user-greeting-text { color: var(--dark-text); font-size: 1.1em; font-weight: bold; padding: 5px; }
        
        .user-icon { 
            width: 20px; height: 20px; margin-right: 5px; background-color: var(--dark-text); 
            -webkit-mask: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><path fill="currentColor" d="M224 256A128 128 0 1 0 224 0a128 128 0 1 0 0 256zm-45.7 48C79.8 304 0 383.8 0 482.3C0 498.7 13.3 512 29.7 512H418.3c16.4 0 29.7-13.3 29.7-29.7c0-98.5-79.8-178.3-178.3-178.3h-45.7z"/></svg>') no-repeat 50% 50%; 
            mask: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><path fill="currentColor" d="M224 256A128 128 0 1 0 224 0a128 128 0 1 0 0 256zm-45.7 48C79.8 304 0 383.8 0 482.3C0 498.7 13.3 512 29.7 512H418.3c16.4 0 29.7-13.3 29.7-29.7c0-98.5-79.8-178.3-178.3-178.3h-45.7z"/></svg>') no-repeat 50% 50%; 
        }

        .dropdown-menu { 
            position: absolute; top: 100%; right: 0; background-color: var(--input-white); 
            border: 1px solid #ccc; border-radius: 5px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); 
            min-width: 150px; z-index: 20; padding: 5px 0; margin-top: 5px; display: none; 
        }
        .dropdown-menu a { display: block; padding: 10px 15px; color: var(--dark-text); border-right: none !important; }
        .dropdown-menu a:hover { background-color: var(--hover-gray); }
    </style>
</head>
<body>
    <div class="header">
        <div class="top-header">
            <div class="logo-container">
                <img src="images/logo_uitm.png" alt="UiTM Logo" class="uitm-logo">
            </div>
        </div>
        <div class="nav-links">
            <div class="nav-links-wrapper">
                <a href="${pageContext.request.contextPath}/index.jsp" id="nav-home">Home</a> 
                
                <%-- LOGGED IN ONLY LINKS --%>
                <c:if test="${not empty sessionScope.userName}">
                    <a href="${pageContext.request.contextPath}/bookAppointment" id="nav-bookappointment">Book Appointment</a> 
                    <a href="${pageContext.request.contextPath}/checkStatus" id="nav-checkstatus">Check Status</a>
                </c:if>

                <a href="${pageContext.request.contextPath}/aboutus.jsp" id="nav-aboutus">About us</a> 
                <a href="${pageContext.request.contextPath}/contact.jsp" id="nav-contact">Contact</a>
            </div>

            <div class="user-menu-container">
                <c:choose>
                    <c:when test="${not empty sessionScope.userName}">
                        <%-- SHOW USER PROFILE IF LOGGED IN --%>
                        <div class="user-icon-clickable" onclick="toggleDropdown(this)">
                            <span class="user-icon"></span>
                        </div>
                        <div class="user-greeting-text">
                            HI, <c:out value="${sessionScope.userName}"/>
                        </div>
                        <div class="dropdown-menu">
                            <a href="editProfile">Edit Profile</a> 
                            <a href="AuthServlet?action=logout">Log Out</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%-- SEPARATED LOGIN | SIGN UP --%>
                        <div class="auth-links-wrapper">
                            <a href="login.jsp" class="auth-link">Login</a>
                            <span class="auth-divider">|</span>
                            <a href="signup.jsp" class="auth-link">Sign Up</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <script>
        function toggleDropdown(clickedElement) {
            const container = clickedElement.closest('.user-menu-container');
            const dropdown = container.querySelector('.dropdown-menu');
            if (dropdown) {
                dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
            }
        }
        
        window.onclick = function(event) {
            if (!event.target.matches('.user-icon-clickable') && !event.target.matches('.user-icon')) {
                var dropdowns = document.getElementsByClassName("dropdown-menu");
                for (var i = 0; i < dropdowns.length; i++) {
                    dropdowns[i].style.display = "none";
                }
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const path = window.location.pathname;
            const page = path.split('/').pop().split('?')[0];
            let activeId;
            if (page === '' || page === 'index.jsp') activeId = 'nav-home';
            else if (page === 'bookAppointment' || page === 'bookappointment.jsp') activeId = 'nav-bookappointment';
            else if (page === 'checkStatus' || page === 'checkstatus.jsp') activeId = 'nav-checkstatus';
            else if (page === 'aboutus.jsp') activeId = 'nav-aboutus';
            else if (page === 'contact.jsp') activeId = 'nav-contact';

            if (activeId) {
                const activeLink = document.getElementById(activeId);
                if (activeLink) activeLink.classList.add('active');
            }
        });
    </script>
</body>
</html>