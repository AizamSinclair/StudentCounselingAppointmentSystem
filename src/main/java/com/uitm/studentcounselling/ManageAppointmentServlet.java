package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import com.uitm.studentcounselling.model.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Comparator;
import java.util.stream.Collectors;

public class ManageAppointmentServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
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

        String filterDatePending = request.getParameter("filterDatePending");
        String filterDateConfirmed = request.getParameter("filterDateConfirmed");

        List<Appointment> rawPending = appointmentDAO.getAppointmentsByStatusAndCounselor("Pending", counselorId);
        List<Appointment> rawConfirmed = appointmentDAO.getAppointmentsByStatusAndCounselor("Confirmed", counselorId);

        List<Appointment> pendingAppointments = rawPending.stream()
            .filter(a -> filterDatePending == null || filterDatePending.trim().isEmpty() || String.valueOf(a.getBookedDate()).equals(filterDatePending))
            .sorted(Comparator.comparing(Appointment::getBookedDate))
            .collect(Collectors.toList());

        List<Appointment> confirmedAppointments = rawConfirmed.stream()
            .filter(a -> filterDateConfirmed == null || filterDateConfirmed.trim().isEmpty() || String.valueOf(a.getBookedDate()).equals(filterDateConfirmed))
            .sorted(Comparator.comparing(Appointment::getBookedDate))
            .collect(Collectors.toList());

        request.setAttribute("pendingAppointments", pendingAppointments);
        request.setAttribute("confirmedAppointments", confirmedAppointments);
        request.setAttribute("filterDatePending", filterDatePending);
        request.setAttribute("filterDateConfirmed", filterDateConfirmed);

        String updateMessage = (String) session.getAttribute("updateMessage");
        if (updateMessage != null) { 
            request.setAttribute("updateMessage", updateMessage); 
            session.removeAttribute("updateMessage"); 
        }
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) { 
            request.setAttribute("errorMessage", errorMessage); 
            session.removeAttribute("errorMessage"); 
        }

        request.getRequestDispatcher("/manageAppointment.jsp").forward(request, response);
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

        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");
        int bookingId = -1;
        
        if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
            try { bookingId = Integer.parseInt(bookingIdStr); } catch (NumberFormatException e) { }
        }
        
        if (bookingId == -1) { 
             session.setAttribute("errorMessage", "Invalid Booking ID.");
             response.sendRedirect(request.getContextPath() + "/manageAppointments");
             return;
        }

        if ("scheduleFollowUp".equals(action)) {
            String nextDate = request.getParameter("nextDate");    
            String nextTime = request.getParameter("nextTime");    
            String remark = request.getParameter("remark");
            String note = request.getParameter("note");

            // Pass 'bookingId' to ignore itself during the check
            if (appointmentDAO.isSlotTaken(nextDate, nextTime, counselorId, bookingId)) {
                session.setAttribute("errorMessage", "Slot has been full. Please choose another date or time.");
            } else {
                boolean updated = appointmentDAO.finalizeSessionDetails(bookingId, "Next Follow-Up", remark, note, nextDate, nextTime);
                if (updated) {
                    session.setAttribute("updateMessage", "Appointment updated with new follow-up.");
                } else {
                    session.setAttribute("errorMessage", "Database update failed.");
                }
            }

        } else if ("updateFinalStatus".equals(action)) { 
            String finalStatus = request.getParameter("finalStatus"); 
            String remark = request.getParameter("remark");
            String note = request.getParameter("note");
            
            Appointment current = appointmentDAO.selectAppointmentById(bookingId);
            if(appointmentDAO.finalizeSessionDetails(bookingId, finalStatus, remark, note, current.getBookedDate(), current.getTimeSlot())) {
                session.setAttribute("updateMessage", "Status updated to " + finalStatus);
            }

        } else if ("updateStatus".equals(action)) {
            String newStatus = request.getParameter("newStatus");
            
            if ("Confirmed".equals(newStatus)) {
                Appointment appt = appointmentDAO.selectAppointmentById(bookingId);
                
                // CRITICAL FIX: Pass bookingId so it doesn't conflict with its own 'Pending' record
                if (appointmentDAO.isSlotTaken(appt.getBookedDate(), appt.getTimeSlot(), counselorId, bookingId)) {
                    session.setAttribute("errorMessage", "Cannot confirm. You already have another appointment at this date and time.");
                } else {
                    if (appointmentDAO.confirmAppointment(bookingId)) {
                        session.setAttribute("updateMessage", "Appointment confirmed successfully.");
                    }
                }
            } else if ("Cancelled".equals(newStatus)) {
                if (appointmentDAO.cancelAppointment(bookingId)) {
                    session.setAttribute("updateMessage", "Appointment cancelled.");
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/manageAppointments");
    }
}