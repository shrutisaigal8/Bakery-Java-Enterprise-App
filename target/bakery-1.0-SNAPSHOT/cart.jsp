<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Cart - Sweet Delights Bakery</title>
    <link href="https://fonts.googleapis.com/css2?family=Georgia&display=swap" rel="stylesheet">
    <style>
        body { font-family:'Georgia', serif; margin:0; padding:0; background:#ffe6f0; color:#b8860b; }
        header { background:#fff; color:#b8860b; padding:20px 40px; text-align:center; box-shadow:0 4px 10px rgba(0,0,0,0.1); }
        header h1 { margin:0; font-size:2.5em; }

        .cart-container { max-width:900px; margin:50px auto; background:#fff; padding:30px; border-radius:20px; box-shadow:0 8px 20px rgba(0,0,0,0.1); }
        table { width:100%; border-collapse:collapse; margin-bottom:20px; }
        th, td { padding:12px; border-bottom:1px solid #ddd; text-align:center; }
        th { background:#ffe6f0; color:#b8860b; font-size:1.1em; }
        td { font-size:1em; }
        .total-row td { font-weight:bold; font-size:1.2em; border-top:2px solid #b8860b; }

        .btn { padding:12px 20px; border:none; border-radius:10px; font-weight:bold; cursor:pointer; transition:0.3s; }
        .btn-checkout { background:#b8860b; color:#fff; margin-right:10px; }
        .btn-checkout:hover { background:#ff69b4; }
        .btn-reset { background:#ff4444; color:#fff; }
        .btn-reset:hover { background:#cc0000; }

        .actions { text-align:right; margin-top:20px; }
        .empty { text-align:center; font-size:1.2em; color:#ff4444; margin-top:20px; }

        footer { background:#fff; color:#b8860b; text-align:center; padding:30px 20px; margin-top:50px; box-shadow:0 -4px 10px rgba(0,0,0,0.05); }
        footer p { margin:5px 0; }
        footer a { color:#b8860b; font-weight:bold; }
        footer a:hover { color:#ff69b4; }
    </style>
</head>
<body>
<header>
    <h1>Sweet Delights Bakery</h1>
</header>

<div class="cart-container">
    <h2>Your Shopping Cart</h2>
    <%
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        double total = 0.0;

        // Handle Reset Cart
        if ("reset".equals(request.getParameter("action"))) {
            session.removeAttribute("cart");
            cart = null;
        }

        if (cart != null && !cart.isEmpty()) {
    %>
    <form method="post" action="checkout.jsp">
        <table>
            <tr>
                <th>Item</th>
                <th>Quantity</th>
                <th>Price (₹)</th>
                <th>Subtotal (₹)</th>
            </tr>
            <%
                for (Map<String, Object> item : cart) {
                    String name = (String) item.get("name");
                    int qty = (Integer) item.get("qty");
                    double price = (Double) item.get("price");
                    double subtotal = qty * price;
                    total += subtotal;
            %>
            <tr>
                <td><%= name %></td>
                <td><%= qty %></td>
                <td><%= String.format("%.2f", price) %></td>
                <td><%= String.format("%.2f", subtotal) %></td>
            </tr>
            <% } %>
            <tr class="total-row">
                <td colspan="3" align="right">Total:</td>
                <td>₹<%= String.format("%.2f", total) %></td>
            </tr>
        </table>

        <div class="actions">
            <button type="submit" class="btn btn-checkout">Proceed to Checkout</button>
            <a href="cart.jsp?action=reset" class="btn btn-reset">Reset Cart</a>
        </div>
    </form>
    <%
        } else {
    %>
        <p class="empty">Your cart is empty! 🛒</p>
        <div class="actions">
            <a href="products.jsp" class="btn btn-checkout">Browse Products</a>
        </div>
    <%
        }
    %>
</div>

<footer>
    <p>Contact us: <a href="mailto:info@sweetdelights.com">info@sweetdelights.com</a> | Phone: +91-9876543210</p>
    <p>Address: 123, Bakery Street, Mumbai, India</p>
    <p>&copy; 2025 Sweet Delights Bakery. All rights reserved.</p>
</footer>
</body>
</html>
