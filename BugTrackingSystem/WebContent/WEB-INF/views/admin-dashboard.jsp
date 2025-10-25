<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.bugtracker.model.*" %>
<%
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    List<BugReport> recentBugs = (List<BugReport>) request.getAttribute("recentBugs");
    List<BugReport> unassignedBugs = (List<BugReport>) request.getAttribute("unassignedBugs");
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Bug Tracking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            padding: 20px;
        }
        .main-content {
            margin-left: 250px;
            padding: 20px;
        }
        .stat-card {
            border-radius: 15px;
            padding: 20px;
            color: white;
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card i {
            font-size: 40px;
            opacity: 0.8;
        }
        .stat-card h3 {
            margin: 10px 0 5px 0;
            font-size: 32px;
            font-weight: bold;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin-top: 30px;
        }
        .sidebar-menu li {
            margin: 10px 0;
        }
        .sidebar-menu a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 12px 15px;
            border-radius: 10px;
            transition: all 0.3s;
        }
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background: rgba(255,255,255,0.2);
        }
        .badge-status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 11px;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h3 class="text-center mb-4">
            <i class="fas fa-bug"></i> Bug Tracker
        </h3>
        <div class="text-center mb-4">
            <i class="fas fa-user-circle" style="font-size: 50px;"></i>
            <h6 class="mt-2"><%= currentUser.getFullName() %></h6>
            <small><%= currentUser.getRole() %></small>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="active">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a></li>
            <li><a href="${pageContext.request.contextPath}/bug">
                <i class="fas fa-list"></i> All Bugs
            </a></li>
            <li><a href="${pageContext.request.contextPath}/bug/create">
                <i class="fas fa-plus-circle"></i> Report Bug
            </a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">
                <i class="fas fa-users"></i> Manage Users
            </a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports">
                <i class="fas fa-chart-bar"></i> Reports
            </a></li>
            <li><a href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <h2 class="mb-4"><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h2>

            <% if (session.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= session.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("success"); %>
            <% } %>

            <!-- Statistics Cards -->
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        <i class="fas fa-bug"></i>
                        <h3><%= stats.getOrDefault("high", 0) %></h3>
                        <p class="mb-0">High Priority</p>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="stat-card" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">
                        <i class="fas fa-tasks"></i>
                        <h3><%= stats.getOrDefault("assigned", 0) %></h3>
                        <p class="mb-0">Assigned</p>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="stat-card" style="background: linear-gradient(135deg, #d299c2 0%, #fef9d7 100%);">
                        <i class="fas fa-clock"></i>
                        <h3><%= unassignedBugs != null ? unassignedBugs.size() : 0 %></h3>
                        <p class="mb-0">Unassigned</p>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="stat-card" style="background: linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%);">
                        <i class="fas fa-lock"></i>
                        <h3><%= stats.getOrDefault("closed", 0) %></h3>
                        <p class="mb-0">Closed</p>
                    </div>
                </div>
            </div>

            <!-- Unassigned Bugs -->
            <% if (unassignedBugs != null && !unassignedBugs.isEmpty()) { %>
            <div class="card">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0"><i class="fas fa-exclamation-triangle"></i> Unassigned Bugs Requiring Attention</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>Severity</th>
                                    <th>Priority</th>
                                    <th>Module</th>
                                    <th>Reported By</th>
                                    <th>Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (BugReport bug : unassignedBugs) { %>
                                <tr>
                                    <td>#<%= bug.getBugId() %></td>
                                    <td><%= bug.getTitle() %></td>
                                    <td><span class="badge bg-<%= bug.getSeverity().equals("Critical") ? "danger" : bug.getSeverity().equals("High") ? "warning" : "info" %>">
                                        <%= bug.getSeverity() %>
                                    </span></td>
                                    <td><span class="badge bg-secondary"><%= bug.getPriority() %></span></td>
                                    <td><%= bug.getModule() %></td>
                                    <td><%= bug.getReportedByName() %></td>
                                    <td><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(bug.getReportedDate()) %></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/bug/assign?id=<%= bug.getBugId() %>" 
                                           class="btn btn-sm btn-primary">
                                            <i class="fas fa-user-plus"></i> Assign
                                        </a>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Recent Bugs -->
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-clock"></i> Recent Bugs</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>Status</th>
                                    <th>Severity</th>
                                    <th>Assigned To</th>
                                    <th>Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (recentBugs != null && !recentBugs.isEmpty()) {
                                    for (BugReport bug : recentBugs) { %>
                                <tr>
                                    <td>#<%= bug.getBugId() %></td>
                                    <td><%= bug.getTitle() %></td>
                                    <td><span class="badge badge-status <%= bug.getStatusClass() %>">
                                        <%= bug.getStatus() %>
                                    </span></td>
                                    <td><span class="badge <%= bug.getSeverityClass() %>">
                                        <%= bug.getSeverity() %>
                                    </span></td>
                                    <td><%= bug.getAssignedToName() != null ? bug.getAssignedToName() : "Unassigned" %></td>
                                    <td><%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(bug.getReportedDate()) %></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/bug/view?id=<%= bug.getBugId() %>" 
                                           class="btn btn-sm btn-info text-white">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                    </td>
                                </tr>
                                <% } 
                                } else { %>
                                <tr>
                                    <td colspan="7" class="text-center text-muted">No bugs reported yet</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-bolt"></i> Quick Actions</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/bug/create" class="btn btn-lg btn-primary w-100 mb-2">
                                <i class="fas fa-plus-circle"></i><br>Report New Bug
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/bug?status=New" class="btn btn-lg btn-warning w-100 mb-2">
                                <i class="fas fa-exclamation-circle"></i><br>View New Bugs
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-lg btn-info w-100 mb-2">
                                <i class="fas fa-chart-bar"></i><br>Generate Report
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-lg btn-success w-100 mb-2">
                                <i class="fas fa-users"></i><br>Manage Users
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>Default("total", 0) %></h3>
                        <p class="mb-0">Total Bugs</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                        <i class="fas fa-exclamation-circle"></i>
                        <h3><%= stats.getOrDefault("new", 0) %></h3>
                        <p class="mb-0">New Bugs</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                        <i class="fas fa-spinner"></i>
                        <h3><%= stats.getOrDefault("inProgress", 0) %></h3>
                        <p class="mb-0">In Progress</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                        <i class="fas fa-check-circle"></i>
                        <h3><%= stats.getOrDefault("resolved", 0) %></h3>
                        <p class="mb-0">Resolved</p>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-2">
                    <div class="stat-card" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                        <i class="fas fa-fire"></i>
                        <h3><%= stats.getOrDefault("critical", 0) %></h3>
                        <p class="mb-0">Critical</p>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="stat-card" style="background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);">
                        <i class="fas fa-exclamation-triangle"></i>
                        <h3><%= stats.getOr