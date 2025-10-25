<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bugtracker.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Bug - Bug Tracking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            padding: 30px;
            margin: 30px auto;
            max-width: 900px;
        }
        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .required:after {
            content: " *";
            color: red;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-bug"></i> Bug Tracker
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text text-white me-3">
                    <i class="fas fa-user"></i> <%= currentUser.getFullName() %>
                </span>
                <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="form-container">
            <div class="form-header">
                <h2 class="mb-0"><i class="fas fa-bug"></i> Report a Bug</h2>
                <p class="mb-0">Please provide detailed information about the bug you encountered</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/bug/create" method="post" enctype="multipart/form-data">
                <div class="row">
                    <div class="col-md-12 mb-3">
                        <label for="title" class="form-label required">Bug Title</label>
                        <input type="text" class="form-control" id="title" name="title" 
                               placeholder="Brief description of the bug" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="severity" class="form-label required">Severity</label>
                        <select class="form-select" id="severity" name="severity" required>
                            <option value="">Select Severity</option>
                            <option value="Critical">Critical - System crash or data loss</option>
                            <option value="High">High - Major functionality broken</option>
                            <option value="Medium">Medium - Feature not working as expected</option>
                            <option value="Low">Low - Minor issue or cosmetic</option>
                        </select>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="priority" class="form-label required">Priority</label>
                        <select class="form-select" id="priority" name="priority" required>
                            <option value="">Select Priority</option>
                            <option value="Urgent">Urgent - Fix immediately</option>
                            <option value="High">High - Fix soon</option>
                            <option value="Medium">Medium - Fix in next release</option>
                            <option value="Low">Low - Fix when possible</option>
                        </select>
                    </div>

                    <div class="col-md-12 mb-3">
                        <label for="module" class="form-label required">Module</label>
                        <select class="form-select" id="module" name="module" required>
                            <option value="">Select Module</option>
                            <option value="Product Search">Product Search</option>
                            <option value="Cart Management">Cart Management</option>
                            <option value="Payment Gateway">Payment Gateway</option>
                            <option value="Order Tracking">Order Tracking</option>
                            <option value="User Authentication">User Authentication</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="col-md-12 mb-3">
                        <label for="description" class="form-label required">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="4" 
                                  placeholder="Detailed description of the bug" required></textarea>
                    </div>

                    <div class="col-md-12 mb-3">
                        <label for="stepsToReproduce" class="form-label required">Steps to Reproduce</label>
                        <textarea class="form-control" id="stepsToReproduce" name="stepsToReproduce" rows="4" 
                                  placeholder="1. Go to...\n2. Click on...\n3. Observe..." required></textarea>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="expectedResult" class="form-label">Expected Result</label>
                        <textarea class="form-control" id="expectedResult" name="expectedResult" rows="3" 
                                  placeholder="What should happen"></textarea>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="actualResult" class="form-label">Actual Result</label>
                        <textarea class="form-control" id="actualResult" name="actualResult" rows="3" 
                                  placeholder="What actually happens"></textarea>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="browserInfo" class="form-label">Browser Information</label>
                        <input type="text" class="form-control" id="browserInfo" name="browserInfo" 
                               placeholder="e.g., Chrome 95.0.4638.69">
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="osInfo" class="form-label">Operating System</label>
                        <input type="text" class="form-control" id="osInfo" name="osInfo" 
                               placeholder="e.g., Windows 11, macOS 12">
                    </div>

                    <div class="col-md-12 mb-3">
                        <label for="screenshot" class="form-label">Screenshot (Optional)</label>
                        <input type="file" class="form-control" id="screenshot" name="screenshot" 
                               accept="image/*">
                        <small class="text-muted">Max file size: 10MB. Supported formats: JPG, PNG, GIF</small>
                    </div>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <a href="${pageContext.request.contextPath}/<%= currentUser.getRole().toLowerCase() %>/dashboard" 
                       class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> Submit Bug Report
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-detect browser and OS
        document.addEventListener('DOMContentLoaded', function() {
            const browserInfo = navigator.userAgent;
            const browserField = document.getElementById('browserInfo');
            
            // Detect browser
            let browser = '';
            if (browserInfo.indexOf('Chrome') > -1) browser = 'Chrome';
            else if (browserInfo.indexOf('Firefox') > -1) browser = 'Firefox';
            else if (browserInfo.indexOf('Safari') > -1) browser = 'Safari';
            else if (browserInfo.indexOf('Edge') > -1) browser = 'Edge';
            
            if (browser && !browserField.value) {
                browserField.value = browser + ' ' + navigator.appVersion.match(/Chrome\/(\d+)/)?.[1] || '';
            }
            
            // Detect OS
            const osField = document.getElementById('osInfo');
            let os = '';
            if (navigator.userAgent.indexOf('Win') > -1) os = 'Windows';
            else if (navigator.userAgent.indexOf('Mac') > -1) os = 'macOS';
            else if (navigator.userAgent.indexOf('Linux') > -1) os = 'Linux';
            else if (navigator.userAgent.indexOf('Android') > -1) os = 'Android';
            else if (navigator.userAgent.indexOf('iOS') > -1) os = 'iOS';
            
            if (os && !osField.value) {
                osField.value = os;
            }
        });
    </script>
</body>
</html>