package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import com.uitm.studentcounselling.model.Appointment;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Comparator;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CheckStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object role = (session != null) ? session.getAttribute("userRole") : null;
        
        if (role == null || !role.equals(3)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("userId");
        // FIX: Explicitly get the filter parameter
        String filterStatus = request.getParameter("filterStatus");
        
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        
        try {
            List<Appointment> allAppointments = appointmentDAO.selectStudentAllAppointments(studentId); 

            // Sort all by date ascending
            List<Appointment> sortedList = allAppointments.stream()
                .sorted(Comparator.comparing(Appointment::getBookedDate))
                .collect(Collectors.toList());

            // LIST 1: Follow-Up Suggested (Remains unchanged by filter)
            List<Appointment> followUpList = sortedList.stream()
                .filter(a -> "Next Follow-Up".equals(a.getStatus()))
                .collect(Collectors.toList());

            // LIST 2: History (Filtering applied here)
            List<Appointment> historyList = sortedList.stream()
                .filter(a -> !"Next Follow-Up".equals(a.getStatus()))
                .filter(a -> {
                    if (filterStatus == null || filterStatus.isEmpty() || "All".equalsIgnoreCase(filterStatus)) {
                        return true;
                    }
                    // Compare case-insensitive to avoid "Pending" vs "pending" issues
                    return filterStatus.equalsIgnoreCase(a.getStatus());
                })
                .collect(Collectors.toList());

            request.setAttribute("followUps", followUpList);
            request.setAttribute("history", historyList);
            request.setAttribute("currentFilter", filterStatus); 
            
            request.getRequestDispatcher("checkstatus.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error fetching appointments: " + e.getMessage());
            request.getRequestDispatcher("checkstatus.jsp").forward(request, response);
        }
    }
}