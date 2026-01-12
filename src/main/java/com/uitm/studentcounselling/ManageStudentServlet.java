package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.StudentDAO;
import com.uitm.studentcounselling.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ManageStudentServlet extends HttpServlet {
    
    private final StudentDAO studentDAO = new StudentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get the search query from the request
        String searchQuery = request.getParameter("searchQuery");
        
        // 2. Use the DAO to fetch the data (it handles the search logic internally)
        List<Student> studentList = studentDAO.selectAllStudents(searchQuery);

        // 3. Set the attribute for the JSP
        request.setAttribute("studentList", studentList);
        
        // 4. Forward to the JSP page
        request.getRequestDispatcher("manageStudent.jsp").forward(request, response);
    }
}