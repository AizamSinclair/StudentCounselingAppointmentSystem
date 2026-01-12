<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="headerCouns.jsp" %> 
<%@ page import="java.util.List, com.uitm.studentcounselling.model.Appointment" %>

<%
    List<Appointment> appointmentRecords = (List<Appointment>) request.getAttribute("appointmentRecords");
    String statusFilter = (String) request.getAttribute("statusFilter");
    if (statusFilter == null) statusFilter = "";
    String searchStudentId = (String) request.getAttribute("searchStudentId");
    String filterDate = (String) request.getAttribute("filterDate");
    if (appointmentRecords == null) appointmentRecords = new java.util.ArrayList<>();
%>

<style>
/* --- BASE STYLE --- */
body { background-color: #f4f7f6; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

.container {
    padding: 30px; width: 95%; max-width: 1500px;
    margin: 50px auto; background: white; border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.05);
}

/* BIG TITLE */
h2 {
    text-align: center; 
    color: #333; 
    margin-bottom: 25px;
    border-bottom: 3.5px solid #f7941d; 
    padding-bottom: 15px;
    font-size: 29px; 
    font-weight: bold;
}

/* --- FILTER ROW --- */
.search-filter-row {
    display: flex; justify-content: space-between; margin-bottom: 25px;
    align-items: center; padding: 20px; background-color: #fffafa; 
    border-radius: 8px; border: 1px solid #ffe4e6; gap: 15px;
}

.search-filter-row > div { display: flex; gap: 12px; align-items: center; }

.search-filter-row label { 
    font-weight: bold; color: #333; font-size: 15px; 
}

.search-filter-row input, .search-filter-row select {
    padding: 8px 12px; border: 1px solid #ccc; border-radius: 5px; 
    outline: none; font-size: 14px;
}

.btn-search {
    padding: 9px 22px; background-color: #f7941d; color: white; 
    border: none; border-radius: 5px; cursor: pointer; 
    font-weight: bold; font-size: 14px;
}

/* --- TABLE STYLING --- */
.table-responsive {
    overflow: hidden; border-radius: 10px; border: 1.5px solid #d1d5db; 
}

.records-table { width: 100%; border-collapse: collapse; font-size: 14px; }

/* Table Header Row (Pink Row - Kept Original) */
.records-table thead tr { background-color: #f9a8b8; color: #333; }

.records-table th {
    padding: 15px; text-align: left; font-weight: bold;
    text-transform: uppercase; font-size: 14px;
}

/* --- HIGH VISIBILITY DATA (THE FIX) --- */
.records-table tbody td {
    padding: 12px 15px; 
    text-align: left; 
    border: 1.2px solid #b1b5ba; /* Darkened grid lines for better contrast */
    color: #000000; /* Pure Black text for maximum visibility */
    font-weight: 500; /* Slightly heavier font weight so it stands out */
}

.date-col, .time-col { width: 115px; white-space: nowrap; }

/* Making key data columns extra visible */
.booked-date-cell { font-weight: 800; color: #000000; }
.status-text { font-weight: 800; color: #000000; }

.records-table tbody tr:hover { background-color: #fff4f6; }
</style>
<title>Student Appointment Record | UiTM Counselor</title>
<div class="container">
    <h2>Student Appointment Records</h2>

    <form action="studentRecords" method="GET" class="search-filter-row">
        <div>
            <label>Search Student:</label>
            <input type="text" name="searchStudentId" placeholder="ID or Name" value="<%= searchStudentId != null ? searchStudentId : "" %>">
            <button type="submit" class="btn-search">Search</button>
            <a href="studentRecords" style="padding: 9px 18px; background-color: #6c757d; color: white; text-decoration: none; border-radius: 5px; font-size: 13px; font-weight: bold;">Clear All</a>
        </div>

        <div>
            <label>Filter Date:</label>
            <input type="date" name="filterDate" value="<%= filterDate != null ? filterDate : "" %>" onchange="this.form.submit()">

            <label style="margin-left: 15px;">Status Filters:</label>
            <select name="statusFilter" onchange="this.form.submit()">
                <option value="" <%= statusFilter.isEmpty() ? "selected" : "" %>>All Historical</option> 
                <option value="Done Session" <%= "Done Session".equals(statusFilter) ? "selected" : "" %>>Done Session</option>
                <option value="No Show" <%= "No Show".equals(statusFilter) ? "selected" : "" %>>No Show</option>
                <option value="Cancelled" <%= "Cancelled".equals(statusFilter) ? "selected" : "" %>>Cancelled</option>
            </select>
        </div>
    </form>

    <div class="table-responsive">
        <table class="records-table">
            <thead>
                <tr>
                    <th>No.</th>
                    <th>Student Name</th>
                    <th>Student ID</th>
                    <th>Phone</th>
                    <th class="date-col">Booked Date</th>
                    <th class="time-col">Time Slot</th>
                    <th>Counselor</th>
                    <th>Reason</th>
                    <th>Remark</th>
                    <th>Note</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% 
                int displayCount = 1;
                boolean foundRecords = false;
                for (Appointment appt : appointmentRecords) {
                    String status = appt.getStatus();
                    if (statusFilter.isEmpty() && ("Confirmed".equals(status) || "Pending".equals(status) || "Follow-Up Scheduled".equals(status))) {
                        continue; 
                    }
                    foundRecords = true;
                    request.setAttribute("currentAppt", appt);
                %>
                <tr>
                    <td><%= displayCount++ %>.</td>
                    <td><%= appt.getStudentName() %></td>
                    <td><%= appt.getStudentId() %></td>
                    <td><%= appt.getStudentPhone() %></td>
                    <td class="date-col booked-date-cell">
                        <fmt:parseDate value="${currentAppt.bookedDate}" pattern="yyyy-MM-dd" var="d" />
                        <fmt:formatDate value="${d}" pattern="dd-MM-yyyy" />
                    </td>
                    <td class="time-col"><%= appt.getTimeSlot() %></td>
                    <td><%= appt.getCounselorName() %></td>
                    <td><%= appt.getReason() %></td>
                    <td><%= appt.getRemark() != null ? appt.getRemark() : "-" %></td>
                    <td><%= appt.getNote() != null ? appt.getNote() : "-" %></td>
                    <td class="status-text"><%= appt.getStatus() %></td>
                </tr>
                <% } 
                if (!foundRecords) { %>
                    <tr><td colspan="11" style="text-align:center; padding:30px; color: #000; font-weight: bold;">No records found.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>