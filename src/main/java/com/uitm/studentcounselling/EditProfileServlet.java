package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.StudentDAO;
import com.uitm.studentcounselling.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class EditProfileServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    
    private boolean isStudentLoggedIn(HttpSession session) {
        Object role = (session != null) ? session.getAttribute("userRole") : null;
        return role != null && role.equals(3);
    }
    
    // --- 1. HANDLE DISPLAY (GET Request) ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // CRITICAL FIX 1: Session and Role validation
        if (!isStudentLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // CRITICAL FIX 2: Use "userId" for the student's ID
        String studentId = (String) session.getAttribute("userId");
        
        String message = request.getParameter("message");
        if ("ProfileUpdateSuccess".equals(message)) {
            request.setAttribute("successMessage", "Profile successfully updated!");
        }

        Student student = studentDAO.selectStudentById(studentId);
        
        if (student != null) {
            request.setAttribute("studentProfile", student);
            request.getRequestDispatcher("editprofile.jsp").forward(request, response);
        } else {
            response.sendRedirect("index.jsp?error=ProfileNotFound"); 
        }
    }
    
    // --- 2. HANDLE SUBMISSION (POST Request) ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // CRITICAL FIX 1: Session and Role validation
        if (!isStudentLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // CRITICAL FIX 2: Use "userId" for the student's ID
        String studentId = (String) session.getAttribute("userId");
        
        String newName = request.getParameter("studentName");
        String newPhone = request.getParameter("studentPhone");
        String newAddress = request.getParameter("studentAddress"); 

        Student updatedStudent = new Student();
        updatedStudent.setStudentId(studentId);
        updatedStudent.setStudName(newName);
        updatedStudent.setStudPhone(newPhone);
        updatedStudent.setStudAddr(newAddress);

        try {
            boolean success = studentDAO.updateStudentProfile(updatedStudent);

            if (success) {
                // CRITICAL FIX 3: Update session variables with the CORRECT names
                session.setAttribute("userName", newName); 
                session.setAttribute("userPhone", newPhone); 
                
                response.sendRedirect("editProfile?message=ProfileUpdateSuccess");
            } else {
                request.setAttribute("error", "Failed to update profile. Please check your inputs.");
                request.setAttribute("studentProfile", updatedStudent); 
                request.getRequestDispatcher("editprofile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            log("Error updating profile: " + e.getMessage(), e);
            request.setAttribute("error", "An unexpected error occurred during profile update.");
            request.setAttribute("studentProfile", updatedStudent);
            request.getRequestDispatcher("editprofile.jsp").forward(request, response);
        }
    }
}