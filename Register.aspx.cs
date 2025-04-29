using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Xml.Linq;
using System.Web.Security;

namespace Laba4
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Если пользователь уже аутентифицирован, перенаправляем на главную страницу
            if (Request.IsAuthenticated)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void RegisterButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string username = UsernameTextBox.Text.Trim();
                string email = EmailTextBox.Text.Trim();
                string password = PasswordTextBox.Text;
                string fullName = FullNameTextBox.Text.Trim();
                string studentId = StudentIdTextBox.Text.Trim();

                // Проверяем, существует ли уже такой пользователь
                if (UserExists(username, email))
                {
                    ShowErrorMessage("Пользователь с таким именем или email уже существует.");
                    return;
                }

                // Проверяем, не используется ли уже такой студенческий ID
                if (StudentIdExists(studentId))
                {
                    ShowErrorMessage("Студенческий ID уже зарегистрирован в системе.");
                    return;
                }

                // Создаем XML-файл пользователей, если его еще нет
                string usersFilePath = Server.MapPath("~/App_Data/Users.xml");
                XDocument usersDoc;

                if (File.Exists(usersFilePath))
                {
                    usersDoc = XDocument.Load(usersFilePath);
                }
                else
                {
                    // Создаем структуру XML
                    usersDoc = new XDocument(
                        new XDeclaration("1.0", "utf-8", null),
                        new XElement("Users")
                    );
                }

                // Добавляем нового пользователя
                XElement newUser = new XElement("User",
                    new XElement("ID", Guid.NewGuid().ToString()),
                    new XElement("Username", username),
                    new XElement("Email", email),
                    new XElement("Password", password), // В реальном приложении пароль должен быть захеширован
                    new XElement("FullName", fullName),
                    new XElement("StudentId", studentId),
                    new XElement("RegistrationDate", DateTime.Now.ToString("o"))
                );

                usersDoc.Root.Add(newUser);
                usersDoc.Save(usersFilePath);

                // Показываем сообщение об успехе
                SuccessPanel.Visible = true;
                SuccessMessageLiteral.Text = "Регистрация прошла успешно! Теперь вы можете <a href='Login.aspx'>войти</a> в систему.";

                // Очищаем форму
                UsernameTextBox.Text = string.Empty;
                EmailTextBox.Text = string.Empty;
                PasswordTextBox.Text = string.Empty;
                ConfirmPasswordTextBox.Text = string.Empty;
                FullNameTextBox.Text = string.Empty;
                StudentIdTextBox.Text = string.Empty;
            }
        }

        private bool UserExists(string username, string email)
        {
            string usersFilePath = Server.MapPath("~/App_Data/Users.xml");
            
            if (File.Exists(usersFilePath))
            {
                try
                {
                    XDocument usersDoc = XDocument.Load(usersFilePath);
                    return usersDoc.Descendants("User")
                        .Any(u => 
                            string.Equals(u.Element("Username")?.Value, username, StringComparison.OrdinalIgnoreCase) ||
                            string.Equals(u.Element("Email")?.Value, email, StringComparison.OrdinalIgnoreCase));
                }
                catch (Exception ex)
                {
                    // Логирование ошибки (в реальном приложении)
                    System.Diagnostics.Debug.WriteLine($"Ошибка проверки пользователя: {ex.Message}");
                }
            }

            return false;
        }

        private bool StudentIdExists(string studentId)
        {
            string usersFilePath = Server.MapPath("~/App_Data/Users.xml");
            
            if (File.Exists(usersFilePath))
            {
                try
                {
                    XDocument usersDoc = XDocument.Load(usersFilePath);
                    return usersDoc.Descendants("User")
                        .Any(u => string.Equals(u.Element("StudentId")?.Value, studentId, StringComparison.OrdinalIgnoreCase));
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Ошибка проверки студенческого ID: {ex.Message}");
                }
            }

            return false;
        }

        private void ShowErrorMessage(string message)
        {
            ErrorPanel.Visible = true;
            ErrorMessageLiteral.Text = message;
        }
    }
} 