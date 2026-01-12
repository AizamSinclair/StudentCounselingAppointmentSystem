<%@page import="com.uitm.studentcounselling.model.Appointment"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="headerCouns.jsp" %>
<%@ page import="com.uitm.studentcounselling.model.Appointment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    if (appointment == null) {
        response.sendRedirect("followUpAppointment?error=Appointment+Details+Missing");
        return;
    }
    String currentStatus = appointment.getStatus();
    int bookingId = appointment.getBookingId();

    // Date formatting
    String formattedDate = appointment.getBookedDate(); 
    try {
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd-MM-yyyy");
        Date date = inputFormat.parse(appointment.getBookedDate());
        formattedDate = outputFormat.format(date);
    } catch (Exception e) {}
%>

<style>
    .appointment-form-container { max-width: 500px; margin: 50px auto; padding: 30px; background-color: #ffc9d1; border-radius: 8px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); font-family: Arial, sans-serif; }
    .appointment-form-container h2 { text-align: center; margin-bottom: 20px; color: #333; font-size: 1.5em; }
    .form-row { display: flex; align-items: center; margin-bottom: 15px; }
    .form-label { flex: 2.5; font-weight: bold; color: #333; }
    .form-separator { flex: 0; margin: 0 10px; font-weight: bold; }
    .form-display-value { flex: 4; }
    .static-value, .status-select, textarea, input[type="date"], select { width: 100%; padding: 8px 10px; border: 1px solid #ccc; border-radius: 4px; background-color: white; box-sizing: border-box; font-size: 1em; }
    .static-value { border: none; }
    .reason-box { background-color: #fff0f2; border: 1px solid #ffb3bc; color: #555; font-style: italic; }
    
    .follow-up-block { background-color: #e3f6ff; padding: 25px; margin-top: 20px; border-radius: 12px; display: none; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .follow-up-block h4 { text-align: center; margin-top: 0; margin-bottom: 20px; color: #333; font-size: 1.3em; }
    
    .action-buttons { text-align: center; margin-top: 30px; display: flex; flex-direction: column; align-items: center; gap: 15px; }
    .row-buttons { display: flex; justify-content: center; gap: 15px; width: 100%; }
    
    .btn-confirm { background-color: #007bff; color: white; padding: 10px 25px; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; font-size: 1em; text-transform: uppercase; width: 150px; }
    .btn-back { background-color: #dc3545; color: white; padding: 10px 25px; border: none; border-radius: 6px; text-decoration: none; font-weight: bold; display: inline-block; font-size: 1em; text-transform: uppercase; width: 150px; }
    .btn-schedule-teal { background-color: #00897b; color: white; width: 100%; padding: 12px; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; font-size: 1em; text-transform: uppercase; margin-bottom: 10px; }
    .status-alert { padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center; font-weight: bold; }
</style>
<title>Manage Follow-Up | UiTM Counselor</title>
<div class="appointment-form-container">
    <h2>Manage Follow-Up Session</h2>

    <%-- ALERTS --%>
    <% if ("Accepted".equalsIgnoreCase(currentStatus)) { %>
        <div class="status-alert" style="background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb;">STUDENT HAS ACCEPTED THIS DATE</div>
    <% } %>

    <%-- Read-Only Fields --%>
    <div class="form-row">
        <div class="form-label">Student Name</div><div class="form-separator">:</div>
        <div class="form-display-value"><input type="text" class="static-value" value="<%= appointment.getStudentName() %>" readonly></div>
    </div>

    <div class="form-row">
        <div class="form-label">Student Id</div><div class="form-separator">:</div>
        <div class="form-display-value"><input type="text" class="static-value" value="<%= appointment.getStudentId() %>" readonly></div>
    </div>

    <div class="form-row">
        <div class="form-label">Student Phone Number</div><div class="form-separator">:</div>
        <div class="form-display-value"><input type="text" class="static-value" value="<%= appointment.getStudentPhone() %>" readonly></div>
    </div>

    <div class="form-row">
        <div class="form-label">Appointment Date</div><div class="form-separator">:</div>
        <div class="form-display-value"><input type="text" class="static-value" value="<%= formattedDate %>" readonly></div>
    </div>

    <div class="form-row">
        <div class="form-label">Time Slot</div><div class="form-separator">:</div>
        <div class="form-display-value"><input type="text" class="static-value" value="<%= appointment.getTimeSlot() %>" readonly></div>
    </div>

    <div class="form-row">
        <div class="form-label">Reason for Appointment</div><div class="form-separator">:</div>
        <div class="form-display-value">
            <textarea class="static-value reason-box" readonly rows="2"><%= appointment.getReason() != null ? appointment.getReason() : "No reason provided." %></textarea>
        </div>
    </div>

    <hr>

    <form action="viewAppointmentDetails" method="post" id="mainForm" onsubmit="return handleFormSubmission()">
        <input type="hidden" name="bookingId" value="<%= bookingId %>">

        <div class="form-row">
            <div class="form-label">Remark for Appointment</div><div class="form-separator">:</div>
            <div class="form-display-value">
                <textarea name="remark" rows="2" placeholder="Summary for student"><%= appointment.getRemark() != null ? appointment.getRemark() : "" %></textarea>
            </div>
        </div>

        <div class="form-row">
            <div class="form-label">Note for Appointment</div><div class="form-separator">:</div>
            <div class="form-display-value">
                <textarea name="note" rows="3" placeholder="Private notes"><%= appointment.getNote() != null ? appointment.getNote() : "" %></textarea>
            </div>
        </div>

        <div class="form-row">
            <div class="form-label">Status Appointment</div><div class="form-separator">:</div>
            <div class="form-display-value">
                <select name="statusAppointment" id="statusSelect" class="status-select" required onchange="toggleFollowUp(this.value)">
                    <option value="">-- Select Status --</option>
                    <option value="Done Session">Done This Session</option>
                    <option value="Next Follow-Up">Schedule Another Follow-Up</option>
                    <option value="No Show">Student No Show</option>
                    <option value="Cancelled">Cancel This Session</option>
                </select>
            </div>
        </div>

        <div id="followUpSection" class="follow-up-block">
            <h4>Schedule Next Follow-Up</h4>
            <div class="form-row">
                <div class="form-label">Next Date</div><div class="form-separator">:</div>
                <div class="form-display-value"><input type="date" name="nextDate" id="nextDate"></div>
            </div>
            <div class="form-row">
                <div class="form-label">Next Time</div><div class="form-separator">:</div>
                <div class="form-display-value">
                    <select name="nextTime" id="nextTime">
                        <option value="">-- Select Time Slot --</option>
                        <option value="8:30 - 9:30 AM">8:30 - 9:30 AM</option>
                        <option value="10:00 - 11:00 AM">10:00 - 11:00 AM</option>
                        <option value="2:00 - 3:00 PM">2:00 - 3:00 PM</option>
                        <option value="3:30 - 4:30 PM">3:30 - 4:30 PM</option>
                    </select>
                </div>
            </div>
            <div class="action-buttons">
                <button type="submit" class="btn-schedule-teal">SCHEDULE FOLLOW-UP</button>
                <a href="followUpAppointment" class="btn-back" style="width: 37%; text-align: center;">BACK TO LIST</a>
            </div>
        </div>

        <div id="defaultButtons" class="action-buttons">
            <div class="row-buttons">
                <button type="submit" class="btn-confirm">CONFIRM</button>
                <a href="followUpAppointment" class="btn-back">BACK TO LIST</a>
            </div>
        </div>
    </form>
</div>

<%-- No changes needed to your CSS or HTML structure, just update the script and form as follows --%>

<script>
/**
 * Toggles the visibility of the Follow-Up date/time section 
 * based on the selected status.
 */
function toggleFollowUp(val) {
    const section = document.getElementById('followUpSection');
    const defaultBtns = document.getElementById('defaultButtons');
    const nDate = document.getElementById('nextDate');
    const nTime = document.getElementById('nextTime');
    
    if (val === 'Next Follow-Up') {
        section.style.display = 'block';
        defaultBtns.style.display = 'none';
        // Make fields required only when this section is visible
        nDate.setAttribute('required', 'required');
        nTime.setAttribute('required', 'required');
    } else {
        section.style.display = 'none';
        defaultBtns.style.display = 'flex';
        // Remove requirements if hidden
        nDate.removeAttribute('required');
        nTime.removeAttribute('required');
    }
}

/**
 * Handles the double-popup logic: 
 * 1. Confirmation ("Are you sure?")
 * 2. Success Alert ("Success!")
 */
function handleFormSubmission() {
    const status = document.getElementById('statusSelect').value;
    
    // 1. Initial Validation
    if (status === "") {
        alert("Please select an Action Status first.");
        return false;
    }

    // 2. Define the Confirmation Message
    let confirmationMessage = "Are you sure you want to mark this appointment as '" + status + "'?";
    
    if (status === 'Next Follow-Up') {
        const nextDate = document.getElementById('nextDate').value;
        const nextTime = document.getElementById('nextTime').value;
        
        if (!nextDate || !nextTime) {
            alert("Please provide both a date and time for the follow-up session.");
            return false;
        }
        confirmationMessage = "Are you sure you want to schedule a new follow-up session for " + nextDate + "?";
    }

    // 3. Step One: "Are you sure?"
    const userConfirmed = confirm(confirmationMessage);

    if (userConfirmed) {
        // 4. Step Two: "Success!" 
        // This shows only after the user clicks 'OK' on the first popup
        alert("Success! The appointment record has been updated.");
        
        // 5. Final Submission
        return true; 
    } else {
        // User clicked 'Cancel' on the confirmation, stop the form submission
        return false;
    }
}
</script>