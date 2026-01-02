<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("name");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
    double totalAmount = 0;

    if (cart != null && !cart.isEmpty()) {
        for (Map<String, Object> item : cart) {
            double price = (Double) item.get("price");
            totalAmount += price;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Sweet Delights Bakery</title>
    <style>
        body {
            font-family: 'Georgia', serif;
            background: #ffe6f0;
            color: #b8860b;
            padding: 40px;
        }
        .container {
            display: flex;
            gap: 40px;
            max-width: 1200px;
            margin: auto;
            flex-wrap: wrap;
        }
        .card, .form {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
            padding: 30px;
            flex: 1 1 45%;
        }
        h2, h3 {
            color: #e63946;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
        }
        input, select {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border-radius: 8px;
            border: 1px solid #ccc;
        }
        .payment-methods label {
            display: block;
            margin: 10px 0;
        }
        .card-details {
            display: none;
        }
        button {
            background-color: #b8860b;
            color: #fff;
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
        }
        button:hover {
            background-color: #ff69b4;
        }
    </style>

    <script>
        function toggleCardFields() {
            const method = document.querySelector('input[name="payment_method"]:checked').value;
            const cardFields = document.getElementById("card-fields");
            if (method === "Credit/Debit Card") {
                cardFields.style.display = "block";
            } else {
                cardFields.style.display = "none";
            }
        }
    </script>
</head>
<body>

<h1>Checkout - Sweet Delights Bakery</h1>

<div class="container">
    <!-- Order Summary -->
    <div class="card">
        <h2>Order Summary</h2>
        <table>
            <tr>
                <th>Product</th>
                <th>Price</th>
            </tr>
            <%
                if (cart != null && !cart.isEmpty()) {
                    for (Map<String, Object> item : cart) {
                        String name = (String) item.get("name");
                        double price = (Double) item.get("price");
            %>
            <tr>
                <td><%= name %></td>
                <td>₹<%= price %></td>
            </tr>
            <%
                    }
            %>
            <tr>
                <td><strong>Total</strong></td>
                <td><strong>₹<%= totalAmount %></strong></td>
            </tr>
            <%
                } else {
            %>
            <tr>
                <td colspan="2">Your cart is empty.</td>
            </tr>
            <% } %>
        </table>
    </div>

    <!-- Payment Form -->
    <div class="form">
        <h3>Payment Method</h3>
        <form method="post" action="order_success.jsp">
            <div class="payment-methods" onchange="toggleCardFields()">
                <label><input type="radio" name="payment_method" value="Cash on Delivery" required> Cash on Delivery</label>
                <label><input type="radio" name="payment_method" value="UPI"> UPI</label>
                <label><input type="radio" name="payment_method" value="Credit/Debit Card"> Credit/Debit Card</label>
            </div>

            <!-- Card Details Section (Initially Hidden) -->
            <div id="card-fields" class="card-details">
                <h4>Card Information</h4>
                <input type="text" name="card_number" placeholder="Card Number" maxlength="16">
                <input type="text" name="card_expiry" placeholder="Expiry (MM/YY)">
                <input type="password" name="card_cvv" placeholder="CVV" maxlength="4">
            </div>

            <input type="hidden" name="amount" value="<%= totalAmount %>">

            <button type="submit">Place Order</button>
        </form>
    </div>
</div>

</body>
</html>
