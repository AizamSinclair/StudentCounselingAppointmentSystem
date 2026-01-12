<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="headerCouns.jsp" %>

<style>
/* --- BASE STYLE --- */
body { background-color: #f4f7f6; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

.dashboard-content {
    padding: 30px;
    width: 95%;
    max-width: 1500px;
    margin: 50px auto;
    min-height: 80vh;
    background: white;
    border-radius: 10px;
    box-shadow: 0 6px 15px rgba(0,0,0,0.1);
}

/* BIG TITLE (Visible at 29px) */
h2 {
    color: #111;
    margin-bottom: 25px;
    border-bottom: 3.5px solid #f7941d;
    padding-bottom: 15px;
    text-align: center;
    font-size: 29px; 
    font-weight: bold;
}

/* --- ALERT BANNERS --- */
.alert {
    padding: 15px;
    margin-bottom: 25px;
    border-radius: 8px;
    text-align: center;
    font-weight: bold;
    font-size: 15px;
}
.alert-error {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}
.alert-success {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

/* --- FILTER ROW --- */
.filter-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    box-sizing: border-box;
    margin-bottom: 30px;
    padding: 20px 25px;
    background-color: #fff8f8; 
    border: 1px solid #ffe0e0;
    border-radius: 8px;
    gap: 15px;
}

.search-group { display: flex; align-items: center; gap: 12px; }
.search-group label { font-weight: bold; color: #333; font-size: 15px; }

.search-input {
    padding: 10px 12px;
    border: 1px solid #ccc;
    border-radius: 5px;
    color: #000;
}

.btn-search {
    padding: 10px 25px;
    background-color: #f7941d; 
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
}

.btn-clear {
    padding: 10px 18px; 
    background-color: #6c757d; 
    color: white;
    text-decoration: none; 
    border-radius: 5px; 
    font-size: 13px; 
    font-weight: bold;
}

/* --- TABLE STYLING --- */
.appointment-table-container { 
    width: 100%; 
    overflow-x: auto; 
    border-radius: 8px; 
    border: 1px solid #ddd;
}

.appointment-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
    min-width: 1300px;
}

.appointment-table th {
    background-color: #ffb6c1; 
    color: #333;
    font-weight: 700;
    text-transform: uppercase;
    border-bottom: 2px solid #ff94a7; 
    padding: 14px 15px;
    text-align: left;
}

.appointment-table td {
    padding: 14px 15px;
    border-bottom: 1.2px solid #b1b5ba; 
    border-right: 1.2px solid #b1b5ba;
    color: #000000 !important; 
    font-weight: 500;
}

.booked-date-cell { font-weight: 700 !important; color: #000; }

.status-pill {
    display: inline-block;
    padding: 8px 14px;
    border-radius: 20px;
    font-size: 0.85em;
    font-weight: bold;
    text-align: center;
    min-width: 160px;
    text-transform: uppercase;
    color: white;
}

.status-pending { background-color: #e9ecef; color: #495057; border: 1px solid #ced4da; }
.status-accepted { background-color: #28a745 !important; }
.status-declined { background-color: #dc3545 !important; }

.action-button {
    padding: 8px 15px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    text-decoration: none;
    font-weight: 600;
}

.waiting-text { color: #333; font-weight: bold; font-style: italic; }
.appointment-table tbody tr:hover { background-color: #fff9fa; }
</style>

<title>Follow-Up Appointment | UiTM Counselor</title>

<div class="dashboard-content">

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error">
            ⚠️ ${sessionScope.errorMessage}
        </div>
        <% session.removeAttribute("errorMessage"); %>
    </c:if>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">
             ${sessionScope.successMessage}
        </div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>

    <h2>Follow-Up Appointments</h2>

    <form action="followUpAppointment" method="GET" class="filter-row">
        <div class="search-group">
            <label>Search Student:</label>
            <input type="text" name="searchTerm" class="search-input" placeholder="ID or Name" value="${searchTerm}" style="width: 200px;">
            <button type="submit" class="btn-search">Search</button>
            <a href="followUpAppointment" class="btn-clear">Clear All</a>
        </div>

        <div class="search-group">
            <label>Filter Date:</label>
            <input type="date" name="filterDate" class="search-input" value="${filterDate}" onchange="this.form.submit()">

            <label style="margin-left: 15px;">Status Filters:</label>
            <select name="statusFilter" class="search-input" onchange="this.form.submit()" style="width: 180px;">
                <option value="ALL" ${statusFilter == 'ALL' ? 'selected' : ''}>All Follow-Ups</option>
                <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Pending Verification</option>
                <option value="Accepted" ${statusFilter == 'Accepted' ? 'selected' : ''}>Accepted</option>
                <option value="Declined" ${statusFilter == 'Declined' ? 'selected' : ''}>Declined</option>
            </select>
        </div>
    </form>

    <div class="appointment-table-container">
        <table class="appointment-table">
            <thead>
                <tr>
                    <th>No.</th>
                    <th>Student Name</th>
                    <th>Student ID</th>
                    <th>Phone</th>
                    <th>Booked Date</th>
                    <th>Time Slot</th>
                    <th>Reason</th>
                    <th>Remark</th>
                    <th>Note</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty followUpRecords}">
                        <tr><td colspan="11" style="text-align:center; padding:40px; color:#000; font-weight:bold;">No records found matching criteria.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="appt" items="${followUpRecords}" varStatus="loop">
                            <tr>
                                <td>${loop.count}.</td>
                                <td>${appt.studentName}</td>
                                <td>${appt.studentId}</td>
                                <td>${appt.studentPhone}</td>
                                <td class="booked-date-cell">
                                    <fmt:parseDate value="${appt.bookedDate}" pattern="yyyy-MM-dd" var="parsedDate" />
                                    <fmt:formatDate value="${parsedDate}" pattern="dd-MM-yyyy" />
                                </td>
                                <td>${appt.timeSlot}</td>
                                <td>${appt.reason}</td>
                                <td>${not empty appt.remark ? appt.remark : '-'}</td>
                                <td>${not empty appt.note ? appt.note : '-'}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${appt.status eq 'Next Follow-Up'}">
                                            <span class="status-pill status-pending">Pending Verification</span>
                                        </c:when>
                                        <c:when test="${appt.status eq 'Accepted'}">
                                            <span class="status-pill status-accepted">Accepted</span>
                                        </c:when>
                                        <c:when test="${appt.status eq 'Declined'}">
                                            <span class="status-pill status-declined">Declined</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${appt.status eq 'Next Follow-Up'}">
                                            <span class="waiting-text">Waiting for Student</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="viewAppointmentDetails?bookingId=${appt.bookingId}" class="action-button">MANAGE</a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>