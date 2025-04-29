using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.IO;
using System.Xml.Linq;

namespace Laba4
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.IsAuthenticated)
            {
                Response.Redirect("~/Default.aspx");
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["ReturnUrl"] != null)
                {
                    ErrorPanel.Visible = true;
                    ErrorMessageLiteral.Text = "Для доступа к запрошенной странице необходимо войти в систему.";
                }
            }
        }

        protected void LoginButton_Click(object sender, EventArgs e)
        {
            string username = UsernameTextBox.Text.Trim();
            string password = PasswordTextBox.Text;
            bool rememberMe = RememberMeCheckBox.Checked;

            string role = ValidateUser(username, password);

            if (!string.IsNullOrEmpty(role))
            {
                FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                    1,                              // версия билета
                    username,                       // имя пользователя
                    DateTime.Now,                   // время создания
                    DateTime.Now.AddMinutes(rememberMe ? 2880 : 30), // время окончания (48 часов или 30 минут)
                    rememberMe,                     // флаг persistant cookie
                    role,                           // роль пользователя
                    FormsAuthentication.FormsCookiePath);

                string encryptedTicket = FormsAuthentication.Encrypt(ticket);

                HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
                if (rememberMe)
                    authCookie.Expires = ticket.Expiration;
                
                Response.Cookies.Add(authCookie);

                if (role == "Admin")
                {
                    string returnUrl = Request.QueryString["ReturnUrl"];
                    Response.Redirect(returnUrl ?? "~/AdminCalendar.aspx");
                }
                else
                {
                    Response.Redirect("~/Calendar.aspx");
                }
            }
            else
            {
                ErrorPanel.Visible = true;
                ErrorMessageLiteral.Text = "Неверное имя пользователя или пароль. Попробуйте еще раз.";
            }
        }

        private string ValidateUser(string username, string password)
        {
            string adminUsername = ConfigurationManager.AppSettings["AdminUsername"];
            string adminPassword = ConfigurationManager.AppSettings["AdminPassword"];
            string studentUsername = ConfigurationManager.AppSettings["StudentUsername"];
            string studentPassword = ConfigurationManager.AppSettings["StudentPassword"];

            if (username == adminUsername && password == adminPassword)
            {
                return "Admin";
            }
            else if (username == studentUsername && password == studentPassword)
            {
                return "Student";
            }

            string usersFilePath = Server.MapPath("~/App_Data/Users.xml");
            
            if (File.Exists(usersFilePath))
            {
                try
                {
                    XDocument usersDoc = XDocument.Load(usersFilePath);
                    var userElement = usersDoc.Descendants("User")
                        .FirstOrDefault(u => 
                            u.Element("Username")?.Value == username && 
                            u.Element("Password")?.Value == password);
                    
                    if (userElement != null)
                    {
                        return "Student";
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Ошибка проверки пользователя: {ex.Message}");
                }
            }

            return string.Empty;
        }
    }
} 