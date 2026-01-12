<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.uitm.studentcounselling.model.Appointment"%>
<%@page import="java.util.List"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    Object userRoleObj = session.getAttribute("userRole");
    if (userRoleObj == null || !userRoleObj.equals(3)) {
        response.sendRedirect("login.jsp");
        return; 
    }
%>

<%@include file="header.jsp" %>

<style>
.content-area {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 40px 20px 60px;
    min-height: calc(100vh - 170px);
    background-color: #f7f7f7; 
}

.section-header {
    width: 95%;
    margin: 25px 0 10px 0;
    font-size: 1.5em;
    font-weight: bold;
    color: #333;
    display: flex;
    align-items: center;
    justify-content: space-between; 
}

.status-table {
    width: 95%;
    margin-bottom: 30px;
    border-collapse: collapse;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    background-color: white;
    border-radius: 8px;
    overflow: hidden;
}

.status-table th, .status-table td {
    padding: 14px 15px;
    text-align: left;
    border-bottom: 1px solid #eee;
    font-size: 0.95em;
}

.status-table th {
    background-color: #ccffcc; 
    color: #384238; 
    font-weight: bold;
    text-transform: uppercase;
}

.follow-up-header th {
    background-color: #f3e5f5;
    color: #8e44ad;
}

.action-links a {
    color: white;
    text-decoration: none;
    margin-right: 5px;
    font-weight: 600;
    padding: 6px 12px;
    border-radius: 4px;
    display: inline-block;
    cursor: pointer;
    font-size: 0.85em;
    transition: 0.3s;
}

.action-links a.confirm-btn { background-color: #28a745; }
.action-links a.cancel-btn { background-color: #dc3545; }
.action-links a.edit-btn { background-color: #007bff; }

/* Consistent Status Styles with Backgrounds */
.status-pill {
    padding: 4px 10px;
    border-radius: 4px;
    font-weight: bold;
    font-size: 0.85em;
    display: inline-block;
}

.status-next-followup { color: #8e44ad; background-color: #f3e5f5; border: 1px solid #e1bee7; }
.status-accepted { color: #27ae60; background-color: #e8f5e9; }
.status-declined { color: #c0392b; background-color: #ffebee; }
.status-pending { color: #f39c12; background-color: #fff3e0; }
.status-confirmed { color: #2980b9; background-color: #e3f2fd; }
.status-general { font-weight: 500; color: #555; }
.no-data { padding: 20px; text-align: center; color: #999; }

.booking-title {
    font-size: 2.5em;
    font-weight: bold;
    margin-bottom: 30px;
    padding: 10px 20px;
    color: #2e4d2e;
    border-bottom: 3px solid #008080;
}

.filter-label {
    font-size: 0.6em; 
    font-weight: bold;
    color: #555;
    margin-right: 10px;
}

.filter-select {
    padding: 5px 10px;
    border-radius: 4px;
    border: 1px solid #ccc;
    background-color: #fff;
    font-size: 0.6em; 
    cursor: pointer;
    font-weight: normal;
}
</style>

<div class="content-area">
    <h1 class="booking-title">Appointment Status Check</h1>

    <div class="section-header" style="color: #8e44ad;">Follow-Up Suggestions</div>
    <table class="status-table">
        <thead class="follow-up-header">
            <tr>
                <th>No.</th>
                <th>Student Name</th>
                <th>Booked Date</th>
                <th>Time Slot</th>
                <th>Counselor</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty followUps}">
                    <c:forEach var="appt" items="${followUps}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td><c:out value="${appt.studentName}" /></td>
                            <td>
                                <fmt:parseDate value="${appt.bookedDate}" pattern="yyyy-MM-dd" var="parsedFUpDate" type="date" />
                                <strong><fmt:formatDate value="${parsedFUpDate}" pattern="dd-MM-yyyy" /></strong>
                            </td>
                            <td><c:out value="${appt.timeSlot}" /></td>
                            <td><c:out value="${appt.counselorName}" /></td>
                            <td><c:out value="${appt.reason}" /></td>
                            <td><span class="status-pill status-next-followup">FOLLOW-UP SUGGESTED</span></td>
                            <td class="action-links">
                                <a href="FollowUpActionServlet?bookingId=${appt.bookingId}&action=confirm" class="confirm-btn"
                                   onclick="return confirm('Confirm follow-up for ' + '<fmt:formatDate value="${parsedFUpDate}" pattern="dd-MM-yyyy" />' + '?');">ACCEPT</a>
                                <a href="FollowUpActionServlet?bookingId=${appt.bookingId}&action=cancel" class="cancel-btn" 
                                   onclick="return confirm('Decline this follow-up suggestion?');">DECLINE</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="8" class="no-data">No follow-up suggestions found.</td></tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <hr style="width: 95%; border: 0.5px solid #ddd; margin: 20px 0;">

    <div class="section-header">
        <span>Appointment History</span>
        <form action="checkStatus" method="get" style="display: flex; align-items: center; margin: 0;">
            <span class="filter-label">Filter Status:</span>
            <select name="filterStatus" class="filter-select" onchange="this.form.submit()">
                <option value="All" ${currentFilter == 'All' || empty currentFilter ? 'selected' : ''}>All Statuses</option>
                <option value="Pending" ${currentFilter == 'Pending' ? 'selected' : ''}>Pending</option>
                <option value="Confirmed" ${currentFilter == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                <option value="Done Session" ${currentFilter == 'Done Session' ? 'selected' : ''}>Done Session</option>
                <option value="Cancelled" ${currentFilter == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                <option value="No Show" ${currentFilter == 'No Show' ? 'selected' : ''}>No Show</option>
                <option value="Accepted" ${currentFilter == 'Accepted' ? 'selected' : ''}>Accepted</option>
                <option value="Declined" ${currentFilter == 'Declined' ? 'selected' : ''}>Declined</option>
            </select>
        </form>
    </div>

    <table class="status-table">
        <thead>
            <tr>
                <th>No.</th>
                <th>Student Name</th>
                <th>Booked Date</th>
                <th>Time Slot</th>
                <th>Counselor</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty history}">
                    <c:forEach var="appt" items="${history}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td><c:out value="${appt.studentName}" /></td>
                            <td>
                                <fmt:parseDate value="${appt.bookedDate}" pattern="yyyy-MM-dd" var="parsedHistDate" type="date" />
                                <fmt:formatDate value="${parsedHistDate}" pattern="dd-MM-yyyy" />
                            </td>
                            <td><c:out value="${appt.timeSlot}" /></td>
                            <td><c:out value="${appt.counselorName}" /></td>
                            <td><c:out value="${appt.reason}" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${appt.status == 'Pending'}"><span class="status-pill status-pending">PENDING</span></c:when>
                                    <c:when test="${appt.status == 'Confirmed'}"><span class="status-pill status-confirmed">CONFIRMED</span></c:when>
                                    <c:when test="${appt.status == 'Accepted'}"><span class="status-pill status-accepted">ACCEPTED</span></c:when>
                                    <c:when test="${appt.status == 'Declined'}"><span class="status-pill status-declined">DECLINED</span></c:when>
                                    <c:otherwise><span class="status-general"><c:out value="${appt.status}" /></span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="action-links">
                                <c:choose>
                                    <%-- Pending remains interactive; Confirmed and others become view-only --%>
                                    <c:when test="${appt.status == 'Pending'}">
                                        <a href="EditAppointmentServlet?bookingId=${appt.bookingId}" class="edit-btn">Edit</a>  
                                        <a href="CancelAppointmentServlet?bookingId=${appt.bookingId}" class="cancel-btn" 
                                           onclick="return confirm('Are you sure you want to cancel this appointment?');">Cancel</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #999; font-size: 0.85em;">No Actions Available</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="8" class="no-data">No history found for this status.</td></tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script>
    // Get URL parameters
    const urlParams = new URLSearchParams(window.location.search);
    const message = urlParams.get('message');
    const error = urlParams.get('error');

    // Success Alerts
    if (message === 'FollowUpConfirmed') {
        alert('Follow-up appointment successfully accepted!');
    } else if (message === 'FollowUpDeclined') {
        alert('You have declined the follow-up suggestion.');
    } else if (message === 'CancelSuccess') {
        // Only added this line for cancellation success
        alert('Your appointment has been successfully cancelled.');
    }

    // Error Alerts
    if (error === 'SlotNoLongerAvailable') {
        // This is triggered because the DAO found a conflict with another ACTIVE session
        alert('Conflict: This time slot is no longer available as another student has an active booking. Please contact your counselor.');
    } else if (error === 'FollowUpActionFailed') {
        alert('Error: Database update failed. Please try again.');
    } else if (error === 'NotFound') {
        alert('Error: Appointment record not found.');
    } else if (error === 'CancelFailed') {
        // Only added this line for cancellation failure
        alert('Error: Could not cancel the appointment.');
    }

    // Clean the URL so alerts don't repeat on refresh
    if (message || error) {
        const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
        window.history.replaceState(null, null, cleanUrl);
    }
</script>

<%@include file="footer.jsp" %>