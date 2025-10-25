<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Bug Tracking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0;
        }
        .register-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
            width: 100%;
            max-width: 600px;
            margin: 20px auto;
        }
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .register-header i {
            font-size: 50px;
            color: #667eea;
            margin-bottom: 15px;
        }
        .register-header h2 {
            color: #333;
            font-weight: 600;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
        }
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        .alert {
            border-radius: 10px;
        }
        .required:after {
            content: " *";
            color: red;
        }
        .password-strength {
            height: 5px;
            margin-top: 5px;
            border-radius: 3px;
            transition: all 0.3s;
        }
        .strength-weak { background-color: #dc3545; width: 33%; }
        .strength-medium { background-color: #ffc107; width: 66%; }
        .strength-strong { background-color: #28a745; width: 100%; }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <i class="fas fa-user-plus"></i>
            <h2>Create Account</h2>
            <p class="text-muted">Join our Bug Tracking System</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm" onsubmit="return validateForm()">
            <div class="row">
                <!-- Username -->
                <div class="col-md-12 mb-3">
                    <label for="username" class="form-label required">Username</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                        <input type="text" class="form-control" id="username" name="username" 
                               placeholder="Choose a username" required minlength="4" maxlength="50"
                               pattern="[a-zA-Z0-9_]+" title="Username can only contain letters, numbers, and underscore">
                    </div>
                    <small class="text-muted">4-50 characters, letters, numbers, and underscore only</small>
                </div>

                <!-- Full Name -->
                <div class="col-md-12 mb-3">
                    <label for="fullName" class="form-label required">Full Name</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                        <input type="text" class="form-control" id="fullName" name="fullName" 
                               placeholder="Enter your full name" required maxlength="100">
                    </div>
                </div>

                <!-- Email -->
                <div class="col-md-12 mb-3">
                    <label for="email" class="form-label required">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                        <input type="email" class="form-control" id="email" name="email" 
                               placeholder="your.email@example.com" required maxlength="100">
                    </div>
                </div>

                <!-- Phone -->
                <div class="col-md-12 mb-3">
                    <label for="phone" class="form-label">Phone Number</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-phone"></i></span>
                        <input type="tel" class="form-control" id="phone" name="phone" 
                               placeholder="10-digit phone number" pattern="[0-9]{10}" maxlength="15">
                    </div>
                    <small class="text-muted">Optional - 10 digits</small>
                </div>

                <!-- Role -->
                <div class="col-md-12 mb-3">
                    <label for="role" class="form-label required">Register As</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                        <select class="form-select" id="role" name="role" required>
                            <option value="">Select Role</option>
                            <option value="Customer" selected>Customer - Report and track bugs</option>
                            <option value="Developer">Developer - Fix bugs</option>
                        </select>
                    </div>
                    <small class="text-muted">Note: Admin accounts are created by system administrators</small>
                </div>

                <!-- Password -->
                <div class="col-md-6 mb-3">
                    <label for="password" class="form-label required">Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Create password" required minlength="6" maxlength="50"
                               onkeyup="checkPasswordStrength()">
                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('password')">
                            <i class="fas fa-eye" id="password-eye"></i>
                        </button>
                    </div>
                    <div class="password-strength" id="password-strength"></div>
                    <small class="text-muted" id="strength-text">Minimum 6 characters</small>
                </div>

                <!-- Confirm Password -->
                <div class="col-md-6 mb-3">
                    <label for="confirmPassword" class="form-label required">Confirm Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                               placeholder="Confirm password" required minlength="6" maxlength="50">
                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('confirmPassword')">
                            <i class="fas fa-eye" id="confirmPassword-eye"></i>
                        </button>
                    </div>
                    <small class="text-danger" id="password-match-error" style="display: none;">
                        Passwords do not match
                    </small>
                </div>

                <!-- Terms and Conditions -->
                <div class="col-md-12 mb-3">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="terms" required>
                        <label class="form-check-label" for="terms">
                            I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Terms and Conditions</a>
                        </label>
                    </div>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary btn-register w-100">
                <i class="fas fa-user-plus"></i> Create Account
            </button>
        </form>

        <!-- Login Link -->
        <div class="text-center mt-4">
            <p class="text-muted">Already have an account? 
                <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">
                    Login here
                </a>
            </p>
        </div>
    </div>

    <!-- Terms and Conditions Modal -->
    <div class="modal fade" id="termsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Terms and Conditions</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h6>1. Acceptance of Terms</h6>
                    <p>By accessing and using this Bug Tracking System, you accept and agree to be bound by these terms.</p>
                    
                    <h6>2. User Responsibilities</h6>
                    <p>Users are responsible for maintaining the confidentiality of their account credentials and for all activities under their account.</p>
                    
                    <h6>3. Data Usage</h6>
                    <p>We collect and use your data to provide bug tracking services. Your information will not be shared with third parties without consent.</p>
                    
                    <h6>4. Acceptable Use</h6>
                    <p>Users must use the system for legitimate bug reporting and tracking purposes only. Misuse may result in account termination.</p>
                    
                    <h6>5. Privacy</h6>
                    <p>We are committed to protecting your privacy. All bug reports and personal information are stored securely.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle password visibility
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const eye = document.getElementById(fieldId + '-eye');
            
            if (field.type === 'password') {
                field.type = 'text';
                eye.classList.remove('fa-eye');
                eye.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                eye.classList.remove('fa-eye-slash');
                eye.classList.add('fa-eye');
            }
        }

        // Check password strength
        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthBar = document.getElementById('password-strength');
            const strengthText = document.getElementById('strength-text');
            
            let strength = 0;
            
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            
            strengthBar.className = 'password-strength';
            
            if (strength <= 2) {
                strengthBar.classList.add('strength-weak');
                strengthText.textContent = 'Weak password';
                strengthText.className = 'text-danger';
            } else if (strength <= 3) {
                strengthBar.classList.add('strength-medium');
                strengthText.textContent = 'Medium strength';
                strengthText.className = 'text-warning';
            } else {
                strengthBar.classList.add('strength-strong');
                strengthText.textContent = 'Strong password';
                strengthText.className = 'text-success';
            }
        }

        // Validate form before submission
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const errorElement = document.getElementById('password-match-error');
            
            if (password !== confirmPassword) {
                errorElement.style.display = 'block';
                document.getElementById('confirmPassword').classList.add('is-invalid');
                return false;
            }
            
            errorElement.style.display = 'none';
            document.getElementById('confirmPassword').classList.remove('is-invalid');
            return true;
        }

        // Real-time password match validation
        document.getElementById('confirmPassword').addEventListener('keyup', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            const errorElement = document.getElementById('password-match-error');
            
            if (confirmPassword && password !== confirmPassword) {
                errorElement.style.display = 'block';
                this.classList.add('is-invalid');
            } else {
                errorElement.style.display = 'none';
                this.classList.remove('is-invalid');
                if (confirmPassword && password === confirmPassword) {
                    this.classList.add('is-valid');
                }
            }
        });

        // Username validation (real-time)
        document.getElementById('username').addEventListener('input', function() {
            const username = this.value;
            const pattern = /^[a-zA-Z0-9_]+$/;
            
            if (username && !pattern.test(username)) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
                if (username.length >= 4) {
                    this.classList.add('is-valid');
                }
            }
        });

        // Phone number formatting
        document.getElementById('phone').addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>
</body>
</html>