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
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Laba4
{
    public partial class Calendar : System.Web.UI.Page
    {
        private string xmlFilePath;
        private XDocument eventsDoc;
        private XDocument usersDoc;
        private XElement currentUserElement;
        private static readonly HttpClient client = new HttpClient();
        private EventServiceClient eventServiceClient;

        protected void Page_Load(object sender, EventArgs e)
        {
            eventServiceClient = new EventServiceClient("EventServiceEndpoint");
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

            if (File.Exists(usersFilePath))
            {
                usersDoc = XDocument.Load(usersFilePath);

                if (Request.IsAuthenticated)
                {
                    string username = Context.User.Identity.Name;
                    currentUserElement = usersDoc.Descendants("User")
                        .FirstOrDefault(u => string.Equals(u.Element("Username")?.Value, username, StringComparison.OrdinalIgnoreCase));
                }
            }

            if (!IsPostBack)
            {
                string dateParam = Request.QueryString["date"];
                string eventIdParam = Request.QueryString["eventId"];
                bool registerParam = Request.QueryString["register"] == "true";
                
                if (!string.IsNullOrEmpty(dateParam))
                {
                    DateTime selectedDate;
                    if (DateTime.TryParse(dateParam, out selectedDate))
                    {
                        EventCalendar.VisibleDate = selectedDate;
                        EventCalendar.SelectedDate = selectedDate;
                        
                        SelectedDateLabel.Text = selectedDate.ToLongDateString();
                        LoadEventsForSelectedDate(selectedDate);
                        
                        EventDetailsPanel.Visible = true;
                        
                        if (registerParam && !string.IsNullOrEmpty(eventIdParam))
                        {
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

        private async Task<List<EventData>> GetEventsFromService(DateTime date)
        {
            try
            {
                string formattedDate = date.ToString("dd.MM.yyyy");
                var events = eventServiceClient.GetEvents(formattedDate);
                return events.ToList();
            }
            catch (Exception ex)
            {
                // В случае ошибки возвращаем пустой список
                return new List<EventData>();
            }
        }

        protected async void SearchByDateButton_Click(object sender, EventArgs e)
        {
            DateTime selectedDate;
            if (DateTime.TryParse(DateSearchTextBox.Text, out selectedDate))
            {
                var events = await GetEventsFromService(selectedDate);
                // Сериализуем результат в JSON для передачи в JS
                string eventsJson = JsonConvert.SerializeObject(events);
                // Показываем модальное окно с результатами через JS
                ScriptManager.RegisterStartupScript(this, GetType(), "showEventsModal",
                    $"showEventsModal({eventsJson});", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Пожалуйста, выберите корректную дату!');", true);
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
                
                FillRegistrationForms();
                
                string eventIdParam = Request.QueryString["eventId"];
                if (!string.IsNullOrEmpty(eventIdParam))
                {
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
                    e.Cell.BackColor = ColorTranslator.FromHtml("#d4edda");
                    
                    int eventCount = eventsOnDay.Count;
                    e.Cell.Controls.Add(new LiteralControl("<div class='event-count'>" + eventCount + "</div>"));
                    
                    e.Cell.CssClass += " has-events";
                    
                    e.Cell.ToolTip = $"События ({eventCount}): Нажмите для просмотра";
                }
                else
                {
                    e.Cell.ToolTip = "Нет событий в этот день";
                }
                
                e.Cell.Attributes["style"] = e.Cell.Attributes["style"] + "; cursor: pointer;";
            }
        }

        protected void EventCalendar_SelectionChanged(object sender, EventArgs e)
        {
            SelectedDateLabel.Text = EventCalendar.SelectedDate.ToLongDateString();
            LoadEventsForSelectedDate(EventCalendar.SelectedDate);
        }
        
        private void FillRegistrationForms()
        {
            if (!Request.IsAuthenticated || currentUserElement == null)
                return;
                
            foreach (RepeaterItem item in EventsRepeater.Items)
            {
                TextBox nameTextBox = (TextBox)item.FindControl("StudentNameTextBox");
                TextBox idTextBox = (TextBox)item.FindControl("StudentIdTextBox");
                TextBox emailTextBox = (TextBox)item.FindControl("EmailTextBox");
                
                if (nameTextBox != null && idTextBox != null && emailTextBox != null)
                {
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
                
                if (attendeesElement == null)
                {
                    attendeesElement = new XElement("Attendees");
                    eventElement.Add(attendeesElement);
                }
                
                attendeesElement.Add(new XElement("Student",
                    new XAttribute("ID", studentId),
                    new XElement("Name", studentName),
                    new XElement("Email", email),
                    new XElement("RegistrationDate", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
                ));
                
                eventsDoc.Save(xmlFilePath);
                
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                    "alert('Вы успешно зарегистрированы на мероприятие!');", true);
                
                // Обновляем отображение событий
                LoadEventsForSelectedDate(EventCalendar.SelectedDate);
            }
        }
        
        protected bool IsRegistrationAvailable(object eventId, object maxAttendees)
        {
            if (eventId == null || maxAttendees == null)
                return false;
                
            XElement eventElement = eventsDoc.Descendants("Event")
                .FirstOrDefault(e => e.Element("ID").Value == eventId.ToString());
                
            if (eventElement == null)
                return false;
                
            int maxAttendeesCount = Convert.ToInt32(maxAttendees);
            int currentAttendeesCount = eventElement.Element("Attendees")?.Elements("Student").Count() ?? 0;
            
            return currentAttendeesCount < maxAttendeesCount;
        }
        
        protected string GetAvailableSpots(object maxAttendees, object eventId)
        {
            if (eventId == null || maxAttendees == null)
                return "0";
                
            XElement eventElement = eventsDoc.Descendants("Event")
                .FirstOrDefault(e => e.Element("ID").Value == eventId.ToString());
                
            if (eventElement == null)
                return "0";
                
            int maxAttendeesCount = Convert.ToInt32(maxAttendees);
            int currentAttendeesCount = eventElement.Element("Attendees")?.Elements("Student").Count() ?? 0;
            
            return (maxAttendeesCount - currentAttendeesCount).ToString();
        }
    }
} 