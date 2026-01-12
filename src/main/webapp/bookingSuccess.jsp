<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>

<style>
    /* New CSS styles for the success page */
    :root {
        --dark-green-bg: #384238; 
        --teal-header: #80e6c6; 
        --input-white: #ffffff;
        --blue-btn: #4bb3f7; 
        --dark-text: #000000;
        --soft-card-bg: #f0f8ff; /* Light, soft background for the card */
        --success-green: #28a745; /* Standard success color */
        --light-success-bg: #e2f0e3; /* Very light green background */
    }

    .success-container {
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 50px 20px;
        min-height: calc(100vh - 170px); /* Adjust based on your header/footer height */
        background-color: var(--dark-green-bg); /* Use the dark background color */
    }

    .success-card {
        background-color: var(--input-white); /* White card background */
        padding: 40px 60px;
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3); /* Stronger shadow for depth */
        text-align: center;
        max-width: 600px;
        width: 90%;
        border-top: 5px solid var(--success-green); /* Green top border for success hint */
    }

    .success-icon {
        font-size: 4em;
        color: var(--success-green);
        margin-bottom: 15px;
        display: block; /* Ensures it sits on its own line */
    }

    .success-title {
        font-size: 2.2em;
        font-weight: 700;
        color: var(--success-green);
        margin-bottom: 10px;
    }

    .success-message {
        font-size: 1.1em;
        color: #555;
        margin-bottom: 30px;
        line-height: 1.5;
    }

    .status-btn {
        text-decoration: none;
        padding: 12px 25px;
        background-color: var(--blue-btn); /* Use your standard blue button color */
        color: var(--input-white);
        border-radius: 8px;
        font-size: 1.1em;
        font-weight: bold;
        transition: background-color 0.3s ease, transform 0.1s ease;
        display: inline-block;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .status-btn:hover {
        background-color: #3a97d8; /* Slightly darker blue on hover */
        transform: translateY(-1px);
    }
</style>

<div class="success-container">
    <div class="success-card">
        
        <span class="success-icon">✅</span>
        
        <h1 class="success-title">Appointment Booked Successfully!</h1>
        
        <p class="success-message">
            Your request has been successfully recorded in the system. 
            The status of your appointment is currently **Pending** approval by a counselor.
        </p>
        
        <p>
            <a href="checkStatus" class="status-btn">Go To Check Status</a>
        </p>
        
    </div>
</div>

<%@include file="footer.jsp" %>