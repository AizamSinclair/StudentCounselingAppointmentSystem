package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.StudentDAO;
import com.uitm.studentcounselling.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

public class EditStudentServlet extends HttpServlet {
    
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("id");
        Student student = studentDAO.selectStudentById(studentId);

        if (student != null) {
            request.setAttribute("student", student);
            request.getRequestDispatcher("editStudent.jsp").forward(request, response);
        } else {
            response.sendRedirect("manageStudent?error=NotFound");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Capture parameters from form
        String id = request.getParameter("studentId");
        String name = request.getParameter("studentName");
        String phone = request.getParameter("studentPhone");
        String email = request.getParameter("studentEmail");
        String password = request.getParameter("studentPass");
        String address = request.getParameter("studentAddr");

        // VALIDATION: 8-30 chars, 1 Uppercase, 1 Number
        String passwordRegex = "^(?=.*[A-Z])(?=.*\\d).{8,30}$";
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        if (password == null || !password.matches(passwordRegex)) {
            out.println("<script type=\"text/javascript\">");
            out.println("alert('Password must be 8-30 characters long and include at least one uppercase letter and one number.');");
            out.println("history.back();"); // Sends user back to the form
            out.println("</script>");
            return;
        }

        // Map data to Student object
        Student s = new Student();
        s.setStudentId(id);
        s.setStudName(name);
        s.setStudPhone(phone);
        s.setStudEmail(email);
        s.setPasswordHash(password);
        s.setStudAddr(address);

        // Execute update via DAO
        boolean isUpdated = studentDAO.updateStudent(s);

        if (isUpdated) {
            out.println("<script type=\"text/javascript\">");
            out.println("alert('Update Successful!');");
            out.println("location='manageStudent';"); 
            out.println("</script>");
        } else {
            response.sendRedirect("manageStudent?error=UpdateFailed");
        }
    }
}