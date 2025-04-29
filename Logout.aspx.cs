using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

namespace Laba4
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Очищаем аутентификационный cookie
            FormsAuthentication.SignOut();
            
            // Удаляем все cookies сеанса
            Session.Clear();
            Session.Abandon();
            
            // Очищаем cookie аутентификации в браузере
            HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, "");
            cookie.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(cookie);
            
            // Перенаправляем на главную страницу
            Response.Redirect("~/Default.aspx");
        }
    }
} 