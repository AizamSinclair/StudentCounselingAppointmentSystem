package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class DeleteStudentServlet extends HttpServlet {
    
    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("id");
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            boolean isDeleted = studentDAO.deleteStudent(studentId);

            out.println("<script type=\"text/javascript\">");
            if (isDeleted) {
                out.println("alert('Student deleted successfully!');");
            } else {
                out.println("alert('Student not found or could not be deleted.');");
            }
            out.println("location='manageStudent';");
            out.println("</script>");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script type=\"text/javascript\">");
            out.println("alert('Error: Could not delete student record (Constraint violation).');");
            out.println("location='manageStudent';");
            out.println("</script>");
        }
    }
}