<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.bakery.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Ensure user is logged in
    Integer userId = (Integer) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("name");
    if(userId == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Check if order was successful (flag set from place_order.jsp)
    Boolean orderSuccess = (Boolean) session.getAttribute("orderSuccess");
    if(orderSuccess != null && orderSuccess) {
        session.removeAttribute("orderSuccess");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Sweet Delights Bakery</title>
    <link href="https://fonts.googleapis.com/css2?family=Georgia&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Georgia', serif; margin:0; padding:0; background:#ffe6f0; color:#b8860b; }
        a { text-decoration:none; transition:0.3s; }
        a:hover { color:#ff69b4; }
        header { background:#fff; color:#b8860b; padding:20px 40px; text-align:center; box-shadow:0 4px 10px rgba(0,0,0,0.1); }
        nav { text-align:right; padding:10px 40px; background:#ffe6f0; }
        nav a { margin-left:15px; font-weight:bold; color:#b8860b; }

        .checkout-section { display:flex; flex-wrap:wrap; gap:40px; max-width:1200px; margin:50px auto; padding:20px; justify-content:center; }
        .order-summary, .shipping-payment-form { background:#fff; border-radius:20px; box-shadow:0 8px 20px rgba(0,0,0,0.05); padding:30px; flex:1 1 45%; }

        .order-summary h2, .shipping-payment-form h3 { color:#e63946; margin-bottom:20px; }
        .order-summary table { width:100%; border-collapse:collapse; }
        .order-summary th, .order-summary td { border:1px solid #ccc; padding:10px; text-align:left; }

        .shipping-payment-form input, .shipping-payment-form select, .shipping-payment-form button, .shipping-payment-form textarea {
            width:100%; padding:12px; margin:10px 0; border-radius:10px; border:1px solid #ccc; font-size:15px; box-sizing: border-box;
        }
        .shipping-payment-form textarea { resize: vertical; }
        .shipping-payment-form input:focus, .shipping-payment-form select:focus, .shipping-payment-form textarea:focus {
            border-color: #ff69b4; outline: none; box-shadow: 0 0 5px rgba(255,105,180,0.4);
        }
        .shipping-payment-form button { background-color:#b8860b; color:#fff; border:none; font-weight:bold; cursor:pointer; transition:0.3s; }
        .shipping-payment-form button:hover { background:#ff69b4; }

        .payment-methods { margin:15px 0; }
        .payment-methods label { display:block; margin:8px 0; font-size:15px; cursor:pointer; }
        .payment-methods input[type="radio"] { margin-right:10px; }

        #cardDetails, #upiDetails { display: none; margin-top:20px; border:1px solid #ccc; padding:20px; border-radius:10px; background: #fafafa; }

        @media(max-width:768px){ .checkout-section{flex-direction:column;} }
    </style>
</head>
<body>

    <header>
        <h1>Sweet Delights Bakery</h1>
    </header>

    <nav>
        Welcome, <%= userName %> | 
        <a href="cart.jsp">Cart</a> | 
        <a href="order_history.jsp">My Orders</a> | 
        <a href="logout.jsp">Logout</a>
    </nav>

    <% if(orderSuccess != null && orderSuccess) { %>
        <div style="background:#e0ffe0; padding:20px; border:2px solid #b8860b; border-radius:10px; margin:20px auto; max-width:600px; text-align:center;">
            <h2>Thank you, <strong><%= userName %></strong>!</h2>
            <p>Your order has been placed successfully.</p>
            <p><a href="order_history.jsp" style="color:#b8860b; text-decoration:none; font-weight:bold;">View My Orders</a></p>
        </div>
    <% } %>

<%
    String addedProduct = request.getParameter("product");
    String priceParam = request.getParameter("price");
    double addedPrice = 0.0;
    if(priceParam != null){
        try {
            addedPrice = Double.parseDouble(priceParam);
        } catch(NumberFormatException e){
            addedPrice = 0.0;
        }
    }

    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
    if(cart == null){ cart = new ArrayList<>(); }

    if(addedProduct != null && !addedProduct.trim().isEmpty()){
        boolean found = false;
        for(Map<String, Object> item : cart){
            String name = (String) item.get("name");
            if(name.equals(addedProduct)){
                int qty = (Integer) item.get("quantity");
                item.put("quantity", qty + 1);
                found = true;
                break;
            }
        }
        if(!found){
            Map<String, Object> item = new HashMap<>();
            item.put("name", addedProduct);
            item.put("price", addedPrice);
            item.put("quantity", 1);
            cart.add(item);
        }
    }

    session.setAttribute("cart", cart);

    double totalAmount = 0.0;
    for(Map<String, Object> item : cart){
        double p = (Double) item.get("price");
        int q = (Integer) item.get("quantity");
        totalAmount += p * q;
    }
%>

    <div class="checkout-section">

        <!-- Order Summary -->
        <div class="order-summary">
            <h2>Order Summary</h2>
            <table>
                <tr>
                    <th>Product Name</th><th>Quantity</th><th>Price (₹)</th><th>Subtotal (₹)</th>
                </tr>
                <%
                    if(cart != null && !cart.isEmpty()){
                        for(Map<String, Object> item : cart){
                            String name = (String) item.get("name");
                            double p = (Double) item.get("price");
                            int q = (Integer) item.get("quantity");
                            double sub = p * q;
                %>
                <tr>
                    <td><%= name %></td>
                    <td><%= q %></td>
                    <td><%= String.format("%.2f", p) %></td>
                    <td><%= String.format("%.2f", sub) %></td>
                </tr>
                <%   } %>
                <tr>
                    <td colspan="3"><strong>Total</strong></td>
                    <td><strong><%= String.format("%.2f", totalAmount) %></strong></td>
                </tr>
                <%  } else { %>
                <tr><td colspan="4">Your cart is empty.</td></tr>
                <% } %>
            </table>
        </div>

        <!-- Shipping & Payment Form -->
        <div class="shipping-payment-form">
            <h3>Payment & Shipping Details</h3>
            <form id="paymentForm" action="place_order.jsp" method="post">
                <h4>Total Amount: ₹<%= String.format("%.2f", totalAmount) %></h4>

                <!-- Shipping Address Fields -->
                <label for="shippingAddress">Shipping Address</label>
                <textarea id="shippingAddress" name="shipping_address" placeholder="Your full address" required rows="3"></textarea>

                <label for="city">City</label>
                <input type="text" id="city" name="city" placeholder="City" required>

                <label for="state">State</label>
                <input type="text" id="state" name="state" placeholder="State" required>

                <label for="pincode">Pincode</label>
                <input type="text" id="pincode" name="pincode" placeholder="6-digit pincode"  required>

                <div class="payment-methods">
                    <label><input type="radio" name="payment_method" value="Cash on Delivery" required> Cash on Delivery</label>
                    <label><input type="radio" name="payment_method" value="UPI" required> UPI</label>
                    <label><input type="radio" name="payment_method" value="Credit/Debit Card" required> Credit/Debit Card</label>
                </div>

                <!-- UPI Field with QR -->
                <div id="upiDetails">
                    <label for="upiId">UPI ID / Number</label>
                    <input type="text" id="upiId" name="upi_id" placeholder="example@bank / your UPI ID">

                    <!-- Static QR Code -->
                    <div style="margin-top:15px; text-align:center;">
                        <p>Or scan the QR code to pay:</p>
                        <img src="images/Shruti Saigal _qr_code.png" alt="UPI QR Code"
                             style="width:200px; height:200px; border:1px solid #ccc; border-radius:10px;" />
                    </div>
                </div>s

                <!-- Card Details Section -->
                <div id="cardDetails">
                    <label for="cardNumber">Card Number</label>
                    <input type="text" id="cardNumber" name="card_number" maxlength="19" placeholder="xxxx xxxx xxxx xxxx" pattern="\\d{13,19}" autocomplete="cc-number">

                    <label for="expiryMonth">Expiry Month</label>
                    <select id="expiryMonth" name="expiry_month">
                        <option value="">MM</option>
                        <% for(int m=1; m<=12; m++){ %>
                            <option value="<%= (m<10 ? "0"+m : m) %>"><%= (m<10 ? "0"+m : m) %></option>
                        <% } %>
                    </select>

                    <label for="expiryYear">Expiry Year</label>
                    <select id="expiryYear" name="expiry_year">
                        <option value="">YYYY</option>
                        <%
                          java.util.Calendar cal = java.util.Calendar.getInstance();
                          int thisYear = cal.get(java.util.Calendar.YEAR);
                          for(int y = thisYear; y < thisYear + 15; y++){
                        %>
                          <option value="<%= y %>"><%= y %></option>
                        <%
                          }
                        %>
                    </select>

                    <label for="cvv">CVV (3 or 4 digits)</label>
                    <input type="password" id="cvv" name="cvv" maxlength="4" placeholder="123" pattern="\\d{3,4}" autocomplete="cc-csc">
                </div>

                <input type="hidden" name="amount" value="<%= totalAmount %>">

                <button type="submit">Place Order</button>
                <button type="reset">Reset</button>
            </form>
        </div>

    </div>

    <script>
    document.addEventListener('DOMContentLoaded', function(){
        const radios = document.getElementsByName('payment_method');
        const cardDetails = document.getElementById('cardDetails');
        const upiDetails = document.getElementById('upiDetails');

        function updateFields(){
            const selected = Array.from(radios).find(r => r.checked);
            if (!selected) {
                cardDetails.style.display = 'none';
                upiDetails.style.display = 'none';
            } else if (selected.value === 'Credit/Debit Card') {
                cardDetails.style.display = 'block';
                upiDetails.style.display = 'none';
            } else if (selected.value === 'UPI') {
                upiDetails.style.display = 'block';
                cardDetails.style.display = 'none';
            } else {
                upiDetails.style.display = 'none';
                cardDetails.style.display = 'none';
            }
        }

        radios.forEach(function(r){
            r.addEventListener('change', updateFields);
        });

        document.getElementById('paymentForm').addEventListener('submit', function(e){
            const selected = Array.from(radios).find(r => r.checked);
            if (selected) {
                if (selected.value === 'Credit/Debit Card') {
                    const cn = document.getElementById('cardNumber').value.trim();
                    const em = document.getElementById('expiryMonth').value;
                    const ey = document.getElementById('expiryYear').value;
                    const cv = document.getElementById('cvv').value.trim();
                    if (!cn || !em || !ey || !cv) {
                        alert("Please fill in all card details for payment by Card.");
                        e.preventDefault();
                        return;
                    }
                } else if (selected.value === 'UPI') {
                    const ui = document.getElementById('upiId').value.trim();
                    if (!ui) {
                        alert("Please enter UPI ID for payment by UPI.");
                        e.preventDefault();
                        return;
                    }
                }
            } else {
                e.preventDefault();
                alert("Please select a payment method.");
            }
        });
    });
    </script>

</body>
</html>
