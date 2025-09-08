<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebApplication3.Pages.Dashboard" %>



<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Dashboard CSS -->
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: #f5f7fb;
            color: #333;
        }

        .dashboard {
            display: grid;
            grid-template-columns: 2fr 1fr;
            grid-gap: 20px;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            grid-gap: 20px;
        }

        .card {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .card h4 {
            font-size: 14px;
            color: #666;
        }

        .card h2 {
            margin: 10px 0;
            font-size: 22px;
            font-weight: 600;
        }

        .progress {
            height: 8px;
            border-radius: 8px;
            background: #eee;
            margin-top: 10px;
            overflow: hidden;
        }

        .progress span {
            display: block;
            height: 100%;
            background: #4CAF50;
            width: 0;
        }

        .companies, .candidates {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .companies h3, .candidates h3 {
            font-size: 18px;
            margin-bottom: 15px;
        }

        .company {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }

        .company:last-child {
            border-bottom: none;
        }

        .company-info {
            display: flex;
            flex-direction: column;
        }

        .company-info span {
            font-size: 14px;
            color: #555;
        }

        .company a {
            font-size: 12px;
            color: #4CAF50;
            text-decoration: none;
        }

        .applications {
            margin-top: 20px;
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .applications-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .applications-header div {
            text-align: center;
        }

        .applications-header div h2 {
            font-size: 18px;
        }

        .candidate {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }

        .candidate:last-child {
            border-bottom: none;
        }

        .candidate img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 12px;
        }

        .candidate span {
            font-weight: 500;
        }
    </style>
    <!-- Dashboard Content -->
    <div class="dashboard">

        <!-- Left Section -->
        <div>
            <!-- Stats -->
            <div class="stats">
                <div class="card">
                    <h4>Total Jobs</h4>
                    <h2>36,894</h2>
                    <div class="progress"><span style="width:95%;background:#4caf50"></span></div>
                </div>
                <div class="card">
                    <h4>Applied Jobs</h4>
                    <h2>28,410</h2>
                    <div class="progress"><span style="width:97%;background:#4caf50"></span></div>
                </div>
                <div class="card">
                    <h4>New Jobs</h4>
                    <h2>4,305</h2>
                    <div class="progress"><span style="width:80%;background:#2196f3"></span></div>
                </div>
                <div class="card">
                    <h4>Interviews</h4>
                    <h2>5,021</h2>
                    <div class="progress"><span style="width:89%;background:#ff5722"></span></div>
                </div>
                <div class="card">
                    <h4>Hired</h4>
                    <h2>3,948</h2>
                    <div class="progress"><span style="width:64%;background:#8bc34a"></span></div>
                </div>
                <div class="card">
                    <h4>Rejected</h4>
                    <h2>1,340</h2>
                    <div class="progress"><span style="width:20%;background:#f44336"></span></div>
                </div>
            </div>

            <!-- Applications Statistic -->
            <div class="applications">
                <div class="applications-header">
                    <div>
                        <h2>3,364</h2>
                        <p>New Applications</p>
                    </div>
                    <div>
                        <h2>2,804</h2>
                        <p>Interview</p>
                    </div>
                    <div>
                        <h2>2,402</h2>
                        <p>Hired</p>
                    </div>
                    <div>
                        <h2>8k</h2>
                        <p>Total Applications</p>
                    </div>
                </div>
                <img src="https://dummyimage.com/600x200/eeeeee/aaa" alt="Graph" width="100%">
            </div>
        </div>

        <!-- Right Section -->
        <div>
            <!-- Featured Companies -->
            <div class="companies">
                <h3>Featured Companies</h3>
                <div class="company">
                    <div class="company-info">
                        <strong>Force Medicines</strong>
                        <span>Cullera, Spain</span>
                    </div>
                    <a href="#">View More →</a>
                </div>
                <div class="company">
                    <div class="company-info">
                        <strong>Syntyce Solutions</strong>
                        <span>Mughairah, UAE</span>
                    </div>
                    <a href="#">View More →</a>
                </div>
                <div class="company">
                    <div class="company-info">
                        <strong>Moetic Fashion</strong>
                        <span>Mughairah, UAE</span>
                    </div>
                    <a href="#">View More →</a>
                </div>
            </div>

            <!-- Popular Candidates -->
            <div class="candidates" style="margin-top:20px;">
                <h3>Popular Candidates</h3>
                <div class="candidate">
                    <img src="https://i.pravatar.cc/40?img=1" alt="">
                    <span>Tonya Noble</span>
                </div>
                <div class="candidate">
                    <img src="https://i.pravatar.cc/40?img=2" alt="">
                    <span>Nicholas Ball</span>
                </div>
                <div class="candidate">
                    <img src="https://i.pravatar.cc/40?img=3" alt="">
                    <span>Zynthia Marrow</span>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
