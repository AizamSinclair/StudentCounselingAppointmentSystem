<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.uitm.studentcounselling.model.Appointment"%>
<%@page import="com.uitm.studentcounselling.model.Counselor"%>
<%@page import="java.util.List"%>
<%
    // 1. Get the appointment object from the Servlet
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    if (appointment == null) {
        response.sendRedirect("checkStatus?error=NoAppointmentSelected");
        return;
    }
    
    // 2. Safely get attributes using standard Java to avoid EL errors
    String errorMsg = (String) request.getAttribute("error");
    List<Counselor> counselorList = (List<Counselor>) request.getAttribute("counselors");
    
    // 3. Define time slots
    String[][] timeSlots = {
        {"8:30 - 9:30 AM", "8:30 - 9:30 AM"},
        {"10:00 - 11:00 AM", "10:00 - 11:00 AM"},
        {"2:00 - 3:00 PM", "2:00 - 3:00 PM"},
        {"3:30 - 4:30 PM", "3:30 - 4:30 PM"}
    };
%>
<%@include file="header.jsp" %>

<style>
    .content-area { display: flex; flex-direction: column; align-items: center; padding: 40px 20px; background-color: #f7f7f7; min-height: 80vh; }
    .booking-form-card { background-color: #ccffcc; padding: 30px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15); width: 600px; display: flex; flex-direction: column; }
    .form-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; font-weight: bold; }
    .form-row label { width: 220px; text-align: right; margin-right: 15px; }
    
    /* Shared styles for inputs and textarea */
    .form-row input, .form-row select, .form-row textarea { 
        flex-grow: 1; 
        padding: 8px 10px; 
        border: 1px solid #ccc; 
        border-radius: 5px; 
        font-family: inherit;
        font-size: 14px;
    }
    
    .form-row input, .form-row select { height: 38px; }
    
    /* Specific styles for the expandable textarea */
    .form-row textarea {
        resize: vertical; /* Allows user to drag corner to expand */
        min-height: 80px;
        line-height: 1.5;
    }
    
    .form-row input[readonly] { background-color: #e9ecef; color: #6c757d; }
    .button-group { display: flex; justify-content: center; gap: 20px; margin-top: 20px; }
    .confirm-btn { background-color: #4bb3f7; color: white; border: none; padding: 10px 30px; border-radius: 5px; font-weight: bold; cursor: pointer; transition: 0.3s; }
    .confirm-btn:disabled { background-color: #cccccc; cursor: not-allowed; opacity: 0.6; }
    .cancel-btn { background-color: #ff3333; color: white; padding: 10px 30px; border-radius: 5px; text-decoration: none; font-weight: bold; transition: 0.3s; }
    .status-msg { text-align: center; font-weight: bold; margin-top: 10px; min-height: 20px; font-size: 0.9em; }
</style>

<div class="content-area">
    <h1 style="color: #384238; margin-bottom: 25px;">Edit Appointment Details</h1>
    
    <% if (errorMsg != null) { %>
        <div style="color: red; background: #fee; padding: 10px; margin-bottom: 20px; border: 1px solid red; width: 600px; text-align: center; border-radius: 5px;">
            <%= errorMsg %>
        </div>
    <% } %>
    
    <form action="EditAppointmentServlet" method="POST" class="booking-form-card" onsubmit="return confirm('Are you sure you want to save these changes?');">
        <input type="hidden" name="bookingId" value="<%= appointment.getBookingId() %>">
        
        <div class="form-row">
            <label>Student Name:</label>
            <input type="text" value="<%= appointment.getStudentName() %>" readonly>
        </div>
        
        <div class="form-row">
            <label>Student ID:</label>
            <input type="text" value="<%= appointment.getStudentId() %>" readonly>
        </div>
        
        <div class="form-row">
            <label for="studentPhone">Phone Number:</label>
            <input type="text" name="studentPhone" value="<%= appointment.getStudentPhone() %>" required>
        </div>
        
        <div class="form-row">
            <label for="appointmentDate">Date:</label>
            <input type="date" id="appointmentDate" name="appointmentDate" value="<%= appointment.getBookedDate() %>" required>
        </div>
        
        <div class="form-row">
            <label for="appointmentTime">Time Slot:</label>
            <select id="appointmentTime" name="appointmentTime" required>
                <% for (String[] slot : timeSlots) { 
                    String selected = slot[0].equals(appointment.getTimeSlot()) ? "selected" : "";
                %>
                    <option value="<%= slot[0] %>" <%= selected %>><%= slot[1] %></option>
                <% } %>
            </select>
        </div>
        
        <div class="form-row">
            <label for="counselor">Counselor:</label>
            <select id="counselor" name="counselorid" required>
                <% if (counselorList != null) {
                    for (Counselor c : counselorList) { 
                        String selected = c.getCounselorId().equals(appointment.getCounselorId()) ? "selected" : "";
                %>
                        <option value="<%= c.getCounselorId() %>" <%= selected %>><%= c.getCounsName() %></option>
                <% } } %>
            </select>
        </div>
        
        <div class="form-row" style="align-items: flex-start;">
            <label for="reason" style="margin-top: 8px;">Reason for Change:</label>
            <textarea name="reason" id="reason" required><%= (appointment.getReason() != null) ? appointment.getReason() : "" %></textarea>
        </div>

        <div id="slotStatus" class="status-msg"></div>
        
        <div class="button-group">
            <button type="submit" class="confirm-btn" id="submitBtn">CONFIRM EDIT</button>
            <a href="checkStatus" class="cancel-btn">CANCEL</a>
        </div>
    </form>
</div>

<script>
    const dateInput = document.getElementById("appointmentDate");
    const timeInput = document.getElementById("appointmentTime");
    const counselorInput = document.getElementById("counselor");
    const statusDiv = document.getElementById("slotStatus");
    const submitBtn = document.getElementById("submitBtn");

    // Prevent selecting past dates
    dateInput.min = new Date().toISOString().split('T')[0];

    function checkAvailability() {
        const d = dateInput.value;
        const t = timeInput.value;
        const c = counselorInput.value;

        if (!d || !t || !c) return;

        statusDiv.innerHTML = "Checking availability...";
        statusDiv.style.color = "blue";

        // Call the same checkSlot servlet
        fetch('checkSlot?date=' + d + '&time=' + encodeURIComponent(t) + '&counselorid=' + encodeURIComponent(c))
            .then(res => res.text())
            .then(data => {
                const result = data.trim();
                if (result === "TAKEN") {
                    statusDiv.innerHTML = "⚠️ Slot might be busy. System will verify on Confirm.";
                    statusDiv.style.color = "orange";
                    submitBtn.disabled = false; 
                } else if (result === "AVAILABLE") {
                    statusDiv.innerHTML = "✅ This slot is available!";
                    statusDiv.style.color = "green";
                    submitBtn.disabled = false;
                } else {
                    statusDiv.innerHTML = "Status: " + result;
                    statusDiv.style.color = "black";
                }
            })
            .catch(err => {
                console.error(err);
                statusDiv.innerHTML = "⚠️ Connection error.";
            });
    }

    // Listen for changes
    [dateInput, timeInput, counselorInput].forEach(el => el.addEventListener("change", checkAvailability));
</script>

<%@include file="footer.jsp" %>