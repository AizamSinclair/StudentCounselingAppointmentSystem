<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, com.uitm.studentcounselling.model.Counselor" %>
<%
    // Security Check: Role 3 = Student
    Object userRoleObj = session.getAttribute("userRole");
    if (userRoleObj == null || !userRoleObj.equals(3)) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    String sName = (session.getAttribute("userName") != null) ? (String)session.getAttribute("userName") : "";
    String sId = (session.getAttribute("userId") != null) ? (String)session.getAttribute("userId") : "";
    String sPhone = (session.getAttribute("userPhone") != null) ? (String)session.getAttribute("userPhone") : "";
    String errorMsg = (String) request.getAttribute("error");
%>
<%@include file="header.jsp" %>


<style>
    .content-area { display: flex; flex-direction: column; align-items: center; padding: 40px 20px; background-color: #f4f4f4; min-height: 80vh; }
    .booking-form-card { background-color: #ccffcc; padding: 30px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 600px; display: flex; flex-direction: column; }
    .form-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; font-weight: bold; }
    .form-row label { width: 180px; text-align: right; margin-right: 15px; }
    
    /* Shared styles for inputs and textarea */
    .form-row input, .form-row select, .form-row textarea { 
        flex-grow: 1; 
        padding: 8px 10px; 
        border-radius: 5px; 
        border: 1px solid #ccc; 
        font-family: inherit;
        font-size: 14px;
    }
    
    .form-row input, .form-row select { height: 38px; }

    /* Specific styles for the expandable textarea */
    .form-row textarea {
        resize: vertical; /* Allows student to drag to expand */
        min-height: 80px;
        line-height: 1.5;
    }

    .submit-btn { background-color: #4bb3f7; color: white; border: none; padding: 10px 30px; border-radius: 5px; cursor: pointer; align-self: center; margin-top: 20px; font-weight: bold; transition: 0.3s; }
    .submit-btn:hover { background-color: #3598db; }
    .submit-btn:disabled { background-color: #cccccc; cursor: not-allowed; opacity: 0.6; }
    .status-msg { margin-top: 10px; text-align: center; font-weight: bold; font-size: 0.9em; min-height: 20px; }
    .alert-danger { background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; width: 600px; margin-bottom: 15px; text-align: center; border: 1px solid #f5c6cb; }
</style>

<div class="content-area">
    <h1 style="color: #384238; margin-bottom: 25px;">Book An Appointment</h1>
    
    <% if (errorMsg != null) { %>
        <div class="alert-danger">
            <strong>Error:</strong> <%= errorMsg %>
        </div>
    <% } %>
    
    <form action="BookAppointmentServlet" method="POST" class="booking-form-card">
        <div class="form-row">
            <label>Student Name:</label>
            <input type="text" value="<%= sName %>" readonly style="background-color: #eee;">
        </div>
        <div class="form-row">
            <label>Student ID:</label>
            <input type="text" value="<%= sId %>" readonly style="background-color: #eee;">
        </div>
        <div class="form-row">
            <label for="studentPhone">Phone Number:</label>
            <input type="text" name="studentPhone" value="<%= sPhone %>" required>
        </div>
        <div class="form-row">
            <label for="appointmentDate">Date:</label>
            <input type="date" id="appointmentDate" name="appointmentDate" required>
        </div>
        <div class="form-row">
            <label for="appointmentTime">Time Slot:</label>
            <select id="appointmentTime" name="appointmentTime" required>
                <option value="" disabled selected>Select Time</option>
                <option value="8:30 - 9:30 AM">8:30 - 9:30 AM</option>
                <option value="10:00 - 11:00 AM">10:00 - 11:00 AM</option>
                <option value="2:00 - 3:00 PM">2:00 - 3:00 PM</option>
                <option value="3:30 - 4:30 PM">3:30 - 4:30 PM</option>
            </select>
        </div>
        <div class="form-row">
            <label for="counselor">Counselor:</label>
            <select id="counselor" name="counselorid" required>
                <option value="" disabled selected>Select Counselor</option>
                <% 
                    List<Counselor> counselors = (List<Counselor>) request.getAttribute("counselors");
                    if (counselors != null) {
                        for (Counselor c : counselors) {
                %>
                    <option value="<%= c.getCounselorId() %>"><%= c.getCounsName() %></option>
                <%      }
                    } 
                %>
            </select>
        </div>

        <div class="form-row" style="align-items: flex-start;">
            <label for="reason" style="margin-top: 8px;">Reason for Visit:</label>
            <textarea name="reason" id="reason" required placeholder="Describe your reason here..."></textarea>
        </div>

        <div id="slotStatus" class="status-msg"></div>
        <button type="submit" class="submit-btn" id="submitBtn" disabled>SUBMIT BOOKING</button>
    </form>
</div>

<script>
    const dateInput = document.getElementById("appointmentDate");
    const timeInput = document.getElementById("appointmentTime");
    const counselorInput = document.getElementById("counselor");
    const statusDiv = document.getElementById("slotStatus");
    const submitBtn = document.getElementById("submitBtn");

    // Prevent selecting past dates
    dateInput.min = new Date().toISOString().split("T")[0];

    function checkAvailability() {
        const d = dateInput.value;
        const t = timeInput.value;
        const c = counselorInput.value;

        if (!d || !t || !c) return;

        statusDiv.innerHTML = "Checking availability...";
        statusDiv.style.color = "blue";

        fetch('checkSlot?date=' + d + '&time=' + encodeURIComponent(t) + '&counselorid=' + encodeURIComponent(c))
            .then(res => res.text())
            .then(data => {
                const result = data.trim();
                if (result === "AVAILABLE") {
                    statusDiv.innerHTML = "✅ Available!";
                    statusDiv.style.color = "green";
                    submitBtn.disabled = false;
                } else if (result === "TAKEN") {
                    statusDiv.innerHTML = "❌ Slot Taken. Choose another time.";
                    statusDiv.style.color = "red";
                    submitBtn.disabled = true;
                } else {
                    statusDiv.innerHTML = "⚠️ Server busy, try again.";
                    statusDiv.style.color = "orange";
                }
            })
            .catch(err => {
                statusDiv.innerHTML = "⚠️ Connection error.";
            });
    }

    [dateInput, timeInput, counselorInput].forEach(el => el.addEventListener("change", checkAvailability));
</script>
<%@include file="footer.jsp" %>