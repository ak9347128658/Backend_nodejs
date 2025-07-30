# Day 7: Order Status Management and Admin Controls

## 🎯 Goal

Implement order status management functionality that allows administrators to update order statuses and provides a dashboard for order analytics.

## 📝 Tasks

1. Implement order status update endpoint
2. Create order analytics for admin dashboard
3. Add order cancellation functionality for users
4. Set up email notification functions (placeholders)
5. Test order management flow

## 📂 Folder & File Structure (New/Updated Files)

```
express_ecommerce/
├── controllers/
│   └── orderController.js (updated)
├── models/
│   └── orderQueries.js (updated)
├── routes/
│   └── orderRoutes.js (updated)
├── utils/
│   └── emailNotification.js (new)
```

## 🖥️ Code Snippets

### models/orderQueries.js (Updated)

```javascript
// Add to existing orderQueries.js

// Cancel order (only if status is 'pending')
cancelOrder: async (orderId) => {
  const query = `
    UPDATE orders
    SET status = 'cancelled', updated_at = CURRENT_TIMESTAMP
    WHERE id = $1 AND status = 'pending'
    RETURNING *
  `;
  
  try {
    const result = await pool.query(query, [orderId]);
    
    if (result.rows.length === 0) {
      return null;
    }
    
    return result.rows[0];
  } catch (error) {
    throw error;
  }
},

// Get order analytics for admin dashboard
getOrderAnalytics: async () => {
  try {
    // Get status counts
    const statusQuery = `
      SELECT status, COUNT(*) as count
      FROM orders
      GROUP BY status
    `;
    
    // Get daily orders for the last 7 days
    const dailyOrdersQuery = `
      SELECT 
        DATE(created_at) as date,
        COUNT(*) as order_count,
        SUM(total_amount) as revenue
      FROM orders
      WHERE created_at >= NOW() - INTERVAL '7 days'
      GROUP BY DATE(created_at)
      ORDER BY date DESC
    `;
    
    // Get top selling products
    const topProductsQuery = `
      SELECT 
        p.id,
        p.name,
        SUM(oi.quantity) as total_quantity,
        SUM(oi.quantity * oi.unit_price) as total_revenue
      FROM order_items oi
      JOIN products p ON oi.product_id = p.id
      JOIN orders o ON oi.order_id = o.id
      WHERE o.status != 'cancelled'
      GROUP BY p.id, p.name
      ORDER BY total_quantity DESC
      LIMIT 5
    `;
    
    // Get total revenue and order count
    const totalsQuery = `
      SELECT 
        COUNT(*) as total_orders,
        SUM(CASE WHEN status != 'cancelled' THEN total_amount ELSE 0 END) as total_revenue,
        COUNT(DISTINCT user_id) as unique_customers
      FROM orders
    `;
    
    // Execute all queries in parallel
    const [statusResult, dailyOrdersResult, topProductsResult, totalsResult] = 
      await Promise.all([
        pool.query(statusQuery),
        pool.query(dailyOrdersQuery),
        pool.query(topProductsQuery),
        pool.query(totalsQuery)
      ]);
    
    // Process status counts
    const statusCounts = {};
    statusResult.rows.forEach(row => {
      statusCounts[row.status] = parseInt(row.count);
    });
    
    // Return analytics data
    return {
      ordersByStatus: statusCounts,
      dailyOrders: dailyOrdersResult.rows.map(row => ({
        date: row.date,
        orderCount: parseInt(row.order_count),
        revenue: parseFloat(row.revenue)
      })),
      topProducts: topProductsResult.rows.map(row => ({
        id: row.id,
        name: row.name,
        totalQuantity: parseInt(row.total_quantity),
        totalRevenue: parseFloat(row.total_revenue)
      })),
      totals: {
        totalOrders: parseInt(totalsResult.rows[0].total_orders),
        totalRevenue: parseFloat(totalsResult.rows[0].total_revenue || 0),
        uniqueCustomers: parseInt(totalsResult.rows[0].unique_customers)
      }
    };
    
  } catch (error) {
    throw error;
  }
}
```

### controllers/orderController.js (Updated)

```javascript
// Add to existing orderController.js

// Update order status (admin only)
updateOrderStatus: async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: 'error',
        errors: errors.array()
      });
    }
    
    const { id } = req.params;
    const { status } = req.body;
    
    // Update order status
    const updatedOrder = await orderQueries.updateOrderStatus(id, status);
    
    if (!updatedOrder) {
      return res.status(404).json({
        status: 'error',
        message: 'Order not found'
      });
    }
    
    // Send notification (placeholder for email service)
    try {
      await emailNotification.sendOrderStatusUpdate(updatedOrder);
    } catch (emailError) {
      console.error('Failed to send email notification:', emailError);
      // Continue processing, don't fail the request due to email issues
    }
    
    res.status(200).json({
      status: 'success',
      message: 'Order status updated successfully',
      data: { order: updatedOrder }
    });
    
  } catch (error) {
    if (error.message === 'Invalid order status') {
      return res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
    next(error);
  }
},

// Cancel order (user can only cancel their own pending orders)
cancelOrder: async (req, res, next) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    
    // Check if order exists and belongs to user
    const order = await orderQueries.getOrderById(id);
    
    if (!order) {
      return res.status(404).json({
        status: 'error',
        message: 'Order not found'
      });
    }
    
    // Check if user owns the order or is admin
    if (order.user_id !== userId && req.user.role !== 'admin') {
      return res.status(403).json({
        status: 'error',
        message: 'You do not have permission to cancel this order'
      });
    }
    
    // Check if order can be cancelled (must be in 'pending' status)
    if (order.status !== 'pending') {
      return res.status(400).json({
        status: 'error',
        message: 'Only pending orders can be cancelled'
      });
    }
    
    // Cancel the order
    const cancelledOrder = await orderQueries.cancelOrder(id);
    
    if (!cancelledOrder) {
      return res.status(500).json({
        status: 'error',
        message: 'Failed to cancel order'
      });
    }
    
    // Send notification (placeholder for email service)
    try {
      await emailNotification.sendOrderCancellation(cancelledOrder);
    } catch (emailError) {
      console.error('Failed to send email notification:', emailError);
      // Continue processing, don't fail the request due to email issues
    }
    
    res.status(200).json({
      status: 'success',
      message: 'Order cancelled successfully',
      data: { order: cancelledOrder }
    });
    
  } catch (error) {
    next(error);
  }
},

// Get order analytics for admin dashboard
getOrderAnalytics: async (req, res, next) => {
  try {
    const analytics = await orderQueries.getOrderAnalytics();
    
    res.status(200).json({
      status: 'success',
      data: { analytics }
    });
    
  } catch (error) {
    next(error);
  }
}
```

### routes/orderRoutes.js (Updated)

```javascript
// Add to existing orderRoutes.js

// Cancel order (user)
router.patch('/user/:id/cancel', orderController.cancelOrder);

// Update order status (admin)
router.patch(
  '/admin/:id/status',
  checkRole(['admin']),
  [
    body('status')
      .isIn(['pending', 'processing', 'shipped', 'delivered', 'cancelled'])
      .withMessage('Invalid order status')
  ],
  orderController.updateOrderStatus
);

// Get order analytics (admin)
router.get(
  '/admin/analytics',
  checkRole(['admin']),
  orderController.getOrderAnalytics
);
```

### utils/emailNotification.js

```javascript
/**
 * Email Notification Service
 * 
 * This is a placeholder for actual email service implementation.
 * In a production application, you would integrate with a real
 * email service provider like SendGrid, Mailgun, etc.
 */

const emailNotification = {
  /**
   * Send order confirmation email
   * @param {Object} order - Order details
   */
  sendOrderConfirmation: async (order) => {
    console.log(`[EMAIL NOTIFICATION] Order Confirmation for Order #${order.id}`);
    console.log(`To: ${order.email}`);
    console.log(`Subject: Your order #${order.id} has been confirmed`);
    console.log(`Body: Thank you for your order! Your order #${order.id} has been confirmed and is being processed.`);
    
    // In actual implementation, you would send a real email here
    return true;
  },
  
  /**
   * Send order status update email
   * @param {Object} order - Updated order
   */
  sendOrderStatusUpdate: async (order) => {
    // Get user email (in a real implementation, you'd fetch this)
    const email = 'user@example.com'; // Placeholder
    
    console.log(`[EMAIL NOTIFICATION] Order Status Update for Order #${order.id}`);
    console.log(`To: ${email}`);
    console.log(`Subject: Your order #${order.id} has been updated`);
    console.log(`Body: Your order status has been updated to ${order.status}.`);
    
    // In actual implementation, you would send a real email here
    return true;
  },
  
  /**
   * Send order cancellation email
   * @param {Object} order - Cancelled order
   */
  sendOrderCancellation: async (order) => {
    // Get user email (in a real implementation, you'd fetch this)
    const email = 'user@example.com'; // Placeholder
    
    console.log(`[EMAIL NOTIFICATION] Order Cancellation for Order #${order.id}`);
    console.log(`To: ${email}`);
    console.log(`Subject: Your order #${order.id} has been cancelled`);
    console.log(`Body: Your order has been cancelled as requested.`);
    
    // In actual implementation, you would send a real email here
    return true;
  }
};

module.exports = emailNotification;
```

## 🔒 Security & Validation Notes

- Order status updates are restricted to admin users
- Order cancellation is allowed only for pending orders
- Users can only cancel their own orders
- Admins can cancel any order
- Input validation ensures valid status values
- Email notifications are logged for auditing (in a production system, these would be actual emails)

## 🧪 API Testing Tips

### Update Order Status (Admin)

```bash
# Using curl (replace ADMIN_JWT_TOKEN and ORDER_ID with actual values)
curl -X PATCH http://localhost:3000/api/orders/admin/ORDER_ID/status \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"status":"processing"}'
```

### Cancel Order (User)

```bash
# Using curl (replace USER_JWT_TOKEN and ORDER_ID with actual values)
curl -X PATCH http://localhost:3000/api/orders/user/ORDER_ID/cancel \
  -H "Authorization: Bearer USER_JWT_TOKEN"
```

### Get Order Analytics (Admin)

```bash
# Using curl (replace ADMIN_JWT_TOKEN with actual token)
curl -X GET http://localhost:3000/api/orders/admin/analytics \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN"
```

## 📊 Analytics Data Example

```json
{
  "status": "success",
  "data": {
    "analytics": {
      "ordersByStatus": {
        "pending": 5,
        "processing": 3,
        "shipped": 2,
        "delivered": 10,
        "cancelled": 1
      },
      "dailyOrders": [
        {
          "date": "2023-09-15",
          "orderCount": 3,
          "revenue": 245.85
        },
        {
          "date": "2023-09-14",
          "orderCount": 2,
          "revenue": 129.99
        },
        // More dates...
      ],
      "topProducts": [
        {
          "id": 12,
          "name": "Wireless Headphones",
          "totalQuantity": 15,
          "totalRevenue": 749.85
        },
        // More products...
      ],
      "totals": {
        "totalOrders": 21,
        "totalRevenue": 2175.50,
        "uniqueCustomers": 12
      }
    }
  }
}
```

## 🚀 Day 7 Implementation Steps

1. **Update order model**:
   - Add method to cancel orders
   - Implement order analytics queries

2. **Enhance order controller**:
   - Add status update functionality
   - Implement order cancellation
   - Create analytics endpoint

3. **Update order routes**:
   - Add status update endpoint for admins
   - Create cancellation endpoint for users
   - Add analytics endpoint for admin dashboard

4. **Create email notification placeholders**:
   - Set up email notification service structure
   - Implement logging for future email integration

5. **Test order management flow**:
   - Test status updates
   - Test order cancellation
   - Test analytics endpoint

## 📝 Notes and Best Practices

- Maintain a clear distinction between user and admin capabilities
- Validate order status transitions to prevent invalid state changes
- Ensure proper error handling and meaningful error messages
- Use analytics to provide business insights
- Structure email notifications to allow for easy integration with real email services later
- Include comprehensive logging for monitoring and debugging
- Use database transactions for critical operations

## 🔄 Next Steps

On Day 8, we'll implement input validation, error handling, and security improvements.
