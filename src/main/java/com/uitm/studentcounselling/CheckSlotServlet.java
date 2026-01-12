package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class CheckSlotServlet extends HttpServlet {
    
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String counselorId = request.getParameter("counselorid"); 
        
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        // Validation logic stays in the Servlet
        if (date == null || time == null || counselorId == null || 
            date.isEmpty() || time.isEmpty() || counselorId.isEmpty()) {
            out.print("WAITING");
            return;
        }

        try {
            // Call the DAO instead of writing SQL here
            boolean available = appointmentDAO.isSlotAvailable(counselorId, date, time);
            
            if (available) {
                out.print("AVAILABLE");
            } else {
                out.print("TAKEN");
            }
        } catch (Exception e) {
            out.print("ERROR");
        }
    }
}