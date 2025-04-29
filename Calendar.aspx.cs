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
                // Получаем параметры из URL
                string dateParam = Request.QueryString["date"];
                string eventIdParam = Request.QueryString["eventId"];
                bool registerParam = Request.QueryString["register"] == "true";
                
                if (!string.IsNullOrEmpty(dateParam))
                {
                    // Устанавливаем дату календаря и выбираем её
                    DateTime selectedDate;
                    if (DateTime.TryParse(dateParam, out selectedDate))
                    {
                        EventCalendar.VisibleDate = selectedDate;
                        EventCalendar.SelectedDate = selectedDate;
                        
                        // Отображаем события на выбранную дату
                        SelectedDateLabel.Text = selectedDate.ToLongDateString();
                        LoadEventsForSelectedDate(selectedDate);
                        
                        // Обязательно делаем панель с деталями события видимой
                        EventDetailsPanel.Visible = true;
                        
                        // Автоматически открываем регистрацию для указанного события
                        if (registerParam && !string.IsNullOrEmpty(eventIdParam))
                        {
                            // Прокручиваем страницу к форме регистрации
                            ScriptManager.RegisterStartupScript(this, GetType(), "scrollToEvent", 
                                $"setTimeout(function() {{ document.getElementById('event-{eventIdParam}').scrollIntoView({{ behavior: 'smooth', block: 'center' }}); }}, 500);", 
                                true);
                        }
                    }
                }
                else
                {
                    EventCalendar.VisibleDate = DateTime.Today;
                }
            }
        }

        private void LoadEventsForSelectedDate(DateTime selectedDate)
        {
            var eventsOnSelectedDay = eventsDoc.Descendants("Event")
                .Where(ev => 
                    DateTime.Parse(ev.Element("StartDate").Value).Date == selectedDate.Date)
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
                
                // Проверяем, передан ли конкретный идентификатор события в URL
                string eventIdParam = Request.QueryString["eventId"];
                if (!string.IsNullOrEmpty(eventIdParam))
                {
                    // Добавляем скрипт для выделения выбранного события
                    ScriptManager.RegisterStartupScript(this, GetType(), "highlightEvent", 
                        $"setTimeout(function() {{ " +
                        $"  const eventElement = document.getElementById('event-{eventIdParam}'); " +
                        $"  if(eventElement) {{ " +
                        $"    eventElement.classList.add('bg-light', 'border-primary'); " +
                        $"    eventElement.scrollIntoView({{ behavior: 'smooth', block: 'center' }}); " +
                        $"  }} " +
                        $"}}, 500);", 
                        true);
                }
            }
            else
            {
                EventDetailsPanel.Visible = true;
                NoEventsPanel.Visible = true;
                EventsRepeater.DataSource = null;
                EventsRepeater.DataBind();
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
                    // Отмечаем дни с событиями специальным цветом
                    e.Cell.BackColor = ColorTranslator.FromHtml("#d4edda");
                    
                    // Показываем количество событий
                    int eventCount = eventsOnDay.Count;
                    e.Cell.Controls.Add(new LiteralControl("<div class='event-count'>" + eventCount + "</div>"));
                    
                    // Добавляем CSS класс для дополнительных стилей
                    e.Cell.CssClass += " has-events";
                    
                    // Добавляем подсказку
                    e.Cell.ToolTip = $"События ({eventCount}): Нажмите для просмотра";
                }
                else
                {
                    // Для дней без событий тоже добавляем подсказку
                    e.Cell.ToolTip = "Нет событий в этот день";
                }
                
                // Добавляем стиль курсора для всех ячеек
                e.Cell.Attributes["style"] = e.Cell.Attributes["style"] + "; cursor: pointer;";
                
                // Делаем ячейку кликабельной с помощью селектора календаря ASP.NET
                // ВАЖНО: не нужно привязывать обработчик событий JavaScript напрямую,
                // встроенный селектор дат ASP.NET Calendar сам обрабатывает клики
            }
        }

        protected void EventCalendar_SelectionChanged(object sender, EventArgs e)
        {
            SelectedDateLabel.Text = EventCalendar.SelectedDate.ToLongDateString();
            LoadEventsForSelectedDate(EventCalendar.SelectedDate);
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