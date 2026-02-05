<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <jsp:include page="headerAdmin.jsp" />
    
    <style>
        body { 
            background-color: #f4f4f4; 
            font-family: Arial, sans-serif; 
            margin: 0;
            overflow-x: hidden;
        }

        .dashboard-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 50px 20px;
            box-sizing: border-box;
        }
        
        .emblem-section { text-align: center; }
        .emblem-image { width: 320px; height: auto; margin-top: -75px; }

        .summary-boxes {
            display: flex;
            gap: 20px;
            justify-content: center;
            width: 100%;
            max-width: 1200px; /* Wide enough for 4 boxes */
        }

        .summary-box {
            background-color: #ffffff;
            padding: 35px 15px;
            border-radius: 15px;
            /* Strong Shadow for "Pop" effect */
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1); 
            text-align: center;
            width: 260px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none; 
            display: block;
        }

        /* Hover effect - Lifts up and deepens shadow */
        .summary-box:hover { 
            transform: translateY(-10px); 
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
        }

        .box-title { 
            font-size: 1.0em; 
            font-weight: bold; 
            margin-bottom: 20px; 
            color: #555; 
            height: 40px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            line-height: 1.2;
        }

        .box-number { 
            font-size: 3.5em; 
            font-weight: bold; 
            color: #0000cd; /* Admin Dark Blue */
        }
        
        /* Colored Bottom Accents */
        .counselor-box { border-bottom: 8px solid #8e44ad; } /* Purple */
        .student-box { border-bottom: 8px solid #16a085; }   /* Teal */
        .report-box { border-bottom: 8px solid #E36C4B; }    /* Original Admin Orange */
        .all-time-box { border-bottom: 8px solid #f39c12; }  /* Yellow/Orange for Grand Total */
        
        .welcome-section {
            text-align: center;
            margin-top: 5px;
            color: #333;
        }

        .welcome-section h1 {
            font-size: 2.2em;
            margin-top: 10px;
            color: #000000;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .welcome-section p {
            font-size: 1.1em;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    
    <div class="welcome-section">
        <h1><u>Welcome to the Admin Dashboard</u></h1>
    </div>
    
    <div class="dashboard-content">
        <div class="emblem-section">
            <img src="${pageContext.request.contextPath}/images/AdminLogo.png" alt="Admin Logo" class="emblem-image">
        </div>
        
        <div class="summary-boxes">
            <a href="manageCounselor" class="summary-box counselor-box">
                <div class="box-title">Total Counselor</div>
                <div class="box-number">${totalCounselor != null ? totalCounselor : 0}</div>
            </a>

            <a href="manageStudent" class="summary-box student-box">
                <div class="box-title">Total Student Registered</div>
                <div class="box-number">${totalStudent != null ? totalStudent : 0}</div>
            </a>

            <a href="appointmentReport" class="summary-box report-box">
                <div class="box-title"> Total Appointment Made in (${currentYear})</div>
                <div class="box-number">${totalAppointment != null ? totalAppointment : 0}</div>
            </a>

            <a href="appointmentReport" class="summary-box all-time-box">
                <div class="box-title">Total Appointment (All-Time)</div>
                <div class="box-number">${totalAllAppointments != null ? totalAllAppointments : 0}</div>
            </a>
        </div>
    </div>
</body>
</html>