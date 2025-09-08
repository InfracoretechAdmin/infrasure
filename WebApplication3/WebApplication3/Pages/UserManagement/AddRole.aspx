<%@ Page Title="Add || Update Role" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddRole.aspx.cs" Inherits="WebApplication3.Pages.UserManagement.AddRole" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%: ResolveUrl("~/Content/add-form.css") %>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Loader -->
    <div id="loader">
        <div class="spinner"></div>
    </div>

    <!-- JS Libraries -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>

    <!-- Toastr Config -->
    <script>
        toastr.options = {
            closeButton: true,
            progressBar: true,
            positionClass: "toast-top-right",
            timeOut: "4000"
        };
    </script>

    <!-- Loader Functions -->
    <script>
        function showLoader() {
            document.getElementById("loader").style.display = "flex";
        }

        window.onload = function () {
            document.getElementById("loader").style.display = "none";
        };
    </script>

    <!-- Particles Background -->
    <div id="particles-js"></div>
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
                events: { onhover: { enable: true, mode: "repulse" } },
                modes: { repulse: { distance: 80, duration: 0.4 } }
            },
            retina_detect: true
        });
    </script>

    <!-- Card Header -->
    <div class="rs-card">
        <div class="rs-card__head">
            <div class="rs-card__head_left">
                <h3>Add New Role</h3>
            </div>
            <div class="rs-card__head_right">
                <asp:Button ID="BtnSave" runat="server" CssClass="rs-btn rs-btn--save rs-btn_save-icon" Text="Save" OnClick="BtnSave_Click" OnClientClick="return validateForm();" />
                <asp:Button ID="BtnEdit" runat="server" CssClass="rs-btn rs-btn--edit rs-btn_edit-icon" Text="Edit" OnClick="BtnEdit_Click" OnClientClick="showLoader();" />
                <asp:Button ID="BtnDelete" runat="server" CssClass="rs-btn rs-btn--delete rs-btn_delete-icon" Text="Delete" OnClick="BtnDelete_Click" OnClientClick="showLoader();" />
                <asp:Button ID="BtnClear" runat="server" CssClass="rs-btn rs-btn--clear rs-btn_clear-icon" Text="Clear" OnClick="BtnClear_Click" OnClientClick="showLoader();" />
                <asp:Button ID="BtnBack" runat="server" CssClass="rs-btn rs-btn--back rs-btn_back-icon" Text="Back" OnClick="BtnBack_Click" OnClientClick="showLoader();" />
            </div>
        </div>
    </div>

    <!-- Form Fields -->
    <div class="rs-card">
        <div class="rs-grid">
            <div class="rs-field">
                <label for="rolename">Role Name</label>
                <asp:TextBox ID="rolename" runat="server" CssClass="rs-input" placeholder="Enter Role Name" />
            </div>

            <div class="rs-field">
                <label for="roledescription">Role Description</label>
                <asp:TextBox ID="roledescription" runat="server" CssClass="rs-input" placeholder="Enter Role Description" />
            </div>
            <asp:HiddenField ID="txtRole" runat="server" />
        </div>
    </div>

    <!-- Custom Validation Script -->
    <script>
        function validateForm() {
            var roleName = document.getElementById('<%= rolename.ClientID %>').value.trim();
            if (roleName === "") {
                toastr.error("Role Name is required.");
                return false; // prevent postback
            }
            showLoader();
            return true;
        }
    </script>
</asp:Content>
