package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class CounselorDashboardServlet extends HttpServlet {
    
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // CHECK: Authentication validation
        if (session == null || session.getAttribute("counselorId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String counselorID = (String) session.getAttribute("counselorId"); 

        try {
            // 1. Pending: Using existing DAO method
            int pending = appointmentDAO.getAppointmentCountByStatus("Pending", counselorID);
            
            // 2. Follow-Up: We use the specialized follow-up count logic
            int followUp = appointmentDAO.getFollowUpCount(counselorID);
            
            // 3. History: Using existing DAO method
            int history = appointmentDAO.getHistoricalAppointmentCount(counselorID);
            
            // Set attributes for the JSP
            request.setAttribute("pendingCount", pending);
            request.setAttribute("followUpCount", followUp);
            request.setAttribute("historyCount", history);
            
            request.getRequestDispatcher("indexCouns.jsp").forward(request, response);
            
        } catch (Exception e) {
            log("Error in CounselorDashboard: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}