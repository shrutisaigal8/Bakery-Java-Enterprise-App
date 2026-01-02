<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.bakery.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String productIdStr = request.getParameter("product_id");
    String qtyStr = request.getParameter("qty");
    int productId = -1;
    int qty = 1; // Default quantity

    // Validate product ID
    if (productIdStr != null && !productIdStr.trim().isEmpty()) {
        try {
            productId = Integer.parseInt(productIdStr);
        } catch (NumberFormatException e) {
            out.println("<p style='color:red;'>❌ Invalid product ID format.</p>");
            return;
        }
    }

    // Validate quantity
    if (qtyStr != null && !qtyStr.trim().isEmpty()) {
        try {
            qty = Integer.parseInt(qtyStr);
            if (qty <= 0) {
                out.println("<p style='color:red;'>❌ Quantity must be a positive integer.</p>");
                return;
            }
        } catch (NumberFormatException e) {
            out.println("<p style='color:red;'>❌ Invalid quantity format.</p>");
            return;
        }
    }

    // Fetch product details from database
    if (productId != -1) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                PreparedStatement ps = conn.prepareStatement("SELECT name, price FROM products WHERE id=?");
                ps.setInt(1, productId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String name = rs.getString("name");
                    double price = rs.getDouble("price");

                    // Retrieve or initialize cart
                    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
                    if (cart == null) {
                        cart = new ArrayList<>();
                        session.setAttribute("cart", cart);
                    }

                    // Check if product already in cart
                    boolean found = false;
                    for (Map<String, Object> item : cart) {
                        if (item.get("name").equals(name)) {
                            int existingQty = (Integer) item.get("qty");
                            item.put("qty", existingQty + qty);
                            found = true;
                            break;
                        }
                    }

                    // Add new item to cart
                    if (!found) {
                        Map<String, Object> newItem = new HashMap<>();
                        newItem.put("name", name);
                        newItem.put("qty", qty);
                        newItem.put("price", price);
                        cart.add(newItem);
                    }

                    // Redirect to cart page
                    response.sendRedirect("cart.jsp");
                } else {
                    out.println("<p style='color:red;'>❌ Product not found.</p>");
                }
            } else {
                out.println("<p style='color:red;'>❌ Database connection failed.</p>");
            }
        } catch (SQLException e) {
            out.println("<p style='color:red;'>❌ Database error: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p style='color:red;'>❌ Invalid product ID.</p>");
    }
%>
