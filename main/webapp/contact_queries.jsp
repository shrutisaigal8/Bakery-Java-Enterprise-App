<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.bakery.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Us - Sweet Delights</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff8f0;
            padding: 50px;
            color: #333;
        }
        h2 {
            color: #b8860b;
            text-align: center;
        }
        form {
            max-width: 500px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            margin-top: 20px;
            padding: 12px;
            width: 100%;
            background-color: #b8860b;
            color: white;
            border: none;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #ff69b4;
        }
        .thank-you {
            max-width: 500px;
            margin: 100px auto;
            background: #fff;
            padding: 30px;
            text-align: center;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            color: #4CAF50;
            font-size: 1.3em;
        }
    </style>
</head>
<body>

<%
    boolean submitted = false;

    if("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        Connection conn = DBConnection.getConnection();
        if(conn != null){
            try {
                String sql = "INSERT INTO contact_queries (name, email, message, created_at) VALUES (?, ?, ?, NOW())";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, message);
                int rows = ps.executeUpdate();
                ps.close();

                if(rows > 0){
                    submitted = true;
                }

            } catch(Exception e){
                out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p style='color:red; text-align:center;'>Database connection not available!</p>");
        }
    }

    if(submitted){
%>
    <!-- ✅ Thank You message -->
    <div class="thank-you">
        <p>🎉 Thank you for contacting us! We’ll get back to you shortly.</p>
        <p>Redirecting to homepage in 3 seconds...</p>
    </div>

    <!-- ✅ Auto redirect using JavaScript -->
    <script>
        setTimeout(function(){
            window.location.href = "index.jsp";
        }, 3000);
    </script>
<%
    } else {
%>

<h2>Contact Us</h2>
<form method="post" action="">
    <input type="text" name="name" placeholder="Your Name" required>
    <input type="email" name="email" placeholder="Your Email" required>
    <textarea name="message" placeholder="Your Message" rows="5" required></textarea>
    <button type="submit">Send Message</button>
</form>

<%
    }
%>

</body>
</html>
