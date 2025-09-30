// src/App.js
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Header from './components/Header';
import Hero from './components/Hero';
import Services from './components/Services'; // Your existing Services component
import HowItWorks from './components/HowItWorks';
import Pricing from './components/Pricing';
import Testimonials from './components/Testimonials';
import FAQ from './components/FAQ';
import Contact from './components/Contact';
import Footer from './components/Footer';
import TotalPricing from './components/totalpricing';
import './App.css';
import SearchResults from './components/SearchResults';
import Login from './Login';
import BackgroundWrapper from './components/BackgroundWrapper';

// Home component that contains all your sections
const Home = () => {
  return (
    <>
      <Hero />
      <Services /> {/* This shows the compact version on home page */}
      <HowItWorks />
      <Pricing />
      <Testimonials />
      <FAQ />
      <Contact />
      <Footer />
    </>
  );
};

// Services page component - uses your existing Services.jsx but as full page
const ServicesPage = () => {
  return (
    <div className="page-container">
      <Services /> {/* Your existing Services component */}
      <Footer/>
    </div>
  );
};

// Pricing page component
const PricingPage = () => {
  return (
    <div className="page-container">
      <TotalPricing />
      <Footer />
    </div>
  );
};

// Back button component


// Placeholder components for other pages (you can enhance these later)
const HowItWorksPage = () => (
  <div className="page-container">
    <Login />
  </div>
);

const TestimonialsPage = () => (
  <div className="page-container">
    <Testimonials />
  </div>
);

const FAQPage = () => (
  <div className="page-container">
    <FAQ />
    <Footer/>
  </div>
);

const ContactPage = () => (
  <div className="page-container">
    <Contact />
  </div>
);
function App() {
  return (
    <Router>
      <div className="App">
        <Header />
        <Routes>
          {/* Home route - shows all sections */}
          <Route path="/" element={<Home />} />
          
          {/* Individual page routes */}
          <Route path="/services" element={<ServicesPage />} />
          <Route path="/pricing" element={<PricingPage />} />
          <Route path="/how-it-works" element={<HowItWorksPage />} />
          <Route path="/testimonials" element={<TestimonialsPage />} />
          <Route path="/faq" element={<FAQPage />} />
          <Route path="/contact" element={<ContactPage />} />
          <Route path="/search" element={<SearchResults />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;