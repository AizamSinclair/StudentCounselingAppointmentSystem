<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="headerCouns.jsp" %>
<%@ page import="com.uitm.studentcounselling.model.Appointment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    // Ensure the Appointment object exists
    Appointment appointment = (Appointment) request.getAttribute("appointment");

    if (appointment == null) {
        // Fallback in case of missing data
        response.sendRedirect("FollowUpAppointmentServlet?error=FollowUp+Details+missing");
        return;
    }

    String currentStatus = appointment.getStatus();
    int bookingId = appointment.getBookingId();

    // Change date format to day-month-year (dd-MM-yyyy)
    String formattedDate = appointment.getBookedDate(); 
    try {
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd-MM-yyyy");
        Date date = inputFormat.parse(appointment.getBookedDate());
        formattedDate = outputFormat.format(date);
    } catch (Exception e) {
        // Keeps original value if parsing fails
    }

    // Determine if the session is finalized and should only display read-only data
    boolean isFinalized = "Done Session".equals(currentStatus) ||
                            "No Show".equals(currentStatus) ||
                            "Cancelled".equals(currentStatus) ||
                            "Follow-Up Scheduled".equals(currentStatus);
%>

<style>
/* ==================== Styles ==================== */
.appointment-form-container { max-width: 500px; margin: 50px auto; padding: 30px; background-color: #ffc9d1; border-radius: 8px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); }
.appointment-form-container h2 { text-align: center; margin-bottom: 30px; color: #333; font-size: 1.5em; }
.form-row { display: flex; align-items: flex-start; margin-bottom: 15px; }
.form-label { flex: 2; font-weight: bold; color: #333; padding-top: 8px; }
.form-separator { flex: 0; margin: 0 10px; font-weight: bold; padding-top: 8px; }
.form-display-value { flex: 4; position: relative; }
.static-value, .status-select, textarea { width: 100%; padding: 8px 10px; border: none; border-radius: 4px; background-color: white; box-sizing: border-box; font-size: 1em; }

/* Custom handling for multi-line reasons */
textarea.static-value { 
    resize: none; 
    line-height: 1.5; 
    font-family: inherit;
    background-color: #fdfdfd; 
}

textarea { resize: vertical; }
.status-select { border: 1px solid #ccc; cursor: pointer; background-color: white; }
.action-buttons { text-align: center; margin-top: 40px; display: flex; justify-content: center; gap: 10px; }
.btn-confirm { background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 1em; text-transform: uppercase; }
.btn-cancel { background-color: #dc3545; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 1em; text-transform: uppercase; display: inline-block; text-decoration: none; }
.btn-neutral { background-color: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 1em; text-transform: uppercase; display: inline-block; text-decoration: none; } 
.follow-up-outer-container { padding: 20px 0; }
.follow-up-block { background-color: #e6f7ff; border: 1px solid #c9e7ff; padding: 20px; margin: 25px auto; border-radius: 8px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); max-width: 400px; display: none; text-align: center; }
.follow-up-block h3 { text-align: center; margin-top: 0; margin-bottom: 20px; font-size: 1.3em; color: #333; }
.follow-up-block .form-row { align-items: center; }
.follow-up-block .form-label { flex: 3; padding-top: 0; }
.follow-up-block .form-display-value { flex: 5; }
.follow-up-block input[type="date"], .follow-up-block select { padding: 8px; border: 1px solid #ccc; border-radius: 4px; width: 100%; box-sizing: border-box; background-color: white; font-size: 1em; }
.btn-schedule-followup { background-color: #009688; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 1em; text-transform: uppercase; width: 90%; }
.current-status { background-color: #ffe000; padding: 8px; border-radius: 4px; font-weight: bold; color: #e65100; }
</style>

<title>Manage Confirmed | UiTM Counselor</title>
<div class="appointment-form-container">
    <h2>Appointment Management</h2>
    <p style="color: red; text-align: center;"><%= (request.getParameter("error") != null) ? request.getParameter("error") : "" %></p>
    <p style="color: green; text-align: center;"><%= (request.getParameter("success") != null) ? request.getParameter("success") : "" %></p>

    <div id="appointment-info">
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
            <div class="form-label">Appointment Date</div>
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
                <textarea class="static-value" rows="4" readonly><%= appointment.getReason() %></textarea>
            </div>
        </div>
    </div>

    <hr style="margin: 20px 0;">

    <% if ("Pending Confirmation".equals(currentStatus)) { %>
        <h3>Action Required: Confirm Follow-Up</h3>
        <p style="text-align: center; color: #e65100; font-weight: bold;">
            This appointment is currently pending confirmation from the counselor.
        </p>
        
        <div class="form-row">
            <div class="form-label">Previous Remark</div>
            <div class="form-separator">:</div>
            <div class="form-display-value">
                <textarea rows="2" readonly><%= appointment.getRemark() != null ? appointment.getRemark() : "N/A" %></textarea>
            </div>
        </div>
        <div class="form-row">
            <div class="form-label">Previous Note</div>
            <div class="form-separator">:</div>
            <div class="form-display-value">
                <textarea rows="3" readonly><%= appointment.getNote() != null ? appointment.getNote() : "N/A" %></textarea>
            </div>
        </div>
        
        <div class="form-row">
            <div class="form-label">Current Status</div>
            <div class="form-separator">:</div>
            <div class="form-display-value">
                <span class="current-status"><%= currentStatus %></span>
            </div>
        </div>

        <form action="FollowUpActionServlet" method="post">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">
            
            <div class="action-buttons" style="margin-top: 30px;">
                <button type="submit" name="action" value="confirm" class="btn-confirm" 
                        onclick="return confirm('Do you want to confirm this follow-up appointment? This will change the status to CONFIRMED.');">
                    CONFIRM APPOINTMENT
                </button>
                <button type="submit" name="action" value="cancel" class="btn-cancel" 
                        onclick="return confirm('Do you want to cancel this follow-up appointment? This will change the status to CANCELLED.');">
                    CANCEL APPOINTMENT
                </button>
                <a href="FollowUpAppointmentServlet" class="btn-neutral">BACK TO LIST</a>
            </div>
        </form>
        
    <% } else if ("Confirmed".equals(currentStatus)) { %>
        
        <form action="manageAppointments" method="post" id="update-status-form">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">
            <input type="hidden" name="action" value="updateFinalStatus">

            <div class="form-row">
                <div class="form-label">Remark for Appointment</div>
                <div class="form-separator">:</div>
                <div class="form-display-value">
                    <textarea name="remark" id="remark_final" rows="2" maxlength="255" placeholder="(Session summary for student)"><%= appointment.getRemark() != null ? appointment.getRemark() : "" %></textarea>
                </div>
            </div>

            <div class="form-row">
                <div class="form-label">Note for Appointment</div>
                <div class="form-separator">:</div>
                <div class="form-display-value">
                    <textarea name="note" id="note_final" rows="3" placeholder="(Private counselling notes)"><%= appointment.getNote() != null ? appointment.getNote() : "" %></textarea>
                </div>
            </div>

            <div class="form-row">
                <div class="form-label">Status Appointment</div>
                <div class="form-separator">:</div>
                <div class="form-display-value">
                    <select name="finalStatus" id="finalStatus" class="status-select" required onchange="handleStatusChange(this.value);">
                        <option value="">-- Select Final Outcome --</option>
                        <option value="Next Follow-Up">Next Follow-Up</option>
                        <option value="Done Session">Done Session</option>
                        <option value="No Show">No Show</option>
                        <option value="Cancelled">Cancelled</option>
                    </select>
                </div>
            </div>

            <div class="action-buttons" id="confirm-buttons">
                <button type="submit" class="btn-confirm" onclick="return confirm('Record the final status, remark, and note?');">
                    CONFIRM
                </button>
                <a href="manageAppointments" class="btn-cancel">BACK TO LIST</a>
            </div>
        </form>

        <hr id="separator-hr">

        <div class="follow-up-outer-container">
            <div class="follow-up-block" id="follow-up-scheduler">
                <h3>Schedule Next Follow-Up</h3>
                
                <form action="manageAppointments" method="post" id="follow-up-form" onsubmit="return confirmFollowUp();">
                    
                    <input type="hidden" name="action" value="scheduleFollowUp">
                    <input type="hidden" name="bookingId" value="<%= bookingId %>">
                    
                    <input type="hidden" name="StudentId" value="<%= appointment.getStudentId() %>">
                    <input type="hidden" name="CounselorId" value="<%= appointment.getCounselorId() %>">
                    <input type="hidden" name="ReasonForAppointment" value="<%= appointment.getReason() %>"> 
                    <input type="hidden" name="StudentPhoneNumber" value="<%= appointment.getStudentPhone() %>">
                    
                    <input type="hidden" name="remark" id="hidden_remark_final">
                    <input type="hidden" name="note" id="hidden_note_final">
                    <input type="hidden" name="StatusAppointment" id="hidden_finalStatus">

                    <div class="form-row">
                        <div class="form-label">Next Date</div>
                        <div class="form-separator">:</div>
                        <div class="form-display-value">
                            <input type="date" name="nextDate" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-label">Next Time</div>
                        <div class="form-separator">:</div>
                        <div class="form-display-value">
                            <select name="nextTime" required>
                                <option value="">-- Select Time Slot --</option>
                                <option value="8:30 - 9:30 AM">8:30 - 9:30 AM</option>
                                <option value="10:00 - 11:00 AM">10:00 - 11:00 AM</option>
                                <option value="2:00 - 3:00 PM">2:00 - 3:00 PM</option>
                                <option value="3:30 - 4:30 PM">3:30 - 4:30 PM</option>
                            </select>
                        </div>
                    </div>

                    <div class="action-buttons" style="margin-top: 15px;">
                        <button type="submit" class="btn-schedule-followup">SCHEDULE FOLLOW-UP</button>
                    </div>

                    <div class="action-buttons" style="margin-top: 10px;">
                        <a href="manageAppointments" class="btn-cancel">BACK TO LIST</a>
                    </div>
                </form>
                </div>
        </div>

    <script>
    function handleStatusChange(selectedValue) {
        const schedulerBlock = document.getElementById('follow-up-scheduler');
        const confirmButtons = document.getElementById('confirm-buttons');
        const separator = document.getElementById('separator-hr');
        
        // Copy visible text to hidden fields
        document.getElementById('hidden_remark_final').value = document.getElementById('remark_final').value;
        document.getElementById('hidden_note_final').value = document.getElementById('note_final').value;
        document.getElementById('hidden_finalStatus').value = selectedValue; 

        if (selectedValue === 'Next Follow-Up') {
            schedulerBlock.style.display = 'block';
            confirmButtons.style.display = 'none';
            separator.style.display = 'none';
        } else {
            schedulerBlock.style.display = 'none';
            confirmButtons.style.display = 'flex';
            separator.style.display = 'block';
        }
    }

    function confirmFollowUp() {
        // Final sync of remarks/notes before submission
        document.getElementById('hidden_remark_final').value = document.getElementById('remark_final').value;
        document.getElementById('hidden_note_final').value = document.getElementById('note_final').value;

        const nextDate = document.querySelector('input[name="nextDate"]').value;
        const nextTime = document.querySelector('select[name="nextTime"]').value;

        if (nextDate === '' || nextTime === '') {
            alert("Please select a Next Date and Next Time Slot.");
            return false;
        }
        return confirm("Finalize this session and update the date/time for the follow-up?");
    }

    document.addEventListener('DOMContentLoaded', function() {
        const statusSelect = document.getElementById('finalStatus');
        if(statusSelect) {
            statusSelect.addEventListener('change', function() {
                handleStatusChange(this.value);
            });
        }
    });
</script>

    <% } else if (isFinalized) { %>

        <div id="finalized-data">
            <div class="form-row">
                <div class="form-label">Remark for Appointment</div>
                <div class="form-separator">:</div>
                <div class="form-display-value">
                    <textarea rows="2" readonly><%= appointment.getRemark() != null ? appointment.getRemark() : "N/A" %></textarea>
                </div>
            </div>
            <div class="form-row">
                <div class="form-label">Note for Appointment</div>
                <div class="form-separator">:</div>
                <div class="form-display-value">
                    <textarea rows="3" readonly><%= appointment.getNote() != null ? appointment.getNote() : "N/A" %></textarea>
                </div>
            </div>
            <div class="form-row">
                <div class="form-label">Status Appointment</div>
                <div class="form-separator">:</div>
                <div class="form-display-value">
                    <input type="text" class="static-value" value="<%= currentStatus %>" readonly>
                </div>
            </div>
        </div>

        <div class="action-buttons" style="margin-top: 20px;">
            <a href="<%= "Follow-Up Scheduled".equals(currentStatus) ? "FollowUpAppointmentServlet" : "manageAppointments" %>" 
               class="btn-cancel">BACK TO LIST</a>
        </div>

    <% } %>
</div>