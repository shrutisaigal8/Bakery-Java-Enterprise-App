<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if order success flag/session attribute exists
    Boolean orderSuccess = (Boolean) session.getAttribute("orderSuccess");
    Integer orderId = (Integer) session.getAttribute("newOrderId");
    if (orderSuccess == null || !orderSuccess) {
        // No order success flagged -> redirect elsewhere, e.g. homepage or cart page
        response.sendRedirect("index.jsp");
        return;
    }

    // Once shown, remove flags so page refresh doesn't show again
    session.removeAttribute("orderSuccess");
    session.removeAttribute("newOrderId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Success</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f0f8ff; padding: 40px; text-align: center; }
        .message { margin-top: 50px; font-size: 24px; color: green; }
        .order-link { margin-top: 20px; display: block; font-size: 18px; }
    </style>
</head>
<body>
    <div class="message">Thank you! Your order has been placed successfully.</div>
    <%
        if (orderId != null) {
    %>
        <div>Your Order ID is: <strong><%= orderId %></strong></div>
    <%
        }
    %>
    <a class="order-link" href="order_history.jsp">View Your Orders</a>
</body>
</html>
