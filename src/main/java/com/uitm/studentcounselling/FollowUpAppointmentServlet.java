package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import com.uitm.studentcounselling.model.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Comparator;
import java.util.stream.Collectors;

public class FollowUpAppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String counselorId = (session != null) ? (String) session.getAttribute("counselorId") : null;

        if (counselorId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // --- NEW: Handle Alert Messages from Session ---
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage");
        }

        String searchTerm = request.getParameter("searchTerm");
        if (searchTerm == null) searchTerm = "";
        
        String filterDate = request.getParameter("filterDate"); 
        String statusFilterParam = request.getParameter("statusFilter");
        if (statusFilterParam == null) statusFilterParam = "ALL";

        final String statusFilter = statusFilterParam;

        List<Appointment> rawList = appointmentDAO.getFollowUpSpecificRecords(counselorId, searchTerm);

        List<Appointment> followUpList = rawList.stream()
            .filter(a -> {
                boolean statusMatch;
                if ("ALL".equals(statusFilter)) statusMatch = true;
                else if ("PENDING".equals(statusFilter)) statusMatch = "Next Follow-Up".equals(a.getStatus());
                else statusMatch = statusFilter.equalsIgnoreCase(a.getStatus());
                
                boolean dateMatch = true;
                if (filterDate != null && !filterDate.isEmpty()) {
                    dateMatch = a.getBookedDate().toString().equals(filterDate);
                }
                return statusMatch && dateMatch;
            })
            .sorted(Comparator.comparing(Appointment::getBookedDate))
            .collect(Collectors.toList());

        // --- NEW: Status Alert Logic for the List View ---
        // This scans the filtered list to notify the counselor if action is needed
        boolean hasPending = followUpList.stream().anyMatch(a -> "Pending".equalsIgnoreCase(a.getStatus()));
        boolean hasFollowUp = followUpList.stream().anyMatch(a -> "Next Follow-Up".equalsIgnoreCase(a.getStatus()));

        if (hasPending) {
            request.setAttribute("infoMessage", "You have appointments PENDING approval.");
        } else if (hasFollowUp) {
            request.setAttribute("infoMessage", "Displaying active Follow-Up schedules waiting for student confirmation.");
        }

        request.setAttribute("followUpRecords", followUpList);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("filterDate", filterDate); 

        request.getRequestDispatcher("followUpAppointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String counselorId = (session != null) ? (String) session.getAttribute("counselorId") : null;

        if (counselorId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String bookingIdStr = request.getParameter("bookingId");
        String status = request.getParameter("statusAppointment");
        String remark = request.getParameter("remark");
        String note = request.getParameter("note");
        String nextDate = request.getParameter("nextDate");
        String nextTime = request.getParameter("nextTime");

        if (bookingIdStr != null && status != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);

                if (nextDate != null && !nextDate.isEmpty() && nextTime != null && !nextTime.isEmpty()) {
                    boolean isTaken = appointmentDAO.isSlotTaken(nextDate, nextTime, counselorId, bookingId);
                    
                    if (isTaken) {
                        session.setAttribute("errorMessage", "Slot has been full. Please assign another date or time.");
                        response.sendRedirect("followUpAppointment");
                        return; 
                    }
                } else {
                    Appointment current = appointmentDAO.selectAppointmentById(bookingId);
                    nextDate = current.getBookedDate();
                    nextTime = current.getTimeSlot();
                }

                boolean success = appointmentDAO.finalizeSessionDetails(
                    bookingId, status, remark, note, nextDate, nextTime
                );

                if (success) {
                    session.setAttribute("successMessage", "Record updated successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to update record in database.");
                }

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            }
        }
        
        response.sendRedirect("followUpAppointment");
    }
}