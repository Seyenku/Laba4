using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;
using System.IO;
using System.Drawing;
using System.Globalization;

namespace Laba4
{
    public partial class Calendar : System.Web.UI.Page
    {
        private string xmlFilePath;
        private XDocument eventsDoc;
        private XDocument usersDoc;
        private XElement currentUserElement;

        protected void Page_Load(object sender, EventArgs e)
        {
            xmlFilePath = Server.MapPath("~/App_Data/Events.xml");
            string usersFilePath = Server.MapPath("~/App_Data/Users.xml");
            
            if (File.Exists(xmlFilePath))
            {
                eventsDoc = XDocument.Load(xmlFilePath);
            }
            else
            {
                eventsDoc = new XDocument(
                    new XDeclaration("1.0", "utf-8", null),
                    new XElement("Events")
                );
                eventsDoc.Save(xmlFilePath);
            }

            // Загружаем данные пользователей, если файл существует
            if (File.Exists(usersFilePath))
            {
                usersDoc = XDocument.Load(usersFilePath);

                // Если пользователь аутентифицирован, получаем его данные из XML
                if (Request.IsAuthenticated)
                {
                    string username = Context.User.Identity.Name;
                    currentUserElement = usersDoc.Descendants("User")
                        .FirstOrDefault(u => string.Equals(u.Element("Username")?.Value, username, StringComparison.OrdinalIgnoreCase));
                }
            }

            if (!IsPostBack)
            {
                EventCalendar.VisibleDate = DateTime.Today;
            }
        }

        protected void EventCalendar_DayRender(object sender, DayRenderEventArgs e)
        {
            if (eventsDoc != null)
            {
                var eventsOnDay = eventsDoc.Descendants("Event")
                    .Where(ev => 
                        DateTime.Parse(ev.Element("StartDate").Value).Date == e.Day.Date)
                    .ToList();

                if (eventsOnDay.Any())
                {
                    e.Cell.BackColor = ColorTranslator.FromHtml("#d4edda");
                    
                    int eventCount = eventsOnDay.Count;
                    e.Cell.Controls.Add(new LiteralControl("<div class='event-count'>" + eventCount + "</div>"));
                    
                    if (eventsOnDay.Count == 1)
                    {
                        var firstEvent = eventsOnDay.First();
                        string id = firstEvent.Element("ID").Value;
                        string title = firstEvent.Element("Title").Value;
                        string desc = firstEvent.Element("Description").Value;
                        string startTime = DateTime.Parse(firstEvent.Element("StartDate").Value).ToShortTimeString();
                        string endTime = DateTime.Parse(firstEvent.Element("EndDate").Value).ToShortTimeString();
                        string location = firstEvent.Element("Location").Value;
                        int maxAttendees = int.Parse(firstEvent.Element("MaxAttendees").Value);
                        int currentAttendees = firstEvent.Element("Attendees")?.Elements("Student")?.Count() ?? 0;

                        string script = $"showEventDetails('{id}', '{title}', '{desc}', '{startTime}', '{endTime}', '{location}', {maxAttendees}, {currentAttendees});";
                        e.Cell.Attributes["onclick"] = "javascript:" + script;
                        e.Cell.Attributes["style"] = "cursor: pointer;";
                    }
                }
            }
        }

        protected void EventCalendar_SelectionChanged(object sender, EventArgs e)
        {
            SelectedDateLabel.Text = EventCalendar.SelectedDate.ToLongDateString();
            
            var eventsOnSelectedDay = eventsDoc.Descendants("Event")
                .Where(ev => 
                    DateTime.Parse(ev.Element("StartDate").Value).Date == EventCalendar.SelectedDate.Date)
                .Select(ev => new
                {
                    ID = ev.Element("ID").Value,
                    Title = ev.Element("Title").Value,
                    Description = ev.Element("Description").Value,
                    StartDate = ev.Element("StartDate").Value,
                    EndDate = ev.Element("EndDate").Value,
                    Location = ev.Element("Location").Value,
                    MaxAttendees = int.Parse(ev.Element("MaxAttendees").Value)
                })
                .ToList();

            if (eventsOnSelectedDay.Any())
            {
                EventsRepeater.DataSource = eventsOnSelectedDay;
                EventsRepeater.DataBind();
                EventDetailsPanel.Visible = true;
                NoEventsPanel.Visible = false;
                
                // Заполняем поля формы регистрации данными пользователя
                FillRegistrationForms();
            }
            else
            {
                EventDetailsPanel.Visible = true;
                NoEventsPanel.Visible = true;
                EventsRepeater.DataSource = null;
                EventsRepeater.DataBind();
            }
        }
        
        private void FillRegistrationForms()
        {
            // Если пользователь не аутентифицирован или данные не найдены, выходим
            if (!Request.IsAuthenticated || currentUserElement == null)
                return;
                
            foreach (RepeaterItem item in EventsRepeater.Items)
            {
                TextBox nameTextBox = (TextBox)item.FindControl("StudentNameTextBox");
                TextBox idTextBox = (TextBox)item.FindControl("StudentIdTextBox");
                TextBox emailTextBox = (TextBox)item.FindControl("EmailTextBox");
                
                if (nameTextBox != null && idTextBox != null && emailTextBox != null)
                {
                    // Заполняем поля данными из профиля пользователя
                    nameTextBox.Text = currentUserElement.Element("FullName")?.Value ?? "";
                    idTextBox.Text = currentUserElement.Element("StudentId")?.Value ?? "";
                    emailTextBox.Text = currentUserElement.Element("Email")?.Value ?? "";
                }
            }
        }

        protected void RegisterButton_Click(object sender, EventArgs evt)
        {
            Button btn = (Button)sender;
            string eventId = btn.CommandArgument;
            
            RepeaterItem item = (RepeaterItem)btn.NamingContainer;
            
            TextBox nameTextBox = (TextBox)item.FindControl("StudentNameTextBox");
            TextBox idTextBox = (TextBox)item.FindControl("StudentIdTextBox");
            TextBox emailTextBox = (TextBox)item.FindControl("EmailTextBox");
            
            string studentName = nameTextBox.Text.Trim();
            string studentId = idTextBox.Text.Trim();
            string email = emailTextBox.Text.Trim();
            
            if (string.IsNullOrEmpty(studentName) || string.IsNullOrEmpty(studentId) || string.IsNullOrEmpty(email))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                    "alert('Пожалуйста, заполните все поля для регистрации.');", true);
                return;
            }
            
            XElement eventElement = eventsDoc.Descendants("Event")
                .FirstOrDefault(e => e.Element("ID").Value == eventId);
                
            if (eventElement != null)
            {
                XElement attendeesElement = eventElement.Element("Attendees");
                bool alreadyRegistered = attendeesElement.Elements("Student")
                    .Any(s => s.Attribute("ID").Value == studentId);
                    
                if (alreadyRegistered)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                        "alert('Вы уже зарегистрированы на это мероприятие.');", true);
                    return;
                }
                
                int maxAttendees = int.Parse(eventElement.Element("MaxAttendees").Value);
                int currentAttendees = attendeesElement.Elements("Student").Count();
                
                if (currentAttendees >= maxAttendees)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                        "alert('Извините, это мероприятие уже заполнено.');", true);
                    return;
                }
                
                attendeesElement.Add(new XElement("Student",
                    new XAttribute("ID", studentId),
                    new XAttribute("Name", studentName),
                    new XAttribute("Email", email),
                    new XAttribute("RegistrationDate", DateTime.Now.ToString("o"))
                ));
                
                eventsDoc.Save(xmlFilePath);
                
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                    "alert('Регистрация успешна! Вы зарегистрированы на это мероприятие.');", true);
                
                EventCalendar_SelectionChanged(sender, evt);
            }
        }

        protected bool IsRegistrationAvailable(object eventId, object maxAttendees)
        {
            string id = eventId.ToString();
            int max = Convert.ToInt32(maxAttendees);
            
            XElement eventElement = eventsDoc.Descendants("Event")
                .FirstOrDefault(e => e.Element("ID").Value == id);
                
            if (eventElement == null)
                return false;
                
            int currentAttendees = eventElement.Element("Attendees").Elements("Student").Count();
            return currentAttendees < max;
        }
        
        protected string GetAvailableSpots(object maxAttendees, object eventId)
        {
            int max = Convert.ToInt32(maxAttendees);
            string id = eventId.ToString();
            
            XElement eventElement = eventsDoc.Descendants("Event")
                .FirstOrDefault(e => e.Element("ID").Value == id);
                
            if (eventElement == null)
                return "0 из " + max;
                
            int currentAttendees = eventElement.Element("Attendees").Elements("Student").Count();
            return (max - currentAttendees) + " из " + max;
        }
    }
} 