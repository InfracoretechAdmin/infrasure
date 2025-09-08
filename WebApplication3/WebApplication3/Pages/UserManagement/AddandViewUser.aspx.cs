using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3.Pages.UserManagement
{
    public partial class AddandViewUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Clear();
        }
        protected void BtnSave_Click(object sender, EventArgs e)
        {
            BtnSave.Enabled = false;
            BtnEdit.Enabled = true;
            BtnDelete.Enabled = true;
        }
        protected void BtnEdit_Click(object sender, EventArgs e)
        {
            BtnSave.Text = "Update";
            BtnSave.Enabled = true;
            BtnEdit.Enabled = false;
            BtnDelete.Enabled = false;
        }
        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            BtnSave.Enabled = true;
            BtnEdit.Enabled = false;
            BtnDelete.Enabled = false;
        }
        protected void BtnClear_Click(object sender, EventArgs e)
        {
            Clear();
        }
        protected void BtnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("users.aspx");
        }
        private void Clear()
        {
            // Reset buttons
            BtnDelete.Enabled = false;
            BtnEdit.Enabled = false;
            BtnSave.Enabled = true;
            BtnSave.Text = "Save";
        }
    }
}