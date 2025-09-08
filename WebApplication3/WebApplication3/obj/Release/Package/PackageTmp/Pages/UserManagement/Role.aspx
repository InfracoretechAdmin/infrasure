<%@ Page Title="Role List" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Role.aspx.cs" Inherits="WebApplication3.Pages.UserManagement.Role" %>

<asp:Content ID="HeadCss" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%: ResolveUrl("~/Content/search-form.css") %>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>
<asp:Content ID="MainContentRole" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Loader -->
    <div id="loader">
        <div class="spinner"></div>
    </div>
    <!-- ✅ All of your page HTML stays inside here -->
    <div class="rs-card">
        <div class="rs-card__head">
            <h3>Role Management</h3>
            <asp:Button ID="Add" runat="server" class="fa fa-plus" CssClass="rs-btn rs-btn--add rs-btn_add-icon" text="Add" OnClick="Add_Click" OnClientClick="showLoader();"/>
         </div>

        <!-- Search Form -->
        <div class="rs-grid">
            <div class="rs-field">
                <label for="txtRole">Role</label>
                <asp:TextBox ID="txtRole" runat="server" CssClass="rs-input" placeholder="Enter Role" />
            </div>
            <div class="rs-field">
                <label for="txtRemark">Remark</label>
                <asp:TextBox ID="txtRemark" runat="server" CssClass="rs-input" placeholder="Enter Remark" />
            </div>
        <!-- 
            <div class="rs-field">
                <label for="txtDepartment">Department</label>
                <asp:TextBox ID="txtDepartment" runat="server" CssClass="rs-input" placeholder="Enter Department" />
            </div>
            <div class="rs-field">
                <label for="txtStatus">Status</label>
                <asp:TextBox ID="txtStatus" runat="server" CssClass="rs-input" placeholder="Enter Status" />
            </div>
        </div>
       -->
        <!-- Actions -->
        <div class="rs-actions">
            <asp:Button ID="btnSearch" runat="server" CssClass="rs-btn rs-btn--primary rs-btn-primary-icon" Text="Search" OnClick="btnSearch_Click" OnClientClick="showLoader();"/>
            <asp:Button ID="btnClear" runat="server" CssClass="rs-btn rs-btn--warn rs-btn-warn-icon" Text="Clear" OnClick="btnClear_Click" OnClientClick="showLoader();" />
            <asp:Button ID="btnPrint" runat="server" CssClass="rs-btn rs-btn--print rs-btn-print-icon" Text="Print" OnClick="btnPrint_Click" OnClientClick="showLoader();" />
        </div>
    </div>

    <!-- Results Grid -->
    <div class="rs-card">
        <!-- Default GIF -->
        <asp:Image ID="imgDefault" runat="server" ImageUrl="~/Content/Images/No_Records.png" AlternateText="Loading..." CssClass="rs-default-gif" />
                <asp:GridView ID="gvRoles" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered rs-gridview " OnRowCommand="gvRoles_RowCommand" Visible="false">
                    <Columns>
                        <asp:TemplateField HeaderText="View">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnView" runat="server" CommandName="ViewRole" CommandArgument='<%# Eval("RoleID") %>'>
                                    <i class="fa fa-eye"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="RoleName" HeaderText="Role Name" />
                        <asp:BoundField DataField="RoleDescription" HeaderText="Role Description" />
                        <asp:BoundField DataField="CreatedBy" HeaderText="Created By" />
                    </Columns>
                </asp:GridView>

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
</asp:Content>
