-- Bug Tracking System Database Schema
-- Drop existing database if exists
DROP DATABASE IF EXISTS bug_tracking_system;
CREATE DATABASE bug_tracking_system;
USE bug_tracking_system;

-- Users Table (Customer, Developer, Admin)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('Customer', 'Developer', 'Admin') NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_username (username),
    INDEX idx_role (role)
);

-- Bug Reports Table
CREATE TABLE bug_reports (
    bug_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    severity ENUM('Critical', 'High', 'Medium', 'Low') NOT NULL,
    priority ENUM('Urgent', 'High', 'Medium', 'Low') NOT NULL,
    status ENUM('New', 'Assigned', 'In Progress', 'Resolved', 'Closed', 'Reopened') DEFAULT 'New',
    module ENUM('Product Search', 'Cart Management', 'Payment Gateway', 'Order Tracking', 'User Authentication', 'Other') NOT NULL,
    reported_by INT NOT NULL,
    assigned_to INT NULL,
    screenshot_path VARCHAR(255),
    steps_to_reproduce TEXT,
    expected_result TEXT,
    actual_result TEXT,
    browser_info VARCHAR(100),
    os_info VARCHAR(100),
    reported_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_date TIMESTAMP NULL,
    resolved_date TIMESTAMP NULL,
    closed_date TIMESTAMP NULL,
    estimated_hours DECIMAL(5,2),
    actual_hours DECIMAL(5,2),
    FOREIGN KEY (reported_by) REFERENCES users(user_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id),
    INDEX idx_status (status),
    INDEX idx_severity (severity),
    INDEX idx_assigned_to (assigned_to),
    INDEX idx_reported_date (reported_date)
);

-- Bug History/Audit Log Table
CREATE TABLE bug_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    bug_id INT NOT NULL,
    changed_by INT NOT NULL,
    field_changed VARCHAR(50) NOT NULL,
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    comment TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bug_id) REFERENCES bug_reports(bug_id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES users(user_id),
    INDEX idx_bug_id (bug_id),
    INDEX idx_changed_at (changed_at)
);

-- Comments Table
CREATE TABLE bug_comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    bug_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bug_id) REFERENCES bug_reports(bug_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX idx_bug_id (bug_id)
);

-- Attachments Table
CREATE TABLE bug_attachments (
    attachment_id INT PRIMARY KEY AUTO_INCREMENT,
    bug_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(50),
    file_size INT,
    uploaded_by INT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bug_id) REFERENCES bug_reports(bug_id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id),
    INDEX idx_bug_id (bug_id)
);

-- Notifications Table
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    bug_id INT,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (bug_id) REFERENCES bug_reports(bug_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read)
);

-- Insert Default Admin User (password: admin123)
INSERT INTO users (username, password, email, full_name, role, phone) VALUES
('admin', 'admin123', 'admin@bugtracker.com', 'System Administrator', 'Admin', '9876543210'),
('developer1', 'dev123', 'dev1@bugtracker.com', 'John Developer', 'Developer', '9876543211'),
('customer1', 'cust123', 'customer1@bugtracker.com', 'Alice Customer', 'Customer', '9876543212'),
('sanjai', 'team123', 'sanjai@bugtracker.com', 'Sanjai V', 'Admin', '9876543213'),
('udayaseelan', 'team123', 'uday@bugtracker.com', 'Udayaseelan V', 'Developer', '9876543214'),
('rosan', 'team123', 'rosan@bugtracker.com', 'Rosan S', 'Developer', '9876543215');

-- Insert Sample Bug Reports
INSERT INTO bug_reports (title, description, severity, priority, status, module, reported_by, steps_to_reproduce, expected_result, actual_result) VALUES
('Payment Gateway Timeout', 'Payment fails after 30 seconds during checkout', 'Critical', 'Urgent', 'New', 'Payment Gateway', 3, 
'1. Add items to cart\n2. Proceed to checkout\n3. Enter payment details\n4. Click Pay Now',
'Payment should process successfully',
'Payment times out after 30 seconds'),
('Product Images Not Loading', 'Product images show broken icon on product listing page', 'High', 'High', 'New', 'Product Search', 3,
'1. Navigate to product listing\n2. Observe product images',
'All product images should display correctly',
'Images show broken icon placeholder'),
('Cart Total Calculation Error', 'Cart shows incorrect total when discount is applied', 'Medium', 'Medium', 'New', 'Cart Management', 3,
'1. Add products with 10% discount\n2. View cart total',
'Total should reflect 10% discount',
'Total shows without discount applied');

-- Views for Analytics

-- Bug Statistics View
CREATE VIEW bug_statistics AS
SELECT 
    COUNT(*) as total_bugs,
    SUM(CASE WHEN status = 'New' THEN 1 ELSE 0 END) as new_bugs,
    SUM(CASE WHEN status = 'Assigned' THEN 1 ELSE 0 END) as assigned_bugs,
    SUM(CASE WHEN status = 'In Progress' THEN 1 ELSE 0 END) as in_progress_bugs,
    SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END) as resolved_bugs,
    SUM(CASE WHEN status = 'Closed' THEN 1 ELSE 0 END) as closed_bugs,
    SUM(CASE WHEN severity = 'Critical' THEN 1 ELSE 0 END) as critical_bugs,
    SUM(CASE WHEN severity = 'High' THEN 1 ELSE 0 END) as high_bugs
FROM bug_reports;

-- Developer Performance View
CREATE VIEW developer_performance AS
SELECT 
    u.user_id,
    u.full_name,
    COUNT(br.bug_id) as total_assigned,
    SUM(CASE WHEN br.status = 'Resolved' THEN 1 ELSE 0 END) as resolved_count,
    SUM(CASE WHEN br.status = 'Closed' THEN 1 ELSE 0 END) as closed_count,
    AVG(TIMESTAMPDIFF(HOUR, br.assigned_date, br.resolved_date)) as avg_resolution_hours
FROM users u
LEFT JOIN bug_reports br ON u.user_id = br.assigned_to
WHERE u.role = 'Developer'
GROUP BY u.user_id, u.full_name;

-- Bug Trends by Module
CREATE VIEW bug_trends_by_module AS
SELECT 
    module,
    COUNT(*) as bug_count,
    AVG(TIMESTAMPDIFF(HOUR, reported_date, resolved_date)) as avg_resolution_hours,
    SUM(CASE WHEN status IN ('Resolved', 'Closed') THEN 1 ELSE 0 END) as resolved_count
FROM bug_reports
GROUP BY module;

-- Stored Procedures

-- Assign Bug to Developer
DELIMITER //
CREATE PROCEDURE assign_bug(
    IN p_bug_id INT,
    IN p_developer_id INT,
    IN p_assigned_by INT
)
BEGIN
    UPDATE bug_reports 
    SET assigned_to = p_developer_id,
        status = 'Assigned',
        assigned_date = CURRENT_TIMESTAMP
    WHERE bug_id = p_bug_id;
    
    INSERT INTO bug_history (bug_id, changed_by, field_changed, old_value, new_value)
    VALUES (p_bug_id, p_assigned_by, 'assigned_to', NULL, p_developer_id);
    
    INSERT INTO notifications (user_id, bug_id, message)
    VALUES (p_developer_id, p_bug_id, CONCAT('New bug assigned: Bug #', p_bug_id));
END //

-- Update Bug Status
CREATE PROCEDURE update_bug_status(
    IN p_bug_id INT,
    IN p_new_status VARCHAR(20),
    IN p_updated_by INT,
    IN p_comment TEXT
)
BEGIN
    DECLARE v_old_status VARCHAR(20);
    
    SELECT status INTO v_old_status FROM bug_reports WHERE bug_id = p_bug_id;
    
    UPDATE bug_reports 
    SET status = p_new_status,
        resolved_date = CASE WHEN p_new_status = 'Resolved' THEN CURRENT_TIMESTAMP ELSE resolved_date END,
        closed_date = CASE WHEN p_new_status = 'Closed' THEN CURRENT_TIMESTAMP ELSE closed_date END
    WHERE bug_id = p_bug_id;
    
    INSERT INTO bug_history (bug_id, changed_by, field_changed, old_value, new_value, comment)
    VALUES (p_bug_id, p_updated_by, 'status', v_old_status, p_new_status, p_comment);
END //

DELIMITER ;

-- Triggers

-- After Bug Insert - Create Notification
DELIMITER //
CREATE TRIGGER after_bug_insert
AFTER INSERT ON bug_reports
FOR EACH ROW
BEGIN
    -- Notify all admins about new bug
    INSERT INTO notifications (user_id, bug_id, message)
    SELECT user_id, NEW.bug_id, CONCAT('New bug reported: ', NEW.title)
    FROM users WHERE role = 'Admin';
END //

DELIMITER ;