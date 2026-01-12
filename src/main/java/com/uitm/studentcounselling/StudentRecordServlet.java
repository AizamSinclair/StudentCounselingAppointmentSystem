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

public class StudentRecordServlet extends HttpServlet {
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

        String searchStudentId = request.getParameter("searchStudentId");
        String statusFilter = request.getParameter("statusFilter") != null ? request.getParameter("statusFilter") : "";
        String filterDate = request.getParameter("filterDate");

        try {
            // Fetch records from DAO
            List<Appointment> allRecords = appointmentDAO.getAppointmentsForCounselorByStatusAndSearch(
                statusFilter, counselorId, searchStudentId);
            
            // Apply Date Filter logic
            if (filterDate != null && !filterDate.isEmpty()) {
                allRecords = allRecords.stream()
                    .filter(a -> a.getBookedDate() != null && String.valueOf(a.getBookedDate()).equals(filterDate))
                    .collect(Collectors.toList());
            }

            // SORTING: Ascending Order (Earliest Date First)
            List<Appointment> sortedRecords = allRecords.stream()
                .sorted(Comparator.comparing(Appointment::getBookedDate))
                .collect(Collectors.toList());
            
            request.setAttribute("appointmentRecords", sortedRecords);
            request.setAttribute("searchStudentId", searchStudentId);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("filterDate", filterDate);
            
            request.getRequestDispatcher("studentRecord.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}