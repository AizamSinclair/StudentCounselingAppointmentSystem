<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Counselor Dashboard</title>
    <jsp:include page="headerCouns.jsp" />
    
    <style>
        .dashboard-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 50px 20px;
        }
        
        .emblem-section { text-align: center; margin-bottom: 40px; }
        .emblem-image { width: 350px; height: auto; }

        .summary-boxes {
            display: flex;
            gap: 30px;
            justify-content: center;
            width: 100%;
            max-width: 1000px;
        }

        .summary-box {
            background-color: #ffffff;
            padding: 30px 20px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 250px;
            cursor: pointer;
            transition: transform 0.2s;
            border-bottom: 6px solid #f39c12; /* Default Orange */
        }

        .summary-box:hover { transform: translateY(-5px); }

        .box-title { font-size: 1.1em; font-weight: bold; margin-bottom: 15px; color: #555; height: 45px; display: flex; align-items: center; justify-content: center; }
        .box-number { font-size: 3em; font-weight: bold; color: #2c3e50; }
        
        /* Color variations */
        .pending-box { border-bottom-color: #f1c40f; }  /* Yellow */
        .followup-box { border-bottom-color: #3498db; } /* Blue */
        .history-box { border-bottom-color: #8ECF67; }   /* Grey */
    </style>
</head>
<body>
    
    <div class="dashboard-content">
        <div class="emblem-section">
            <img src="${pageContext.request.contextPath}/images/unit_kerjaya.png" alt="Emblem" class="emblem-image">
        </div>
        
        <div class="summary-boxes">
            <%-- Box 1: Pending (Single status: Pending) --%>
            <div class="summary-box pending-box" onclick="location.href='manageAppointments?statusFilter=Pending'">
                <div class="box-title">New Pending Requests</div>
                <div class="box-number">${pendingCount != null ? pendingCount : 0}</div>
            </div>

            <%-- Box 2: Follow-Up (Grouped: Next Follow-Up, Accepted, Declined) --%>
            <div class="summary-box followup-box" onclick="location.href='followUpAppointment'">
                <div class="box-title">Follow-Up Appointments</div>
                <div class="box-number">${followUpCount != null ? followUpCount : 0}</div>
            </div>

            <%-- Box 3: History (Grouped: Done Session, No Show, Cancelled) --%>
            <div class="summary-box history-box" onclick="location.href='studentRecords'">
                <div class="box-title">Student Records</div>
                <div class="box-number">${historyCount != null ? historyCount : 0}</div>
            </div>
        </div>
    </div>
</body>
</html>