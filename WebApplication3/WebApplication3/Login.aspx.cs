using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace WebApplication3
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
            Response.Cache.SetNoStore();
            //Password1.Enabled = false;
            // Already logged in? → redirect to Dashboard
            if (!IsPostBack && Session["UserId"] != null)
            {
                Response.Redirect("~/Pages/Dashboard.aspx");
            }
            BindBuildingDropdown();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string connString = ConfigurationManager.ConnectionStrings["connect"].ToString();

            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();

                // Secure Query (Parameterized)
                string query = @"SELECT UserId, Username, Roleid, BuildingID 
                         FROM sSecurity.tUsers 
                         WHERE Username=@uname AND Password=@pwd";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@uname", UserName1.Text.Trim());
                cmd.Parameters.AddWithValue("@pwd", Password1.Text.Trim());

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    // ✅ User found
                    int userId = Convert.ToInt32(dr["UserId"]);
                    string username = dr["Username"].ToString();
                    string role = dr["Roleid"].ToString();
                    int userBuildingId = Convert.ToInt32(dr["BuildingID"]);

                    dr.Close();

                    int selectedBuildingId = 0;
                    int.TryParse(ddlSearch.SelectedValue, out selectedBuildingId);

                    // Superadmin bypasses
                    if (userId != 1)
                    {
                        // Ensure selected building matches the one in DB
                        if (selectedBuildingId == 0)
                        {
                            string script = "toastr.warning('Please select a building.', 'Access Denied');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "toastr", script, true);
                            return;
                        }
                        else if (selectedBuildingId != userBuildingId)
                        {
                            string script = "toastr.warning('You are not enrolled with the selected building. Contact building admin.', 'Access Denied');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "toastr", script, true);
                            return;
                        }
                    }


                    // ✅ Save to Session
                    Session["UserId"] = userId;
                    Session["Username"] = username;
                    Session["Role"] = role;
                    Session["BuildingId"] = selectedBuildingId;

                    // Save login history
                    SaveLoginHistory(userId, username, con);

                    // Redirect (use returnUrl if provided, else dashboard)
                    string returnUrl = Request.QueryString["returnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl))
                        Response.Redirect(returnUrl);
                    else
                        Response.Redirect("~/Pages/Dashboard.aspx");
                }
                else
                {
                    // ❌ Invalid login → show red toaster
                    string script = "toastr.error('Invalid Username or Password', 'Login Failed');";
                    ScriptManager.RegisterStartupScript(this, GetType(), "toastr", script, true);
                }

                Button1.Text = "Validate OTP and Login";
            }
        }



        private void SaveLoginHistory(int userId, string username, SqlConnection con)
        {
            // Store login history (user, login time, IP)
            string historyQuery = @"INSERT INTO sSecurity.tLoginHistory 
                                    (UserId, Username, AttemptTime, IpAddress, IsSuccessful) 
                                    VALUES (@uid, @uname, @ltime, @ip, @isSuccess)";

            SqlCommand historyCmd = new SqlCommand(historyQuery, con);
            historyCmd.Parameters.AddWithValue("@uid", userId);
            historyCmd.Parameters.AddWithValue("@uname", username);
            historyCmd.Parameters.AddWithValue("@ltime", DateTime.Now);
            historyCmd.Parameters.AddWithValue("@ip", HttpContext.Current.Request.UserHostAddress);
            historyCmd.Parameters.AddWithValue("@isSuccess", true);
            historyCmd.ExecuteNonQuery();
        }
        private void BindBuildingDropdown()
        {
            string connStr = ConfigurationManager.ConnectionStrings["connect"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT Id, BuildingName 
                                 FROM sBuilding.tList
                                 WHERE ActiveFlag = 'Y'
                                 ORDER BY BuildingName";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                ddlSearch.DataSource = dr;
                ddlSearch.DataTextField = "BuildingName"; // Text shown to user
                ddlSearch.DataValueField = "Id";         // Hidden value
                ddlSearch.DataBind();
            }

            // Insert default option on top
            ddlSearch.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Building --", ""));
        }

    }
}
