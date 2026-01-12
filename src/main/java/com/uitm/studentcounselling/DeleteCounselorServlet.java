package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.CounselorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class DeleteCounselorServlet extends HttpServlet {

    private CounselorDAO counselorDAO;

    @Override
    public void init() {
        counselorDAO = new CounselorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        
        if (id != null && !id.isEmpty()) {
            boolean isDeleted = counselorDAO.deleteCounselor(id);
            
            if (isDeleted) {
                HttpSession session = request.getSession();
                session.setAttribute("deleteSuccess", true);
            }
        }
        
        // Redirect back to the management list
        response.sendRedirect("manageCounselor");
    }
}