<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Details | UiTM Admin</title>
    <style>
    /* Base Reset */
    body { 
        background-color: #d3d3d3; 
        font-family: Arial, sans-serif; 
        margin: 0; 
        padding: 0; 
    }

    .container {
        max-width: 1100px;
        margin: 0 auto;
        padding: 20px;
    }

    .main-title { 
        text-align: center; 
        font-weight: bold; 
        text-decoration: underline; 
        margin-top: 30px; 
        font-size: 2.5rem; 
        color: #000; 
    }
    
    .search-container { 
        margin: 20px auto; 
        max-width: 600px; 
        display: flex; 
        align-items: center; 
        justify-content: center;
        font-weight: bold; 
        font-size: 1.1rem; 
        flex-wrap: wrap;
        gap: 10px;
    }

    .search-box { 
        border-radius: 20px; 
        border: 1px solid #bbb; 
        padding: 5px 15px; 
        width: 250px; 
        background: #fff; 
        display: flex; 
        align-items: center; 
    }

    .search-box input { border: none; outline: none; width: 100%; font-size: 1rem; }
    .search-btn { background: none; border: none; cursor: pointer; font-size: 1.1rem; }

    .btn-clear {
        background-color: #f0f0f0;
        color: #333;
        font-weight: bold;
        padding: 6px 15px;
        border-radius: 20px;
        font-size: 0.85rem;
        text-decoration: none;
        border: 1px solid #bbb;
    }

    .student-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); 
        gap: 30px;
        margin-top: 40px;
        padding-bottom: 50px;
        justify-content: center; 
    }

    .student-card {
        background-color: #727272; 
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.4);
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 350px; /* Increased height to accommodate password row */
        max-width: 600px; 
        margin: 0 auto; 
    }

    .info-row { display: flex; margin-bottom: 12px; align-items: flex-start; }
    .label-col { width: 140px; min-width: 140px; color: #000000; font-weight: bold; font-size: 1rem; }
    .colon-col { width: 25px; min-width: 25px; color: #000; font-weight: bold; text-align: center; }
    .value-col { flex: 1; color: #ffffff; font-weight: bold; font-size: 1rem; word-break: break-word; line-height: 1.3; }

    .card-actions { 
        display: flex; 
        flex-direction: column; 
        align-items: center; 
        gap: 12px; 
        margin-top: 25px; 
    }

    .btn-edit { background-color: #00ccff; color: black; font-weight: bold; padding: 8px 0; border-radius: 5px; width: 120px; text-align: center; }
    .btn-delete { background-color: #ff0000; color: white; font-weight: bold; padding: 8px 0; border-radius: 5px; width: 120px; text-align: center; cursor: pointer; }

    a { text-decoration: none; }
    </style>
</head>
<body>

    <jsp:include page="headerAdmin.jsp" />

    <div class="container">
        <h1 class="main-title">Student Details</h1>

        <form action="manageStudent" method="get">
            <div class="search-container">
                <span>Search Student : </span>
                <div class="search-box">
                    <input type="text" name="searchQuery" value="${param.searchQuery}" placeholder="Enter name or ID...">
                    <button type="submit" class="search-btn">🔍</button>
                </div>
                <a href="manageStudent" class="btn-clear">CLEAR</a>
            </div>
        </form>

        <div class="student-grid">
            <c:forEach var="s" items="${studentList}">
                <div class="student-card">
                    <div class="card-content">
                        <div class="info-row">
                            <div class="label-col">Student Name</div>
                            <div class="colon-col">:</div>
                            <div class="value-col"><c:out value="${s.studName}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="label-col">Student ID</div>
                            <div class="colon-col">:</div>
                            <div class="value-col"><c:out value="${s.studentId}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="label-col">Phone Number</div>
                            <div class="colon-col">:</div>
                            <div class="value-col"><c:out value="${s.studPhone}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="label-col">Email</div>
                            <div class="colon-col">:</div>
                            <div class="value-col"><c:out value="${s.studEmail}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="label-col">Address</div>
                            <div class="colon-col">:</div>
                            <div class="value-col"><c:out value="${s.studAddr}"/></div>
                        </div>
                        <%-- NEW ROW: Password shown below Address --%>
                        <div class="info-row">
                            <div class="label-col">Password</div>
                            <div class="colon-col">:</div>
                            <div class="value-col"><c:out value="${s.passwordHash}"/></div>
                        </div>
                    </div>

                    <div class="card-actions">
                        <a href="editStudent?id=${s.studentId}" class="btn-edit">EDIT</a>
                        <a href="deleteStudent?id=${s.studentId}" 
                           class="btn-delete" 
                           onclick="return confirm('Delete student: ${s.studName}?');">
                           DELETE
                        </a>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty studentList}">
                <div style="text-align: center; width: 100%; padding: 50px;">
                    <p>No student records found.</p>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>