<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="header.jsp" %>

    <style>
        /* ================================================= */
        /* === PAGE-SPECIFIC CSS STYLES FOR ABOUT US PAGE === */
        /* ================================================= */
        :root {
            /* Inheriting these from header.jsp, added here for clarity */
            --dark-green-bg: #384238; 
            --teal-header: #80e6c6; 
            --input-white: #ffffff;
            --dark-text: #000000;
            --body-bg-light: #f4f4f4; 
        }

        /* --- Main Content Container --- */
        .content-area {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px 60px;
            min-height: calc(100vh - 170px); 
            background-color: var(--body-bg-light); 
            color: var(--dark-text);
        }

        /* --- Main Title --- */
        .about-title {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 30px;
            padding: 10px 20px;
            color: var(--dark-green-bg);
            border-bottom: 3px solid var(--teal-header);
        }

        /* --- Image/Graphic Section --- */
        .graphic-section {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 40px;
            width: 100%;
        }

        .about-graphic {
            width: 100%;
            max-width: 330px; 
            height: auto;
        }
        
        /* --- Text Container/Card --- */
        .purpose-card {
            background-color: var(--input-white);
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 800px;
            
            /* Ensures the card is centered horizontally */
            margin: 0 auto;
            line-height: 1.6;
        }

        .card-text {
            font-size: 1.05em;
            margin-bottom: 15px;
            
            /* 1. Makes the text justified (straight edges) */
            text-align: justify; 
            
            /* 2. FIX APPLIED HERE: Centers the final line of the justified text */
            text-align-last: center; 
        }

        .emphasis-text {
            font-weight: bold;
            color: var(--dark-text);
        }

        /* --- Mobile Adjustments --- */
        @media (max-width: 768px) {
            .about-title {
                font-size: 2em;
            }
            .purpose-card {
                padding: 20px;
            }
        }
    </style>
    
    <div class="content-area">
        
        <h1 class="about-title">About us</h1>
        
        <div class="graphic-section">
            <img src="images/aboutus.png" alt="Benefits of Counselling Graphic" class="about-graphic">
        </div>

        <div class="purpose-card">
            <p class="card-text">
                The Student Counseling Appointment System is designed to make the counseling process more organized and accessible for all students. Instead of walking in or relying on manual booking, students can now view available time slots, choose their preferred counselor, and reserve an appointment online.
            </p>
            <p class="card-text">
                The system ensures a more efficient workflow by reducing booking conflicts, improving counselor availability management, and giving students a convenient platform to seek academic, emotional or personal guidance. It also supports the university’s initiative to enhance student wellbeing through timely and structured counseling services.
            </p>
        </div>
        
    </div>

<%@include file="footer.jsp" %>