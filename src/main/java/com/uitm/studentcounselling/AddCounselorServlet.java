package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.CounselorDAO;
import com.uitm.studentcounselling.model.Counselor;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AddCounselorServlet extends HttpServlet {

    // Initialize the DAO to handle all database operations
    private CounselorDAO counselorDAO = new CounselorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Capture data from the JSP form (cid, cname, etc.)
        String id = request.getParameter("cid");
        String name = request.getParameter("cname");
        String email = request.getParameter("cemail");
        String phone = request.getParameter("cphone");
        String pass = request.getParameter("cpass");

        // 2. Create a Counselor object (Model) and set its values
        Counselor newCouns = new Counselor();
        newCouns.setCounselorId(id);
        newCouns.setCounsName(name);
        newCouns.setCounsEmail(email);
        newCouns.setCounsPhone(phone);
        newCouns.setCounsPass(pass);

        // 3. Use the DAO [FUNCTION: INSERT NEW COUNSELOR]
        boolean isAdded = counselorDAO.insertCounselor(newCouns);
        
        // 4. If database insert worked, set the session attribute for the success message
        if (isAdded) {
            HttpSession session = request.getSession();
            session.setAttribute("addSuccess", true);
        }

        // 5. Redirect back to the display page
        response.sendRedirect("manageCounselor");
    }
}