<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BuildingAllDetails.aspx.cs" Inherits="WebApplication3.Pages.BuildingManagement.BuildingAllDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%: ResolveUrl("~/Content/Details_page.css") %>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <!-- Sidebar -->
  <div class="student-sidebar">
    <h2>Jivan Joshi | 1वी B [10033]</h2>
    <ul class="menu">
      <li class="active">Overview</li>
      <li>Student Detail</li>
      <li>Fee</li>
      <li>Attendance</li>
      <li>Assessment</li>
      <li>Certificate</li>
      <li>Charge</li>
      <li>Deposit</li>
      <li>Photos & Documents</li>
      <li>Alert</li>
      <li>Hostel</li>
    </ul>
  </div>

  <!-- Main Content -->
  <div class="page-wrapper">
    <div class="profile">
      <div class="info">
        <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" alt="student">
        <div class="details">
          <h3>Kaushik Joshi</h3>
          <p>Code: 100033 | Class: 1वी / B</p>
          <p>Gender: Male | DOB: 16/01/2017</p>
          <p>Status: Active</p>
        </div>
      </div>
      <div class="barcode">
        <img src="https://api.qrserver.com/v1/create-qr-code/?size=80x80&data=TTT000602" alt="QR Code">
        <p>TTT000602</p>
      </div>
    

    <!-- Cards -->
    <div class="cards">
      <div class="card">
        <h3>Contact Detail</h3>
        <p>Father: Joshi</p>
        <p>Phone: 9726398224</p>
      </div>

      <div class="card">
        <h3>Attendance Detail</h3>
        <p>Total Present: 11</p>
        <p>Total Days: 15</p>
        <p>Percentage: 73.33%</p>
      </div>

      <div class="card">
        <h3>Fee Detail</h3>
        <p>Paid: 0</p>
        <p>Pending: 1000</p>
        <p>Total: 1000</p>
        <a href="#" class="btn">Pay Offline</a>
        <a href="#" class="btn">Pay Online</a>
      </div>

      <div class="card">
        <h3>Deposit Detail</h3>
        <p>Credit: 0</p>
        <p>Debit: 0</p>
        <p>Balance: 0</p>
      </div>

      <div class="card">
        <h3>Transport Detail</h3>
        <p>Pickup Route: 2</p>
        <p>Pickup Point: 6</p>
        <p>Drop Route: 2</p>
      </div>

      <div class="card">
        <h3>Hostel Detail</h3>
        <p>Room No: -</p>
        <p>Select Hostel</p>
      </div>
    </div>
        </div>
  </div>

</asp:Content>
