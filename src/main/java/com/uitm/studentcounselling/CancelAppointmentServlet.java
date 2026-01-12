package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class CancelAppointmentServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    
    private boolean isStudentLoggedIn(HttpSession session) {
        Object role = (session != null) ? session.getAttribute("userRole") : null;
        return role != null && role.equals(3);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        if (!isStudentLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String studentId = (String) session.getAttribute("userId"); 
            
            // Execute deletion logic
            boolean success = appointmentDAO.deleteAppointment(bookingId, studentId);
            
            if (success) {
                // SUCCESS: Redirect back to the list with the success flag
                response.sendRedirect("checkStatus?message=CancelSuccess");
            } else {
                // FAILURE: Redirect back with error flag
                response.sendRedirect("checkStatus?error=CancelFailed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("checkStatus?error=InvalidId");
        } catch (Exception e) {
            log("Error canceling appointment: " + e.getMessage(), e);
            response.sendRedirect("checkStatus?error=SystemError");
        }
    }
}