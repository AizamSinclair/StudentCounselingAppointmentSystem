package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import com.uitm.studentcounselling.model.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ViewAppointmentDetailsServlet extends HttpServlet {
    
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

        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manageAppointments");
            return;
        }
        
        int bookingId = Integer.parseInt(bookingIdStr);
        Appointment appointment = appointmentDAO.selectAppointmentById(bookingId);

        // Security check: Ensure counselor owns this appointment
        if (appointment == null || !counselorId.trim().equals(appointment.getCounselorId().trim())) {
             response.sendRedirect(request.getContextPath() + "/manageAppointments");
             return;
        }

        // Transfer session messages (success/error) to request attributes for JSP display
        handleSessionMessages(session, request);

        request.setAttribute("appointment", appointment);
        
        // Routing logic based on current status
        String currentStatus = appointment.getStatus();
        String targetJsp = "handleAppointment2.jsp"; // Default view
        
        if (currentStatus != null && currentStatus.startsWith("Pending")) {
            targetJsp = "handleAppointment1.jsp";
        } else if (currentStatus != null && currentStatus.matches("(?i)Next Follow-Up|Accepted|Declined")) {
            targetJsp = "handleAppointment3.jsp";
        }

        request.getRequestDispatcher(targetJsp).forward(request, response);
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
        if (bookingIdStr == null) {
            response.sendRedirect("manageAppointments");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        String remark = request.getParameter("remark");
        String note = request.getParameter("note");

        // route based on whether we are scheduling a new follow-up or updating current status
        if ("scheduleFollowUp".equals(action)) {
            handleFollowUpAction(request, response, session, counselorId, bookingId, remark, note);
        } else {
            handleStandardUpdate(request, response, session, bookingId, remark, note);
        }
    }

    private void handleFollowUpAction(HttpServletRequest request, HttpServletResponse response, HttpSession session, 
                                     String counselorId, int bookingId, String remark, String note) throws IOException {
        
        String nextDate = request.getParameter("nextDate");
        String nextTime = request.getParameter("nextTime");
        
        // Conflict check
        if (appointmentDAO.isSlotTaken(nextDate, nextTime, counselorId, bookingId)) {
            session.setAttribute("errorMessage", "Error: That date and time is already taken.");
            response.sendRedirect("viewAppointmentDetails?bookingId=" + bookingId);
            return;
        }

        // 1. Mark current session as Done
        appointmentDAO.finalizeSessionDetails(bookingId, "Done Session", remark, note, nextDate, nextTime);
        
        // 2. Create the follow-up record
        boolean success = appointmentDAO.createFollowUpAppointment(
            request.getParameter("StudentId"), 
            "Student", 
            counselorId, 
            nextDate, 
            nextTime, 
            "Follow-up: " + request.getParameter("ReasonForAppointment"), 
            request.getParameter("StudentPhoneNumber")
        );

        finalizeResponse(response, session, success, "followUpAppointment", bookingId);
    }

    private void handleStandardUpdate(HttpServletRequest request, HttpServletResponse response, HttpSession session, 
                                     int bookingId, String remark, String note) throws IOException {
        
        // Try all potential parameter names used in your various JSPs
        String finalStatus = request.getParameter("finalStatus");
        if (finalStatus == null) finalStatus = request.getParameter("statusAppointment");
        if (finalStatus == null) finalStatus = request.getParameter("newStatus");

        // CRITICAL: Null safety check to prevent Status 500 error
        if (finalStatus == null) {
            session.setAttribute("errorMessage", "Error: No status selected.");
            response.sendRedirect("viewAppointmentDetails?bookingId=" + bookingId);
            return;
        }

        Appointment current = appointmentDAO.selectAppointmentById(bookingId);
        
        // Update the database
        boolean success = appointmentDAO.finalizeSessionDetails(bookingId, finalStatus, remark, note, 
                                                              current.getBookedDate(), current.getTimeSlot());

        // Determine redirection based on the new status
        String redirectPath = "manageAppointments";
        if (finalStatus.matches("(?i)Done Session|No Show|Cancelled")) {
            redirectPath = "studentRecords";
        }

        finalizeResponse(response, session, success, redirectPath, bookingId);
    }

    private void handleSessionMessages(HttpSession session, HttpServletRequest request) {
        if (session == null) return;
        String[] msgTypes = {"successMessage", "errorMessage"};
        for (String msgType : msgTypes) {
            Object msg = session.getAttribute(msgType);
            if (msg != null) {
                request.setAttribute(msgType, msg);
                session.removeAttribute(msgType);
            }
        }
    }

    private void finalizeResponse(HttpServletResponse response, HttpSession session, boolean success, 
                                 String path, int bookingId) throws IOException {
        if (success) {
            session.setAttribute("successMessage", "Action completed successfully!");
            // Ensure path is clean for redirection
            String cleanPath = path.startsWith("/") ? path.substring(1) : path;
            response.sendRedirect(response.encodeRedirectURL(cleanPath));
        } else {
            session.setAttribute("errorMessage", "Database update failed. Check logs.");
            response.sendRedirect("viewAppointmentDetails?bookingId=" + bookingId);
        }
    }
}