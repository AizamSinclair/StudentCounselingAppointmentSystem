package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import com.uitm.studentcounselling.dao.CounselorDAO;
import com.uitm.studentcounselling.model.Appointment;
import com.uitm.studentcounselling.model.Counselor;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/BookAppointmentServlet")
public class BookAppointmentServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final CounselorDAO counselorDAO = new CounselorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fetch counselors to populate the dropdown in the JSP
        List<Counselor> counselorList = counselorDAO.selectAllCounselors();
        request.setAttribute("counselors", counselorList);
        request.getRequestDispatcher("bookappointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        // Security: Ensure user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Retrieve parameters from the form
        String studentId = (String) session.getAttribute("userId");
        String studentName = (String) session.getAttribute("userName");
        String studentPhone = request.getParameter("studentPhone");
        String apptDateStr = request.getParameter("appointmentDate");
        String apptTime = request.getParameter("appointmentTime");
        String apptReason = request.getParameter("reason");
        
        // CONSISTENT: matches <select name="counselorid"> in your JSP
        String counselorId = request.getParameter("counselorid"); 

        try {
            // 2. Final server-side availability check
            boolean isAvailable = appointmentDAO.isSlotAvailable(counselorId, apptDateStr, apptTime);

            if (!isAvailable) {
                request.setAttribute("error", "Sorry, that slot was just taken by someone else!");
                doGet(request, response); // Reload form with counselors list
                return;
            }

            // 3. Map form data to Appointment object
            Appointment appt = new Appointment();
            appt.setStudentId(studentId);
            appt.setStudentName(studentName); 
            appt.setStudentPhone(studentPhone);
            appt.setCounselorId(counselorId);
            appt.setBookedDate(apptDateStr);
            appt.setTimeSlot(apptTime);
            appt.setReason(apptReason);

            // 4. Save to database
            boolean success = appointmentDAO.insertAppointment(appt);

            if (success) {
                // REDIRECT to success JSP to avoid "Access Denied" from Filter
                response.sendRedirect("bookingSuccess.jsp"); 
            } else {
                // REDIRECT to error JSP or reload with message
                request.setAttribute("error", "Database error: Could not save your booking.");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System Error: " + e.getMessage());
            doGet(request, response);
        }
    }
}