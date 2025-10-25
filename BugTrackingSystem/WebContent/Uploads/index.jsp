<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bugtracker.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser != null) {
        // Redirect to appropriate dashboard based on role
        String dashboardUrl = "";
        switch (currentUser.getRole()) {
            case "Admin":
                dashboardUrl = request.getContextPath() + "/admin/dashboard";
                break;
            case "Developer":
                dashboardUrl = request.getContextPath() + "/developer/dashboard";
                break;
            case "Customer":
                dashboardUrl = request.getContextPath() + "/customer/dashboard";
                break;
        }
        response.sendRedirect(dashboardUrl);
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bug Tracking System - Welcome</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: white;
        }
        .hero-section {
            padding: 100px 0;
            text-align: center;
        }
        .hero-section h1 {
            font-size: 4rem;
            font-weight: 700;
            margin-bottom: 20px;
            animation: fadeInUp 1s ease;
        }
        .hero-section p {
            font-size: 1.5rem;
            margin-bottom: 40px;
            animation: fadeInUp 1.2s ease;
        }
        .feature-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin: 20px 0;
            transition: transform 0.3s;
            animation: fadeInUp 1.4s ease;
        }
        .feature-card:hover {
            transform: translateY(-10px);
            background: rgba(255, 255, 255, 0.15);
        }
        .feature-card i {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        .btn-hero {
            padding: 15px 50px;
            font-size: 1.2rem;
            border-radius: 50px;
            margin: 10px;
            animation: fadeInUp 1.6s ease;
        }
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .stats-section {
            background: rgba(255, 255, 255, 0.1);
            padding: 50px 0;
            margin: 50px 0;
        }
        .stat-item {
            text-align: center;
            padding: 20px;
        }
        .stat-item h2 {
            font-size: 3rem;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="hero-section">
            <i class="fas fa-bug" style="font-size: 5rem; margin-bottom: 30px;"></i>
            <h1>Bug Tracking System</h1>
            <p>Streamline Your Bug Management Process</p>
            <p class="lead">
                Track, manage, and resolve bugs efficiently with our comprehensive bug tracking solution
                designed specifically for online shopping cart applications.
            </p>
            <div class="mt-5">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-light btn-lg btn-hero">
                    <i class="fas fa-sign-in-alt"></i> Login
                </a>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light btn-lg btn-hero">
                    <i class="fas fa-user-plus"></i> Register
                </a>
            </div>
        </div>

        <div class="row mt-5">
            <div class="col-md-4">
                <div class="feature-card">
                    <i class="fas fa-tasks"></i>
                    <h3>Centralized Tracking</h3>
                    <p>Keep all your bug reports in one place with easy-to-use reporting interface and comprehensive tracking capabilities.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <i class="fas fa-users"></i>
                    <h3>Team Collaboration</h3>
                    <p>Assign bugs to developers, track progress, and collaborate effectively to resolve issues faster.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <i class="fas fa-chart-line"></i>
                    <h3>Analytics & Reports</h3>
                    <p>Gain insights with detailed reports on bug trends, resolution times, and developer performance.</p>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-4">
                <div class="feature-card">
                    <i class="fas fa-shield-alt"></i>
                    <h3>Priority Management</h3>
                    <p>Classify bugs by severity and priority to ensure critical issues are addressed first.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <i class="fas fa-bell"></i>
                    <h3>Real-time Notifications</h3>
                    <p>Stay updated with instant notifications when bugs are assigned, updated, or resolved.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <i class="fas fa-history"></i>
                    <h3>Complete History</h3>
                    <p>Track every change made to a bug with comprehensive audit logs and history tracking.</p>
                </div>
            </div>
        </div>

        <div class="stats-section rounded">
            <div class="row">
                <div class="col-md-3 stat-item">
                    <i class="fas fa-bug" style="font-size: 2rem;"></i>
                    <h2>100%</h2>
                    <p>Visibility</p>
                </div>
                <div class="col-md-3 stat-item">
                    <i class="fas fa-clock" style="font-size: 2rem;"></i>
                    <h2>50%</h2>
                    <p>Faster Resolution</p>
                </div>
                <div class="col-md-3 stat-item">
                    <i class="fas fa-users" style="font-size: 2rem;"></i>
                    <h2>∞</h2>
                    <p>Team Members</p>
                </div>
                <div class="col-md-3 stat-item">
                    <i class="fas fa-chart-line" style="font-size: 2rem;"></i>
                    <h2>24/7</h2>
                    <p>Tracking</p>
                </div>
            </div>
        </div>

        <div class="text-center mt-5 pb-5">
            <h3>Ready to Get Started?</h3>
            <p class="lead mb-4">Join us today and take control of your bug management process</p>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-light btn-lg btn-hero">
                <i class="fas fa-rocket"></i> Get Started Now
            </a>
        </div>

        <footer class="text-center pb-4">
            <p>&copy; 2024 Bug Tracking System | Developed by Team: Sanjai V, Udayaseelan V, Rosan S</p>
            <p class="small">VIT Chennai | 23MIS0147, 23MIS0113, 23MIS0116</p>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>