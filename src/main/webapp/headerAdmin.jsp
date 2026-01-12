<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get the current page name or servlet path for active tab highlighting
    String uri = request.getRequestURI();
    String currentPage = uri.substring(uri.lastIndexOf("/") + 1);
%>

<style>
/* === VARIABLES === */
:root {
    --uitm-maroon: #a1466a; 
    --nav-text: black;      
    --active-bg: #e0e0e0;   
}

body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
}

/* --- HEADER STYLES --- */
header {
    background-color: var(--uitm-maroon);
    padding: 10px 20px;
    width: 100%;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
}

.top-header-row {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    width: 100%;
}

.uitm-logo {
    width: 180px; 
    height: auto;
}

.nav-bottom-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    margin-top: 10px;
    color: var(--nav-text);
}

.top-nav {
    display: flex;
    align-items: center;
    font-weight: bold;
    font-size: 16px;
}

.top-nav a {
    color: var(--nav-text);
    text-decoration: none;
    padding: 5px 12px;
    border-radius: 8px;
    transition: background-color 0.3s;
}

.nav-sep {
    padding: 0 5px;
    color: var(--nav-text);
}

/* Dynamic Active State */
.top-nav a.active {
    background-color: var(--active-bg);
    color: black;
}

.user-info {
    font-weight: bold;
    font-size: 16px;
    display: flex;
    align-items: center;
    color: var(--nav-text);
}

.user-info a {
    color: var(--nav-text);
    text-decoration: none;
}

/* === LOGIN ALERT STYLES (UPDATED FOR BETTER VISIBILITY) === */
.login-success-alert {
    position: fixed;
    top: -100px;
    left: 50%;
    transform: translateX(-50%);
    background-color: #d4edda;  
    color: #155724;  
    border: 2px solid #c3e6cb;
    padding: 15px 40px;
    border-radius: 0 0 12px 12px;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.25);
    z-index: 9999;  
    opacity: 0;  
    transition: opacity 0.5s, top 0.5s;
    font-weight: bold;
}

.login-success-alert.show {
    opacity: 1;
    top: 0;
}
</style>

<header>
    <div class="top-header-row">
        <div class="logo-section">
            <img src="images/logo_uitm.png" alt="UiTM Logo" class="uitm-logo">
        </div>
    </div>
    
    <div class="nav-bottom-row">
        <nav class="top-nav">
            <%-- Pointing to adminDashboard servlet --%>
            <a href="adminDashboard" class="<%= (currentPage.contains("adminDashboard") || currentPage.equals("indexAdmin.jsp")) ? "active" : "" %>">Dashboard</a>
            <span class="nav-sep">|</span>
            
            <%-- Pointing to manageCounselor servlet --%>
            <a href="manageCounselor" class="<%= (currentPage.contains("manageCounselor")) ? "active" : "" %>">Manage Counselor</a>
            <span class="nav-sep">|</span>
            
            <%-- Pointing to manageStudent servlet --%>
            <a href="manageStudent" class="<%= (currentPage.contains("manageStudent")) ? "active" : "" %>">Manage Student</a>
            <span class="nav-sep">|</span>
            
            <%-- Pointing to appointmentReport servlet --%>
            <a href="appointmentReport" class="<%= (currentPage.contains("appointmentReport")) ? "active" : "" %>">Appointment Report</a>
        </nav>
        
        <div class="user-info">
            <% 
                String adminName = (String) session.getAttribute("adminName"); 
                if(adminName == null) adminName = "Admin"; 
            %>
            <span><%= adminName %></span>
            <span class="nav-sep">|</span>
            <a href="AuthServlet?action=logout">Log Out</a>
        </div>
    </div>
</header>

<div id="loginAlert" class="login-success-alert">
    Login Successful! Welcome, <%= adminName %>!
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const alertBox = document.getElementById('loginAlert');

        if (urlParams.get('status') === 'LoginSuccess' && alertBox) {
            // Show alert
            setTimeout(() => { alertBox.classList.add('show'); }, 100);
            
            // Hide after 4 seconds (given it's more important now)
            setTimeout(() => { alertBox.classList.remove('show'); }, 4000);

            // Clean URL
            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.pathname);
            }
        }
    });
</script>