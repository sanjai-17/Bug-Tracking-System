<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bugtracker.model.*, java.text.SimpleDateFormat" %>
<%
    User currentUser = (User) session.getAttribute("user");
    BugReport bug = (BugReport) request.getAttribute("bug");
    
    if (currentUser == null || bug == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Check authorization - only Admin and assigned Developer can edit
    boolean canEdit = "Admin".equals(currentUser.getRole()) || 
                     (bug.getAssignedTo() != null && bug.getAssignedTo() == currentUser.getUserId());
    
    if (!canEdit) {
        response.sendRedirect(request.getContextPath() + "/bug/view?id=" + bug.getBugId());
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Bug #<%= bug.getBugId() %> - Bug Tracking System</title>
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
        .info-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 13px;
            margin-right: 10px;
        }
        .section-divider {
            border-top: 2px solid #e9ecef;
            margin: 30px 0;
            padding-top: 20px;
        }
        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
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
                <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/bug/view?id=<%= bug.getBugId() %>">
                    <i class="fas fa-arrow-left"></i> Back to Bug
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="form-container">
            <div class="form-header">
                <h2 class="mb-0"><i class="fas fa-edit"></i> Edit Bug #<%= bug.getBugId() %></h2>
                <p class="mb-0">Update bug information and details</p>
                <div class="mt-3">
                    <span class="info-badge bg-light text-dark">
                        <i class="fas fa-user"></i> Reported by: <%= bug.getReportedByName() %>
                    </span>
                    <span class="info-badge bg-light text-dark">
                        <i class="fas fa-calendar"></i> <%= new SimpleDateFormat("MMM dd, yyyy").format(bug.getReportedDate()) %>
                    </span>
                    <span class="info-badge <%= bug.getStatusClass() %>">
                        <%= bug.getStatus() %>
                    </span>
                </div>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/bug/update" method="post" id="editBugForm">
                <input type="hidden" name="bugId" value="<%= bug.getBugId() %>">
                
                <!-- Basic Information Section -->
                <h5 class="mb-3"><i class="fas fa-info-circle"></i> Basic Information</h5>
                
                <div class="row">
                    <div class="col-md-12 mb-3">
                        <label for="title" class="form-label required">Bug Title</label>
                        <input type="text" class="form-control" id="title" name="title" 
                               value="<%= bug.getTitle() %>"
                               placeholder="Brief description of the bug" required maxlength="200">
                        <div class="help-text">
                            <i class="fas fa-lightbulb"></i> Keep it concise and descriptive
                        </div>
                    </div>

                    <div class="col-md-12 mb-3">
                        <label for="description" class="form-label required">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="4" 
                                  required maxlength="5000"><%= bug.getDescription() %></textarea>
                        <div class="help-text">
                            <i class="fas fa-info-circle"></i> Provide detailed information about the issue
                        </div>
                    </div>
                </div>

                <div class="section-divider"></div>

                <!-- Classification Section -->
                <h5 class="mb-3"><i class="fas fa-tags"></i> Classification</h5>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="severity" class="form-label required">Severity</label>
                        <select class="form-select" id="severity" name="severity" required>
                            <option value="Critical" <%= "Critical".equals(bug.getSeverity()) ? "selected" : "" %>>
                                Critical - System crash or data loss
                            </option>
                            <option value="High" <%= "High".equals(bug.getSeverity()) ? "selected" : "" %>>
                                High - Major functionality broken
                            </option>
                            <option value="Medium" <%= "Medium".equals(bug.getSeverity()) ? "selected" : "" %>>
                                Medium - Feature not working as expected
                            </option>
                            <option value="Low" <%= "Low".equals(bug.getSeverity()) ? "selected" : "" %>>
                                Low - Minor issue or cosmetic
                            </option>
                        </select>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label for="priority" class="form-label required">Priority</label>
                        <select class="form-select" id="priority" name="priority" required>
                            <option value="Urgent" <%= "Urgent".equals(bug.getPriority()) ? "selected" : "" %>>
                                Urgent - Fix immediately
                            </option>
                            <option value="High" <%= "High".equals(bug.getPriority()) ? "selected" : "" %>>
                                High - Fix soon
                            </option>
                            <option value="Medium" <%= "Medium".equals(bug.getPriority()) ? "selected" : "" %>>
                                Medium - Fix in next release
                            </option>
                            <option value="Low" <%= "Low".equals(bug.getPriority()) ? "selected" : "" %>>
                                Low - Fix when possible
                            </option>
                        </select>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label for="module" class="form-label required">Module</label>
                        <select class="form-select" id="module" name="module" required>
                            <option value="Product Search" <%= "Product Search".equals(bug.getModule()) ? "selected" : "" %>>
                                Product Search
                            </option>
                            <option value="Cart Management" <%= "Cart Management".equals(bug.getModule()) ? "selected" : "" %>>
                                Cart Management
                            </option>
                            <option value="Payment Gateway" <%= "Payment Gateway".equals(bug.getModule()) ? "selected" : "" %>>
                                Payment Gateway
                            </option>
                            <option value="Order Tracking" <%= "Order Tracking".equals(bug.getModule()) ? "selected" : "" %>>
                                Order Tracking
                            </option>
                            <option value="User Authentication" <%= "User Authentication".equals(bug.getModule()) ? "selected" : "" %>>
                                User Authentication
                            </option>
                            <option value="Other" <%= "Other".equals(bug.getModule()) ? "selected" : "" %>>
                                Other
                            </option>
                        </select>
                    </div>
                </div>

                <div class="section-divider"></div>

                <!-- Reproduction Details Section -->
                <h5 class="mb-3"><i class="fas fa-redo"></i> Reproduction Details</h5>

                <div class="row">
                    <div class="col-md-12 mb-3">
                        <label for="stepsToReproduce" class="form-label required">Steps to Reproduce</label>
                        <textarea class="form-control" id="stepsToReproduce" name="stepsToReproduce" rows="5" 
                                  required maxlength="2000"><%= bug.getStepsToReproduce() != null ? bug.getStepsToReproduce() : "" %></textarea>
                        <div class="help-text">
                            <i class="fas fa-list-ol"></i> List clear steps: 1. First do this... 2. Then do that...
                        </div>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="expectedResult" class="form-label">Expected Result</label>
                        <textarea class="form-control" id="expectedResult" name="expectedResult" rows="3" 
                                  maxlength="1000"><%= bug.getExpectedResult() != null ? bug.getExpectedResult() : "" %></textarea>
                        <div class="help-text">What should happen?</div>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="actualResult" class="form-label">Actual Result</label>
                        <textarea class="form-control" id="actualResult" name="actualResult" rows="3" 
                                  maxlength="1000"><%= bug.getActualResult() != null ? bug.getActualResult() : "" %></textarea>
                        <div class="help-text">What actually happens?</div>
                    </div>
                </div>

                <div class="section-divider"></div>

                <!-- Developer Information Section -->
                <% if ("Developer".equals(currentUser.getRole()) || "Admin".equals(currentUser.getRole())) { %>
                <h5 class="mb-3"><i class="fas fa-clock"></i> Time Estimation</h5>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="estimatedHours" class="form-label">Estimated Hours</label>
                        <input type="number" class="form-control" id="estimatedHours" name="estimatedHours" 
                               value="<%= bug.getEstimatedHours() != null ? bug.getEstimatedHours() : "" %>"
                               min="0" max="1000" step="0.5" placeholder="e.g., 4.5">
                        <div class="help-text">
                            <i class="fas fa-info-circle"></i> Estimated time to fix this bug (in hours)
                        </div>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Current Status</label>
                        <div class="form-control-plaintext">
                            <span class="badge <%= bug.getStatusClass() %> fs-6">
                                <%= bug.getStatus() %>
                            </span>
                            <div class="help-text mt-2">
                                <i class="fas fa-lightbulb"></i> Use "Update Status" button on view page to change status
                            </div>
                        </div>
                    </div>
                </div>

                <div class="section-divider"></div>
                <% } %>

                <!-- Additional Information Section -->
                <h5 class="mb-3"><i class="fas fa-desktop"></i> Environment Information</h5>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="browserInfo" class="form-label">Browser Information</label>
                        <input type="text" class="form-control" id="browserInfo" name="browserInfo" 
                               value="<%= bug.getBrowserInfo() != null ? bug.getBrowserInfo() : "" %>"
                               placeholder="e.g., Chrome 95.0.4638.69" maxlength="100">
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="osInfo" class="form-label">Operating System</label>
                        <input type="text" class="form-control" id="osInfo" name="osInfo" 
                               value="<%= bug.getOsInfo() != null ? bug.getOsInfo() : "" %>"
                               placeholder="e.g., Windows 11, macOS 12" maxlength="100">
                    </div>
                </div>

                <!-- Current Screenshot Info -->
                <% if (bug.getScreenshotPath() != null) { %>
                <div class="alert alert-info">
                    <i class="fas fa-image"></i> Current screenshot: 
                    <a href="${pageContext.request.contextPath}/<%= bug.getScreenshotPath() %>" target="_blank">
                        View Screenshot
                    </a>
                    <br>
                    <small class="text-muted">Note: To update screenshot, please contact administrator</small>
                </div>
                <% } %>

                <!-- Form Actions -->
                <div class="d-flex justify-content-between mt-4">
                    <a href="${pageContext.request.contextPath}/bug/view?id=<%= bug.getBugId() %>" 
                       class="btn btn-secondary btn-lg">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
                </div>

                <!-- Warning Note -->
                <div class="alert alert-warning mt-3">
                    <i class="fas fa-exclamation-triangle"></i> 
                    <strong>Note:</strong> Changes will be logged in bug history. Make sure all information is accurate before saving.
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('editBugForm').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const description = document.getElementById('description').value.trim();
            const stepsToReproduce = document.getElementById('stepsToReproduce').value.trim();
            
            if (!title || title.length < 5) {
                e.preventDefault();
                alert('Title must be at least 5 characters long');
                document.getElementById('title').focus();
                return false;
            }
            
            if (!description || description.length < 10) {
                e.preventDefault();
                alert('Description must be at least 10 characters long');
                document.getElementById('description').focus();
                return false;
            }
            
            if (!stepsToReproduce) {
                e.preventDefault();
                alert('Please provide steps to reproduce the bug');
                document.getElementById('stepsToReproduce').focus();
                return false;
            }
            
            // Confirm submission
            return confirm('Are you sure you want to save these changes?');
        });

        // Character counter for textareas
        function addCharacterCounter(elementId, maxLength) {
            const element = document.getElementById(elementId);
            const helpText = element.nextElementSibling;
            
            if (element && helpText) {
                const counter = document.createElement('span');
                counter.className = 'float-end text-muted';
                counter.style.fontSize = '12px';
                
                function updateCounter() {
                    const remaining = maxLength - element.value.length;
                    counter.textContent = remaining + ' characters remaining';
                    
                    if (remaining < 50) {
                        counter.className = 'float-end text-warning';
                    } else if (remaining < 0) {
                        counter.className = 'float-end text-danger';
                    } else {
                        counter.className = 'float-end text-muted';
                    }
                }
                
                helpText.appendChild(counter);
                element.addEventListener('input', updateCounter);
                updateCounter();
            }
        }

        // Add character counters
        addCharacterCounter('title', 200);
        addCharacterCounter('description', 5000);
        addCharacterCounter('stepsToReproduce', 2000);

        // Highlight changed fields
        const formElements = document.querySelectorAll('#editBugForm input, #editBugForm textarea, #editBugForm select');
        const originalValues = new Map();
        
        formElements.forEach(element => {
            if (element.name) {
                originalValues.set(element.name, element.value);
                
                element.addEventListener('change', function() {
                    if (this.value !== originalValues.get(this.name)) {
                        this.classList.add('border-warning');
                        this.style.borderWidth = '2px';
                    } else {
                        this.classList.remove('border-warning');
                        this.style.borderWidth = '';
                    }
                });
            }
        });

        // Auto-save draft (to localStorage)
        let autoSaveTimeout;
        formElements.forEach(element => {
            element.addEventListener('input', function() {
                clearTimeout(autoSaveTimeout);
                autoSaveTimeout = setTimeout(() => {
                    const draftKey = 'bug_edit_draft_<%= bug.getBugId() %>';
                    const formData = {};
                    
                    formElements.forEach(el => {
                        if (el.name) {
                            formData[el.name] = el.value;
                        }
                    });
                    
                    localStorage.setItem(draftKey, JSON.stringify(formData));
                    console.log('Draft saved');
                }, 2000);
            });
        });

        // Clear draft on successful submit
        document.getElementById('editBugForm').addEventListener('submit', function() {
            const draftKey = 'bug_edit_draft_<%= bug.getBugId() %>';
            localStorage.removeItem(draftKey);
        });
    </script>
</body>
</html>