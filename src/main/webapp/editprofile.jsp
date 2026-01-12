<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.uitm.studentcounselling.model.Student"%>
<%@include file="header.jsp" %>

<%
    // Retrieve the Student object from the request scope
    Student student = (Student) request.getAttribute("studentProfile");
    
    // The servlet ensures 'studentProfile' is set correctly, or redirects away.
    if (student == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    String errorMsg = (String) request.getAttribute("error");
    String successMsg = (String) request.getAttribute("successMessage");
%>

<style>
    /* CSS for Edit Profile page, consistent with your previous UI */
    .content-area {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 40px 20px 60px;
        min-height: calc(100vh - 170px); 
        background-color: #f7f7f7; 
        color: #000000;
    }

    .booking-title {
        font-size: 2.5em;
        font-weight: bold;
        color: #384238;
        margin-bottom: 30px;
    }

    .error-message {
        color: #ff3333;
        background-color: #ffe0e0;
        border: 1px solid #ff3333;
        padding: 10px 20px;
        margin-bottom: 20px;
        border-radius: 5px;
        font-weight: bold;
        text-align: center;
    }
    
    .success-message {
        color: #155724;
        background-color: #d4edda;
        border: 1px solid #c3e6cb;
        padding: 10px 20px;
        margin-bottom: 20px;
        border-radius: 5px;
        font-weight: bold;
        text-align: center;
    }


    .booking-form-card {
        background-color: #ccffcc;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        width: 600px; 
        display: flex;
        flex-direction: column;
    }

    .form-row {
        display: flex;
        justify-content: space-between;
        align-items: center; 
        margin-bottom: 15px;
        font-size: 1.1em;
        font-weight: bold;
    }

    .form-row label {
        display: flex; 
        justify-content: flex-end; 
        align-items: center; 
        white-space: nowrap;
        margin-right: 15px;
        width: 250px; 
        height: 38px;
    }

    .form-row input[type="text"],
    .form-row input[type="email"],
    .form-row textarea {
        flex-grow: 1; 
        height: 38px;
        padding: 0 10px; 
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
        font-size: 1em;
    }
    
    .form-row textarea {
        height: 80px; 
        padding-top: 10px;
        resize: vertical;
    }
    
    .form-row input[disabled],
    .form-row input[readonly] {
        background-color: #e9ecef; 
        cursor: not-allowed;
        color: #6c757d;
    }
    
    .button-group {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin-top: 30px;
    }

    .confirm-btn {
        background-color: #4bb3f7;
        color: white;
        border: none;
        padding: 10px 30px;
        border-radius: 5px;
        font-size: 1.1em;
        font-weight: bold;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .confirm-btn:hover {
        background-color: #3a97d8;
    }
    
    .cancel-btn {
        background-color: #ff3333; 
        color: white;
        border: none;
        padding: 10px 30px;
        border-radius: 5px;
        font-size: 1.1em;
        font-weight: bold;
        cursor: pointer;
        transition: background-color 0.3s;
        text-decoration: none; 
        display: inline-block;
        text-align: center;
    }

    .cancel-btn:hover {
        background-color: #cc0000;
    }
</style>
    
    <div class="content-area">
    
    <h1 class="booking-title">Edit Profile Details</h1>
    
    <% 
        // --- START FIX: Show Alert and Redirect ---
        if (successMsg != null) { 
    %>
        <script>
            // Show the success message in an alert box
            alert('<%= successMsg %>');
            // Redirect back to index.jsp 
            window.location.href = 'index.jsp';
        </script>
    <%
            // Stop rendering the rest of the JSP form if successful
            return;
        }
        // --- END FIX ---
    %>
    
    <% if (errorMsg != null) { %>
        <div class="error-message">
            <%= errorMsg %>
        </div>
    <% } %>
    
    <form action="editProfile" method="POST" class="booking-form-card">
        
        <div class="form-row">
            <label for="studentId">Student ID :</label>
            <input type="text" id="studentId" value="<%= student.getStudentId() %>" readonly>
        </div>
        
        <div class="form-row">
            <label for="studentEmail">Student Email :</label>
            <input type="email" id="studentEmail" value="<%= student.getStudEmail() %>" readonly>
        </div>
        
        <div class="form-row">
            <label for="studentName">Student Name :</label>
            <input type="text" id="studentName" name="studentName" 
                     value="<%= student.getStudName() %>" required>
        </div>
        
        <div class="form-row">
            <label for="studentPhone">Student Phone Number :</label>
            <input type="text" id="studentPhone" name="studentPhone" 
                     value="<%= student.getStudPhone() %>" 
                     pattern="[0-9]{10,12}" title="Must be a valid phone number (10-12 digits)" required>
        </div>
        
        <div class="form-row">
            <label for="studentAddress">Student Address :</label>
            <textarea id="studentAddress" name="studentAddress" required><%= student.getStudAddr() != null ? student.getStudAddr() : "" %></textarea>
        </div>
        
        <div class="button-group">
            <button type="submit" class="confirm-btn">CONFIRM EDIT</button>
            <a href="index.jsp" class="cancel-btn">CANCEL</a>
        </div>
        
    </form>
    
</div>

<%@include file="footer.jsp" %>