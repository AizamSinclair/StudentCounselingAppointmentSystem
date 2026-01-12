package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import com.uitm.studentcounselling.dao.CounselorDAO;
import com.uitm.studentcounselling.dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Calendar;

public class AdminDashboardServlet extends HttpServlet {
    
    // Initialize DAOs
    private CounselorDAO counselorDAO = new CounselorDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);

        // 1. Call DAOs to get the numbers
        int totalCounselor = counselorDAO.getTotalCounselorCount();
        int totalStudent = studentDAO.getTotalStudentCount();
        int totalAppointmentYear = appointmentDAO.getYearlyFinalizedCount(currentYear);
        int totalAllAppointments = appointmentDAO.getAllTimeFinalizedCount();

        // 2. Set attributes for JSP
        request.setAttribute("totalCounselor", totalCounselor);
        request.setAttribute("totalStudent", totalStudent);
        request.setAttribute("totalAppointment", totalAppointmentYear);
        request.setAttribute("totalAllAppointments", totalAllAppointments);
        request.setAttribute("currentYear", currentYear);

        // 3. Forward to the dashboard view
        request.getRequestDispatcher("indexAdmin.jsp").forward(request, response);
    }
}