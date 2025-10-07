// src/components/login.jsx
import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import "./login.css";

const Login = () => {
  const [formData, setFormData] = useState({
    email: "",
    password: ""
  });
  const [rememberMe, setRememberMe] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState({});
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({
        ...prev,
        [name]: ""
      }));
    }
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData.email) {
      newErrors.email = "Email is required";
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = "Email is invalid";
    }

    if (!formData.password) {
      newErrors.password = "Password is required";
    } else if (formData.password.length < 6) {
      newErrors.password = "Password must be at least 6 characters";
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!validateForm()) return;

    setIsLoading(true);
    
    // Simulate API call
    try {
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // For demo purposes, always succeed
      console.log("Login successful:", formData);
      
      // Redirect to dashboard or previous page
      navigate("/dashboard");
    } catch (error) {
      setErrors({ submit: "Invalid email or password" });
    } finally {
      setIsLoading(false);
    }
  };

  const handleDemoLogin = () => {
    setFormData({
      email: "demo@laundry.com",
      password: "demo123"
    });
  };

  return (
    <div className="login-page">
      {/* Background Elements */}
      <div className="background-elements">
        <div className="bg-circle circle-1"></div>
        <div className="bg-circle circle-2"></div>
        <div className="bg-circle circle-3"></div>
        <div className="bg-circle circle-4"></div>
      </div>

      {/* Back to Home */}
      <div className="back-button-container">
        <Link to="/" className="back-button">
          <span className="back-arrow">←</span>
          Back to Home
        </Link>
      </div>

      <div className="login-container">
        {/* Left Side - Illustration */}
        <div className="login-left">
          <div className="illustration-container">
            <div className="illustration">
              <div className="icon">🧺</div>
              <div className="sparkle sparkle-1">✨</div>
              <div className="sparkle sparkle-2">✨</div>
              <div className="sparkle sparkle-3">✨</div>
            </div>
            <h2 className="welcome-title">Welcome Back!</h2>
            <p className="welcome-subtitle">
              Sign in to access your laundry services dashboard and manage your orders.
            </p>
            <div className="features-list">
              <div className="feature">
                <span className="feature-icon">✓</span>
                <span>Track your orders</span>
              </div>
              <div className="feature">
                <span className="feature-icon">✓</span>
                <span>Manage services</span>
              </div>
              <div className="feature">
                <span className="feature-icon">✓</span>
                <span>View pricing</span>
              </div>
            </div>
          </div>
        </div>

        {/* Right Side - Login Form */}
        <div className="login-right">
          <div className="login-form-container">
            <div className="form-header">
              <h1 className="form-title">Sign In</h1>
              <p className="form-subtitle">Enter your credentials to access your account</p>
            </div>

            <form onSubmit={handleSubmit} className="login-form">
              {errors.submit && (
                <div className="error-message submit-error">
                  {errors.submit}
                </div>
              )}

              <div className="form-group">
                <label htmlFor="email" className="form-label">
                  Email Address
                </label>
                <input
                  type="email"
                  id="email"
                  name="email"
                  value={formData.email}
                  onChange={handleChange}
                  className={`form-input ${errors.email ? 'error' : ''}`}
                  placeholder="Enter your email"
                />
                {errors.email && (
                  <span className="error-message">{errors.email}</span>
                )}
              </div>

              <div className="form-group">
                <label htmlFor="password" className="form-label">
                  Password
                </label>
                <input
                  type="password"
                  id="password"
                  name="password"
                  value={formData.password}
                  onChange={handleChange}
                  className={`form-input ${errors.password ? 'error' : ''}`}
                  placeholder="Enter your password"
                />
                {errors.password && (
                  <span className="error-message">{errors.password}</span>
                )}
              </div>

              <div className="form-options">
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={rememberMe}
                    onChange={(e) => setRememberMe(e.target.checked)}
                    className="checkbox-input"
                  />
                  <span className="checkmark"></span>
                  Remember me
                </label>
                <Link to="/forgot-password" className="forgot-password">
                  Forgot password?
                </Link>
              </div>

              <button
                type="submit"
                disabled={isLoading}
                className={`login-button ${isLoading ? 'loading' : ''}`}
              >
                {isLoading ? (
                  <>
                    <div className="spinner"></div>
                    Signing In...
                  </>
                ) : (
                  'Sign In'
                )}
              </button>

              <div className="demo-section">
                <button
                  type="button"
                  onClick={handleDemoLogin}
                  className="demo-button"
                >
                  Try Demo Account
                </button>
              </div>

              <div className="divider">
                <span>Or</span>
              </div>

              <div className="signup-link">
                Don't have an account?{" "}
                <Link to="/signup" className="signup-text">
                  Sign up here
                </Link>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Login;