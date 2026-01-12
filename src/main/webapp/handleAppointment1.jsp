<%-- handleAppointment1.jsp (For PENDING status appointments) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.uitm.studentcounselling.model.Appointment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="headerCouns.jsp" %>

<%
    // Retrieve the appointment object passed from ViewAppointmentDetailsServlet
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    if (appointment == null) {
        response.sendRedirect("manageAppointments?error=Invalid+Appointment+Access");
        return;
    }
    String currentStatus = appointment.getStatus() != null ? appointment.getStatus() : "Pending";

    // Format the date to day-month-year (dd-MM-yyyy)
    String formattedDate = appointment.getBookedDate(); 
    try {
        // Assuming database date is in yyyy-MM-dd format
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd-MM-yyyy");
        Date date = inputFormat.parse(appointment.getBookedDate());
        formattedDate = outputFormat.format(date);
    } catch (Exception e) {
        // Fallback to original string if parsing fails
    }
%>

<style>
    body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; }
    
    .appointment-form-container {
        max-width: 500px;
        margin: 50px auto;
        padding: 30px;
        background-color: #ffc9d1; /* Pink/Salmon theme */
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    }

    .appointment-form-container h2 {
        text-align: center;
        margin-bottom: 30px;
        color: #333;
        font-size: 1.5em;
        font-weight: bold;
    }

    .form-row {
        display: flex;
        align-items: flex-start; /* Changed from center to align label to top of textareas */
        margin-bottom: 15px;
    }

    .form-label {
        flex: 2;
        font-weight: bold;
        color: #333;
        font-size: 14px;
        padding-top: 8px; /* Added padding to align with input text */
    }

    .form-separator {
        flex: 0;
        margin: 0 10px;
        font-weight: bold;
        padding-top: 8px;
    }

    .form-display-value {
        flex: 4;
    }

    .static-value {
        width: 100%;
        padding: 8px 10px;
        border-radius: 4px;
        background-color: white;
        box-sizing: border-box;
        border: none;
        color: #555;
        font-size: 14px;
        font-family: inherit;
    }

    /* Styles specifically for the multi-line reason box */
    textarea.static-value {
        resize: none;
        line-height: 1.5;
        display: block;
        background-color: #fdfdfd;
    }

    .status-select {
        width: 100%;
        padding: 8px 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
        background-color: white;
        box-sizing: border-box;
        cursor: pointer;
    }

    .action-buttons {
        text-align: center;
        margin-top: 40px;
    }

    .btn-confirm {
        background-color: #007bff; /* Blue */
        color: white;
        padding: 10px 25px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
        font-size: 14px;
        text-transform: uppercase;
        margin-right: 10px;
        transition: background 0.3s;
    }

    .btn-confirm:hover {
        background-color: #0056b3;
    }

    .btn-back {
        background-color: #dc3545; /* Red */
        color: white;
        padding: 10px 25px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
        font-size: 14px;
        text-transform: uppercase;
        text-decoration: none;
        display: inline-block;
        transition: background 0.3s;
    }

    .btn-back:hover {
        background-color: #c82333;
        text-decoration: none;
        color: white;
    }
</style>

<title>Manage Pending | UiTM Counselor</title>
<div class="appointment-form-container">
    <h2>Appointment Management</h2>
    
    <form action="manageAppointments" method="post" id="statusForm">
        <input type="hidden" name="bookingId" value="<%= appointment.getBookingId() %>">
        
        <div class="form-row">
            <div class="form-label">Student Name</div>
            <div class="form-separator">:</div>
            <div class="form-display-value"><input type="text" class="static-value" value="<%= appointment.getStudentName() %>" readonly></div>
        </div>

        <div class="form-row">
            <div class="form-label">Student Id</div>
            <div class="form-separator">:</div>
            <div class="form-display-value"><input type="text" class="static-value" value="<%= appointment.getStudentId() %>" readonly></div>
        </div>

        <div class="form-row">
            <div class="form-label">Student Phone Number</div>
            <div class="form-separator">:</div>
            <div class="form-display-value"><input type="text" class="static-value" value="<%= appointment.getStudentPhone() %>" readonly></div>
        </div>

        <div class="form-row">
            <div class="form-label">Date To Book</div>
            <div class="form-separator">:</div>
            <div class="form-display-value"><input type="text" class="static-value" value="<%= formattedDate %>" readonly></div>
        </div>

        <div class="form-row">
            <div class="form-label">Time Slot</div>
            <div class="form-separator">:</div>
            <div class="form-display-value"><input type="text" class="static-value" value="<%= appointment.getTimeSlot() %>" readonly></div>
        </div>

        <div class="form-row">
            <div class="form-label">Reason for Appointment</div>
            <div class="form-separator">:</div>
            <div class="form-display-value">
                <textarea class="static-value" rows="5" readonly><%= appointment.getReason() %></textarea>
            </div>
        </div>

        <div class="form-row">
            <div class="form-label">Status Appointment</div>
            <div class="form-separator">:</div>
            <div class="form-display-value">
                <select name="newStatus" id="newStatus" class="status-select">
                    <option value="Pending" <%= currentStatus.equals("Pending") ? "selected" : "" %>>Pending</option>
                    <option value="Confirmed" <%= currentStatus.equals("Confirmed") ? "selected" : "" %>>Confirmed</option>
                    <option value="Cancelled" <%= currentStatus.equals("Cancelled") ? "selected" : "" %>>Cancelled</option>
                </select>
            </div>
        </div>

        <div class="action-buttons">
            <button type="submit" class="btn-confirm" name="action" value="updateStatus" onclick="return confirmStatusChange();">
                CONFIRM
            </button>
            <a href="manageAppointments" class="btn-back">BACK</a>
        </div>
    </form>
</div>

<script>
    function confirmStatusChange() {
        var status = document.getElementById("newStatus").value;
        
        if (status === "Pending") {
            alert("Please choose either 'Confirmed' or 'Cancelled' before submitting.");
            return false;
        }
        
        return confirm("Are you sure you want to " + status.toLowerCase() + " this appointment?");
    }
</script>
