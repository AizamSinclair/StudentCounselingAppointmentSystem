package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.CounselorDAO;
import com.uitm.studentcounselling.model.Counselor;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ManageCounselorServlet extends HttpServlet {
    
    private final CounselorDAO counselorDAO = new CounselorDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Use the DAO method instead of raw JDBC
        List<Counselor> counselorList = counselorDAO.selectAllCounselors();
        
        // Debug: Check console to verify list is populated
        if (counselorList != null) {
            for (Counselor c : counselorList) {
                System.out.println("Found Counselor: " + c.getCounsName());
            }
        }

        // 2. Set the attribute for the JSP (Key name "counselorList" remains the same)
        request.setAttribute("counselorList", counselorList);
        
        // 3. Forward to the JSP page exactly as before
        request.getRequestDispatcher("manageCounselor.jsp").forward(request, response);
    }
}