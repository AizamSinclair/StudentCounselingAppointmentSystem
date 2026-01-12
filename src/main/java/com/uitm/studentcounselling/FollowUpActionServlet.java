package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import com.uitm.studentcounselling.model.Appointment;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class FollowUpActionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Security Check
        HttpSession session = request.getSession(false);
        Object userRole = (session != null) ? session.getAttribute("userRole") : null;

        if (userRole == null || !userRole.equals(3)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String bookingIdStr = request.getParameter("bookingId");
        String action = request.getParameter("action"); 

        if (bookingIdStr != null && action != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                AppointmentDAO dao = new AppointmentDAO();
                
                // Fetch current details to get Date, Time, and CounselorID for validation
                Appointment appt = dao.selectAppointmentById(bookingId);
                
                if (appt == null) {
                    response.sendRedirect("checkStatus?error=NotFound");
                    return;
                }

                String statusUpdate = "";
                String redirectMsg = "";

                if ("confirm".equalsIgnoreCase(action)) {
                    // Check if slot is taken by an ACTIVE appointment
                    // This uses the updated DAO logic that ignores Done/No Show/Cancelled
                    boolean isConflict = dao.isSlotTaken(appt.getBookedDate(), appt.getTimeSlot(), appt.getCounselorId(), bookingId);
                    
                    if (isConflict) {
                        response.sendRedirect("checkStatus?error=SlotNoLongerAvailable");
                        return;
                    }

                    statusUpdate = "Accepted"; 
                    redirectMsg = "FollowUpConfirmed";
                    
                } else if ("cancel".equalsIgnoreCase(action)) {
                    statusUpdate = "Declined";
                    redirectMsg = "FollowUpDeclined";
                }

                // Update the Database (Using your existing method name updateAppointmentStatus)
                boolean success = dao.updateAppointmentStatus(bookingId, statusUpdate);

                if (success) {
                    response.sendRedirect("checkStatus?message=" + redirectMsg);
                } else {
                    response.sendRedirect("checkStatus?error=FollowUpActionFailed");
                }

            } catch (NumberFormatException e) {
                response.sendRedirect("checkStatus?error=InvalidID");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("checkStatus?error=FollowUpActionFailed");
            }
        } else {
            response.sendRedirect("checkStatus");
        }
    }
}