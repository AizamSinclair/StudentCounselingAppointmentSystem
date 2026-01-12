package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.CounselorDAO;
import com.uitm.studentcounselling.model.Counselor;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class EditCounselorServlet extends HttpServlet {

    private final CounselorDAO counselorDAO = new CounselorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        Counselor counselor = counselorDAO.selectCounselorById(id);

        if (counselor != null) {
            request.setAttribute("counselor", counselor); 
            request.getRequestDispatcher("editCounselor.jsp").forward(request, response);
        } else {
            response.sendRedirect("manageCounselor?error=NotFound");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from the form
        String id = request.getParameter("cid");
        String name = request.getParameter("cname");
        String email = request.getParameter("cemail");
        String phone = request.getParameter("cphone");
        String cpass = request.getParameter("cpass");

        // BACK-END VALIDATION: 1 Uppercase, 1 Number, 8-30 length
        String passwordRegex = "^(?=.*[A-Z])(?=.*\\d).{8,30}$";
        if (cpass == null || !cpass.matches(passwordRegex)) {
            // If the password doesn't meet requirements, send back to form with error
            response.sendRedirect("EditCounselorServlet?id=" + id + "&status=invalidPassword");
            return;
        }

        // Map data to the Counselor Model object
        Counselor updatedCounselor = new Counselor();
        updatedCounselor.setCounselorId(id);
        updatedCounselor.setCounsName(name);
        updatedCounselor.setCounsEmail(email);
        updatedCounselor.setCounsPhone(phone);
        updatedCounselor.setCounsPass(cpass);

        // Execute update via DAO
        boolean isUpdated = counselorDAO.updateCounselor(updatedCounselor);

        if (isUpdated) {
            HttpSession session = request.getSession();
            session.setAttribute("editSuccess", true);
            response.sendRedirect("manageCounselor");
        } else {
            response.sendRedirect("manageCounselor?status=fail");
        }
    }
}