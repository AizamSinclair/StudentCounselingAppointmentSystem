package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import java.io.IOException;
import java.util.Calendar;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AppointmentReportServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Determine the year to report on
        int systemYear = Calendar.getInstance().get(Calendar.YEAR);
        String yearParam = request.getParameter("year");
        
        int selectedYear;
        try {
            selectedYear = (yearParam == null || yearParam.isEmpty()) 
                           ? systemYear 
                           : Integer.parseInt(yearParam);
        } catch (NumberFormatException e) {
            selectedYear = systemYear;
        }

        // 2. Fetch the data from the DAO
        int[] monthlyCounts = appointmentDAO.getMonthlyAppointmentCounts(selectedYear);

        // 3. Send data to JSP
        request.setAttribute("year", String.valueOf(selectedYear));
        request.setAttribute("counts", monthlyCounts);
        
        request.getRequestDispatcher("appointmentReport.jsp").forward(request, response);
    }
}