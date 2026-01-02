<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Invalidate session safely
    if (session != null) {
        session.invalidate();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout - Sweet Delights Bakery</title>
    <link href="https://fonts.googleapis.com/css2?family=Georgia:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Georgia', serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: #ffe6f0;
            color: #b8860b;
            flex-direction: column;
        }
        .logout-container {
            background: #fff;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            text-align: center;
            animation: fadeIn 1s ease-in-out;
        }
        h1 {
            margin-bottom: 20px;
        }
        p {
            font-size: 1.1em;
            margin-bottom: 10px;
        }
        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(-20px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
    <!-- ✅ Auto redirect after 3 seconds -->
    <meta http-equiv="refresh" content="3;url=login.jsp">
    <script>
        let countdown = 3;
        function updateCountdown() {
            if(countdown > 0){
                document.getElementById("count").innerText = countdown;
                countdown--;
                setTimeout(updateCountdown, 1000);
            }
        }
        window.onload = updateCountdown;
    </script>
</head>
<body>
    <div class="logout-container">
        <h1>Logging out...</h1>
        <p>You will be redirected to the login page in <span id="count">3</span> seconds.</p>
        <p>Thank you for visiting <b>Sweet Delights Bakery!</b></p>
    </div>
</body>
</html>
