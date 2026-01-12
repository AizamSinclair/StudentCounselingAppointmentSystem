<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>

<style>
/* ================================================= */
/* === VARIABLES === */
/* ================================================= */
:root {
    --counselor-header-bg: #f7941d; /* Original Orange/Brown */
    --counselor-link-text: black; /* Black text */
    --counselor-hover-active: #ccc; /* Light grey for hover/active background */
    --header-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
}

body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #e5e8e8;  
    color: #333;
}

/* --- HEADER / NAVIGATION BAR STYLES --- */
header {
    background-color: var(--counselor-header-bg);
    padding: 5px 30px;  
    display: flex;
    flex-direction: column;
    justify-content: flex-start;  
    align-items: center;  
    height: auto;  
    width: 100%;
    box-sizing: border-box;
}

.top-header-row {
    display: flex;
    justify-content: flex-start;  
    align-items: center;
    width: 100%;  
}

.logo-section {
    display: flex;
    align-items: center;
    min-width: 175px;  
}

.uitm-logo {
    width: 165px;  
    height: 90px;
    object-fit: contain;  
}

/* --- Bottom Navigation Row --- */
.nav-bottom-row {
    display: flex;
    justify-content: space-between;  
    align-items: center;
    width: 100%;  
    white-space: nowrap;  
    padding: 5px 0 5px;  
}
 
.top-nav {
    display: flex;
    align-items: center;
}

.top-nav a {
    color: var(--counselor-link-text);  
    text-decoration: none;
    font-size: 16px;
    font-weight: bold;
    padding: 5px 15px;  
    border-right: 1px solid black;  
    transition: background-color 0.2s;
}
 
.top-nav a:last-child {
    border-right: none;
}

/* Active & Hover styling */
.top-nav a.active, .top-nav a:hover {
    background-color: var(--counselor-hover-active);  
    color: black;  
    border-radius: 5px;
}

/* --- User Info --- */
.user-info {
    font-weight: bold;
    display: flex;
    align-items: center;
    gap: 10px;  
    color: black;  
}
 
.user-info span {
    padding-right: 10px;
    border-right: 1px solid black;  
}
 
.user-info a {
    color: black;
    text-decoration: none;
}

/* --- ALERT STYLES --- */
.login-success-alert {
    position: fixed;
    top: -100px; /* Start hidden above */
    left: 50%;
    transform: translateX(-50%);
    background-color: #d4edda;  
    color: #155724;  
    border: 1px solid #c3e6cb;
    padding: 15px 30px;
    border-radius: 0 0 8px 8px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    z-index: 9999;  
    font-weight: bold;
    transition: top 0.5s ease-in-out;
}
 
.login-success-alert.show {
    top: 0; /* Slide down into view */
}
</style>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // 1. Handle Login Alert
        const urlParams = new URLSearchParams(window.location.search);
        const alertBox = document.getElementById('loginAlert');

        if (urlParams.get('status') === 'LoginSuccess' && alertBox) {
            alertBox.classList.add('show');
            setTimeout(() => {
                alertBox.classList.remove('show');
            }, 3000);

            // Clean URL
            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.pathname);
            }
        }
        
        // 2. Dynamic Active Link Logic
        const path = window.location.pathname;
        const navLinks = document.querySelectorAll('.top-nav a');
        
        navLinks.forEach(link => {
            const linkHref = link.getAttribute('href').split('?')[0]; // Ignore query params
            if (path.includes(linkHref)) {
                link.classList.add('active');
            }
        });
        
        // Fallback for direct JSP access
        if (path.endsWith('indexCouns.jsp')) {
            document.querySelector('a[href="counselorDashboard"]').classList.add('active');
        }
    });
</script>

<header>
    <div class="top-header-row">
        <div class="logo-section">
            <img src="images/logo_uitm.png" alt="UiTM Logo" class="uitm-logo">
        </div>
    </div>
    
    <div class="nav-bottom-row">
        <nav class="top-nav">
            <%-- REDIRECTS FIXED: Points to Servlets, not JSPs --%>
            <a href="counselorDashboard">Dashboard</a>  
            <a href="manageAppointments?statusFilter=Pending">Manage Appointment</a>
            <a href="followUpAppointment">Follow-Up Appointment</a>
            <a href="studentRecords">Student Appointment Record</a>
        </nav>
        
        <div class="user-info">
            <span><%= session.getAttribute("counselorName") != null ? session.getAttribute("counselorName") : "Counselor" %></span>
            <a href="AuthServlet?action=logout">Log Out</a>
        </div>
    </div>
</header>

<div id="loginAlert" class="login-success-alert">
    Login successful! Welcome back, <%= session.getAttribute("counselorName") != null ? session.getAttribute("counselorName") : "Counselor" %>!
</div>