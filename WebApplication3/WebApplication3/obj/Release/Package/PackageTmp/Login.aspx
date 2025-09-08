<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication3.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>InfraSure Login</title>
    <link rel="stylesheet" href="<%: ResolveUrl("~/Content/login-form.css") %>" />
    <link rel="shortcut icon" href="favicon_i.ico" type="image/x-icon" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />
    <!-- Toastr -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

    <!-- Particles.js Background -->
    <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>
    <script>
        toastr.options = {
            closeButton: true,
            progressBar: true,
            positionClass: "toast-top-right",
            timeOut: "4000"
        };
    </script>
</head>
<body>
    <!-- Particles Background -->
    <div id="particles-js"></div>

    <!-- Loader -->
    <div id="loader" style="display:none;">
        <div class="spinner"></div>
    </div>

    <!-- Login Form -->
    <form runat="server">
        <div class="formclass">
            <h1>
                  <img src="<%: ResolveUrl("~/Media/Login/Login_Logo.png") %>" alt="InfraSure Logo" style="max-width:180px; height:auto; display:block; margin:0 auto;" />
            </h1>
            <h2>Welcome to InfraSure</h2>
            <p>Registered Email</p>
            <asp:TextBox ID="UserName1" CssClass="input" placeholder="User Name" runat="server"></asp:TextBox>
            <p>OTP (One TIme Password)</p>
            <asp:TextBox ID="Password1" CssClass="input" TextMode="Password" placeholder="Enter OTP" runat="server"></asp:TextBox>
            <asp:Button ID="Button1" runat="server" Text="Get One Time Password" OnClick="Button1_Click" CssClass="rs-btn_login rs-btn_login-icon" OnClientClick="showLoader();" />
        </div>
    </form>

    <!-- Footer -->
    <footer>
        <p><b>Licenced No : 1 | Licenced To : Radha Krishna Gold Ornaments Makers | IP Address : Localhost:9680 | Version : 1.0 | Powered By : Suresh Software Solutions</b></p>
        <p><b>Suresh Software's Escalation No : +91 7048314462 | Mail : patrasuresh212@gmail.com</b></p>
    </footer>

    <!-- Loader Script -->
    <script>
        function showLoader() {
            document.getElementById("loader").style.display = "flex";
        }

        window.onload = function () {
            document.getElementById("loader").style.display = "none";
        };
    </script>

    <!-- Particles Config -->
    <script>
        particlesJS("particles-js", {
            particles: {
                number: { value: 50, density: { enable: true, value_area: 800 } },
                color: { value: "#ffffff" },
                shape: { type: "circle" },
                opacity: { value: 0.3, random: true },
                size: { value: 3, random: true },
                move: {
                    enable: true,
                    speed: 1.5,
                    direction: "none",
                    out_mode: "out"
                }
            },
            interactivity: {
                events: {
                    onhover: { enable: true, mode: "repulse" }
                },
                modes: {
                    repulse: { distance: 80, duration: 0.4 }
                }
            },
            retina_detect: true
        });
    </script>
</body>
</html>
