<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>

    <style>
        /* ================================================= */
        /* === PAGE-SPECIFIC CSS STYLES FOR CONTACT PAGE === */
        /* ================================================= */
        :root {
            /* Inheriting these from header.jsp for consistency */
            --dark-green-bg: #384238; 
            --teal-header: #80e6c6; 
            --input-white: #ffffff;
            --dark-text: #000000;
            --body-bg-light: #f4f4f4; 
        }

        /* --- Main Content Container (Same as About Us) --- */
        .content-area {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px 60px;
            min-height: calc(100vh - 170px); 
            background-color: var(--body-bg-light); 
            color: var(--dark-text);
        }

        /* --- Main Title (Similar to About Us) --- */
        .contact-title-box {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 30px;
            padding: 10px 20px;
            background-color: #ccffcc; /* Light green background for the title box (from image) */
            color: var(--dark-green-bg);
            text-align: center;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        /* --- Contact Grid Container --- */
        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1fr; /* Two columns */
            gap: 20px;
            max-width: 700px;
            width: 100%;
        }

        /* --- Individual Contact Card/Box --- */
        .contact-box {
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        /* Specific background colors matching the visual layout */
        .contact-box.phone, .contact-box.hours {
            background-color: #80e6c6; /* Teal/Light Green */
        }
        .contact-box.email, .contact-box.location {
            background-color: var(--soft-card-bg); /* Light Gray/Off-white */
            color: var(--dark-text);
        }

        .contact-box h3 {
            font-size: 1.2em;
            margin-top: 5px;
            margin-bottom: 10px;
            font-weight: bold;
            color: var(--dark-text);
        }

        .contact-box p {
            font-size: 1.1em;
            margin: 5px 0;
            line-height: 1.4;
            font-weight: 500;
        }

        /* Icon Styling (using a placeholder font size/color) */
        .contact-icon {
            font-size: 3em;
            margin-bottom: 10px;
            color: var(--dark-green-bg);
        }

        /* --- Mobile Adjustments --- */
        @media (max-width: 600px) {
            .contact-grid {
                grid-template-columns: 1fr; /* Single column layout on mobile */
            }
            .contact-box {
                padding: 20px;
            }
        }
    </style>
    
    <div class="content-area">
        
        <h1 class="contact-title-box">Get In Touch With Us !</h1>
        
        <div class="contact-grid">
            
            <%-- 1. PHONE NUMBER --%>
            <div class="contact-box phone">
                <span class="contact-icon">📞</span>
                <h3>PHONE NUMBER</h3>
                <p>+6082-677 057</p>
            </div>

            <%-- 2. EMAIL --%>
            <div class="contact-box email">
                <span class="contact-icon">📧</span>
                <h3>Email</h3>
                <p>korporat_swk@uitm.edu.my</p>
            </div>
            
            <%-- 3. LOCATION --%>
            <div class="contact-box location">
                <span class="contact-icon">📍</span>
                <h3>Location</h3>
                <p>UiTM Cawangan Sarawak</p>
                <p>Kampus Samarahan Jalan</p>
                <p>Maranek, 94300, Kota</p>
                <p>Samarahan, Sarawak</p>
            </div>

            <%-- 4. WORKING HOURS --%>
            <div class="contact-box hours">
                <span class="contact-icon">🕒</span>
                <h3>Working Hours</h3>
                <p>Monday To Friday</p>
                <p>8:00 AM To 5:00 PM</p>
            </div>
            
        </div>
        
    </div>

<%-- Includes the Footer div and the closing HTML tags from the SAME directory --%>
<%@include file="footer.jsp" %>