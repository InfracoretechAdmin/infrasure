<%@ Page Title="User List" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="WebApplication3.Pages.User_Management.Users" %>
<asp:Content ID="HeadCss" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%: ResolveUrl("~/Content/search-form.css") %>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>
<asp:Content ID="MainContentRole" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Loader -->
    <div id="loader">
        <div class="spinner"></div>
    </div>
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
    <script type="text/javascript">
        function showLoader() {
            document.getElementById("loader").style.display = "flex";
        }

        // Show loader while loading
        document.onreadystatechange = function () {
            if (document.readyState !== "complete") {
                document.getElementById("loader").style.display = "flex";
            } else {
                document.getElementById("loader").style.display = "none";
            }
        };
    </script>
    <!-- ✅ All of your page HTML stays inside here -->
    <div class="rs-card">
        <div class="rs-card__head">
            <h3>User List</h3>
            <asp:Button ID="Add" runat="server" class="fa fa-plus" CssClass="rs-btn rs-btn--add rs-btn_add-icon" text="Add" OnClick="Add_Click" OnClientClick="showLoader();"/>
         </div>
        
        <!-- Search Form -->
        <div class="rs-grid">
            <div class="rs-field">
                <label for="txtRole">Search Field 1</label>
                <asp:TextBox ID="txtRole" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>
            <div class="rs-field">
                <label for="txtRemark">Search Field 2</label>
                <asp:TextBox ID="txtRemark" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>
            <div class="rs-field">
                <label for="txtRemark">Search Field 3</label>
                <asp:TextBox ID="TextBox1" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>
            <div class="rs-field">
                <label for="txtRemark">Search Field 3</label>
                <asp:TextBox ID="TextBox2" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>
         </div>
        <!-- Actions -->
        <div class="rs-actions">
            <asp:Button ID="btnSearch" runat="server" CssClass="rs-btn rs-btn--primary rs-btn-primary-icon" Text="Search" OnClientClick="showLoader();" />
            <asp:Button ID="btnClear" runat="server" CssClass="rs-btn rs-btn--warn rs-btn-warn-icon" Text="Clear" OnClientClick="showLoader();" />
        </div>
    </div>
    <div class="rs-card">
        <!-- Default GIF -->
        <asp:Image ID="imgDefault" runat="server" ImageUrl="~/Media/Common/NoRecordVector.png" AlternateText="Loading..." CssClass="rs-default-gif" />
     </div>
</asp:Content>