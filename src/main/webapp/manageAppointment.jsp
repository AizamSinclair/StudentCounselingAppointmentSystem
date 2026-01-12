<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="headerCouns.jsp" %>

<style>
    body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; }
    .dashboard-content { padding: 20px; width: 95%; max-width: 1500px; margin: 20px auto; }
    
    .section-block { background: white; border-radius: 10px; box-shadow: 0 6px 15px rgba(0,0,0,0.1); padding: 25px; margin-bottom: 40px; }
    
    .section-header { 
        display: flex; justify-content: space-between; align-items: center; 
        border-bottom: 3.5px solid #f7941d; margin-bottom: 20px; padding-bottom: 10px; 
    }
    
    h2 { color: #111; font-size: 24px; font-weight: bold; margin: 0; }

    /* Independent Table Filters */
    .filter-box { display: flex; align-items: center; gap: 10px; background: #fff8f8; padding: 8px 15px; border: 1px solid #ffe0e0; border-radius: 5px; }
    .filter-box label { font-size: 13px; font-weight: bold; color: #333; }
    .date-input { padding: 6px; border: 1px solid #ccc; border-radius: 4px; font-size: 13px; }
    
    /* Solid Clear Button */
    .btn-clear { 
        font-size: 12px; 
        color: white; 
        background-color: #6c757d; 
        text-decoration: none; 
        padding: 6px 12px; 
        border-radius: 4px; 
        font-weight: bold;
        border: none;
    }
    .btn-clear:hover { background-color: #5a6268; }

    /* Rounded Table Container */
    .table-container {
        border-radius: 12px; 
        overflow: hidden;    
        border: 1.2px solid #b1b5ba;
        margin-top: 10px;
    }

    /* High Visibility Table */
    .appointment-table { width: 100%; border-collapse: collapse; background: white; }
    .appointment-table th { background-color: #ffb6c1; color: #333; padding: 12px; text-align: left; text-transform: uppercase; font-size: 13px; border-bottom: 2px solid #ff94a7; }
    .appointment-table td { 
        padding: 12px; 
        border-bottom: 1.1px solid #b1b5ba; 
        border-right: 1.1px solid #b1b5ba; 
        color: #000000; 
        font-weight: 400; 
    }
    
    .appointment-table td:last-child, .appointment-table th:last-child { border-right: none; }
    .appointment-table tr:last-child td { border-bottom: none; }

    /* --- FIXED STATUS COLORS --- */
    .status-pending { 
        color: #f7941d !important; 
        font-weight: bold !important; 
    }
    .status-confirmed { 
        color: #28a745 !important; 
        font-weight: bold !important; 
    }
    /* --------------------------- */

    .action-btn { background: #007bff; color: white; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-weight: bold; font-size: 12px; }
    .alert { padding: 15px; margin-bottom: 20px; border-radius: 8px; text-align: center; font-weight: bold; }
</style>
<title>Manage Appointment | UiTM Counselor</title>
<div class="dashboard-content">

    <c:if test="${not empty updateMessage}"><div class="alert" style="background:#d4edda; color:#155724;">${updateMessage}</div></c:if>
    <c:if test="${not empty errorMessage}"><div class="alert" style="background:#f8d7da; color:#721c24;">${errorMessage}</div></c:if>

    <div class="section-block">
        <div class="section-header">
            <h2>Manage Pending Appointments</h2>
            <form action="manageAppointments" method="GET" class="filter-box">
                <input type="hidden" name="filterDateConfirmed" value="${filterDateConfirmed}">
                <label>Filter Date:</label>
                <input type="date" name="filterDatePending" class="date-input" value="${filterDatePending}" onchange="this.form.submit()">
                <c:if test="${not empty filterDatePending}">
                    <a href="manageAppointments?filterDateConfirmed=${filterDateConfirmed}" class="btn-clear">Clear Date</a>
                </c:if>
            </form>
        </div>
        
        <div class="table-container">
            <table class="appointment-table">
                <thead>
                    <tr>
                        <th>No.</th><th>Student Name</th><th>ID</th><th>Phone</th><th>Booked Date</th><th>Time Slot</th><th>Counselor</th><th>Reason</th><th>Status</th><th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="appt" items="${pendingAppointments}" varStatus="loop">
                        <tr>
                            <td>${loop.count}.</td>
                            <td>${appt.studentName}</td>
                            <td>${appt.studentId}</td>
                            <td>${appt.studentPhone}</td>
                            <td>
                                <fmt:parseDate value="${appt.bookedDate}" pattern="yyyy-MM-dd" var="pd" />
                                <fmt:formatDate value="${pd}" pattern="dd-MM-yyyy" />
                            </td>
                            <td>${appt.timeSlot}</td>
                            <td>${appt.counselorName}</td>
                            <td>${appt.reason}</td>
                            <td class="status-pending">${appt.status}</td>
                            <td><a href="viewAppointmentDetails?bookingId=${appt.bookingId}" class="action-btn">MANAGE</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="section-block">
        <div class="section-header">
            <h2>Confirmed Appointments</h2>
            <form action="manageAppointments" method="GET" class="filter-box">
                <input type="hidden" name="filterDatePending" value="${filterDatePending}">
                <label>Filter Date:</label>
                <input type="date" name="filterDateConfirmed" class="date-input" value="${filterDateConfirmed}" onchange="this.form.submit()">
                <c:if test="${not empty filterDateConfirmed}">
                    <a href="manageAppointments?filterDatePending=${filterDatePending}" class="btn-clear">Clear Date</a>
                </c:if>
            </form>
        </div>
        
        <div class="table-container">
            <table class="appointment-table">
                <thead>
                    <tr>
                        <th>No.</th><th>Student Name</th><th>ID</th><th>Phone</th><th>Booked Date</th><th>Time Slot</th><th>Counselor</th><th>Reason</th><th>Status</th><th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="appt" items="${confirmedAppointments}" varStatus="loop">
                        <tr>
                            <td>${loop.count}.</td>
                            <td>${appt.studentName}</td>
                            <td>${appt.studentId}</td>
                            <td>${appt.studentPhone}</td>
                            <td>
                                <fmt:parseDate value="${appt.bookedDate}" pattern="yyyy-MM-dd" var="pd" />
                                <fmt:formatDate value="${pd}" pattern="dd-MM-yyyy" />
                            </td>
                            <td>${appt.timeSlot}</td>
                            <td>${appt.counselorName}</td>
                            <td>${appt.reason}</td>
                            <td class="status-confirmed">${appt.status}</td>
                            <td><a href="viewAppointmentDetails?bookingId=${appt.bookingId}" class="action-btn">MANAGE</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>