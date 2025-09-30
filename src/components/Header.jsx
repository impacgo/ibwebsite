// src/components/Header.jsx
import React, { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import './Header.css';
import logo from "../images/logo1.svg" // Add your logo file

const Header = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isScrolled, setIsScrolled] = useState(false);
  const location = useLocation();

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 50);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  const closeMenu = () => {
    setIsMenuOpen(false);
  };

  const isActiveLink = (path) => {
    return location.pathname === path ? 'active' : '';
  };

  return (
    <header className={`header ${isScrolled ? 'scrolled' : ''}`}>
      <div className="header-container">
        <div className="header-content">
          {/* Logo and Name in same line */}
          <Link to="/" className="logo" onClick={closeMenu}>
            <img src={logo} alt="Ironing Boy" className="logo-image" />
            <div className="logo-text">
              <span className="logo-name">IroningBoy LTD</span>
            </div>
          </Link>

          {/* Navigation */}
          <nav className={isMenuOpen ? 'active' : ''}>
            <ul className="nav-list">
              <li className="nav-item">
                <Link 
                  to="/" 
                  className={`nav-link ${isActiveLink('/')}`}
                  onClick={closeMenu}
                >
                  <i className="fas fa-home"></i>
                  Home
                </Link>
              </li>
              <li className="nav-item">
                <Link 
                  to="/services" 
                  className={`nav-link ${isActiveLink('/services')}`}
                  onClick={closeMenu}
                >
                  <i className="fas fa-concierge-bell"></i>
                  Services
                </Link>
              </li>
              <li className="nav-item">
                <Link 
                  to="/pricing" 
                  className={`nav-link ${isActiveLink('/pricing')}`}
                  onClick={closeMenu}
                >
                  <i className="fas fa-tag"></i>
                  Pricing
                </Link>
              </li>
              <li className="nav-item">
                <Link 
                  to="/testimonials" 
                  className={`nav-link ${isActiveLink('/testimonials')}`}
                  onClick={closeMenu}
                >
                  <i className="fas fa-star"></i>
                  Testimonials
                </Link>
              </li>
              <li className="nav-item">
                <Link 
                  to="/faq" 
                  className={`nav-link ${isActiveLink('/faq')}`}
                  onClick={closeMenu}
                >
                  <i className="fas fa-question-circle"></i>
                  FAQ
                </Link>
              </li>
              <li className="nav-item mobile-only">
                <Link 
                  to="/login" 
                  className={`nav-link login-btn-mobile ${isActiveLink('/login')}`}
                  onClick={closeMenu}
                >
                  <i className="fas fa-user"></i>
                  Login
                </Link>
              </li>
            </ul>
          </nav>

          {/* Desktop Login */}
          <Link 
            to="/login" 
            className={`login-btn desktop-only ${isActiveLink('/login')}`}
          >
            <i className="fas fa-user"></i>
            <span>Guest</span>
          </Link>

          {/* Mobile Menu Toggle */}
          <button 
            className={`mobile-menu-toggle ${isMenuOpen ? 'active' : ''}`}
            onClick={toggleMenu}
            aria-label="Toggle menu"
          >
            <span></span>
            <span></span>
            <span></span>
          </button>
        </div>
      </div>
    </header>
  );
};

export default Header;