<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Student | UiTM Admin</title>
    <style>
        body {
            background-color: #e0e0e0;
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 0;
        }
        
        .content-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 30px;
        }

        .container {
            background-color: #e6a5a5; /* Pinkish background */
            padding: 40px;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-top: 20px;
            width: 550px; 
        }

        h1 { font-weight: bold; margin-bottom: 30px; }

        .form-group {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            font-weight: bold;
            font-size: 1.2rem;
        }

        .label-text { width: 180px; }
        .colon { width: 30px; }

        input {
            flex: 1;
            padding: 10px 20px;
            border-radius: 25px;
            border: 1px solid #ccc;
            outline: none;
        }

        .button-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-top: 30px;
            gap: 15px;
        }

        .btn-action {
            width: 200px; 
            padding: 12px 0; 
            border-radius: 10px;
            font-weight: bold;
            font-size: 1rem;
            text-align: center;
            cursor: pointer;
            border: none;
            text-decoration: none;
            display: inline-block;
        }

        .btn-confirm { background-color: #00ccff; color: black; }
        .btn-cancel { background-color: #ff3333; color: black; }
        
    </style>
</head>
<body>

    <jsp:include page="headerAdmin.jsp" />

    <div class="content-wrapper">
        <h1>Edit Student Details</h1>

        <div class="container">
            <form action="editStudent" method="post">
                <div class="form-group">
                    <div class="label-text">Student Name</div>
                    <div class="colon">:</div>
                    <input type="text" name="studentName" value="${student.studName}" required>
                </div>

                <div class="form-group">
                    <div class="label-text">Student ID</div>
                    <div class="colon">:</div>
                    <input type="text" name="studentId" value="${student.studentId}" readonly style="background-color: #eee;">
                </div>

                <div class="form-group">
                    <div class="label-text">Phone Number</div>
                    <div class="colon">:</div>
                    <input type="text" name="studentPhone" value="${student.studPhone}" required>
                </div>

                <div class="form-group">
                    <div class="label-text">Email</div>
                    <div class="colon">:</div>
                    <input type="email" name="studentEmail" value="${student.studEmail}" required>
                </div>
                
                <div class="form-group">
                    <div class="label-text">Address</div>
                    <div class="colon">:</div>
                    <input type="text" name="studentAddr" value="${student.studAddr}" required>
                </div>

                <div class="form-group">
                    <div class="label-text">Password</div>
                    <div class="colon">:</div>
                    <div style="flex: 1; display: flex; flex-direction: column;">
                        <%-- VISIBLE PASSWORD with Regex Pattern --%>
                        <input type="text" 
                               name="studentPass" 
                               value="${student.passwordHash}" 
                               required
                               pattern="^(?=.*[A-Z])(?=.*\d).{8,30}$"
                               title="Must be 8-30 characters, with 1 uppercase and 1 number">
                    </div>
                </div>

                <div class="button-container">
                    <button type="submit" class="btn-action btn-confirm">CONFIRM CHANGES</button>
                    <a href="manageStudent" class="btn-action btn-cancel">CANCEL</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>