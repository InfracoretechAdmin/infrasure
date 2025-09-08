<%@ Page Title="Add || View User" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddandViewUser.aspx.cs" Inherits="WebApplication3.Pages.UserManagement.AddandViewUser" %>
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
    <script>
    $(document).ready(function () {
        loadUsers();
    });

    function loadUsers() {
        $.ajax({
            url: '<%= ResolveUrl("~/api/users") %>',  // FIXED
            method: 'GET',
            success: function (data) {
                renderUserTable(data);
            },
            error: function (xhr) {
                toastr.error('Failed to load users. ' + xhr.statusText);
            }
        });
    }
    function renderUserTable(users) {
        var html = '<table class="rs-table"><thead><tr><th>ID</th><th>Username</th><th>Full Name</th><th>Email</th><th>Mobile</th><th>Actions</th></tr></thead><tbody>';
        users.forEach(function (u) {
            html += '<tr>' +
                    '<td>' + u.userid + '</td>' +
                    '<td>' + (u.username || '') + '</td>' +
                    '<td>' + (u.fullname || '') + '</td>' +
                    '<td>' + (u.email || '') + '</td>' +
                    '<td>' + (u.mobileno || '') + '</td>' +
                    '<td>' +
                        '<button onclick="editUser(' + u.userid + ')">Edit</button> ' +
                        '<button onclick="deleteUser(' + u.userid + ')">Delete</button>' +
                    '</td>' +
                    '</tr>';
        });
        html += '</tbody></table>';
        $('#usersContainer').html(html);
    }

    function addUser() {
        var user = {
            username: $('#<%= rolename.ClientID %>').val(),
            fullname: $('#<%= roledescription.ClientID %>').val(),
            email: $('#<%= TextBox1.ClientID %>').val(),
            mobileno: $('#<%= TextBox2.ClientID %>').val(),
            // passwordHash should be created server-side; here we pass plain only for example (NOT recommended)
            passwordHash: $('#<%= TextBox3.ClientID %>').val(),
            roleId: parseInt($('#<%= DropDownList1.ClientID %>').val() || 0)
        };

        $.ajax({
            url: '/api/users',
            method: 'POST',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify(user),
            success: function () {
                toastr.success('User added.');
                loadUsers();
            },
            error: function () {
                toastr.error('Error adding user.');
            }
        });
    }

    function editUser(id) {
        $.ajax({
            url: '/api/users/' + id,
            method: 'GET',
            success: function (u) {
                // populate the form fields. Use a hidden field to store editing id
                $('#<%= rolename.ClientID %>').val(u.username);
                $('#<%= roledescription.ClientID %>').val(u.fullname);
                $('#<%= TextBox1.ClientID %>').val(u.email);
                $('#<%= TextBox2.ClientID %>').val(u.mobileno);
                $('#<%= DropDownList1.ClientID %>').val(u.roleId);

                $('#hiddenEditingId').val(u.userid);
                // change Save button to call updateUser
                $('#<%= BtnSave.ClientID %>').off('click').on('click', function (e) {
                    e.preventDefault();
                    updateUser();
                });
            },
            error: function () { toastr.error('Failed to load user.'); }
        });
    }

    function updateUser() {
        var id = parseInt($('#hiddenEditingId').val());
        var user = {
            username: $('#<%= rolename.ClientID %>').val(),
            fullname: $('#<%= roledescription.ClientID %>').val(),
            email: $('#<%= TextBox1.ClientID %>').val(),
            mobileno: $('#<%= TextBox2.ClientID %>').val(),
            roleId: parseInt($('#<%= DropDownList1.ClientID %>').val() || 0)
        };

        $.ajax({
            url: '/api/users/' + id,
            method: 'PUT',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify(user),
            success: function () {
                toastr.success('User updated.');
                loadUsers();
                // restore Save button behavior if needed
            },
            error: function () { toastr.error('Failed to update.'); }
        });
    }

    function deleteUser(id) {
        if (!confirm('Delete user ID ' + id + '?')) return;
        $.ajax({
            url: '/api/users/' + id,
            method: 'DELETE',
            success: function () {
                toastr.success('Deleted.');
                loadUsers();
            },
            error: function () { toastr.error('Failed to delete.'); }
        });
    }
</script>
    <div class="rs-card">
        <div class="rs-card__head">
            <div class="rs-card__head_left">
                <h3>Add || View User</h3>
            </div>
            <div class="rs-card__head_right">
                <asp:Button ID="BtnSave" runat="server" CssClass="rs-btn rs-btn--save rs-btn_save-icon" Text="Save" OnClick="BtnSave_Click"  OnClientClick="return validateForm();" />
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
                <label for="rolename">Input Field 1</label>
                <asp:TextBox ID="rolename" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>

            <div class="rs-field">
                <label for="roledescription">Input Field 1</label>
                <asp:TextBox ID="roledescription" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>

            <div class="rs-field">
                <label for="roledescription">Input Field 1</label>
                <asp:TextBox ID="TextBox1" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>

            <div class="rs-field">
                <label for="roledescription">Input Field 1</label>
                <asp:TextBox ID="TextBox2" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>

            <div class="rs-field">
                <label for="roledescription">Input Field 1</label>
                <asp:TextBox ID="TextBox3" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>

            <div class="rs-field">
                <label for="roledescription">Input Field 1</label>
                <asp:TextBox ID="TextBox4" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>

            <div class="rs-field">
                <label for="roledescription">Input Field 1</label>
                <asp:TextBox ID="TextBox5" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>

            <div class="rs-field">
                <label for="roledescription">Input Field 1</label>
                <asp:TextBox ID="TextBox6" runat="server" CssClass="rs-input" placeholder="Enter Details" />
            </div>
            
            <div class="rs-field">
                <label for="roledescription">Input Field 1</label>
                <asp:DropDownList ID="DropDownList1" runat="server" CssClass="rs-input" ></asp:DropDownList>
            </div>
        </div>
    </div>
    <!-- container for the table -->
    <div id="usersContainer"></div>
    <!-- hidden field to hold editing id -->
    <input type="hidden" id="hiddenEditingId" runat="server" />
</asp:Content>
