using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Data;  // Add this

namespace WebApplication3
{
    public partial class SiteMaster : MasterPage
    {
        private const string AntiXsrfTokenKey = "__AntiXsrfToken";
        private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
        private string _antiXsrfTokenValue;

        protected void Page_Init(object sender, EventArgs e)
        {
            // Anti-XSRF Protection
            var requestCookie = Request.Cookies[AntiXsrfTokenKey];
            Guid requestCookieGuidValue;
            if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
            {
                _antiXsrfTokenValue = requestCookie.Value;
                Page.ViewStateUserKey = _antiXsrfTokenValue;
            }
            else
            {
                _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
                Page.ViewStateUserKey = _antiXsrfTokenValue;

                var responseCookie = new HttpCookie(AntiXsrfTokenKey)
                {
                    HttpOnly = true,
                    Value = _antiXsrfTokenValue
                };
                if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
                {
                    responseCookie.Secure = true;
                }
                Response.Cookies.Set(responseCookie);
            }

            Page.PreLoad += master_Page_PreLoad;
        }

        protected void master_Page_PreLoad(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
                ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
            }
            else
            {
                if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                    || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
                {
                    throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var menuItems = GetMenuItems();
                litMenu.Text = BuildMenuHtml(menuItems, null);

                        // 🔽 Bind Building Dropdown
        BindBuildingDropdown();
            }
        }

        // ===== MENU MODEL =====
        public class MenuItem
        {
            public int MenuID { get; set; }
            public int? ParentMenuID { get; set; }
            public string MenuText { get; set; }
            public string MenuURL { get; set; }
            public string IconClass { get; set; }
            public int SortOrder { get; set; }
        }

        // ===== FETCH MENUS =====
        private List<MenuItem> GetMenuItems()
        {
            List<MenuItem> menuItems = new List<MenuItem>();
            string connStr = ConfigurationManager.ConnectionStrings["connect"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT MenuID, ParentMenuID, MenuText, MenuURL, IconClass, SortOrder 
                                 FROM sMaster.tmenus ORDER BY SortOrder";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    menuItems.Add(new MenuItem
                    {
                        MenuID = Convert.ToInt32(dr["MenuID"]),
                        ParentMenuID = dr["ParentMenuID"] != DBNull.Value ? (int?)Convert.ToInt32(dr["ParentMenuID"]) : null,
                        MenuText = dr["MenuText"].ToString(),
                        MenuURL = dr["MenuURL"] != DBNull.Value ? "/pages/" + dr["MenuURL"].ToString().TrimStart('/') : "/PageURLNotFound.aspx",
                        IconClass = dr["IconClass"] != DBNull.Value ? dr["IconClass"].ToString() : "glyphicon glyphicon-circle-arrow-right",
                        SortOrder = Convert.ToInt32(dr["SortOrder"])
                    });
                }
            }
            return menuItems;
        }

        // ===== BUILD MENU HTML =====
        private string BuildMenuHtml(List<MenuItem> menuItems, int? parentId)
        {
            var filtered = menuItems.Where(m => m.ParentMenuID == parentId).OrderBy(m => m.SortOrder).ToList();
            if (!filtered.Any()) return "";

            string html = "<ul>";

            foreach (var item in filtered)
            {
                var children = menuItems.Where(m => m.ParentMenuID == item.MenuID).ToList();
                if (children.Any()) // parent
                {
                    html += $"<li class='has-submenu'>" +
                            $"<a class='submenu-toggle'><i class='{item.IconClass}'></i> {item.MenuText} <span class='arrow'>▶</span></a>";
                    html += BuildMenuHtml(menuItems, item.MenuID);
                    html += "</li>";
                }
                else // leaf
                {
                    html += $"<li><a href='{item.MenuURL}'><i class='{item.IconClass}'></i> {item.MenuText}</a></li>";
                }
            }

            html += "</ul>";
            return html;
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

    protected void lnkLogout_Click(object sender, EventArgs e)
        {
            // Clear session
            Session.Clear();
            Session.Abandon();

            // Optional: clear authentication cookie if you are using Forms Auth
            if (Request.Cookies[".ASPXAUTH"] != null)
            {
                HttpCookie myCookie = new HttpCookie(".ASPXAUTH");
                myCookie.Expires = DateTime.Now.AddDays(-1d);
                Response.Cookies.Add(myCookie);
            }

            // Redirect to login page
            Response.Redirect("~/Login.aspx");
        }
    }
}
