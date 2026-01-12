package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AppointmentDAO;
import com.uitm.studentcounselling.dao.CounselorDAO;
import com.uitm.studentcounselling.model.Appointment;
import com.uitm.studentcounselling.model.Counselor;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class EditAppointmentServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final CounselorDAO counselorDAO = new CounselorDAO();

    private boolean isStudentLoggedIn(HttpSession session) {
        Object role = (session != null) ? session.getAttribute("userRole") : null;
        return role != null && role.equals(3);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String studentId = (session != null) ? (String) session.getAttribute("userId") : null;

        if (!isStudentLoggedIn(session) || studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            Appointment appointmentToEdit = appointmentDAO.selectAppointmentById(bookingId);

            if (appointmentToEdit != null) {
                if (!appointmentToEdit.getStudentId().trim().equals(studentId.trim())) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized access.");
                    return;
                }

                List<Counselor> counselorList = counselorDAO.selectAllCounselors();
                request.setAttribute("counselors", counselorList);
                request.setAttribute("appointment", appointmentToEdit);
                request.getRequestDispatcher("editstudentappointment.jsp").forward(request, response);
            } else {
                response.sendRedirect("checkStatus?error=NotFound");
            }
        } catch (Exception e) {
            response.sendRedirect("checkStatus?error=InvalidID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String studentId = (session != null) ? (String) session.getAttribute("userId") : null;

        if (!isStudentLoggedIn(session) || studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String newApptDate = request.getParameter("appointmentDate");
            String newApptTime = request.getParameter("appointmentTime");
            String newCounselorId = request.getParameter("counselorid");
            String newReason = request.getParameter("reason");
            String studentPhone = request.getParameter("studentPhone");

            if (appointmentDAO.isSlotTaken(newApptDate, newApptTime, newCounselorId, bookingId)) {
                request.setAttribute("error", "This slot is already taken by another student.");
                doGet(request, response);
                return;
            }

            Appointment updated = new Appointment();
            updated.setBookingId(bookingId);
            updated.setStudentId(studentId);
            updated.setBookedDate(newApptDate);
            updated.setTimeSlot(newApptTime);
            updated.setCounselorId(newCounselorId);
            updated.setReason(newReason);
            updated.setStudentPhone(studentPhone);

            // EXECUTE UPDATE
            if (appointmentDAO.updateAppointment(updated)) {
                // SUCCESS ALERT BOX LOGIC
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Appointment details updated successfully!');");
                out.println("location='checkStatus';"); // Redirect back to status list
                out.println("</script>");
            } else {
                request.setAttribute("error", "The appointment can only be edited while it is 'Pending'.");
                doGet(request, response);
            }
        } catch (Exception e) {
            log("Update error: " + e.getMessage());
            request.setAttribute("error", "Error processing request.");
            doGet(request, response);
        }
    }
}