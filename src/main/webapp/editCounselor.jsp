<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Counselor | Uitm Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #e0e0e0; font-family: Arial, sans-serif; margin: 0; }
        
        .main-content {
            padding-top: 50px; 
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .edit-container {
            background: #d18297; /* Pink theme */
            padding: 40px;
            width: 500px;
            margin-top: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        h2 { text-align: center; font-weight: bold; margin-bottom: 30px; }
        .info-row { display: flex; margin-bottom: 15px; align-items: start; }
        .info-label { width: 150px; font-weight: bold; color: #000; padding-top: 5px; }
        .info-colon { width: 20px; font-weight: bold; padding-top: 5px; }
        
        .input-group-container {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .input-box {
            width: 100%;
            border-radius: 15px;
            border: none;
            padding: 5px 15px;
            background: #f0f0f0;
            outline: none;
        }

        .btn-action {
            width: 180px;
            padding: 10px 0;
            border-radius: 10px;
            font-weight: bold;
            border: none;
            text-decoration: none;
            display: inline-block;
            margin: 5px 0;
            font-size: 1rem;
            text-align: center;
        }
        
        .button-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-top: 30px;
            gap: 15px;
        }

        .btn-confirm { background-color: #00ccff; color: black; }
        .btn-cancel { background-color: #ff4d4d; color: black; line-height: 1.5; }
        
    </style>
</head>
<body>

    <jsp:include page="headerAdmin.jsp" />

    <div class="main-content">
        <h2>Edit Counselor Details</h2>
        
        <div class="edit-container">
            <form action="EditCounselorServlet" method="POST">
                <div class="info-row">
                    <div class="info-label">Counselor Name</div>
                    <div class="info-colon">:</div>
                    <div class="input-group-container">
                        <input type="text" name="cname" class="input-box" value="${counselor.counsName}" required>
                    </div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Staff ID</div>
                    <div class="info-colon">:</div>
                    <div class="input-group-container">
                        <input type="text" name="cid" class="input-box" value="${counselor.counselorId}" readonly style="background: #ccc;">
                    </div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Phone Number</div>
                    <div class="info-colon">:</div>
                    <div class="input-group-container">
                        <input type="text" name="cphone" class="input-box" value="${counselor.counsPhone}" required>
                    </div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Email</div>
                    <div class="info-colon">:</div>
                    <div class="input-group-container">
                        <input type="email" name="cemail" class="input-box" value="${counselor.counsEmail}" required>
                    </div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Password</div>
                    <div class="info-colon">:</div>
                    <div class="input-group-container">
                        <input type="text" 
                               name="cpass" 
                               class="input-box" 
                               value="${counselor.counsPass}" 
                               required
                               pattern="^(?=.*[A-Z])(?=.*\d).{8,30}$"
                               title="Must be 8-30 characters, including 1 uppercase letter and 1 number">
                    </div>
                </div>

                <div class="button-container">
                    <button type="submit" class="btn-action btn-confirm">CONFIRM CHANGES</button>
                    <a href="manageCounselor" class="btn-action btn-cancel">CANCEL</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>